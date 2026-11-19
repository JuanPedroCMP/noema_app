import 'package:flutter_test/flutter_test.dart';
import 'package:noema/core/database/database.dart';
import 'package:noema/feature/graph/service/calculate_paths.dart';

void main() {
  const parent = GraphNodeData(
    id: 'parent',
    graphId: 'graph',
    type: 'TOPIC',
    title: 'Parent',
    isSkipped: false,
    positionX: 100,
    positionY: 100,
    createdAt: 0,
    updatedAt: 0,
    isFirstAccess: false,
    isAiGenerated: false,
    softDeleted: false,
  );
  const child = GraphNodeData(
    id: 'child',
    graphId: 'graph',
    type: 'SUBCONCEPT',
    title: 'Child',
    isSkipped: false,
    positionX: 300,
    positionY: 260,
    createdAt: 0,
    updatedAt: 0,
    isFirstAccess: false,
    isAiGenerated: false,
    softDeleted: false,
  );

  final relations = [
    const GraphEdgeData(
      id: 'prerequisite',
      graphId: 'graph',
      sourceNodeId: 'parent',
      targetNodeId: 'child',
      type: 'PREREQUISITE',
    ),
    const GraphEdgeData(
      id: 'subtopic',
      graphId: 'graph',
      sourceNodeId: 'child',
      targetNodeId: 'parent',
      type: 'SUBTOPIC',
    ),
  ];

  for (final option in [0, 1, 2, 3]) {
    test('routes option $option from parent bottom to child top', () {
      final (paths, ids) = calculatePaths([parent, child], relations, option);

      expect(ids, ['prerequisite', 'subtopic']);
      for (final path in paths) {
        final metric = path.computeMetrics().single;
        expect(metric.getTangentForOffset(0)!.position, const Offset(100, 140));
        expect(
          metric.getTangentForOffset(metric.length)!.position,
          const Offset(300, 220),
        );
      }
    });
  }

  test('keeps subtopic anchors when the existing layout puts parent below', () {
    final parentBelow = parent.copyWith(positionY: 260);
    final childAbove = child.copyWith(positionY: 100);
    final (paths, ids) = calculatePaths(
      [parentBelow, childAbove],
      [relations.last],
      0,
    );

    expect(ids, ['subtopic']);
    final metric = paths.single.computeMetrics().single;
    expect(metric.getTangentForOffset(0)!.position, const Offset(100, 300));
    expect(
      metric.getTangentForOffset(metric.length)!.position,
      const Offset(300, 60),
    );
  });

  test('uses node hierarchy when a subtopic edge direction is reversed', () {
    const reversedSubtopic = GraphEdgeData(
      id: 'reversed-subtopic',
      graphId: 'graph',
      sourceNodeId: 'parent',
      targetNodeId: 'child',
      type: 'SUBTOPIC',
    );
    final (paths, ids) = calculatePaths([parent, child], [reversedSubtopic], 0);

    expect(ids, ['reversed-subtopic']);
    final metric = paths.single.computeMetrics().single;
    expect(metric.getTangentForOffset(0)!.position, const Offset(100, 140));
    expect(
      metric.getTangentForOffset(metric.length)!.position,
      const Offset(300, 220),
    );
  });
}
