import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noema/core/database/database.dart' show ColorThemeData;
import 'package:noema/core/database/database_provider.dart';
import 'package:noema/core/design/theme/color_theme_dao.dart';
import 'package:noema/core/design/theme/theme_defaults.dart';
import 'package:noema/core/design/theme/typography_theme_dao.dart';
import 'package:noema/core/device_fingerprint.dart';
import 'package:noema/feature/config/data/config_dao.dart';
import 'package:noema/feature/config/providers/user_provider.dart';

class SwitchColor extends AsyncNotifier<int> {
  @override
  Future<int> build() async {
    final user = await ref.read(userProvider.notifier).getUser();
    final db = ref.read(appDatabaseProvider);
    final colorThemeDao = ColorThemeDao(db);
    final typographyThemeDao = TypographyThemeDao(db);
    final configDao = ConfigDao(db);
    final fingerprint = await DeviceFingerprint.get();

    final config = await configDao.getConfigByUser(userId: user.id);

    if (config == null) {
      final colorThemeId = await colorThemeDao.insertColorTheme(
        userId: user.id,
        name: "Default",
        seedColor: AppThemeDefaults.seedColor,
      );

      final typographThemeId = await typographyThemeDao.insertTypographyTheme(
        userId: user.id,
        name: "Default",
        fontScale: 1,
      );

      await configDao.insertConfig(
        userId: user.id,
        colorThemeId: colorThemeId,
        typographyThemeId: typographThemeId,
        preferences: "{}",
        deviceFingerprint: fingerprint,
      );

      final theme = await (db.select(
        db.colorTheme,
      )..where((theme) => theme.id.equals(colorThemeId))).getSingleOrNull();

      if (theme == null) {
        return AppThemeDefaults.seedColor;
      }

      _setBrightnessFromTheme(theme.overridesJson);
      return theme.seedColor;
    }

    final theme =
        await (db.select(db.colorTheme)
              ..where((theme) => theme.id.equals(config.colorThemeId)))
            .getSingleOrNull();

    if (theme == null) return AppThemeDefaults.seedColor;

    final seedColor =
        AppThemeDefaults.isUntouchedLegacyDefault(
          name: theme.name,
          seedColor: theme.seedColor,
          overridesJson: theme.overridesJson,
        )
        ? AppThemeDefaults.seedColor
        : theme.seedColor;
    if (seedColor != theme.seedColor) {
      await colorThemeDao.updateColorTheme(id: theme.id, seedColor: seedColor);
    }

    _setBrightnessFromTheme(theme.overridesJson);
    return seedColor;
  }

  void _setBrightnessFromTheme(String? json) {
    try {
      final values = json == null
          ? const <String, dynamic>{}
          : jsonDecode(json) as Map<String, dynamic>;
      final mode = values['__brightness'];
      if (mode == 'dark' || mode == 'light') {
        ref
            .read(brightnessProvider.notifier)
            .change(
              brightness: mode == 'dark' ? Brightness.dark : Brightness.light,
            );
      }
    } catch (_) {
      // Invalid optional overrides must not prevent the app from starting.
    }
  }

  Future<void> change({required int color}) async {
    if (color < 0 || color > 0xFFFFFFFF) {
      throw ArgumentError.value(color, 'color', 'must be a valid ARGB color');
    }

    final user = await ref.read(userProvider.notifier).getUser();
    final db = ref.read(appDatabaseProvider);
    final colorThemeDao = ColorThemeDao(db);
    final configDao = ConfigDao(db);

    final config = await configDao.getConfigByUser(userId: user.id);

    final theme =
        await (db.select(db.colorTheme)
              ..where((theme) => theme.id.equals(config?.colorThemeId ?? "")))
            .getSingleOrNull();

    if (theme == null) {
      state = AsyncError(
        StateError('Tema de cores não encontrado'),
        StackTrace.current,
      );
      return;
    }

    await colorThemeDao.updateColorTheme(id: theme.id, seedColor: color);

    state = AsyncData(color);
    ref.invalidate(activeColorThemeProvider);
  }

  Future<void> setBrightness({required Brightness brightness}) async {
    final user = await ref.read(userProvider.notifier).getUser();
    final db = ref.read(appDatabaseProvider);
    final config = await ConfigDao(db).getConfigByUser(userId: user.id);
    if (config == null) {
      throw StateError('Configuração de tema do usuário não encontrada.');
    }

    final dao = ColorThemeDao(db);
    final theme = await dao.getColorTheme(id: config.colorThemeId);
    if (theme == null || theme.userId != user.id) {
      throw StateError('Tema de cores ativo não encontrado.');
    }

    final overrides = _readThemeOverrides(theme.overridesJson)
      ..['__brightness'] = brightness == Brightness.dark ? 'dark' : 'light';
    await dao.updateColorTheme(
      id: theme.id,
      overridesJson: jsonEncode(overrides),
    );
    ref.read(brightnessProvider.notifier).change(brightness: brightness);
    state = AsyncData(theme.seedColor);
    ref.invalidate(activeColorThemeProvider);
  }

  Future<void> applyTheme({required String themeId}) async {
    final user = await ref.read(userProvider.notifier).getUser();
    final db = ref.read(appDatabaseProvider);
    final theme = await (db.select(
      db.colorTheme,
    )..where((item) => item.id.equals(themeId))).getSingleOrNull();
    if (theme == null || theme.userId != user.id) {
      throw StateError('Tema selecionado não encontrado');
    }

    final configDao = ConfigDao(db);
    final config = await configDao.getConfigByUser(userId: user.id);
    if (config == null) {
      throw StateError('Configuração do usuário não encontrada');
    }

    await configDao.updateConfig(id: config.id, colorThemeId: theme.id);
    _setBrightnessFromTheme(theme.overridesJson);
    state = AsyncData(theme.seedColor);
    ref.invalidate(activeColorThemeProvider);
  }

  Future<String> newTheme({
    required String name,
    required int seedColor,
    required Map<String, int> overrides,
    required Brightness brightness,
  }) async {
    final normalizedName = name.trim();
    if (normalizedName.isEmpty) {
      throw ArgumentError.value(name, 'name', 'cannot be empty');
    }

    final user = await ref.read(userProvider.notifier).getUser();
    final db = ref.read(appDatabaseProvider);
    final colorThemeDao = ColorThemeDao(db);

    final id = await colorThemeDao.insertColorTheme(
      userId: user.id,
      name: normalizedName,
      seedColor: seedColor,
      overridesJson: jsonEncode({
        ...overrides,
        '__brightness': brightness == Brightness.dark ? 'dark' : 'light',
      }),
    );
    return id;
  }

  Future<void> updateTheme({
    required String themeId,
    required String name,
    required int seedColor,
    required Brightness brightness,
    required Map<String, int> overrides,
  }) async {
    final db = ref.read(appDatabaseProvider);
    await ColorThemeDao(db).updateColorTheme(
      id: themeId,
      name: name.trim(),
      seedColor: seedColor,
      overridesJson: jsonEncode({
        ...overrides,
        '__brightness': brightness == Brightness.dark ? 'dark' : 'light',
      }),
    );
    await applyTheme(themeId: themeId);
  }
}

final colorProvider = AsyncNotifierProvider<SwitchColor, int>(SwitchColor.new);

final activeColorThemeProvider = StreamProvider.autoDispose<ColorThemeData?>((
  ref,
) async* {
  final user = await ref.watch(userProvider.future);
  final db = ref.watch(appDatabaseProvider);
  final query =
      db.select(db.colorTheme).join([
        innerJoin(
          db.config,
          db.config.colorThemeId.equalsExp(db.colorTheme.id),
        ),
      ])..where(
        db.config.userId.equals(user.id) & db.colorTheme.userId.equals(user.id),
      );

  await for (final rows in query.watch()) {
    yield rows.isEmpty ? null : rows.first.readTable(db.colorTheme);
  }
});

class SwithBrightness extends Notifier<Brightness> {
  @override
  Brightness build() {
    return WidgetsBinding.instance.platformDispatcher.platformBrightness;
  }

  void change({required Brightness brightness}) {
    state = brightness;
  }
}

final brightnessProvider = NotifierProvider<SwithBrightness, Brightness>(
  SwithBrightness.new,
);

Map<String, dynamic> _readThemeOverrides(String? json) {
  if (json == null || json.trim().isEmpty) return {};
  final decoded = jsonDecode(json);
  if (decoded is! Map<String, dynamic>) {
    throw const FormatException('As personalizações do tema estão inválidas.');
  }
  return Map<String, dynamic>.from(decoded);
}
