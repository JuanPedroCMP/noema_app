import 'dart:convert';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noema/core/database/database.dart';
import 'package:noema/feature/graph/data/graph_edge_dao.dart';
import 'package:noema/feature/graph/data/graph_node_dao.dart';
import 'package:noema/feature/graph/service/ai_graph_edit_service.dart';
import 'package:noema/feature/graph/service/ai_graph_patch.dart';
import 'package:noema/feature/graph/service/compact_graph_context.dart';
import 'package:noema/feature/graph/service/import_grap_from_json.dart';

void main() {
  late AppDatabase database;
  late String graphId;

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
    graphId = await importGraphFromJson(
      db: database,
      userId: 'user-id',
      jsonString: jsonEncode({
        'graph_title': 'Biologia',
        'nodes': [
          {'node_id': 1, 'title': 'A', 'type': 'CONCEPT'},
          {'node_id': 2, 'title': 'B', 'type': 'CONCEPT'},
          {'node_id': 3, 'title': 'C', 'type': 'CONCEPT'},
        ],
        'edges': [
          {'source_node': 1, 'target_node': 2, 'type': 'PREREQUISITE'},
          {'source_node': 2, 'target_node': 3, 'type': 'SUBTOPIC'},
        ],
      }),
    );
  });

  tearDown(() async => database.close());

  test(
    'applies node and edge edits atomically and queues descriptions',
    () async {
      final nodes = await GraphNodeDao(
        database,
      ).getGraphNodesByGraph(graphId: graphId);
      final edges = await GraphEdgeDao(
        database,
      ).getGraphEdgesByGraph(graphId: graphId);
      final snapshot = compactGraphSnapshot(nodes: nodes, edges: edges);
      final draft = AiGraphEditDraft(
        snapshot: snapshot,
        patch: AiGraphPatch.fromJson({
          'delete_nodes': [3],
          'rename_nodes': [
            {'id': 1, 'title': 'A revisado'},
          ],
          'add_nodes': [
            {'id': 'new_1', 'title': 'D', 'type': 'CONCEPT'},
          ],
          'delete_edges': [2],
          'add_edges': [
            {'source_node': 1, 'target_node': 'new_1', 'type': 'SUBTOPIC'},
          ],
        }),
      );

      await AiGraphPatchApplier(database).apply(graphId: graphId, draft: draft);

      final savedNodes = await GraphNodeDao(
        database,
      ).getGraphNodesByGraph(graphId: graphId);
      final savedEdges = await GraphEdgeDao(
        database,
      ).getGraphEdgesByGraph(graphId: graphId);
      final queuedDescriptions = await (database.select(
        database.aiBackgroundTask,
      )..where((task) => task.taskType.equals('NODE_DESCRIPTION'))).get();
      expect(savedNodes.map((node) => node.title).toSet(), {
        'A revisado',
        'B',
        'D',
      });
      expect(savedEdges, hasLength(2));
      expect(queuedDescriptions, hasLength(2));
      expect(
        (await GraphNodeDao(
          database,
        ).getGraphNode(id: snapshot.nodesByCompactId[3]!.id))?.softDeleted,
        isTrue,
      );
    },
  );

  test('rejects stale drafts without overwriting concurrent edits', () async {
    final nodes = await GraphNodeDao(
      database,
    ).getGraphNodesByGraph(graphId: graphId);
    final edges = await GraphEdgeDao(
      database,
    ).getGraphEdgesByGraph(graphId: graphId);
    final snapshot = compactGraphSnapshot(nodes: nodes, edges: edges);
    final draft = AiGraphEditDraft(
      snapshot: snapshot,
      patch: AiGraphPatch.fromJson({
        'rename_nodes': [
          {'id': 1, 'title': 'Título da IA'},
        ],
      }),
    );
    await GraphNodeDao(database).updateGraphNode(
      id: snapshot.nodesByCompactId[1]!.id,
      title: 'Edição concorrente',
    );

    await expectLater(
      AiGraphPatchApplier(database).apply(graphId: graphId, draft: draft),
      throwsStateError,
    );
    final current = await GraphNodeDao(
      database,
    ).getGraphNode(id: snapshot.nodesByCompactId[1]!.id);
    expect(current?.title, 'Edição concorrente');
  });
}
