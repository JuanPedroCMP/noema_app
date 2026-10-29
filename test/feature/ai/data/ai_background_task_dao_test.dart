import 'dart:convert';

import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noema/core/database/database.dart';
import 'package:noema/feature/ai/data/ai_background_task_dao.dart';
import 'package:noema/feature/graph/service/import_grap_from_json.dart';

void main() {
  late AppDatabase database;
  late AiBackgroundTaskDao dao;
  late String nodeId;
  late String taskId;

  setUp(() async {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    dao = AiBackgroundTaskDao(database);
    await database
        .into(database.appUser)
        .insert(
          AppUserCompanion.insert(
            id: 'user-id',
            remoteId: 'remote-user-id',
            userName: 'student',
            displayName: 'Student',
            primaryEmail: 'student@example.com',
            lastSeenAt: 0,
          ),
        );
    final graphId = await importGraphFromJson(
      db: database,
      userId: 'user-id',
      isAiGenerated: true,
      queueMissingAiDescriptions: true,
      jsonString: jsonEncode({
        'graph_title': 'Biologia',
        'nodes': [
          {'node_id': 1, 'title': 'Célula', 'type': 'TOPIC'},
        ],
        'edges': [],
      }),
    );
    final node = (await (database.select(
      database.graphNode,
    )..where((row) => row.graphId.equals(graphId))).get()).single;
    nodeId = node.id;
    taskId =
        (await (database.select(database.aiBackgroundTask).get())).single.id;
  });

  tearDown(() async {
    await database.close();
  });

  test(
    'persists generated descriptions and recovers interrupted work',
    () async {
      final task = await dao.markRunning(taskId);
      expect(task?.attemptCount, 1);
      await dao.recoverInterruptedTasks();

      final recoveredTask = await (database.select(
        database.aiBackgroundTask,
      )..where((row) => row.id.equals(taskId))).getSingle();
      expect(recoveredTask.status, aiTaskPending);

      await dao.markRunning(taskId);
      await dao.complete(taskId, description: 'Unidade básica da vida.');

      final savedTask = await (database.select(
        database.aiBackgroundTask,
      )..where((row) => row.id.equals(taskId))).getSingle();
      final savedNode = await dao.getNode(nodeId);
      expect(savedTask.status, aiTaskCompleted);
      expect(savedNode?.description, 'Unidade básica da vida.');
    },
  );

  test('exposes task, node, and graph details to the queue page', () async {
    final items = await dao.watchQueueItems().first;

    expect(items, hasLength(1));
    expect(items.single.node.title, 'Célula');
    expect(items.single.graph.title, 'Biologia');
    expect(items.single.task.status, aiTaskPending);
  });

  test('queues multiple exercise corrections by response without collisions', () async {
    final firstResponse = await dao.enqueueExerciseCorrection(
      nodeId: nodeId,
      responseId: 'response-one',
      taskType: aiOpenEndedCorrectionTaskType,
    );
    final secondResponse = await dao.enqueueExerciseCorrection(
      nodeId: nodeId,
      responseId: 'response-two',
      taskType: aiOpenEndedCorrectionTaskType,
    );
    final multipleChoice = await dao.enqueueExerciseCorrection(
      nodeId: nodeId,
      responseId: 'response-three',
      taskType: aiMultipleChoiceCorrectionTaskType,
    );
    final duplicate = await dao.enqueueExerciseCorrection(
      nodeId: nodeId,
      responseId: 'response-one',
      taskType: aiOpenEndedCorrectionTaskType,
    );

    expect(duplicate, firstResponse);
    expect({firstResponse, secondResponse, multipleChoice}, hasLength(3));
    final items = await dao.watchQueueItems().first;
    expect(items, hasLength(4));
    expect(
      items.where((item) => item.task.subjectId != null),
      hasLength(3),
    );
  });

  test(
    'does not overwrite a description edited while generation is running',
    () async {
      await dao.markRunning(taskId);
      await (database.update(
        database.graphNode,
      )..where((node) => node.id.equals(nodeId))).write(
        const GraphNodeCompanion(description: Value('Texto do usuário')),
      );

      await dao.complete(
        taskId,
        description: 'Texto gerado pela IA',
        expectedNodeTitle: 'Célula',
      );

      final savedNode = await dao.getNode(nodeId);
      expect(savedNode?.description, 'Texto do usuário');
    },
  );

  test('schedules a retry and allows a user to retry it immediately', () async {
    await dao.markRunning(taskId);
    await dao.scheduleRetry(
      taskId: taskId,
      error: 'Temporary provider error',
      retryAt: DateTime.now()
          .add(const Duration(hours: 1))
          .millisecondsSinceEpoch,
    );

    expect(
      await dao.getReadyTasks(
        now: DateTime.now().millisecondsSinceEpoch,
        limit: 1,
      ),
      isEmpty,
    );
    expect(await dao.retryNow(taskId), 1);

    final ready = await dao.getReadyTasks(
      now: DateTime.now().millisecondsSinceEpoch,
      limit: 1,
    );
    expect(ready.single.id, taskId);
    expect(ready.single.attemptCount, 0);
    expect(ready.single.lastError, isNull);
  });

  test('does not exceed the automatic-attempt limit after restart', () async {
    for (var attempt = 1; attempt < aiTaskMaximumAttempts; attempt++) {
      await dao.markRunning(taskId);
      await dao.scheduleRetry(
        taskId: taskId,
        error: 'Temporary provider error',
        retryAt: DateTime.now()
            .subtract(const Duration(seconds: 1))
            .millisecondsSinceEpoch,
      );
    }
    final lastAttempt = await dao.markRunning(taskId);
    expect(lastAttempt?.attemptCount, aiTaskMaximumAttempts);

    await dao.recoverInterruptedTasks();

    final savedTask = await (database.select(
      database.aiBackgroundTask,
    )..where((row) => row.id.equals(taskId))).getSingle();
    expect(savedTask.status, aiTaskFailed);
    expect(savedTask.attemptCount, aiTaskMaximumAttempts);
  });
}
