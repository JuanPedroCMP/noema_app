import 'package:flutter/cupertino.dart';
import 'package:flutter/painting.dart';
import 'package:noema/core/database/database.dart';
import 'package:noema/core/design/theme/theme_tokens.dart';
import 'package:noema/feature/graph/provider/selected_provider.dart';

(String, bool, bool) getTapTarget(
  Offset position,
  List<GraphNodeData> nodes,
  List<GraphEdgeData> edges,
  (List<Path>, List<String>) paths,
  SelectedNotifier selectedNotifier,
  BuildContext context,
) {
  final double nodeWidth = 200;
  final double nodeHeigth = 80;
  // Nodes
  for (final node in nodes) {
    final rect = Rect.fromLTWH(
      node.positionX - nodeWidth / 2,
      node.positionY - nodeHeigth / 2,
      nodeWidth,
      nodeHeigth,
    );

    final rrect = RRect.fromRectAndRadius(
      rect,
      Radius.circular(context.radius.card),
    );

    if (rrect.contains(position)) {
      selectedNotifier.selectedChanged(node.id);
      return (node.id, true, true);
    }
  }

  const tolerance = 15.0;
  const step = 5.0;

  for (int pathIndex = 0; pathIndex < paths.$1.length; pathIndex++) {
    final path = paths.$1[pathIndex];

    for (final metric in path.computeMetrics()) {
      for (double distance = 0; distance <= metric.length; distance += step) {
        final tangent = metric.getTangentForOffset(distance);

        if (tangent == null) {
          continue;
        }

        final pathPoint = tangent.position;

        if ((position - pathPoint).distance <= tolerance) {
          selectedNotifier.selectedChanged(paths.$2[pathIndex]);
          return (paths.$2[pathIndex], false, true);
        }
      }
    }
  }

  return ("", false, false);
}

// Ações
GraphNodeData onNodeTap(
  List<GraphNodeData> nodes,
  String nodeId,
  TransformationController controller,
) {
  controller.value = Matrix4.identity();
  return nodes.firstWhere((node) => node.id == nodeId);
}
