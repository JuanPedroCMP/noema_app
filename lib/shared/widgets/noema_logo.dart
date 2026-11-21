import 'package:flutter/material.dart';

class NoemaLogo extends StatelessWidget {
  const NoemaLogo({
    super.key,
    this.markSize = 42,
    this.wordmarkSize = 30,
    this.stacked = false,
    this.inkColor,
    this.accentColor,
    this.wordmark = true,
  });

  final double markSize;
  final double wordmarkSize;
  final bool stacked;
  final Color? inkColor;
  final Color? accentColor;
  final bool wordmark;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ink = inkColor ?? scheme.onSurface;
    final accent = accentColor ?? scheme.primary;
    final mark = CustomPaint(
      size: Size.square(markSize),
      painter: _NoemaMarkPainter(ink: ink, accent: accent),
    );

    if (!wordmark) {
      return Semantics(
        image: true,
        label: 'Noema',
        child: ExcludeSemantics(child: mark),
      );
    }

    final name = Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: 'n',
            style: TextStyle(color: accent),
          ),
          TextSpan(
            text: 'oema',
            style: TextStyle(color: ink),
          ),
        ],
      ),
      style: TextStyle(
        fontSize: wordmarkSize,
        fontWeight: FontWeight.w600,
        letterSpacing: -wordmarkSize * .025,
        height: 1,
      ),
    );

    return Semantics(
      image: true,
      label: 'Noema, grafo de conhecimento personalizado',
      child: ExcludeSemantics(
        child: stacked
            ? Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  mark,
                  SizedBox(height: markSize * .08),
                  name,
                ],
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  mark,
                  SizedBox(width: markSize * .18),
                  name,
                ],
              ),
      ),
    );
  }
}

class _NoemaMarkPainter extends CustomPainter {
  const _NoemaMarkPainter({required this.ink, required this.accent});

  final Color ink;
  final Color accent;

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 120;
    canvas.save();
    canvas.scale(scale);

    final line = Paint()
      ..color = ink
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    canvas.drawLine(const Offset(30, 30), const Offset(30, 90), line);
    canvas.drawLine(const Offset(30, 30), const Offset(90, 90), line);
    canvas.drawLine(const Offset(90, 30), const Offset(90, 90), line);

    final inkNode = Paint()..color = ink;
    for (final point in const [
      Offset(30, 30),
      Offset(30, 90),
      Offset(90, 30),
      Offset(90, 90),
    ]) {
      canvas.drawCircle(point, 7, inkNode);
    }

    final accentLine = Paint()..color = accent;
    for (var index = 0; index < 3; index++) {
      final t = index / 3;
      canvas.drawCircle(
        Offset(60 + (83 - 60) * t, 60 + (41 - 60) * t),
        1.9,
        accentLine,
      );
    }
    canvas.drawCircle(const Offset(60, 60), 10, accentLine);
    canvas.drawCircle(const Offset(83, 41), 5, accentLine);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _NoemaMarkPainter oldDelegate) =>
      oldDelegate.ink != ink || oldDelegate.accent != accent;
}
