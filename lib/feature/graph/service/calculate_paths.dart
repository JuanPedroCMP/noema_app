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

  final double nodeHeigth = 80;

  if (option == 1) {
    //// Direto
    for (final edge in edges) {
      final source = nodesById[edge.sourceNodeId];
      final target = nodesById[edge.targetNodeId];

      if (source == null || target == null) {
        continue;
      }

      final path = Path();

      path.moveTo(source.positionX, source.positionY + nodeHeigth / 2);

      path.lineTo(target.positionX, target.positionY - nodeHeigth / 2);

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
        Offset(source.positionX, source.positionY + nodeHeigth / 2),
        Offset(source.positionX, (target.positionY + source.positionY) / 2),
        Offset(target.positionX, (target.positionY + source.positionY) / 2),
        Offset(target.positionX, target.positionY - nodeHeigth / 2),
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
        Offset(source.positionX, source.positionY + nodeHeigth / 2),
        Offset(target.positionX, (target.positionY + source.positionY) / 2),
        Offset(target.positionX, target.positionY - nodeHeigth / 2),
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

      path.moveTo(source.positionX, source.positionY + nodeHeigth / 2);

      path.quadraticBezierTo(
        source.positionX,
        (source.positionY + target.positionY) / 2,
        target.positionX,
        target.positionY - nodeHeigth / 2,
      );

      paths.add(path);
      ids.add(edge.id);
    }
  }

  return (paths, ids);
}
