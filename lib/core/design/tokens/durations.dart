import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'durations.freezed.dart';

@freezed
abstract class AppDurations with _$AppDurations {
  const factory AppDurations({
    required Duration instant,
    required Duration fast,
    required Duration normal,
    required Duration slow,
    required Duration page,
  }) = _AppDurations;

  static const material = AppDurations(
    instant: Duration(milliseconds: 75),
    fast: Duration(milliseconds: 180),
    normal: Duration(milliseconds: 250),
    slow: Duration(milliseconds: 400),
    page: Duration(milliseconds: 500),
  );
}

class AppDurationsTheme extends ThemeExtension<AppDurationsTheme> {
  final AppDurations durations;

  const AppDurationsTheme({required this.durations});

  @override
  AppDurationsTheme copyWith({AppDurations? durations}) {
    return AppDurationsTheme(durations: durations ?? this.durations);
  }

  @override
  AppDurationsTheme lerp(ThemeExtension<AppDurationsTheme>? other, double t) {
    if (other is! AppDurationsTheme) {
      return this;
    }

    return t < 0.5 ? this : other;
  }
}
