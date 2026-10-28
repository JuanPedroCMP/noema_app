import 'dart:math' as math;
import 'dart:ui' show PathMetric;

import 'package:flutter/cupertino.dart';
import 'package:noema/core/database/database.dart';
import 'package:noema/core/design/theme/theme_tokens.dart';

(String, bool, bool) getTapTarget(
  Offset position,
  List<GraphNodeData> nodes,
  (List<Path>, List<String>) paths,
  BuildContext context,
) {
  const nodeWidth = 200.0;
  const nodeHeight = 80.0;
  // Nodes
  for (final node in nodes) {
    final rect = Rect.fromLTWH(
      node.positionX - nodeWidth / 2,
      node.positionY - nodeHeight / 2,
      nodeWidth,
      nodeHeight,
    );

    final rrect = RRect.fromRectAndRadius(
      rect,
      Radius.circular(context.radius.card),
    );

    if (rrect.contains(position)) {
      return (node.id, true, true);
    }
  }

  const tolerance = 15.0;
  for (int pathIndex = 0; pathIndex < paths.$1.length; pathIndex++) {
    final path = paths.$1[pathIndex];

    for (final metric in path.computeMetrics()) {
      if (_distanceToPath(metric, position) <= tolerance) {
        return (paths.$2[pathIndex], false, true);
      }
    }
  }

  return ("", false, false);
}

double _distanceToPath(PathMetric metric, Offset position) {
  const sampleCount = 24;
  var minimumDistance = double.infinity;

  for (var index = 0; index <= sampleCount; index++) {
    final tangent = metric.getTangentForOffset(
      metric.length * index / sampleCount,
    );
    if (tangent != null) {
      minimumDistance = math.min(
        minimumDistance,
        (position - tangent.position).distance,
      );
    }
  }

  return minimumDistance;
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
