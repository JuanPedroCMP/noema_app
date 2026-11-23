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
import 'package:noema/feature/ai/services/ai_request_queue.dart';
import 'package:noema/feature/ai/services/ai_task_notification_service.dart';
import 'package:noema/feature/config/providers/user_provider.dart';
import 'package:noema/feature/exercises/data/study_pack_service.dart';
import 'package:noema/feature/graph/data/learning_resource_dao.dart';
import 'package:noema/feature/graph/data/graph_node_dao.dart';
import 'package:noema/feature/graph/service/import_grap_from_json.dart';

void main() {
  test('replaces graph-draft descriptions in the background', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
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
      regenerateAiDescriptions: true,
      jsonString: jsonEncode({
        'graph_title': 'Biologia',
        'nodes': [
          {
            'node_id': 1,
            'title': 'Fotossíntese',
            'type': 'CONCEPT',
            'description': 'Rascunho criado durante a geração do grafo.',
          },
        ],
        'edges': [],
      }),
    );
    final node = (await GraphNodeDao(
      database,
    ).getGraphNodesByGraph(graphId: graphId)).single;
    final user = (await database.select(database.appUser).get()).single;
    _FakeAiContentGenerationService.existingDescriptions.clear();
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
    expect(
      await container.read(aiBackgroundTaskRunnerProvider).runNextReadyTask(),
      isTrue,
    );

    final refreshedNode = await GraphNodeDao(
      database,
    ).getGraphNode(id: node.id);
    expect(refreshedNode?.description, 'Descrição específica de Fotossíntese.');
    expect(_FakeAiContentGenerationService.existingDescriptions, [
      'Rascunho criado durante a geração do grafo.',
    ]);
    expect(notifications.taskIds, hasLength(1));
  });

  test('worker processes and persists a queued study pack', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    final user = await _createUserAndGraph(database);
    final graphId =
        (await database.select(database.knowledgeGraph).get()).single.id;
    final node = (await GraphNodeDao(
      database,
    ).getGraphNodesByGraph(graphId: graphId)).single;
    await LearningResourceDao(database).insertLearningResource(
      nodeId: node.id,
      category: 'BOOK',
      title: 'Botânica essencial',
      tier: 'TIER_1',
      rationale: 'Explica os processos de fotossíntese.',
      relevanceScore: 0.9,
      reputationScore: 0.9,
    );
    _FakeAiContentGenerationService.generatedPrompts.clear();
    _FakeAiContentGenerationService.generatedPriorities.clear();
    final taskId = await AiBackgroundTaskDao(database).enqueueStudyPack(
      nodeId: node.id,
      payload: {
        ...const StudyPackRequest(
          counts: StudyPackCounts(
            multipleChoice: 1,
            essay: 1,
            feynman: 1,
            flashcards: 1,
          ),
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
    final multipleChoice = await (database.select(
      database.multipleChoice,
    )..where((question) => question.nodeId.equals(node.id))).get();
    final choices =
        await (database.select(database.choice)..where(
              (choice) =>
                  choice.multipleChoiceId.equals(multipleChoice.single.id),
            ))
            .get();
    final openEnded = await (database.select(
      database.openEnded,
    )..where((question) => question.nodeId.equals(node.id))).get();
    final decks = await (database.select(
      database.flashcardGroup,
    )..where((deck) => deck.nodeId.equals(node.id))).get();
    final links = await (database.select(
      database.flashcardBelongsGroup,
    )..where((link) => link.flashcardGroupId.equals(decks.single.id))).get();
    expect(savedTask?.status, aiTaskCompleted);
    expect(cards.single.title, 'Pergunta de revisão');
    expect(decks.single.name, '${node.title} - pacote manual');
    expect(links, hasLength(1));
    expect(multipleChoice, hasLength(1));
    expect(choices, hasLength(4));
    expect(openEnded, hasLength(2));
    expect(notifications.taskIds, [taskId]);
    expect(_FakeAiContentGenerationService.generatedPrompts, hasLength(4));
    expect(
      _FakeAiContentGenerationService.generatedPriorities,
      everyElement(AiRequestPriority.background),
    );
    expect(
      _FakeAiContentGenerationService.generatedPrompts,
      everyElement(contains('Botânica essencial')),
    );

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
    expect(
      await (database.select(database.flashcardBelongsGroup)).get(),
      hasLength(1),
    );
    expect(
      await (database.select(database.multipleChoice)).get(),
      hasLength(1),
    );
    expect(await (database.select(database.choice)).get(), hasLength(4));
    expect(await (database.select(database.openEnded)).get(), hasLength(2));
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
  static final generatedPrompts = <String>[];
  static final generatedPriorities = <AiRequestPriority>[];
  static final existingDescriptions = <String?>[];

  _FakeAiContentGenerationService(super.ref);

  @override
  Future<String> resolveAgentId(AiAgentTask task) async => 'test-agent';

  @override
  Future<String> generateNodeDescription({
    required String nodeId,
    required String title,
    required String type,
    required String? existingDescription,
    required String agentId,
  }) async {
    existingDescriptions.add(existingDescription);
    return 'Descrição específica de $title.';
  }

  @override
  Future<T> generateWithRetry<T>({
    required AiAgentTask task,
    required String prompt,
    required T Function(Map<String, dynamic> payload) parse,
    String? agentId,
    Map<String, dynamic>? context,
    AiRequestPriority priority = AiRequestPriority.user,
    String Function(T)? retryFeedback,
    int maxAttempts = 2,
  }) async {
    generatedPrompts.add(prompt);
    generatedPriorities.add(priority);
    final response = switch (task) {
      AiAgentTask.createFlashcards => {
        'flashcards': [
          {'title': 'Pergunta de revisão', 'statement': 'Resposta de revisão'},
        ],
      },
      AiAgentTask.createMultipleChoiceQuestion => {
        'title': 'Questão de revisão',
        'statement': 'Qual alternativa está correta?',
        'choices': [
          {
            'title': 'Resposta correta',
            'statement': 'A resposta correta.',
            'is_correct': true,
            'explanation': 'Explicação.',
            'weight': 2,
          },
          {
            'title': 'Resposta incorreta 1',
            'statement': 'Uma alternativa incorreta.',
            'is_correct': false,
            'explanation': 'Explicação.',
            'weight': 1,
          },
          {
            'title': 'Resposta incorreta 2',
            'statement': 'Outra alternativa incorreta.',
            'is_correct': false,
            'explanation': 'Explicação.',
            'weight': 1,
          },
          {
            'title': 'Resposta incorreta 3',
            'statement': 'Mais uma alternativa incorreta.',
            'is_correct': false,
            'explanation': 'Explicação.',
            'weight': 1,
          },
        ],
      },
      AiAgentTask.createEssayQuestion || AiAgentTask.createFeynman => {
        'title': 'Questão dissertativa',
        'statement': 'Explique o processo.',
        'reference_correct_answer': 'A resposta esperada.',
      },
      _ => throw StateError('Unexpected task: ${task.wireName}'),
    };
    return parse(response);
  }
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
