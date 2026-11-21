import 'package:flutter_test/flutter_test.dart';
import 'package:noema/core/database/database.dart';
import 'package:noema/feature/graph/service/compact_graph_context.dart';

void main() {
  test('compacts node and edge IDs and preserves complete edge data', () {
    final snapshot = compactGraphSnapshot(
      nodes: [_node('uuid-z', 'Zeta'), _node('uuid-a', 'Alpha')],
      edges: [_edge('edge-uuid', 'uuid-z', 'uuid-a', weight: 2.5)],
    );

    expect(snapshot.nodeCompactIdByLocalId, {'uuid-a': 1, 'uuid-z': 2});
    expect(snapshot.edgeCompactIdByLocalId, {'edge-uuid': 1});
    expect(
      snapshot.toJson(includeNodeTypes: false),
      {
        'nodes': [
          {'id': 1, 'title': 'Alpha'},
          {'id': 2, 'title': 'Zeta'},
        ],
        'edges': [
          {
            'id': 1,
            'source_node': 2,
            'target_node': 1,
            'type': 'PREREQUISITE',
            'weight': 2.5,
          },
        ],
      },
    );
    expect(snapshot.toJson()['nodes'].toString(), isNot(contains('uuid')));
  });

  test('includes target node and optional hierarchy type for study context', () {
    final snapshot = compactGraphSnapshot(
      nodes: [_node('node-a', 'Alpha')],
      edges: const [],
    );

    expect(
      snapshot.toJson(includeNodeTypes: true, targetNodeId: 'node-a'),
      {
        'target_node': 1,
        'nodes': [
          {'id': 1, 'title': 'Alpha', 'type': 'CONCEPT'},
        ],
        'edges': <Map<String, Object?>>[],
      },
    );
    expect(
      () => snapshot.toJson(targetNodeId: 'unknown'),
      throwsStateError,
    );
  });
}

GraphNodeData _node(String id, String title) => GraphNodeData(
  id: id,
  graphId: 'graph',
  type: 'CONCEPT',
  title: title,
  isSkipped: false,
  positionX: 0,
  positionY: 0,
  createdAt: 0,
  updatedAt: 0,
  isFirstAccess: false,
  isAiGenerated: false,
  softDeleted: false,
);

GraphEdgeData _edge(
  String id,
  String source,
  String target, {
  double? weight,
}) => GraphEdgeData(
  id: id,
  graphId: 'graph',
  sourceNodeId: source,
  targetNodeId: target,
  type: 'PREREQUISITE',
  weight: weight,
);
