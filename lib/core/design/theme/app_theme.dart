import "package:flutter/material.dart";
import "package:noema/core/design/tokens/durations.dart";
import "package:noema/core/design/tokens/elevation.dart";
import "package:noema/core/design/tokens/icon_size.dart";
import "package:noema/core/design/tokens/radius.dart";
import "package:noema/core/design/tokens/spacing.dart";
import 'package:noema/core/design/theme/theme_tokens.dart';
import "package:path/path.dart";

class AppTheme {
  const AppTheme._();

  static ThemeData create({
    required int seedColor,
    required Brightness brightness,
    required double displayWidth,
  }) {
    final scheme = ColorScheme.fromSeed(
      seedColor: Color(seedColor),
      brightness: brightness,
    );
    final radius = AppRadius.material;

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      extensions: [
        AppSpacingTheme(spacing: AppSpacingTheme.spacingFor(displayWidth)),

        AppRadiusTheme(radius: AppRadius.material),

        AppDurationsTheme(durations: AppDurations.material),

        AppElevationTheme(elevation: AppElevation.material),

        AppIconSizeTheme(iconSize: AppIconSize.material),
      ],
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius.sm),
          ),
        ),
      ),
    );
  }
}
