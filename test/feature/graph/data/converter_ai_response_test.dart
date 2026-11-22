import 'package:flutter_test/flutter_test.dart';
import 'package:noema/feature/graph/data/converter_ai_response.dart';

GraphNode _node(int id, String title, {String type = 'CONCEPT', String? level}) =>
    GraphNode(
      nodeId: id,
      title: title,
      description: '',
      type: GraphNodeType.fromString(type),
      level: level,
    );

GraphEdge _edge(
  int source,
  int target, {
  String type = 'PREREQUISITE',
  double weight = 1,
}) => GraphEdge(
  sourceNode: source,
  targetNode: target,
  type: type,
  weight: weight,
);

void main() {
  test('legacy JSON defaults weight but omits transient values when absent', () {
    final graph = GraphResponse.fromJson({
      'graph_title': 'Fundamentos',
      'nodes': [
        {'node_id': 1, 'title': 'Base', 'type': 'CONCEPT'},
      ],
      'edges': [
        {'source_node': 1, 'target_node': 2, 'type': 'PREREQUISITE'},
      ],
    });

    expect(graph.edges.single.weight, 1.0);
    expect(graph.nodes.single.level, isNull);
    expect(graph.toJson()['nodes'].single.containsKey('level'), isFalse);
    expect(graph.toJson()['edges'].single['weight'], 1.0);
  });

  test('repair removes container prerequisites, self-loops and duplicates', () {
    final graph = GraphResponse(
      graphTitle: 'Grafo',
      graphDescription: '',
      nodes: [
        _node(1, 'Área', type: 'AREA'),
        _node(2, 'Tópico', type: 'TOPIC'),
        _node(3, 'Folha', level: 'foundation'),
      ],
      edges: [
        _edge(1, 2, type: 'SUBTOPIC'),
        _edge(2, 3, type: 'SUBTOPIC'),
        _edge(2, 3, weight: 0.4),
        _edge(2, 3, type: 'SUBTOPIC', weight: 0.4),
        _edge(3, 3),
      ],
    ).repair();

    expect(graph.edges.map((edge) => (edge.sourceNode, edge.targetNode)), [
      (1, 2),
      (2, 3),
    ]);
    expect(
      graph.problems.map((problem) => problem.code),
      containsAll(['container_prerequisite_removed', 'self_loop_removed']),
    );
    expect(
      graph.problems.map((problem) => problem.code),
      contains('duplicate_edge_removed'),
    );
  });

  test('repair removes the lowest-weight cycle edge and reduces transitivity', () {
    final graph = GraphResponse(
      graphTitle: 'Ciclo e transitividade',
      graphDescription: '',
      nodes: [
        _node(1, 'Fundamento', level: 'foundation'),
        _node(2, 'Núcleo'),
        _node(3, 'Avançado', level: 'advanced'),
        _node(4, 'Alternativo'),
      ],
      edges: [
        _edge(1, 2, weight: 0.8),
        _edge(2, 3, weight: 0.2),
        _edge(3, 1, weight: 0.2),
        _edge(1, 3, weight: 0.4),
        _edge(1, 4, weight: 0),
      ],
    ).repair();

    expect(
      graph.edges.any((edge) => edge.sourceNode == 3 && edge.targetNode == 1),
      isFalse,
    );
    expect(
      graph.edges.any((edge) => edge.sourceNode == 1 && edge.targetNode == 3),
      isFalse,
    );
    expect(
      graph.problems.map((problem) => problem.code),
      contains('cycle_edge_removed'),
    );
    expect(
      graph.problems.map((problem) => problem.code),
      contains('transitive_prerequisite_removed'),
    );
  });

  test('validate returns structured retry feedback for generation gaps', () {
    final graph = GraphResponse(
      graphTitle: 'Base',
      graphDescription: '',
      nodes: [_node(1, 'Neural networks'), _node(2, 'Neural network')],
      edges: const [],
    );

    final problems = graph.validate();
    expect(problems, isNotEmpty);
    expect(problems.every((problem) => problem.retryable), isTrue);
    expect(
      problems.map((problem) => problem.code),
      containsAll([
        'leaf_without_prerequisite',
        'leaf_unreachable_from_foundation',
        'duplicate_or_similar_titles',
      ]),
    );
  });
}
