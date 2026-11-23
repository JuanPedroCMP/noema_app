import 'dart:convert';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noema/core/database/database.dart';
import 'package:noema/feature/graph/service/import_grap_from_json.dart';

void main() {
  late AppDatabase database;

  setUp(() async {
    database = AppDatabase.forTesting(NativeDatabase.memory());
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
  });

  tearDown(() async {
    await database.close();
  });

  test('imports a graph with duplicate edges only once', () async {
    final graphId = await importGraphFromJson(
      db: database,
      userId: 'user-id',
      jsonString: jsonEncode({
        'graph_title': 'Biologia básica',
        'nodes': [
          {'node_id': 1, 'title': 'Biologia', 'type': 'AREA'},
          {'node_id': 2, 'title': 'Biologia básica', 'type': 'TOPIC'},
        ],
        'edges': [
          {'source_node': 1, 'target_node': 2, 'type': 'SUBTOPIC'},
          {'source_node': 1, 'target_node': 2, 'type': 'SUBTOPIC'},
        ],
      }),
      isAiGenerated: true,
    );

    final savedEdges = await (database.select(
      database.graphEdge,
    )..where((edge) => edge.graphId.equals(graphId))).get();

    expect(savedEdges, hasLength(1));
    expect(
      savedEdges.single.sourceNodeId,
      isNot(savedEdges.single.targetNodeId),
    );
    expect(savedEdges.single.type, 'SUBTOPIC');
    expect(savedEdges.single.weight, 1.0);
    final nodes = await (database.select(
      database.graphNode,
    )..where((node) => node.graphId.equals(graphId))).get();
    final parent = nodes.singleWhere((node) => node.title == 'Biologia');
    final child = nodes.singleWhere((node) => node.title == 'Biologia básica');
    expect(savedEdges.single.sourceNodeId, child.id);
    expect(savedEdges.single.targetNodeId, parent.id);
    expect(parent.positionY, lessThan(child.positionY));
  });

  test(
    'imports generated prerequisite weights and defaults legacy weights',
    () async {
      final graphId = await importGraphFromJson(
        db: database,
        userId: 'user-id',
        jsonString: jsonEncode({
          'graph_title': 'Matemática',
          'nodes': [
            {
              'node_id': 1,
              'title': 'Álgebra',
              'type': 'CONCEPT',
              'level': 'foundation',
            },
            {
              'node_id': 2,
              'title': 'Equações',
              'type': 'CONCEPT',
              'level': 'core',
            },
          ],
          'edges': [
            {
              'source_node': 1,
              'target_node': 2,
              'type': 'PREREQUISITE',
              'weight': 0.5,
            },
          ],
        }),
        isAiGenerated: true,
      );
      final savedEdges = await (database.select(
        database.graphEdge,
      )..where((edge) => edge.graphId.equals(graphId))).get();

      expect(savedEdges.single.weight, 0.5);
    },
  );

  test('queues only missing descriptions with the graph import', () async {
    final graphId = await importGraphFromJson(
      db: database,
      userId: 'user-id',
      jsonString: jsonEncode({
        'graph_title': 'Biologia básica',
        'nodes': [
          {'node_id': 1, 'title': 'Biologia', 'type': 'AREA'},
          {
            'node_id': 2,
            'title': 'Biologia básica',
            'type': 'TOPIC',
            'description': 'Descrição existente',
          },
          {
            'node_id': 3,
            'title': 'Fotossíntese',
            'type': 'CONCEPT',
            'description':
                'Explicar como a energia luminosa é convertida em energia química.',
            'level': 'foundation',
          },
        ],
        'edges': [
          {'source_node': 1, 'target_node': 2, 'type': 'SUBTOPIC'},
          {'source_node': 2, 'target_node': 3, 'type': 'SUBTOPIC'},
        ],
      }),
      isAiGenerated: true,
      queueMissingAiDescriptions: true,
    );

    final nodes = await (database.select(
      database.graphNode,
    )..where((node) => node.graphId.equals(graphId))).get();
    final tasks = await database.select(database.aiBackgroundTask).get();

    expect(tasks, hasLength(1));
    expect(
      tasks.single.nodeId,
      nodes.singleWhere((node) => node.title == 'Biologia').id,
    );
    expect(
      nodes.singleWhere((node) => node.title == 'Fotossíntese').description,
      'Explicar como a energia luminosa é convertida em energia química.',
    );
    expect(tasks.single.status, 'PENDING');
  });

  test(
    'queues replacement descriptions for every generated graph node',
    () async {
      final graphId = await importGraphFromJson(
        db: database,
        userId: 'user-id',
        jsonString: jsonEncode({
          'graph_title': 'Biologia básica',
          'nodes': [
            {
              'node_id': 1,
              'title': 'Biologia',
              'type': 'AREA',
              'description': 'Resumo provisório.',
            },
            {
              'node_id': 2,
              'title': 'Ecologia',
              'type': 'TOPIC',
              'description': 'Outro resumo provisório.',
            },
            {
              'node_id': 3,
              'title': 'Ciclos biogeoquímicos',
              'type': 'CONCEPT',
              'description': 'Descrição criada junto ao grafo.',
            },
          ],
          'edges': [
            {'source_node': 1, 'target_node': 2, 'type': 'SUBTOPIC'},
            {'source_node': 2, 'target_node': 3, 'type': 'SUBTOPIC'},
          ],
        }),
        isAiGenerated: true,
        regenerateAiDescriptions: true,
      );

      final nodes = await (database.select(
        database.graphNode,
      )..where((node) => node.graphId.equals(graphId))).get();
      final tasks = await database.select(database.aiBackgroundTask).get();
      final tasksByNodeId = {for (final task in tasks) task.nodeId: task};

      expect(tasks, hasLength(3));
      for (final node in nodes) {
        final payload =
            jsonDecode(tasksByNodeId[node.id]!.payloadJson)
                as Map<String, dynamic>;
        expect(payload['replace_existing_description'], isTrue);
        expect(payload['expected_description'], node.description);
      }
    },
  );

  test(
    'repairs and imports an AI-generated graph with cycles and invalid edges',
    () async {
      final graphId = await importGraphFromJson(
        db: database,
        userId: 'user-id',
        jsonString: jsonEncode({
          'graph_title': 'Biologia do ENEM',
          'nodes': [
            {'node_id': 1, 'title': 'Biologia', 'type': 'AREA'},
            {'node_id': 2, 'title': 'Genética', 'type': 'TOPIC'},
            {'node_id': 3, 'title': 'Mendel', 'type': 'CONCEPT'},
          ],
          'edges': [
            {'source_node': 1, 'target_node': 2, 'type': 'SUBTOPIC'},
            {'source_node': 2, 'target_node': 3, 'type': 'SUBTOPIC'},
            // Cycle: 1 is SUBTOPIC of 3
            {'source_node': 3, 'target_node': 1, 'type': 'SUBTOPIC'},
            // Self loop
            {'source_node': 2, 'target_node': 2, 'type': 'SUBTOPIC'},
          ],
        }),
        isAiGenerated: true,
      );

      final savedEdges = await (database.select(
        database.graphEdge,
      )..where((edge) => edge.graphId.equals(graphId))).get();

      // Cycle and self loop should be broken/removed, leaving 2 valid edges
      expect(savedEdges, hasLength(2));
      final nodes = await (database.select(
        database.graphNode,
      )..where((node) => node.graphId.equals(graphId))).get();
      expect(nodes, hasLength(3));
    },
  );
}
