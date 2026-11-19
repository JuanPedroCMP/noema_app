import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noema/core/design/theme/app_semantic_colors.dart';
import 'package:noema/core/design/theme/app_theme.dart';
import 'package:noema/core/design/theme/theme_defaults.dart';

void main() {
  test('uses the default seed and semantic palette', () {
    final theme = AppTheme.create(
      seedColor: AppThemeDefaults.seedColor,
      brightness: Brightness.light,
      displayWidth: 800,
    );
    final semanticColors = theme.extension<AppSemanticColors>()!;

    expect(
      theme.colorScheme.primary,
      ColorScheme.fromSeed(
        seedColor: const Color(AppThemeDefaults.seedColor),
        brightness: Brightness.light,
      ).primary,
    );
    expect(theme.colorScheme.primary, isNot(const Color(0xFF3F51B5)));
    expect(semanticColors.accent, theme.colorScheme.tertiary);
    expect(semanticColors.success, AppSemanticColors.successDefault);
    expect(semanticColors.warning, AppSemanticColors.warningDefault);
    expect(semanticColors.info, AppSemanticColors.infoDefault);
    expect(semanticColors.highlight, AppSemanticColors.highlightDefault);
  });

  test(
    'supports semantic color overrides',
    () {
      final theme = AppTheme.create(
        seedColor: AppThemeDefaults.seedColor,
        brightness: Brightness.light,
        displayWidth: 800,
        overridesJson: jsonEncode({
          'customAccent': 0xFFB05B3B,
          'customSuccess': 0xFF357A48,
          'customWarning': 0xFFC28A20,
          'customInfo': 0xFF3477A5,
          'customHighlight': 0xFFE0AE48,
        }),
      );

      final semanticColors = theme.extension<AppSemanticColors>()!;

      expect(semanticColors.accent, const Color(0xFFB05B3B));
      expect(semanticColors.success, const Color(0xFF357A48));
      expect(semanticColors.warning, const Color(0xFFC28A20));
      expect(semanticColors.info, const Color(0xFF3477A5));
      expect(semanticColors.highlight, const Color(0xFFE0AE48));
    },
  );
}
