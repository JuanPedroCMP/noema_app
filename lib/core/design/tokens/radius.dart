import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'radius.freezed.dart';

@freezed
abstract class AppRadius with _$AppRadius {
  const factory AppRadius({
    required double none,

    required double xxs,
    required double xs,
    required double sm,
    required double md,
    required double lg,
    required double xl,
    required double xxl,

    /// Botões arredondados
    required double button,

    /// Cards Material 3
    required double card,

    /// BottomSheets
    required double sheet,

    /// Dialogs
    required double dialog,

    /// Chips
    required double chip,

    /// FAB
    required double fab,

    /// Avatares
    required double avatar,

    /// Pills
    required double pill,
  }) = _AppRadius;

  static const material = AppRadius(
    none: 0,

    xxs: 2,
    xs: 4,
    sm: 8,
    md: 12,
    lg: 16,
    xl: 24,
    xxl: 32,

    button: 14,
    card: 20,
    sheet: 28,
    dialog: 24,
    chip: 12,
    fab: 16,
    avatar: 999,
    pill: 9999,
  );
}

class AppRadiusTheme extends ThemeExtension<AppRadiusTheme> {
  final AppRadius radius;

  const AppRadiusTheme({
    required this.radius,
  });

  @override
  AppRadiusTheme copyWith({
    AppRadius? radius,
  }) {
    return AppRadiusTheme(
      radius: radius ?? this.radius,
    );
  }

  @override
  AppRadiusTheme lerp(
    ThemeExtension<AppRadiusTheme>? other,
    double t,
  ) {
    if (other is! AppRadiusTheme) {
      return this;
    }

    return t < 0.5 ? this : other;
  }
}