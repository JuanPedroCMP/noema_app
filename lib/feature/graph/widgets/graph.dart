import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:noema/core/database/database.dart';
import 'package:noema/core/design/theme/theme_tokens.dart';

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
  });

  final BuildContext context;
  final List<GraphNodeData> nodes;
  final List<GraphEdgeData> edges;
  final String selected;
  final int option;
  final Offset origin;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.translate(origin.dx, origin.dy);

    final colors = context.colors;
    final edgePaint = Paint()
      ..color = colors.outlineVariant
      ..strokeWidth = 2.2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

    final edgePaintSelected = Paint()
      ..color = colors.primary
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

    final nodeFillPaint = Paint()
      ..color = colors.surfaceContainerLow
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final nodeBorderPaint = Paint()
      ..color = colors.outlineVariant
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
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

    final nodesById = {for (final node in nodes) node.id: node};

    const nodeWidth = 200.0;
    const nodeHeight = 80.0;

    if (option == 1) {
      //// Direto
      for (final edge in edges) {
        final source = nodesById[edge.sourceNodeId];
        final target = nodesById[edge.targetNodeId];

        if (source == null || target == null) {
          continue;
        }

        final path = Path();

        path.moveTo(source.positionX, source.positionY + nodeHeight / 2);

        path.lineTo(target.positionX, target.positionY - nodeHeight / 2);

        _drawEdge(canvas, path, edge.id == selected ? edgePaintSelected : edgePaint);
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
          Offset(source.positionX, source.positionY + nodeHeight / 2),
          Offset(source.positionX, (target.positionY + source.positionY) / 2),
          Offset(target.positionX, (target.positionY + source.positionY) / 2),
          Offset(target.positionX, target.positionY - nodeHeight / 2),
        ], false);

        _drawEdge(canvas, path, edge.id == selected ? edgePaintSelected : edgePaint);
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
          Offset(source.positionX, source.positionY + nodeHeight / 2),
          Offset(target.positionX, (target.positionY + source.positionY) / 2),
          Offset(target.positionX, target.positionY - nodeHeight / 2),
        ], false);

        _drawEdge(canvas, path, edge.id == selected ? edgePaintSelected : edgePaint);
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

        path.moveTo(source.positionX, source.positionY + nodeHeight / 2);

        path.quadraticBezierTo(
          source.positionX,
          (source.positionY + target.positionY) / 2,
          target.positionX,
          target.positionY - nodeHeight / 2,
        );

        _drawEdge(canvas, path, edge.id == selected ? edgePaintSelected : edgePaint);
      }
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
      final fillPaint = isSelected ? nodeSelectedPaint : nodeFillPaint;
      if (isSelected) canvas.drawShadow(Path()..addRRect(rrect), colors.shadow, 5, true);
      canvas.drawRRect(rrect, fillPaint);
      canvas.drawRRect(rrect, isSelected ? selectedBorderPaint : nodeBorderPaint);

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
    }
  }

  void _drawEdge(Canvas canvas, Path path, Paint paint) {
    canvas.drawPath(path, paint);
    final metrics = path.computeMetrics().iterator;
    if (!metrics.moveNext()) return;
    final metric = metrics.current;
    if (metric.length < 10) return;
    final tangent = metric.getTangentForOffset(metric.length - 2);
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
        oldPainter.context != context;
  }
}
