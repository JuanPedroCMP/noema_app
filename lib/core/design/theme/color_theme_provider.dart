import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noema/core/database/database_provider.dart';
import 'package:noema/core/design/theme/color_theme_dao.dart';
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
        seedColor: 0x0000FF,
      );

      final typographThemeId = await typographyThemeDao.insertTypographyTheme(
        userId: user.id,
        name: "Default",
        fontScale: 1,
      );

      final configId = await configDao.insertConfig(
        userId: user.id,
        colorThemeId: colorThemeId.toString(),
        typographyThemeId: typographThemeId.toString(),
        preferences: "{}",
        deviceFingerprint: fingerprint,
      );

      final theme =
          await (db.select(
                db.colorTheme,
              )..where((theme) => theme.id.equals(typographThemeId.toString())))
              .getSingleOrNull();

      if (theme == null) {
        return 0x22FF;
      }

      return theme.seedColor;
    }

    final theme = await (db.select(
      db.colorTheme,
    )..where((theme) => theme.id.equals(config.colorThemeId))).getSingleOrNull();

    if (theme == null) {
      //TODO Dps fazer verificação se tem config específica para esse device
    }

    return theme!.seedColor;
  }

  void change({required int color}) async {
    final user = await ref.read(userProvider.notifier).getUser();
    final db = ref.read(appDatabaseProvider);
    final colorThemeDao = ColorThemeDao(db);

    final theme = await (db.select(
      db.colorTheme,
    )..where((theme) => theme.userId.equals(user.id))).getSingleOrNull();

    colorThemeDao.updateColorTheme(id: theme!.id, seedColor: color);

    state = AsyncData(color);
  }
}

final colorProvider = AsyncNotifierProvider<SwitchColor, int>(SwitchColor.new);

class SwithBrightness extends Notifier<Brightness> {
  @override
  Brightness build() {
    return Brightness.dark; // Pegar por padrão o modo do sistema
  }

  void change({required Brightness brightness}) {
    state = brightness;
  }
}

final brightnessProvider = NotifierProvider<SwithBrightness, Brightness>(
  SwithBrightness.new,
);
