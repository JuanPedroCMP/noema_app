import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noema/core/database/database.dart';
import 'package:noema/core/database/database_provider.dart';
import 'package:noema/feature/ai/data/ai_background_task_dao.dart';
import 'package:noema/feature/ai/models/ai_agent_task.dart';
import 'package:noema/feature/ai/providers/ai_queue_concurrency_provider.dart';
import 'package:noema/feature/ai/services/ai_content_generation_service.dart';
import 'package:noema/feature/ai/services/ai_request_queue.dart';
import 'package:noema/feature/ai/services/ai_task_notification_service.dart';
import 'package:noema/feature/config/providers/user_provider.dart';
import 'package:noema/feature/exercises/data/queued_exercise_correction_service.dart';
import 'package:noema/feature/exercises/data/study_pack_service.dart';
import 'package:noema/feature/graph/data/learning_resource_dao.dart';

const maximumAiBackgroundAttempts = aiTaskMaximumAttempts;

Duration? aiBackgroundRetryDelay(int attemptCount) => switch (attemptCount) {
  1 => const Duration(seconds: 15),
  2 => const Duration(seconds: 45),
  _ => null,
};

class AiBackgroundTaskRunner extends ChangeNotifier {
  AiBackgroundTaskRunner(this._ref, {required this._userId});

  final Ref _ref;
  final String? _userId;
  Timer? _timer;
  StreamSubscription<List<AiQueueItem>>? _subscription;
  bool _started = false;
  bool _starting = false;
  bool _disposed = false;
  bool _paused = false;
  bool _pumping = false;
  bool _pumpRequested = false;
  int _activeTasks = 0;

  bool get isPaused => _paused;
  int get activeTasks => _activeTasks;

  Future<void> start() async {
    final userId = _userId;
    if (_started || _starting || _disposed || userId == null) return;
    _starting = true;
    try {
      final dao = AiBackgroundTaskDao(_ref.read(appDatabaseProvider));
      await dao.recoverInterruptedTasks(
        userId: userId,
        updatedBefore: DateTime.now()
            .subtract(aiTaskExecutionLease)
            .millisecondsSinceEpoch,
      );
      _subscription = dao
          .watchQueueItems(userId: userId)
          .listen(
            (_) => requestPump(),
            onError: (Object error, StackTrace stackTrace) {
              developer.log(
                'Não foi possível observar a fila de IA.',
                name: 'noema.ai.queue',
                error: error,
                stackTrace: stackTrace,
              );
            },
          );
      _started = true;
      _timer = Timer.periodic(const Duration(seconds: 2), (_) => requestPump());
      requestPump();
    } catch (error, stackTrace) {
      developer.log(
        'Não foi possível iniciar a fila de IA. Uma nova tentativa ocorrerá.',
        name: 'noema.ai.queue',
        error: error,
        stackTrace: stackTrace,
      );
      _timer = Timer(const Duration(seconds: 10), () => unawaited(start()));
    } finally {
      _starting = false;
    }
  }

  Future<bool> runNextReadyTask() async {
    final userId = _userId;
    if (userId == null) return false;
    final dao = AiBackgroundTaskDao(_ref.read(appDatabaseProvider));
    await _recoverExpiredTasks(userId, dao);
    final ready = await dao.getReadyTasks(
      userId: userId,
      now: DateTime.now().millisecondsSinceEpoch,
      limit: 1,
    );
    if (ready.isEmpty) return false;
    final task = await dao.markRunning(id: ready.first.id, userId: userId);
    if (task == null) return false;
    await _execute(task, dao);
    final savedTask = await dao.getTask(task.id);
    if (savedTask?.status == aiTaskCompleted) {
      final node = await dao.getNode(task.nodeId);
      if (node != null && !node.softDeleted) {
        await _ref
            .read(aiTaskNotificationServiceProvider)
            .show(
              taskId: task.id,
              taskType: task.taskType,
              nodeTitle: node.title,
            );
      }
    }
    return true;
  }

  void pause() {
    _paused = true;
    _notifyIfAlive();
  }

  void resume() {
    _paused = false;
    _notifyIfAlive();
    requestPump();
  }

  void requestPump() {
    if (!_started || _paused) return;
    if (_pumping) {
      _pumpRequested = true;
      return;
    }
    unawaited(_pump());
  }

  Future<void> _pump() async {
    final userId = _userId;
    if (_pumping || !_started || _paused || userId == null) return;
    _pumping = true;
    try {
      final dao = AiBackgroundTaskDao(_ref.read(appDatabaseProvider));
      await _recoverExpiredTasks(userId, dao);
      while (!_paused) {
        final ready = await dao.getReadyTasks(
          userId: userId,
          now: DateTime.now().millisecondsSinceEpoch,
          limit: 1,
        );
        if (ready.isEmpty) break;
        final concurrency = await _ref.read(aiQueueConcurrencyProvider.future);
        if (_activeTasks >= concurrency) break;
        final task = await dao.markRunning(id: ready.first.id, userId: userId);
        if (task == null) break;
        _activeTasks++;
        _notifyIfAlive();
        unawaited(
          _execute(task, dao).whenComplete(() {
            _activeTasks--;
            _notifyIfAlive();
            requestPump();
          }),
        );
      }
    } catch (error, stackTrace) {
      developer.log(
        'Não foi possível processar a fila de IA.',
        name: 'noema.ai.queue',
        error: error,
        stackTrace: stackTrace,
      );
    } finally {
      _pumping = false;
      if (_pumpRequested) {
        _pumpRequested = false;
        requestPump();
      }
    }
  }

  Future<void> _execute(
    AiBackgroundTaskData task,
    AiBackgroundTaskDao dao,
  ) async {
    final heartbeat = Timer.periodic(const Duration(seconds: 30), (_) {
      unawaited(
        dao.touchRunningTask(task.id).catchError((
          Object error,
          StackTrace stackTrace,
        ) {
          developer.log(
            'Não foi possível renovar o lease da tarefa ${task.id}.',
            name: 'noema.ai.queue',
            error: error,
            stackTrace: stackTrace,
          );
          return 0;
        }),
      );
    });
    try {
      await _executeTask(task, dao);
    } finally {
      heartbeat.cancel();
    }
  }

  Future<void> _executeTask(
    AiBackgroundTaskData task,
    AiBackgroundTaskDao dao,
  ) async {
    try {
      final node = await dao.getNode(task.nodeId);
      if (node == null || node.softDeleted) {
        await dao.complete(task.id);
        return;
      }
      final graph = await dao.getGraph(node.graphId);
      if (graph == null || graph.softDeleted) {
        await dao.complete(task.id);
        return;
      }
      if (task.taskType == aiNodeDescriptionTaskType) {
        final payload = jsonDecode(task.payloadJson);
        if (payload is! Map<String, dynamic>) {
          throw const FormatException('A tarefa de descrição está inválida.');
        }
        final replaceExistingDescription =
            payload['replace_existing_description'] == true;
        final rawExpectedDescription = payload['expected_description'];
        if (rawExpectedDescription != null &&
            rawExpectedDescription is! String) {
          throw const FormatException(
            'A descrição original da tarefa está inválida.',
          );
        }
        final expectedNodeDescription = rawExpectedDescription as String?;
        if (replaceExistingDescription &&
            node.description != expectedNodeDescription) {
          await dao.complete(task.id);
          return;
        }
        if (!replaceExistingDescription &&
            node.description?.trim().isNotEmpty == true) {
          await dao.complete(task.id);
          return;
        }

        final ai = _ref.read(aiContentGenerationServiceProvider);
        final description = await ai.generateNodeDescription(
          nodeId: task.nodeId,
          title: node.title,
          type: node.type,
          existingDescription: node.description,
          agentId: await ai.resolveAgentId(_nodeDescriptionTask),
        );
        await dao.complete(
          task.id,
          description: description,
          expectedNodeTitle: node.title,
          replaceExistingDescription: replaceExistingDescription,
          expectedNodeDescription: expectedNodeDescription,
        );
      } else if (task.taskType == aiStudyPackTaskType) {
        final payload = jsonDecode(task.payloadJson);
        if (payload is! Map<String, dynamic>) {
          throw const FormatException('O pacote de estudo está inválido.');
        }
        final request = StudyPackRequest.fromJson(payload);
        final configuredDeckName = payload['deck_name'];
        final service = StudyPackService(
          ai: _ref.read(aiContentGenerationServiceProvider),
          database: _ref.read(appDatabaseProvider),
        );
        final resources = await LearningResourceDao(
          _ref.read(appDatabaseProvider),
        ).getLearningResourcesByNode(nodeId: node.id);
        final draft = await service.generate(
          nodeTitle: node.title,
          nodeDescription: node.description,
          request: request,
          studyMaterials: StudyPackService.studyMaterialContext(resources),
          priority: AiRequestPriority.background,
        );
        await service.save(
          nodeId: node.id,
          flashcardDeckName:
              configuredDeckName is String &&
                  configuredDeckName.trim().isNotEmpty
              ? configuredDeckName.trim()
              : '${node.title} - estudo recomendado',
          draft: draft,
          idempotencyKey: task.id,
        );
        await dao.complete(task.id);
      } else {
        await QueuedExerciseCorrectionService(
          database: _ref.read(appDatabaseProvider),
          ai: _ref.read(aiContentGenerationServiceProvider),
        ).correct(task: task, node: node);
        await dao.complete(task.id);
      }
    } catch (error, stackTrace) {
      developer.log(
        'Falha ao processar a tarefa ${task.taskType} para o nó ${task.nodeId}.',
        name: 'noema.ai.queue',
        error: error,
        stackTrace: stackTrace,
      );
      try {
        final retryDelay = aiBackgroundRetryDelay(task.attemptCount);
        final rawMessage = error.toString();
        final errorMessage = rawMessage.length > 1000
            ? rawMessage.substring(0, 1000)
            : rawMessage;
        if (retryDelay != null &&
            task.attemptCount < maximumAiBackgroundAttempts) {
          await dao.scheduleRetry(
            taskId: task.id,
            error: errorMessage,
            retryAt: DateTime.now().add(retryDelay).millisecondsSinceEpoch,
          );
        } else {
          await dao.markFailed(taskId: task.id, error: errorMessage);
        }
      } catch (queueError, queueStackTrace) {
        developer.log(
          'Não foi possível salvar o erro ou a retentativa da tarefa '
          '${task.id}.',
          name: 'noema.ai.queue',
          error: queueError,
          stackTrace: queueStackTrace,
        );
      }
    }
  }

  Future<void> _recoverExpiredTasks(String userId, AiBackgroundTaskDao dao) {
    return dao.recoverInterruptedTasks(
      userId: userId,
      updatedBefore: DateTime.now()
          .subtract(aiTaskExecutionLease)
          .millisecondsSinceEpoch,
    );
  }

  void _notifyIfAlive() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    _started = false;
    _timer?.cancel();
    unawaited(_subscription?.cancel());
    super.dispose();
  }
}

const _nodeDescriptionTask = AiAgentTask.generateNodeDescription;

final aiBackgroundWorkerModeProvider = Provider<bool>((ref) => false);

final aiBackgroundTaskRunnerProvider = Provider<AiBackgroundTaskRunner>((ref) {
  final user = ref.watch(userProvider).asData?.value;
  final workerMode = ref.watch(aiBackgroundWorkerModeProvider);
  final runner = AiBackgroundTaskRunner(ref, userId: user?.id);
  if (user != null && !workerMode) unawaited(runner.start());
  ref.onDispose(runner.dispose);
  return runner;
});
