import "package:flutter/material.dart";

class ColorTheme {
  const ColorTheme._();

  static ThemeData create({ 
    required int seedColor,
    required Brightness brightness,
  }) {
    final scheme = ColorScheme.fromSeed(
      seedColor: Color(seedColor),
      brightness: brightness,
    );

    return ThemeData(useMaterial3: true, colorScheme: scheme);
  }
}
