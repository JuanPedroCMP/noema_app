import 'package:flutter_test/flutter_test.dart';
import 'package:noema/feature/graph/service/ai_graph_patch.dart';

void main() {
  test('parses and validates compact IDs and explicit new-node IDs', () {
    final patch = AiGraphPatch.fromJson({
      'delete_nodes': [3],
      'rename_nodes': [
        {'id': 1, 'title': 'Fotossíntese'},
      ],
      'add_nodes': [
        {'id': 'new_1', 'title': 'Clorofila'},
      ],
      'delete_edges': [2],
      'add_edges': [
        {
          'source_node': 1,
          'target_node': 'new_1',
          'type': 'prerequisite',
          'weight': 1.5,
        },
      ],
    });

    patch.validate(existingNodeIds: {1, 2, 3}, existingEdgeIds: {1, 2});

    expect(patch.deletedNodeIds, [3]);
    expect(patch.renamedNodes.single.title, 'Fotossíntese');
    expect(patch.addedNodes.single.id, 'new_1');
    expect(patch.addedEdges.single.type, 'PREREQUISITE');
    expect(patch.addedEdges.single.weight, 1.5);
  });

  test('rejects unknown IDs, dangling edges, and unmarked new IDs', () {
    final unknownNode = AiGraphPatch.fromJson({
      'delete_nodes': [9],
    });
    expect(
      () => unknownNode.validate(existingNodeIds: {1}, existingEdgeIds: {}),
      throwsFormatException,
    );

    final danglingEdge = AiGraphPatch.fromJson({
      'add_edges': [
        {'source_node': 1, 'target_node': 9, 'type': 'SUBTOPIC'},
      ],
    });
    expect(
      () => danglingEdge.validate(existingNodeIds: {1}, existingEdgeIds: {}),
      throwsFormatException,
    );

    expect(
      () => AiGraphPatch.fromJson({
        'add_nodes': [
          {'id': 1, 'title': 'Sem marcador new'},
        ],
      }),
      throwsFormatException,
    );
  });

  test('rejects graph node and edge types outside the database contract', () {
    expect(
      () => AiGraphPatch.fromJson({
        'add_nodes': [
          {'id': 'new_1', 'title': 'Nó', 'type': 'UNKNOWN'},
        ],
      }),
      throwsFormatException,
    );
    expect(
      () => AiGraphPatch.fromJson({
        'add_edges': [
          {'source_node': 1, 'target_node': 2, 'type': 'RELATED'},
        ],
      }),
      throwsFormatException,
    );
  });
}
