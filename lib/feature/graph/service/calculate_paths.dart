import 'dart:ui';

import 'package:noema/core/database/database.dart';

(List<Path>, List<String>) calculatePaths(
  List<GraphNodeData> nodes,
  List<GraphEdgeData> edges,
  int option,
) {
  final nodesById = {for (final node in nodes) node.id: node};

  final paths = <Path>[];
  final ids = <String>[];

  const nodeHeight = 80.0;

  int? hierarchyLevel(String type) => switch (type.toUpperCase()) {
    'AREA' => 0,
    'TOPIC' => 1,
    'CONCEPT' => 2,
    'SUBCONCEPT' => 3,
    _ => null,
  };

  for (final edge in edges) {
    final source = nodesById[edge.sourceNodeId];
    final target = nodesById[edge.targetNodeId];

    if (source == null || target == null) {
      continue;
    }

    var parent = source;
    var child = target;
    if (edge.type.toUpperCase() == 'SUBTOPIC') {
      final sourceLevel = hierarchyLevel(source.type);
      final targetLevel = hierarchyLevel(target.type);
      if (sourceLevel != null &&
          targetLevel != null &&
          sourceLevel != targetLevel) {
        parent = sourceLevel < targetLevel ? source : target;
        child = sourceLevel < targetLevel ? target : source;
      } else {
        parent = target;
        child = source;
      }
    }

    final parentBottom = Offset(
      parent.positionX,
      parent.positionY + nodeHeight / 2,
    );
    final childTop = Offset(child.positionX, child.positionY - nodeHeight / 2);
    final path = Path();

    if (option == 1) {
      path
        ..moveTo(parentBottom.dx, parentBottom.dy)
        ..lineTo(childTop.dx, childTop.dy);
    } else if (option == 2) {
      final middleY = (child.positionY + parent.positionY) / 2;
      path.addPolygon(<Offset>[
        parentBottom,
        Offset(parent.positionX, middleY),
        Offset(child.positionX, middleY),
        childTop,
      ], false);
    } else if (option == 3) {
      path.addPolygon(<Offset>[
        parentBottom,
        Offset(child.positionX, (child.positionY + parent.positionY) / 2),
        childTop,
      ], false);
    } else {
      path
        ..moveTo(parentBottom.dx, parentBottom.dy)
        ..quadraticBezierTo(
          parent.positionX,
          (parent.positionY + child.positionY) / 2,
          childTop.dx,
          childTop.dy,
        );
    }

    paths.add(path);
    ids.add(edge.id);
  }

  return (paths, ids);
}
