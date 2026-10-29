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
  });

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
        ],
        'edges': [
          {'source_node': 1, 'target_node': 2, 'type': 'SUBTOPIC'},
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
    expect(tasks.single.status, 'PENDING');
  });
}
