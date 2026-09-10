import 'package:noema/core/database/database.dart';
import 'package:noema/core/design/theme/color_theme_dao.dart';
import 'package:noema/core/design/theme/typography_theme_dao.dart';
import 'package:noema/feature/config/data/config_dao.dart';

Future<void> ensureLocalConfig({
  required AppUserData user,
  required ConfigDao configDao,
  required ColorThemeDao colorThemeDao,
  required TypographyThemeDao typographyThemeDao,
  required String fingerprint,
}) async {
  final config = await configDao.getConfigByUser(userId: user.id);

  if (config != null) return;

  final colorThemeId = await colorThemeDao.insertColorTheme(
    userId: user.id,
    name: 'Default',
    seedColor: 0xFF0000FF,
  );

  final typographyThemeId =
      await typographyThemeDao.insertTypographyTheme(
    userId: user.id,
    name: 'Default',
    fontScale: 1,
  );

  await configDao.insertConfig(
    userId: user.id,
    colorThemeId: colorThemeId.toString(),
    typographyThemeId: typographyThemeId.toString(),
    preferences: '{}',
    deviceFingerprint: fingerprint,
  );
}

