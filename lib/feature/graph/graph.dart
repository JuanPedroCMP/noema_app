import 'package:flutter/material.dart';
import 'package:noema/core/database/database.dart';

class GraphNode {
  GraphNode({required this.radius, required this.position});

  final Offset position;
  final double radius;
}

class GraphPainter extends CustomPainter {
  GraphPainter({required this.nodes, required this.edges});

  final List<GraphNodeData> nodes;
  final List<GraphEdgeData> edges;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));

    final paint = Paint()..color = Colors.blue;

    final edgePaint = Paint()
      ..color = Colors.deepOrange
      ..strokeWidth = 4;

    final paint1 = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.miter
      ..strokeWidth = 4;
    canvas.drawLine(Offset(100, 100), Offset(300, 300), paint1);

    canvas.drawCircle(const Offset(100, 100), 40, paint);

    for (final edge in edges) {
      final path = Path();

      path.moveTo(
        nodes.firstWhere((node) => node.id == edge.sourceNodeId).positionX,
        nodes.firstWhere((node) => node.id == edge.sourceNodeId).positionY,
      );

      path.lineTo(
        nodes.firstWhere((node) => node.id == edge.targetNodeId).positionX,
        nodes.firstWhere((node) => node.id == edge.targetNodeId).positionY,
      );

      canvas.drawPath(path, edgePaint);
    }

    for (final node in nodes) {
      canvas.drawCircle(Offset(node.positionX, node.positionY), 40, paint1);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
