import "dart:convert";
import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:noema/core/design/theme/app_semantic_colors.dart";
import "package:noema/core/design/tokens/durations.dart";
import "package:noema/core/design/tokens/elevation.dart";
import "package:noema/core/design/tokens/icon_size.dart";
import "package:noema/core/design/tokens/layout.dart";
import "package:noema/core/design/tokens/radius.dart";
import "package:noema/core/design/tokens/spacing.dart";

class AppTheme {
  const AppTheme._();

  static const List<String> systemFontFamilies = <String>[
    'sans-serif',
    'serif',
    'monospace',
    'Arial',
    'Helvetica',
    'Roboto',
    'Noto Sans',
    'Noto Serif',
    'DejaVu Sans',
    'Liberation Sans',
    'Ubuntu',
    'Cantarell',
  ];

  static ThemeData create({
    required int seedColor,
    required Brightness brightness,
    required double displayWidth,
    String? overridesJson,
    String? displayFont,
    String? bodyFont,
    String? monoFont,
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

    final baseText = Typography.material2021().black;
    final bodyTextTheme = baseText.apply(
      fontFamily: bodyFont,
      displayColor: customizedScheme.onSurface,
      bodyColor: customizedScheme.onSurface,
    );
    TextStyle? withFamily(TextStyle? style, String? family) {
      if (style == null) return null;
      final selected = family?.trim();
      if (selected == null || selected.isEmpty) {
        return style.copyWith(fontFamily: style.fontFamily);
      }
      if (!GoogleFonts.asMap().containsKey(selected)) {
        return style.copyWith(fontFamily: selected);
      }
      try {
        return GoogleFonts.getFont(selected, textStyle: style);
      } on Object {
        return style.copyWith(fontFamily: selected);
      }
    }

    final textTheme = bodyTextTheme.copyWith(
      displayLarge: withFamily(bodyTextTheme.displayLarge, displayFont),
      displayMedium: withFamily(bodyTextTheme.displayMedium, displayFont),
      displaySmall: withFamily(bodyTextTheme.displaySmall, displayFont),
      headlineLarge: withFamily(bodyTextTheme.headlineLarge, displayFont),
      headlineMedium: withFamily(bodyTextTheme.headlineMedium, displayFont),
      headlineSmall: withFamily(bodyTextTheme.headlineSmall, displayFont),
      titleLarge: withFamily(bodyTextTheme.titleLarge, displayFont),
      titleMedium: withFamily(bodyTextTheme.titleMedium, displayFont),
      titleSmall: withFamily(bodyTextTheme.titleSmall, displayFont),
      labelLarge: withFamily(bodyTextTheme.labelLarge, monoFont),
      labelMedium: withFamily(bodyTextTheme.labelMedium, monoFont),
      labelSmall: withFamily(bodyTextTheme.labelSmall, monoFont),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: customizedScheme,
      scaffoldBackgroundColor: customizedScheme.surfaceContainerLowest,
      visualDensity: VisualDensity.standard,
      cardTheme: CardThemeData(
        color: customizedScheme.surface,
        surfaceTintColor: Colors.transparent,
        margin: EdgeInsets.zero,
        elevation: 1,
        shadowColor: customizedScheme.shadow.withValues(alpha: .08),
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius.card),
          side: BorderSide(
            color: customizedScheme.outlineVariant.withValues(alpha: .55),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: customizedScheme.surfaceContainerHighest.withValues(
          alpha: .35,
        ),
        floatingLabelStyle: textTheme.bodyLarge?.copyWith(
          color: customizedScheme.primary,
        ),
        hintStyle: textTheme.bodyMedium?.copyWith(
          color: customizedScheme.onSurfaceVariant,
        ),
        prefixIconColor: customizedScheme.onSurfaceVariant,
        suffixIconColor: customizedScheme.onSurfaceVariant,
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
          textStyle: textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: customizedScheme.primary,
          foregroundColor: customizedScheme.onPrimary,
          minimumSize: const Size(0, AppLayoutTokens.minimumControlHeight),
          padding: const EdgeInsets.symmetric(
            horizontal: AppLayoutTokens.buttonHorizontalPadding,
            vertical: AppLayoutTokens.buttonVerticalPadding,
          ),
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius.button),
          ),
          textStyle: textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
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
          side: BorderSide(color: customizedScheme.outline),
          textStyle: textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: const Size(0, AppLayoutTokens.minimumControlHeight),
          padding: const EdgeInsets.symmetric(
            horizontal: AppLayoutTokens.buttonHorizontalPadding,
            vertical: AppLayoutTokens.buttonVerticalPadding,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius.button),
          ),
          textStyle: textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          minimumSize: const Size.square(AppLayoutTokens.minimumControlHeight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius.button),
          ),
        ),
      ),
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: customizedScheme.surfaceContainerLow,
        surfaceTintColor: Colors.transparent,
        iconTheme: IconThemeData(color: customizedScheme.onSurfaceVariant),
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: customizedScheme.onSurface,
          fontWeight: FontWeight.w600,
        ),
        shape: Border(
          bottom: BorderSide(
            color: customizedScheme.outlineVariant.withValues(alpha: .55),
          ),
        ),
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: customizedScheme.surfaceContainerLow,
        minExtendedWidth: AppLayoutTokens.extendedNavigationRailWidth,
        indicatorColor: customizedScheme.primaryContainer,
        indicatorShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius.button),
        ),
        selectedIconTheme: IconThemeData(
          color: customizedScheme.onPrimaryContainer,
        ),
        unselectedIconTheme: IconThemeData(
          color: customizedScheme.onSurfaceVariant,
        ),
        selectedLabelTextStyle: textTheme.labelMedium?.copyWith(
          color: customizedScheme.onSurface,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelTextStyle: textTheme.labelSmall?.copyWith(
          color: customizedScheme.onSurfaceVariant,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: customizedScheme.primaryContainer,
        foregroundColor: customizedScheme.onPrimaryContainer,
        elevation: 1,
        focusElevation: 2,
        hoverElevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius.fab),
        ),
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: customizedScheme.primary,
        unselectedLabelColor: customizedScheme.onSurfaceVariant,
        indicatorColor: customizedScheme.primary,
        dividerColor: customizedScheme.outlineVariant,
        indicatorSize: TabBarIndicatorSize.label,
        labelStyle: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
        unselectedLabelStyle: textTheme.titleSmall,
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: AppLayoutTokens.navigationBarHeight,
        elevation: 0,
        backgroundColor: customizedScheme.surfaceContainerLow,
        indicatorColor: customizedScheme.primaryContainer,
        indicatorShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius.button),
        ),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            color: selected
                ? customizedScheme.onPrimaryContainer
                : customizedScheme.onSurfaceVariant,
          );
        }),
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600);
          }
          return textTheme.labelSmall;
        }),
      ),
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        horizontalTitleGap: 12,
        minLeadingWidth: 40,
        minVerticalPadding: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius.md),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: customizedScheme.surfaceContainerHigh,
        selectedColor: customizedScheme.primaryContainer,
        checkmarkColor: customizedScheme.onPrimaryContainer,
        labelStyle: textTheme.labelLarge,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        side: BorderSide(
          color: customizedScheme.outlineVariant.withValues(alpha: .55),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius.chip),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: customizedScheme.surfaceContainerHigh,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius.dialog),
        ),
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: customizedScheme.onSurface,
        ),
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: customizedScheme.onSurfaceVariant,
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: customizedScheme.surfaceContainerLow,
        modalBackgroundColor: customizedScheme.surfaceContainerLow,
        surfaceTintColor: Colors.transparent,
        showDragHandle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(radius.sheet),
          ),
        ),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: customizedScheme.surfaceContainerLow,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius.md),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: customizedScheme.inverseSurface,
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: customizedScheme.onInverseSurface,
        ),
        actionTextColor: customizedScheme.inversePrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius.md),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: customizedScheme.outlineVariant.withValues(alpha: .55),
        thickness: 1,
        space: 1,
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: customizedScheme.primary,
        selectionColor: customizedScheme.primary.withValues(alpha: .22),
        selectionHandleColor: customizedScheme.primary,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: customizedScheme.primary,
        linearTrackColor: customizedScheme.surfaceContainerHighest,
        circularTrackColor: customizedScheme.surfaceContainerHighest,
        linearMinHeight: 4,
        refreshBackgroundColor: customizedScheme.surfaceContainerLow,
      ),
      tooltipTheme: TooltipThemeData(
        waitDuration: const Duration(milliseconds: 500),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: customizedScheme.inverseSurface,
          borderRadius: BorderRadius.circular(radius.xs),
        ),
        textStyle: textTheme.bodySmall?.copyWith(
          color: customizedScheme.onInverseSurface,
        ),
      ),
      dropdownMenuTheme: DropdownMenuThemeData(
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: customizedScheme.surfaceContainerHighest.withValues(
            alpha: .35,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius.md),
          ),
        ),
      ),
      fontFamily: bodyFont,
      textTheme: textTheme,
      extensions: [
        AppSpacingTheme(spacing: AppSpacingTheme.spacingFor(displayWidth)),

        AppRadiusTheme(radius: AppRadius.material),

        AppDurationsTheme(durations: AppDurations.material),

        AppElevationTheme(elevation: AppElevation.material),

        AppIconSizeTheme(iconSize: AppIconSize.material),
        AppSemanticColors(
          accent:
              _color(overrides, 'customAccent') ?? customizedScheme.tertiary,
          success:
              _color(overrides, 'customSuccess') ??
              AppSemanticColors.successDefault,
          warning:
              _color(overrides, 'customWarning') ??
              AppSemanticColors.warningDefault,
          info:
              _color(overrides, 'customInfo') ?? AppSemanticColors.infoDefault,
          highlight:
              _color(overrides, 'customHighlight') ??
              AppSemanticColors.highlightDefault,
        ),
      ],
    );
  }

  static int normalizeFontScale(int value) =>
      (value <= 10 ? 100 : value).clamp(75, 200).toInt();

  static TextScaler textScaler(TextScaler systemScaler, int fontScale) {
    final factor = normalizeFontScale(fontScale) / 100;
    return factor == 1
        ? systemScaler
        : _CombinedTextScaler(systemScaler, factor);
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

class _CombinedTextScaler extends TextScaler {
  const _CombinedTextScaler(this.systemScaler, this.userScale);

  final TextScaler systemScaler;
  final double userScale;

  @override
  double scale(double fontSize) => systemScaler.scale(fontSize) * userScale;

  @override
  double get textScaleFactor => scale(14) / 14;

  @override
  TextScaler clamp({
    double minScaleFactor = 0,
    double maxScaleFactor = double.infinity,
  }) {
    return _CombinedTextScaler(
      systemScaler.clamp(
        minScaleFactor: minScaleFactor / userScale,
        maxScaleFactor: maxScaleFactor / userScale,
      ),
      userScale,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is _CombinedTextScaler &&
      other.systemScaler == systemScaler &&
      other.userScale == userScale;

  @override
  int get hashCode => Object.hash(systemScaler, userScale);
}
