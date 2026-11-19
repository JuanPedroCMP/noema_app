import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noema/core/database/database.dart';
import 'package:noema/core/router/route_paths.dart';
import 'package:noema/feature/search/data/global_search_service.dart';

void main() {
  late AppDatabase database;
  late GlobalSearchService service;

  setUp(() async {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    service = GlobalSearchService(database);
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
    await database
        .into(database.knowledgeGraph)
        .insert(
          KnowledgeGraphCompanion.insert(
            id: 'graph-id',
            userId: 'user-id',
            title: 'Matemática',
            description: const Value('Derivadas e integrais'),
          ),
        );
    await database
        .into(database.graphNode)
        .insert(
          GraphNodeCompanion.insert(
            id: 'node-id',
            graphId: 'graph-id',
            type: 'TOPIC',
            title: 'Derivada',
            description: const Value('Taxa de variação'),
            positionX: 0,
            positionY: 0,
          ),
        );
    await database
        .into(database.openEnded)
        .insert(
          OpenEndedCompanion.insert(
            id: 'task-id',
            nodeId: 'node-id',
            title: 'Explique a derivada',
            statement: 'Descreva como calcular uma derivada.',
            type: 'ESSAY',
          ),
        );
    await database
        .into(database.flashcard)
        .insert(
          FlashcardCompanion.insert(
            id: 'flashcard-id',
            nodeId: 'node-id',
            title: 'Regra da derivada',
            statement: 'Como calcular a derivada de uma potência?',
          ),
        );
    await database
        .into(database.note)
        .insert(
          NoteCompanion.insert(
            id: 'note-id',
            userId: 'user-id',
            title: 'Revisão de derivadas',
            contentQuillJson: '[]',
            currentVersion: 1,
          ),
        );
    await database
        .into(database.studySession)
        .insert(
          StudySessionCompanion.insert(
            id: 'session-id',
            userId: 'user-id',
            title: 'Estudar derivadas',
            status: 'CONFIGURING',
            targetDurationMin: 30,
          ),
        );
  });

  tearDown(() => database.close());

  test(
    'finds and routes graphs, nodes, tasks, flashcards, notes and sessions',
    () async {
      final results = await service.search(
        userId: 'user-id',
        query: 'derivada',
      );

      expect(
        results.map((result) => result.kind),
        containsAll({
          GlobalSearchKind.graph,
          GlobalSearchKind.node,
          GlobalSearchKind.task,
          GlobalSearchKind.flashcard,
          GlobalSearchKind.note,
          GlobalSearchKind.session,
        }),
      );
      expect(
        results
            .firstWhere((result) => result.kind == GlobalSearchKind.node)
            .path,
        RoutePaths.graph('graph-id'),
      );
      expect(
        results
            .firstWhere((result) => result.kind == GlobalSearchKind.task)
            .path,
        RoutePaths.openEndedAnswer('graph-id', 'node-id', 'task-id'),
      );
      expect(
        results
            .firstWhere((result) => result.kind == GlobalSearchKind.flashcard)
            .path,
        RoutePaths.flashcardsForNode('graph-id', 'node-id'),
      );
      expect(
        results
            .firstWhere((result) => result.kind == GlobalSearchKind.session)
            .path,
        RoutePaths.studySession('session-id'),
      );
    },
  );

  test('requires two characters and returns no other users content', () async {
    expect(await service.search(userId: 'user-id', query: 'd'), isEmpty);
    expect(
      await service.search(userId: 'other-user', query: 'derivada'),
      isEmpty,
    );
  });
}
