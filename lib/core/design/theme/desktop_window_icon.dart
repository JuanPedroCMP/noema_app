import 'dart:developer' as developer;
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const _desktopIconChannel = MethodChannel('noema/desktop_window_icon');
String? _lastIconColorKey;
String? _pendingIconColorKey;

Future<void> updateDesktopWindowIcon({
  required Color accent,
  required Color ink,
  required bool dark,
}) async {
  if (!Platform.isLinux) return;
  final background = dark ? const Color(0xFF28262C) : const Color(0xFFF4F2F6);
  final colorKey =
      '${accent.toARGB32()}:${ink.toARGB32()}:${background.toARGB32()}';
  if (_lastIconColorKey == colorKey || _pendingIconColorKey == colorKey) return;
  _pendingIconColorKey = colorKey;

  try {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final bounds = Rect.fromLTWH(0, 0, 128, 128);
    canvas.drawRRect(
      RRect.fromRectAndRadius(bounds, const Radius.circular(28)),
      Paint()..color = background,
    );

    canvas.save();
    canvas.translate(4, 4);
    _paintMark(canvas, ink: ink, accent: accent);
    canvas.restore();

    final image = await recorder.endRecording().toImage(128, 128);
    try {
      final data = await image.toByteData(format: ui.ImageByteFormat.png);
      if (data == null) {
        throw StateError('Não foi possível codificar o ícone da janela.');
      }
      if (_pendingIconColorKey != colorKey) return;
      await _desktopIconChannel.invokeMethod<void>(
        'setIcon',
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
      );
      _lastIconColorKey = colorKey;
    } finally {
      image.dispose();
    }
  } on Object catch (error, stackTrace) {
    developer.log(
      'Não foi possível atualizar o ícone da janela desktop.',
      name: 'noema.desktop_icon',
      error: error,
      stackTrace: stackTrace,
    );
  } finally {
    if (_pendingIconColorKey == colorKey) {
      _pendingIconColorKey = null;
    }
  }
}

void _paintMark(Canvas canvas, {required Color ink, required Color accent}) {
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

  final accentPaint = Paint()..color = accent;
  for (var index = 0; index < 3; index++) {
    final t = index / 3;
    canvas.drawCircle(
      Offset(60 + (83 - 60) * t, 60 + (41 - 60) * t),
      1.9,
      accentPaint,
    );
  }
  canvas.drawCircle(const Offset(60, 60), 10, accentPaint);
  canvas.drawCircle(const Offset(83, 41), 5, accentPaint);
}
