import 'package:flutter_test/flutter_test.dart';
import 'package:noema/core/database/database.dart';
import 'package:noema/feature/graph/service/sugiyama.dart';

void main() {
  test('orients reversed subtopic edges from broader to narrower nodes', () {
    final layout = calculateSugiyamaLayout(
      nodes: [
        _node('area', 'AREA'),
        _node('topic', 'TOPIC'),
        _node('concept', 'CONCEPT'),
      ],
      edges: [
        _edge('area-topic', 'topic', 'area', 'SUBTOPIC'),
        _edge('topic-concept', 'concept', 'topic', 'SUBTOPIC'),
      ],
      config: const SugiyamaConfig(preservePreviousOrder: false),
    );

    expect(layout.layers['area'], lessThan(layout.layers['topic']!));
    expect(layout.layers['topic'], lessThan(layout.layers['concept']!));
    expect(
      layout.positions['area']!.dy,
      lessThan(layout.positions['topic']!.dy),
    );
    expect(
      layout.positions['topic']!.dy,
      lessThan(layout.positions['concept']!.dy),
    );
    expect(layout.positions['area']!.dx, layout.positions['topic']!.dx);
    expect(layout.positions['topic']!.dx, layout.positions['concept']!.dx);
  });

  test('caps layer width and preserves minimum node separation', () {
    const config = SugiyamaConfig(
      maxNodesPerLayer: 3,
      preservePreviousOrder: false,
    );
    final nodes = [
      for (var index = 0; index < 10; index++) _node('node-$index', 'AREA'),
    ];
    final layout = calculateSugiyamaLayout(
      nodes: nodes,
      edges: const [],
      config: config,
    );

    final countByLayer = <int, int>{};
    for (final layer in layout.layers.values) {
      countByLayer.update(layer, (count) => count + 1, ifAbsent: () => 1);
    }
    expect(countByLayer.values, everyElement(lessThanOrEqualTo(3)));

    for (final layer in countByLayer.keys) {
      final nodesInLayer =
          nodes.where((node) => layout.layers[node.id] == layer).toList()..sort(
            (first, second) => layout.positions[first.id]!.dx.compareTo(
              layout.positions[second.id]!.dx,
            ),
          );
      for (var index = 1; index < nodesInLayer.length; index++) {
        final previousX = layout.positions[nodesInLayer[index - 1].id]!.dx;
        final currentX = layout.positions[nodesInLayer[index].id]!.dx;
        expect(
          currentX - previousX,
          greaterThanOrEqualTo(config.minimumHorizontalGap),
        );
      }
    }
  });

  test(
    'keeps prerequisite flow downward and produces deterministic positions',
    () {
      final nodes = [
        _node('prerequisite', 'CONCEPT'),
        _node('dependent', 'CONCEPT'),
        _node('independent', 'CONCEPT'),
      ];
      final edges = [
        _edge('prerequisite-link', 'prerequisite', 'dependent', 'PREREQUISITE'),
      ];
      const config = SugiyamaConfig(
        maxNodesPerLayer: 2,
        preservePreviousOrder: false,
      );

      final first = calculateSugiyamaLayout(
        nodes: nodes,
        edges: edges,
        config: config,
      );
      final second = calculateSugiyamaLayout(
        nodes: nodes,
        edges: edges,
        config: config,
      );

      expect(
        first.layers['prerequisite'],
        lessThan(first.layers['dependent']!),
      );
      expect(second.positions, first.positions);
    },
  );

  test('reorients cyclic edges for layout without dropping graph nodes', () {
    final layout = calculateSugiyamaLayout(
      nodes: [_node('first', 'CONCEPT'), _node('second', 'CONCEPT')],
      edges: [
        _edge('forward', 'first', 'second', 'PREREQUISITE'),
        _edge('backward', 'second', 'first', 'PREREQUISITE'),
      ],
      config: const SugiyamaConfig(preservePreviousOrder: false),
    );

    expect(layout.cyclesBrokenCount, 1);
    expect(layout.positions.keys, {'first', 'second'});
    expect(
      layout.positions.values.every((position) => position.dx.isFinite),
      isTrue,
    );
    expect(
      layout.positions.values.every((position) => position.dy.isFinite),
      isTrue,
    );
  });
}

GraphNodeData _node(String id, String type) => GraphNodeData(
  id: id,
  graphId: 'graph',
  type: type,
  title: id,
  isSkipped: false,
  positionX: 0,
  positionY: 0,
  createdAt: 0,
  updatedAt: 0,
  isFirstAccess: false,
  isAiGenerated: false,
  softDeleted: false,
);

GraphEdgeData _edge(String id, String source, String target, String type) =>
    GraphEdgeData(
      id: id,
      graphId: 'graph',
      sourceNodeId: source,
      targetNodeId: target,
      type: type,
    );
