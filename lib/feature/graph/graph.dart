import 'package:flutter/material.dart';

class GraphPage extends StatelessWidget {
  const GraphPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: GraphPainter(), child: const SizedBox.expand());
  }
}

class GraphNode {
  GraphNode({required this.radius, required this.position});

  final Offset position;
  final double radius;
}

final nodes = {
  GraphNode(position: Offset(0, 0), radius: 30),
  GraphNode(position: Offset(110, 10), radius: 30),
  GraphNode(position: Offset(220, 20), radius: 30),
  GraphNode(position: Offset(330, 30), radius: 30),
  GraphNode(position: Offset(440, 40), radius: 30),
  GraphNode(position: Offset(550, 50), radius: 30),
  GraphNode(position: Offset(660, 60), radius: 30),
  GraphNode(position: Offset(770, 70), radius: 30),
};

class GraphPainter extends CustomPainter {
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
    ..strokeCap= StrokeCap.round
    ..strokeJoin = StrokeJoin.miter
    ..strokeWidth = 4;
    canvas.drawLine(Offset(100, 100), Offset(300, 300), paint1);

    canvas.drawCircle(const Offset(100, 100), 40, paint);


    for (final node in nodes) {
      canvas.drawCircle(node.position, node.radius, paint);
    }
     // empilha o estado atual (matriz de transformação, clip)
   // desempilha, voltando ao estado antes do save
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
