import 'package:flutter/material.dart';
import 'package:noema/shared/widgets/noema_logo.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _reduceMotion = false;
  bool _motionPreferenceLoaded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    if (_motionPreferenceLoaded && reduceMotion == _reduceMotion) return;
    _motionPreferenceLoaded = true;
    _reduceMotion = reduceMotion;
    if (_reduceMotion) {
      _controller
        ..stop()
        ..value = 0;
    } else {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 220,
              height: 190,
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, _) {
                  final progress = _reduceMotion ? 0.0 : _controller.value;
                  final graphOpacity = _graphOpacity(progress);
                  final logoOpacity = _logoOpacity(progress);
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      Opacity(
                        opacity: logoOpacity,
                        child: const NoemaLogo(
                          markSize: 84,
                          wordmarkSize: 46,
                          stacked: true,
                        ),
                      ),
                      Opacity(
                        opacity: graphOpacity,
                        child: CustomPaint(
                          size: const Size(156, 112),
                          painter: _GraphTransitionPainter(
                            progress: _graphProgress(progress),
                            ink: colors.onSurface,
                            accent: colors.primary,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: 120,
              child: LinearProgressIndicator(
                minHeight: 2,
                color: colors.primary.withValues(alpha: .75),
                backgroundColor: colors.surfaceContainerHighest,
              ),
            ),
          ],
        ),
      ),
    );
  }

  double _graphOpacity(double progress) {
    if (progress < .2) return 0;
    if (progress < .42) {
      return Curves.easeInOut.transform((progress - .2) / .22);
    }
    if (progress < .72) return 1;
    if (progress < .94) {
      return 1 - Curves.easeInOut.transform((progress - .72) / .22);
    }
    return 0;
  }

  double _logoOpacity(double progress) {
    if (progress < .18) return 1;
    if (progress < .4) {
      return 1 - Curves.easeInOut.transform((progress - .18) / .22);
    }
    if (progress < .76) return 0;
    if (progress < .98) {
      return Curves.easeInOut.transform((progress - .76) / .22);
    }
    return 1;
  }

  double _graphProgress(double progress) =>
      Curves.easeOutCubic.transform(((progress - .14) / .38).clamp(0.0, 1.0));
}

class _GraphTransitionPainter extends CustomPainter {
  const _GraphTransitionPainter({
    required this.progress,
    required this.ink,
    required this.accent,
  });

  final double progress;
  final Color ink;
  final Color accent;

  static const _nodes = [
    Offset(18, 56),
    Offset(57, 20),
    Offset(57, 92),
    Offset(99, 56),
    Offset(138, 30),
    Offset(138, 82),
  ];
  static const _edges = [(0, 1), (0, 2), (1, 3), (2, 3), (3, 4), (3, 5)];

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / 156;
    final scaleY = size.height / 112;
    canvas.save();
    canvas.scale(scaleX, scaleY);
    final edgePaint = Paint()
      ..color = ink.withValues(alpha: .72)
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    for (var index = 0; index < _edges.length; index++) {
      final edgeProgress = (progress * _edges.length - index).clamp(0.0, 1.0);
      if (edgeProgress == 0) continue;
      final (from, to) = _edges[index];
      final start = _nodes[from];
      final end = Offset.lerp(start, _nodes[to], edgeProgress)!;
      canvas.drawLine(start, end, edgePaint);
    }

    for (var index = 0; index < _nodes.length; index++) {
      final nodeProgress = (progress * _nodes.length - index).clamp(0.0, 1.0);
      if (nodeProgress == 0) continue;
      final node = _nodes[index];
      final paint = Paint()
        ..color = index == 3 ? accent : ink
        ..style = PaintingStyle.fill;
      canvas.drawCircle(node, 8 * nodeProgress, paint);
      canvas.drawCircle(
        node,
        13 * nodeProgress,
        Paint()
          ..color = (index == 3 ? accent : ink).withValues(alpha: .18)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _GraphTransitionPainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.ink != ink ||
      oldDelegate.accent != accent;
}
