import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noema/core/database/database.dart';
import 'package:noema/core/database/database_provider.dart';
import 'package:noema/feature/graph/data/graph_node_dao.dart';
import 'package:noema/feature/graph/provider/path_provider.dart';
import 'package:noema/teste_page.dart';

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
  });

  final BuildContext context;
  final List<GraphNodeData> nodes;
  final List<GraphEdgeData> edges;
  final String selected;
  final int option;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));

    final edgePaint = Paint()
      ..color = context.colorScheme.tertiary
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    final edgePaintSelected = Paint()
      ..color = context.colorScheme.onPrimary
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    final nodePaint = Paint()
      ..color = context.colorScheme.surfaceContainer
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.miter
      ..strokeWidth = 4;
      
    final nodePaintSelected = Paint()
      ..color = context.colorScheme.surfaceContainerHighest
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.miter
      ..strokeWidth = 4;

    final nodesById = {for (final node in nodes) node.id: node};

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

        if (edge.id == selected) {
          canvas.drawPath(path, edgePaintSelected);
        } else {
          canvas.drawPath(path, edgePaint);
        }
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

        if (edge.id == selected) {
          canvas.drawPath(path, edgePaintSelected);
        } else {
          canvas.drawPath(path, edgePaint);
        }
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
 
        if (edge.id == selected) {
          canvas.drawPath(path, edgePaintSelected);
        } else {
          canvas.drawPath(path, edgePaint);
        }
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

        if (edge.id == selected) {
          canvas.drawPath(path, edgePaintSelected);
        } else {
          canvas.drawPath(path, edgePaint);
        }
      }
    }

    for (final node in nodes) {
      if (node.id == selected) {
        canvas.drawCircle(
          Offset(node.positionX, node.positionY),
          40,
          nodePaintSelected,
        );
      } else {
        canvas.drawCircle(
          Offset(node.positionX, node.positionY),
          40,
          nodePaint,
        );
      }

      final textStyle = TextStyle(
        color: const Color.fromARGB(255, 255, 255, 255),
        fontSize: 24,
        fontWeight: FontWeight.bold,
      );

      // 2. Create a TextSpan configuration tree
      final textSpan = TextSpan(text: node.title, style: textStyle);

      // 3. Initialize the TextPainter object
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr, // Required parameter
      );

      // 4. Compute constraints and layout the paragraph geometry
      textPainter.layout(
        minWidth: 0,
        maxWidth: size.width, // Wrap text if it exceeds width boundary
      );

      // 6. Paint the computed text paragraph onto the canvas
      textPainter.paint(canvas, Offset(node.positionX, node.positionY));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
