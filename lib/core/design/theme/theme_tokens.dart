import 'package:flutter/material.dart';
import 'package:noema/core/design/tokens/durations.dart';
import 'package:noema/core/design/tokens/elevation.dart';
import 'package:noema/core/design/tokens/icon_size.dart';
import 'package:noema/core/design/tokens/radius.dart';
import 'package:noema/core/design/tokens/spacing.dart';

extension BuildContextThemeExtension on BuildContext {
  ThemeData get theme => Theme.of(this);

  ColorScheme get colors => theme.colorScheme;

  TextTheme get textTheme => theme.textTheme;

  AppSpacing get spacing =>
      theme.extension<AppSpacingTheme>()!.spacing;

  AppRadius get radius =>
      theme.extension<AppRadiusTheme>()!.radius;

  AppDurations get durations =>
      theme.extension<AppDurationsTheme>()!.durations;

  AppElevation get elevation =>
      theme.extension<AppElevationTheme>()!.elevation;

  AppIconSize get iconSize =>
      theme.extension<AppIconSizeTheme>()!.iconSize;
}