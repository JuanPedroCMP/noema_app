import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:noema/core/database/database.dart';
import 'package:noema/core/design/theme/theme_tokens.dart';
import 'package:noema/feature/graph/service/calculate_paths.dart';
import 'package:noema/feature/graph/service/learning_path.dart';

class GraphNode {
  GraphNode({required this.radius, required this.position});

  final Offset position;
  final double radius;
}

class GraphPainter extends CustomPainter {
  GraphPainter({
    required this.context,
    required this.nodes,
    required this.edges,
    required this.selected,
    required this.option,
    required this.origin,
    required Map<String, LearningNodeProgress> this.progressByNodeId,
    required List<String> this.recommendedNodeIds,
  });

  final BuildContext context;
  final List<GraphNodeData> nodes;
  final List<GraphEdgeData> edges;
  final String selected;
  final int option;
  final Offset origin;
  final Map<String, LearningNodeProgress>? progressByNodeId;
  final List<String>? recommendedNodeIds;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.translate(origin.dx, origin.dy);

    final progressByNodeId =
        this.progressByNodeId ?? const <String, LearningNodeProgress>{};
    final recommendedNodeIds = this.recommendedNodeIds ?? const <String>[];
    final colors = context.colors;
    final edgePaintSelected = Paint()
      ..color = colors.primary
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

    final prerequisitePaint = Paint()
      ..color = colors.primary.withValues(alpha: 0.75)
      ..strokeWidth = 2.2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

    final subtopicPaint = Paint()
      ..color = colors.tertiary.withValues(alpha: 0.75)
      ..strokeWidth = 2.2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

    final nodeFillPaint = Paint()
      ..color = colors.surfaceContainerLow
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final nodeSelectedPaint = Paint()
      ..color = colors.primaryContainer
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final selectedBorderPaint = Paint()
      ..color = colors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..isAntiAlias = true;

    const nodeWidth = 200.0;
    const nodeHeight = 80.0;

    Paint paintForEdge(GraphEdgeData edge) {
      if (edge.id == selected) return edgePaintSelected;
      return edge.type == 'SUBTOPIC' ? subtopicPaint : prerequisitePaint;
    }

    final (paths, edgeIds) = calculatePaths(nodes, edges, option);
    final edgesById = {for (final edge in edges) edge.id: edge};
    for (var index = 0; index < paths.length; index++) {
      final edge = edgesById[edgeIds[index]]!;
      _drawEdge(canvas, paths[index], paintForEdge(edge));
    }

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

      final isSelected = node.id == selected;
      final progress = progressByNodeId[node.id];
      final isRecommended =
          recommendedNodeIds.isNotEmpty && recommendedNodeIds.first == node.id;
      final stateColor = switch (progress?.status) {
        LearningProgressStatus.mastered => colors.tertiary,
        LearningProgressStatus.ready => colors.primary,
        LearningProgressStatus.availableWithGaps => colors.tertiary,
        null => colors.outlineVariant,
      };
      final fillPaint = isSelected ? nodeSelectedPaint : nodeFillPaint;
      if (isSelected) {
        canvas.drawShadow(Path()..addRRect(rrect), colors.shadow, 5, true);
      }
      canvas.drawRRect(rrect, fillPaint);
      final statusBorderPaint = Paint()
        ..color = isSelected ? colors.primary : stateColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = isSelected || isRecommended ? 2.8 : 1.7
        ..isAntiAlias = true;
      canvas.drawRRect(
        rrect,
        isSelected ? selectedBorderPaint : statusBorderPaint,
      );

      final typePainter = TextPainter(
        text: TextSpan(
          text: _nodeTypeLabel(node.type),
          style: TextStyle(
            color: isSelected ? colors.onPrimaryContainer : colors.primary,
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
          ),
        ),
        textDirection: Directionality.of(context),
        maxLines: 1,
        ellipsis: '…',
      )..layout(maxWidth: nodeWidth - 28);
      typePainter.paint(
        canvas,
        Offset(node.positionX - typePainter.width / 2, node.positionY - 26),
      );

      final titlePainter = TextPainter(
        text: TextSpan(
          text: node.title,
          style: TextStyle(
            color: isSelected ? colors.onPrimaryContainer : colors.onSurface,
            fontSize: 15,
            fontWeight: FontWeight.w600,
            height: 1.15,
          ),
        ),
        textDirection: Directionality.of(context),
        textAlign: TextAlign.center,
        maxLines: 2,
        ellipsis: '…',
      )..layout(maxWidth: nodeWidth - 24);
      titlePainter.paint(
        canvas,
        Offset(
          node.positionX - titlePainter.width / 2,
          node.positionY - titlePainter.height / 2 + 8,
        ),
      );

      final progressTrack = RRect.fromRectAndRadius(
        Rect.fromLTWH(rect.left + 12, rect.bottom - 7, nodeWidth - 24, 3),
        const Radius.circular(2),
      );
      canvas.drawRRect(
        progressTrack,
        Paint()..color = colors.surfaceContainerHighest,
      );
      final score = node.masteryScore;
      if (score != null && score.isFinite) {
        final progressFill = RRect.fromRectAndRadius(
          Rect.fromLTWH(
            rect.left + 12,
            rect.bottom - 7,
            (nodeWidth - 24) * score.clamp(0.0, 1.0),
            3,
          ),
          const Radius.circular(2),
        );
        canvas.drawRRect(progressFill, Paint()..color = stateColor);
      }

      if (isRecommended) {
        canvas.drawCircle(
          Offset(rect.right - 12, rect.top + 12),
          4,
          Paint()..color = colors.primary,
        );
      }
    }
  }

  void _drawEdge(Canvas canvas, Path path, Paint paint) {
    canvas.drawPath(path, paint);
    final metrics = path.computeMetrics().iterator;
    if (!metrics.moveNext()) return;
    final metric = metrics.current;
    if (metric.length < 10) return;
    final tangent = metric.getTangentForOffset(metric.length);
    if (tangent == null) return;

    const arrowLength = 8.0;
    const arrowAngle = 0.48;
    final angle = tangent.angle;
    final arrow = Path()
      ..moveTo(tangent.position.dx, tangent.position.dy)
      ..lineTo(
        tangent.position.dx - arrowLength * math.cos(angle - arrowAngle),
        tangent.position.dy - arrowLength * math.sin(angle - arrowAngle),
      )
      ..moveTo(tangent.position.dx, tangent.position.dy)
      ..lineTo(
        tangent.position.dx - arrowLength * math.cos(angle + arrowAngle),
        tangent.position.dy - arrowLength * math.sin(angle + arrowAngle),
      );
    canvas.drawPath(arrow, paint);
  }

  String _nodeTypeLabel(String type) {
    switch (type.toUpperCase()) {
      case 'AREA':
        return 'ÁREA';
      case 'TOPIC':
        return 'TÓPICO';
      case 'CONCEPT':
        return 'CONCEITO';
      case 'SUBCONCEPT':
        return 'SUBCONCEITO';
      default:
        return type.toUpperCase();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    final oldPainter = oldDelegate as GraphPainter;
    return oldPainter.nodes != nodes ||
        oldPainter.edges != edges ||
        oldPainter.selected != selected ||
        oldPainter.option != option ||
        oldPainter.origin != origin ||
        oldPainter.context != context ||
        oldPainter.progressByNodeId != progressByNodeId ||
        oldPainter.recommendedNodeIds != recommendedNodeIds;
  }
}
