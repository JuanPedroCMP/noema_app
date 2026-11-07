import 'package:flutter_test/flutter_test.dart';
import 'package:noema/feature/graph/service/sugiyama.dart';

void main() {
  test(
    'keeps generations in consecutive layers and centers a parent over children',
    () {
      final layout = computeSugiyamaLayout(
        nodeIds: const [
          'parent',
          'child-1',
          'child-2',
          'child-3',
          'grandchild-1',
        ],
        edges: const [
          SugiyamaLayoutEdge(sourceNodeId: 'parent', targetNodeId: 'child-1'),
          SugiyamaLayoutEdge(sourceNodeId: 'parent', targetNodeId: 'child-2'),
          SugiyamaLayoutEdge(sourceNodeId: 'parent', targetNodeId: 'child-3'),
          SugiyamaLayoutEdge(
            sourceNodeId: 'child-1',
            targetNodeId: 'grandchild-1',
          ),
        ],
        previousX: const {},
        config: const SugiyamaConfig(
          horizontalSpacing: 100,
          minimumHorizontalGap: 80,
          verticalSpacing: 50,
          preservePreviousOrder: false,
          mode: SugiyamaLayoutMode.centered,
        ),
      );

      final parent = layout.positions['parent']!;
      final child1 = layout.positions['child-1']!;
      final child2 = layout.positions['child-2']!;
      final child3 = layout.positions['child-3']!;
      final grandchild = layout.positions['grandchild-1']!;

      expect(layout.layers['parent'], 0);
      expect(layout.layers['child-1'], 1);
      expect(layout.layers['child-2'], 1);
      expect(layout.layers['child-3'], 1);
      expect(layout.layers['grandchild-1'], 2);

      expect(parent.dy, 0);
      expect(child1.dy, 50);
      expect(child2.dy, 50);
      expect(child3.dy, 50);
      expect(grandchild.dy, 100);

      expect(child2.dx - child1.dx, greaterThanOrEqualTo(100));
      expect(child3.dx - child2.dx, greaterThanOrEqualTo(100));
      expect(parent.dx, closeTo((child1.dx + child3.dx) / 2, 0.0001));
      expect(grandchild.dx, child1.dx);
    },
  );
}
