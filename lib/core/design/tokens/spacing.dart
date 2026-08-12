import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'spacing.freezed.dart';

@freezed
abstract class AppSpacing with _$AppSpacing {
  const factory AppSpacing({
    required double xxs,
    required double xs,
    required double sm,
    required double md,
    required double lg,
    required double xl,
    required double xxl,
    required double xxxl,
    required double huge,
  }) = _AppSpacing;

  /// Smartphones
  static const mobile = AppSpacing(
    xxs: 2,
    xs: 4,
    sm: 8,
    md: 16,
    lg: 24,
    xl: 32,
    xxl: 48,
    xxxl: 64,
    huge: 96,
  );

  /// Tablets
  static const tablet = AppSpacing(
    xxs: 2,
    xs: 4,
    sm: 8,
    md: 16,
    lg: 28,
    xl: 40,
    xxl: 56,
    xxxl: 72,
    huge: 104,
  );

  /// Desktop
  static const desktop = AppSpacing(
    xxs: 2,
    xs: 4,
    sm: 8,
    md: 16,
    lg: 32,
    xl: 48,
    xxl: 64,
    xxxl: 96,
    huge: 128,
  );
}

class AppSpacingTheme extends ThemeExtension<AppSpacingTheme> {
  final AppSpacing spacing;

  const AppSpacingTheme({
    required this.spacing,
  });

  @override
  AppSpacingTheme copyWith({
    AppSpacing? spacing,
  }) {
    return AppSpacingTheme(
      spacing: spacing ?? this.spacing,
    );
  }

  @override
  AppSpacingTheme lerp(
    ThemeExtension<AppSpacingTheme>? other,
    double t,
  ) {
    if (other is! AppSpacingTheme) {
      return this;
    }

    return t < 0.5 ? this : other;
  }

  static AppSpacing spacingFor(double width) {
    if (width >= 900) return AppSpacing.desktop;
    if (width >= 600) return AppSpacing.tablet;

    return AppSpacing.mobile;
  }
}