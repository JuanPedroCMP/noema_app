import 'package:flutter/material.dart';

@immutable
class AppSemanticColors extends ThemeExtension<AppSemanticColors> {
  const AppSemanticColors({
    required this.accent,
    required this.success,
    required this.warning,
    required this.info,
    required this.highlight,
  });

  static const successDefault = Color(0xFF2E7D32);
  static const warningDefault = Color(0xFFF9A825);
  static const infoDefault = Color(0xFF0277BD);
  static const highlightDefault = Color(0xFFFFC107);

  final Color accent;
  final Color success;
  final Color warning;
  final Color info;
  final Color highlight;

  @override
  AppSemanticColors copyWith({
    Color? accent,
    Color? success,
    Color? warning,
    Color? info,
    Color? highlight,
  }) {
    return AppSemanticColors(
      accent: accent ?? this.accent,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      info: info ?? this.info,
      highlight: highlight ?? this.highlight,
    );
  }

  @override
  AppSemanticColors lerp(
    covariant ThemeExtension<AppSemanticColors>? other,
    double t,
  ) {
    if (other is! AppSemanticColors) return this;
    return AppSemanticColors(
      accent: Color.lerp(accent, other.accent, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      info: Color.lerp(info, other.info, t)!,
      highlight: Color.lerp(highlight, other.highlight, t)!,
    );
  }
}
