import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noema/core/database/database.dart';
import 'package:noema/core/database/database_provider.dart';
import 'package:noema/feature/ai/data/ai_background_task_dao.dart';
import 'package:noema/feature/ai/models/ai_agent_task.dart';
import 'package:noema/feature/ai/services/ai_background_task_runner.dart';
import 'package:noema/feature/ai/services/ai_content_generation_service.dart';
import 'package:noema/feature/ai/services/ai_task_notification_service.dart';
import 'package:noema/feature/config/providers/user_provider.dart';
import 'package:noema/feature/exercises/data/study_pack_service.dart';
import 'package:noema/feature/graph/data/graph_node_dao.dart';
import 'package:noema/feature/graph/service/import_grap_from_json.dart';

void main() {
  test('worker processes and persists a queued study pack', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    final user = await _createUserAndGraph(database);
    final graphId =
        (await database.select(database.knowledgeGraph).get()).single.id;
    final node = (await GraphNodeDao(
      database,
    ).getGraphNodesByGraph(graphId: graphId)).single;
    final taskId = await AiBackgroundTaskDao(database).enqueueStudyPack(
      nodeId: node.id,
      payload: {
        ...const StudyPackRequest(
          counts: StudyPackCounts(flashcards: 1),
        ).toJson(),
        'deck_name': 'Fotossíntese - pacote manual',
      },
    );
    final notifications = _RecordingAiTaskNotificationService();
    final container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(database),
        userProvider.overrideWith(() => _TestUserNotifier(user)),
        aiBackgroundWorkerModeProvider.overrideWithValue(true),
        aiContentGenerationServiceProvider.overrideWith(
          _FakeAiContentGenerationService.new,
        ),
        aiTaskNotificationServiceProvider.overrideWithValue(notifications),
      ],
    );
    addTearDown(container.dispose);
    addTearDown(database.close);

    await container.read(userProvider.future);
    final processed = await container
        .read(aiBackgroundTaskRunnerProvider)
        .runNextReadyTask();

    expect(processed, isTrue);
    final savedTask = await AiBackgroundTaskDao(database).getTask(taskId);
    final cards = await (database.select(
      database.flashcard,
    )..where((card) => card.nodeId.equals(node.id))).get();
    final decks = await (database.select(
      database.flashcardGroup,
    )..where((deck) => deck.nodeId.equals(node.id))).get();
    expect(savedTask?.status, aiTaskCompleted);
    expect(cards.single.title, 'Pergunta de revisão');
    expect(decks.single.name, '${node.title} - pacote manual');
    expect(notifications.taskIds, [taskId]);

    await (database.update(database.aiBackgroundTask)
          ..where((task) => task.id.equals(taskId)))
        .write(const AiBackgroundTaskCompanion(status: Value(aiTaskPending)));
    await container.read(aiBackgroundTaskRunnerProvider).runNextReadyTask();
    expect(
      await (database.select(
        database.flashcard,
      )..where((card) => card.nodeId.equals(node.id))).get(),
      hasLength(1),
    );
    expect(
      await (database.select(
        database.flashcardGroup,
      )..where((deck) => deck.nodeId.equals(node.id))).get(),
      hasLength(1),
    );
    expect(notifications.taskIds, [taskId, taskId]);
  });
}

Future<AppUserData> _createUserAndGraph(AppDatabase database) async {
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
  await importGraphFromJson(
    db: database,
    userId: 'user-id',
    jsonString: jsonEncode({
      'graph_title': 'Biologia',
      'nodes': [
        {'node_id': 1, 'title': 'Fotossíntese', 'type': 'CONCEPT'},
      ],
      'edges': [],
    }),
  );
  return (await database.select(database.appUser).get()).single;
}

class _TestUserNotifier extends UserNotifier {
  _TestUserNotifier(this._user);

  final AppUserData _user;

  @override
  Future<AppUserData> build() async => _user;
}

class _FakeAiContentGenerationService extends AiContentGenerationService {
  _FakeAiContentGenerationService(super.ref);

  @override
  Future<String> resolveAgentId(AiAgentTask task) async => 'test-agent';

  @override
  Future<List<Map<String, dynamic>>> generateBatch({
    required AiAgentTask task,
    required String agentId,
    required List<String> prompts,
  }) async => [
    for (final _ in prompts)
      {'title': 'Pergunta de revisão', 'statement': 'Resposta de revisão'},
  ];
}

class _RecordingAiTaskNotificationService extends AiTaskNotificationService {
  final taskIds = <String>[];

  @override
  Future<void> show({
    required String taskId,
    required String taskType,
    required String nodeTitle,
  }) async {
    taskIds.add(taskId);
  }
}
