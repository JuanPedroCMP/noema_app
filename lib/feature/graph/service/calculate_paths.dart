import 'dart:ui';

import 'package:noema/core/database/database.dart';

(List<Path>, List<String>) calculatePaths(
  List<GraphNodeData> nodes,
  List<GraphEdgeData> edges,
  int option,
) {
  final nodesById = {for (final node in nodes) node.id: node};

  List<Path> paths = [];
  List<String> ids = [];

  if (option == 1) {
    //// Direto
    for (final edge in edges) {
      final source = nodesById[edge.sourceNodeId];
      final target = nodesById[edge.targetNodeId];

      if (source == null || target == null) {
        continue;
      }

      final path = Path();

      path.moveTo(source.positionX, source.positionY);

      path.lineTo(target.positionX, target.positionY);

      paths.add(path);
      ids.add(edge.id);
    }
  } else if (option == 2) {
    //// Ângulo Reto
    for (final edge in edges) {
      final source = nodesById[edge.sourceNodeId];
      final target = nodesById[edge.targetNodeId];

      if (source == null || target == null) {
        continue;
      }

      final path = Path();

      path.addPolygon(<Offset>[
        Offset(source.positionX, source.positionY),
        Offset(source.positionX, (target.positionY + source.positionY) / 2),
        Offset(target.positionX, (target.positionY + source.positionY) / 2),
        Offset(target.positionX, target.positionY),
      ], false);

      paths.add(path);
      ids.add(edge.id);
    }
  } else if (option == 3) {
    //// Um vértice
    for (final edge in edges) {
      final source = nodesById[edge.sourceNodeId];
      final target = nodesById[edge.targetNodeId];

      if (source == null || target == null) {
        continue;
      }

      final path = Path();

      path.addPolygon(<Offset>[
        Offset(source.positionX, source.positionY),
        Offset(target.positionX, (target.positionY + source.positionY) / 2),
        Offset(target.positionX, target.positionY),
      ], false);
      paths.add(path);
      ids.add(edge.id);
    }
  } else {
    //// Curvado
    for (final edge in edges) {
      final source = nodesById[edge.sourceNodeId];
      final target = nodesById[edge.targetNodeId];

      if (source == null || target == null) {
        continue;
      }

      final path = Path();

      path.moveTo(source.positionX, source.positionY);

      path.quadraticBezierTo(
        source.positionX,
        (source.positionY + target.positionY) / 2,
        target.positionX,
        target.positionY,
      );

      paths.add(path);
      ids.add(edge.id);
    }
  }

  return (paths, ids);
}
