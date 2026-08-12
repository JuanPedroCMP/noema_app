import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'icon_size.freezed.dart';

@freezed
abstract class AppIconSize with _$AppIconSize {
  const factory AppIconSize({
    /// Indicadores
    required double xxs,

    /// Pequenos
    required double xs,

    /// Compactos
    required double sm,

    /// Material padrão
    required double md,

    /// AppBar
    required double lg,

    /// Botões grandes
    required double xl,

    /// Destaques
    required double xxl,

    /// Hero
    required double huge,

    /// Splash
    required double giant,

    /// Ilustrações
    required double massive,
  }) = _AppIconSize;

  static const material = AppIconSize(
    xxs: 12,
    xs: 16,
    sm: 20,
    md: 24,
    lg: 28,
    xl: 32,
    xxl: 40,
    huge: 48,
    giant: 64,
    massive: 96,
  );
}

class AppIconSizeTheme extends ThemeExtension<AppIconSizeTheme> {
  final AppIconSize iconSize;

  const AppIconSizeTheme({
    required this.iconSize,
  });

  @override
  AppIconSizeTheme copyWith({
    AppIconSize? iconSize,
  }) {
    return AppIconSizeTheme(
      iconSize: iconSize ?? this.iconSize,
    );
  }

  @override
  AppIconSizeTheme lerp(
    ThemeExtension<AppIconSizeTheme>? other,
    double t,
  ) {
    if (other is! AppIconSizeTheme) {
      return this;
    }

    return t < 0.5 ? this : other;
  }
}