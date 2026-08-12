import 'package:flutter_riverpod/flutter_riverpod.dart';

class DisplayWidth extends Notifier<double> {
  @override
  double build() => 0;

  void update(double width) {
    state = width;
  }
}

final displayWidthProvider = NotifierProvider<DisplayWidth, double>(
  DisplayWidth.new,
);
