import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'elevation.freezed.dart';

@freezed
abstract class AppElevation with _$AppElevation {
  const factory AppElevation({
    /// Flat
    required double none,

    /// Hover
    required double xs,

    /// Buttons
    required double sm,

    /// Cards
    required double md,

    /// Dialogs
    required double lg,

    /// Navigation Drawer
    required double xl,

    /// Floating
    required double xxl,

    /// Máximo recomendado
    required double huge,
  }) = _AppElevation;

  static const material = AppElevation(
    none: 0,
    xs: 1,
    sm: 2,
    md: 3,
    lg: 6,
    xl: 8,
    xxl: 12,
    huge: 16,
  );
}

class AppElevationTheme extends ThemeExtension<AppElevationTheme> {
  final AppElevation elevation;

  const AppElevationTheme({
    required this.elevation,
  });

  @override
  AppElevationTheme copyWith({
    AppElevation? elevation,
  }) {
    return AppElevationTheme(
      elevation: elevation ?? this.elevation,
    );
  }

  @override
  AppElevationTheme lerp(
    ThemeExtension<AppElevationTheme>? other,
    double t,
  ) {
    if (other is! AppElevationTheme) {
      return this;
    }

    return t < 0.5 ? this : other;
  }
}