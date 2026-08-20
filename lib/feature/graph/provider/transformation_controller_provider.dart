import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransformationControllerNotifier
    extends Notifier<TransformationController> {
  Ticker? _ticker;

  @override
  TransformationController build() {
    final controller = TransformationController();

    ref.onDispose(() {
      _ticker?.dispose();
      controller.dispose();
    });

    return controller;
  }

  void setTransformation(Matrix4 value) {
    state.value = value;
  }

  void animateTo(
    Matrix4 destination, {
    Duration duration = const Duration(milliseconds: 400),
    Curve curve = Curves.easeInOut,
  }) {
    _ticker?.dispose();

    final Matrix4 begin = state.value.clone();
    final CurveTween curveTween = CurveTween(curve: curve);

    _ticker = Ticker((elapsed) {
      final double t = (elapsed.inMilliseconds / duration.inMilliseconds).clamp(
        0.0,
        1.1,
      );
      final double curvedT = curveTween.transform(t);

      state.value = Matrix4Tween(begin: begin, end: destination).lerp(curvedT);

      if (t >= 1.0) {
        _ticker?.stop();
      }
    });

    _ticker!.start();
  }

  void goToPoint(Offset targetPoint, double scale, Size viewportSize) {
    final Matrix4 destination =
        Matrix4.identity() *
        Matrix4.translationValues(
          viewportSize.width / 2 - targetPoint.dx * scale,
          viewportSize.height / 2 - targetPoint.dy * scale,
          0,
        ) *
        Matrix4.diagonal3Values(scale, scale, 3);

    animateTo(destination);
  }
}

final transformationControllerProvider =
    NotifierProvider<
      TransformationControllerNotifier,
      TransformationController
    >(TransformationControllerNotifier.new);
