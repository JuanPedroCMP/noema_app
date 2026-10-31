import "dart:convert";
import "package:flutter/material.dart";
import "package:noema/core/design/tokens/durations.dart";
import "package:noema/core/design/tokens/elevation.dart";
import "package:noema/core/design/tokens/icon_size.dart";
import "package:noema/core/design/tokens/layout.dart";
import "package:noema/core/design/tokens/radius.dart";
import "package:noema/core/design/tokens/spacing.dart";

class AppTheme {
  const AppTheme._();

  static ThemeData create({
    required int seedColor,
    required Brightness brightness,
    required double displayWidth,
    String? overridesJson,
    String? displayFont,
    String? bodyFont,
    String? monoFont,
    int fontScale = 100,
  }) {
    final scheme = ColorScheme.fromSeed(
      seedColor: Color(seedColor),
      brightness: brightness,
    );
    final radius = AppRadius.material;

    final overrides = _parseOverrides(overridesJson);
    final customizedScheme = scheme.copyWith(
      primary: _color(overrides, 'primary') ?? scheme.primary,
      onPrimary: _color(overrides, 'onPrimary') ?? scheme.onPrimary,
      primaryContainer:
          _color(overrides, 'primaryContainer') ?? scheme.primaryContainer,
      onPrimaryContainer:
          _color(overrides, 'onPrimaryContainer') ?? scheme.onPrimaryContainer,
      secondary: _color(overrides, 'secondary') ?? scheme.secondary,
      onSecondary: _color(overrides, 'onSecondary') ?? scheme.onSecondary,
      secondaryContainer:
          _color(overrides, 'secondaryContainer') ?? scheme.secondaryContainer,
      onSecondaryContainer:
          _color(overrides, 'onSecondaryContainer') ??
          scheme.onSecondaryContainer,
      tertiary: _color(overrides, 'tertiary') ?? scheme.tertiary,
      onTertiary: _color(overrides, 'onTertiary') ?? scheme.onTertiary,
      tertiaryContainer:
          _color(overrides, 'tertiaryContainer') ?? scheme.tertiaryContainer,
      onTertiaryContainer:
          _color(overrides, 'onTertiaryContainer') ??
          scheme.onTertiaryContainer,
      surface: _color(overrides, 'surface') ?? scheme.surface,
      onSurface: _color(overrides, 'onSurface') ?? scheme.onSurface,
      error: _color(overrides, 'error') ?? scheme.error,
      onError: _color(overrides, 'onError') ?? scheme.onError,
      errorContainer:
          _color(overrides, 'errorContainer') ?? scheme.errorContainer,
      onErrorContainer:
          _color(overrides, 'onErrorContainer') ?? scheme.onErrorContainer,
      surfaceContainerHighest:
          _color(overrides, 'surfaceVariant') ?? scheme.surfaceContainerHighest,
      outline: _color(overrides, 'outline') ?? scheme.outline,
      shadow: _color(overrides, 'shadow') ?? scheme.shadow,
      scrim: _color(overrides, 'scrim') ?? scheme.scrim,
    );

    final scale = (fontScale <= 10 ? 100 : fontScale) / 100;
    final baseText = Typography.material2021().black;
    final textTheme = baseText.apply(
      fontFamily: bodyFont,
      displayColor: customizedScheme.onSurface,
      bodyColor: customizedScheme.onSurface,
    );
    TextStyle? scaled(TextStyle? style, {String? family}) {
      if (style == null) return null;
      return style.copyWith(
        fontFamily: family ?? style.fontFamily,
        fontSize: style.fontSize == null ? null : style.fontSize! * scale,
      );
    }

    return ThemeData(
      useMaterial3: true,
      colorScheme: customizedScheme,
      scaffoldBackgroundColor: customizedScheme.surface,
      visualDensity: VisualDensity.standard,
      cardTheme: CardThemeData(
        margin: EdgeInsets.zero,
        elevation: 0,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius.card),
          side: BorderSide(color: customizedScheme.outlineVariant),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: customizedScheme.surfaceContainerHighest.withValues(alpha: .35),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius.md),
          borderSide: BorderSide(color: customizedScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius.md),
          borderSide: BorderSide(color: customizedScheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius.md),
          borderSide: BorderSide(color: customizedScheme.primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppLayoutTokens.fieldHorizontalPadding,
          vertical: AppLayoutTokens.fieldVerticalPadding,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(0, AppLayoutTokens.minimumControlHeight),
          padding: const EdgeInsets.symmetric(
            horizontal: AppLayoutTokens.buttonHorizontalPadding,
            vertical: AppLayoutTokens.buttonVerticalPadding,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius.button),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(0, AppLayoutTokens.minimumControlHeight),
          padding: const EdgeInsets.symmetric(
            horizontal: AppLayoutTokens.buttonHorizontalPadding,
            vertical: AppLayoutTokens.buttonVerticalPadding,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius.button),
          ),
        ),
      ),
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 1,
        backgroundColor: customizedScheme.surface,
        surfaceTintColor: customizedScheme.surfaceTint,
        iconTheme: IconThemeData(color: customizedScheme.onSurfaceVariant),
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: AppLayoutTokens.navigationBarHeight,
        elevation: 0,
        backgroundColor: customizedScheme.surface,
        indicatorShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius.button),
        ),
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius.md),
        ),
      ),
      dropdownMenuTheme: DropdownMenuThemeData(
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: customizedScheme.surfaceContainerHighest.withValues(alpha: .35),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius.md),
          ),
        ),
      ),
      textTheme: textTheme.copyWith(
        displayLarge: scaled(textTheme.displayLarge, family: displayFont),
        displayMedium: scaled(textTheme.displayMedium, family: displayFont),
        displaySmall: scaled(textTheme.displaySmall, family: displayFont),
        headlineLarge: scaled(textTheme.headlineLarge, family: displayFont),
        headlineMedium: scaled(textTheme.headlineMedium, family: displayFont),
        headlineSmall: scaled(textTheme.headlineSmall, family: displayFont),
        titleLarge: scaled(textTheme.titleLarge, family: displayFont),
        titleMedium: scaled(textTheme.titleMedium, family: displayFont),
        titleSmall: scaled(textTheme.titleSmall, family: displayFont),
        bodyLarge: scaled(textTheme.bodyLarge),
        bodyMedium: scaled(textTheme.bodyMedium),
        bodySmall: scaled(textTheme.bodySmall),
        labelLarge: scaled(textTheme.labelLarge, family: monoFont),
        labelMedium: scaled(textTheme.labelMedium, family: monoFont),
        labelSmall: scaled(textTheme.labelSmall, family: monoFont),
      ),
      extensions: [
        AppSpacingTheme(spacing: AppSpacingTheme.spacingFor(displayWidth)),

        AppRadiusTheme(radius: AppRadius.material),

        AppDurationsTheme(durations: AppDurations.material),

        AppElevationTheme(elevation: AppElevation.material),

        AppIconSizeTheme(iconSize: AppIconSize.material),
      ],
    );
  }

  static Map<String, dynamic> _parseOverrides(String? json) {
    if (json == null || json.trim().isEmpty) return {};
    try {
      final value = jsonDecode(json);
      return value is Map<String, dynamic> ? value : {};
    } catch (_) {
      return {};
    }
  }

  static Color? _color(Map<String, dynamic> values, String key) {
    final value = values[key];
    if (value is! num || value < 0 || value > 0xFFFFFFFF) return null;
    return Color(value.toInt());
  }
}
