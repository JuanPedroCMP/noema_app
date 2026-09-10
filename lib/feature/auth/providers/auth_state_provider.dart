import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noema/core/database/database_provider.dart';
import 'package:noema/core/design/theme/color_theme_dao.dart';
import 'package:noema/core/design/theme/typography_theme_dao.dart';
import 'package:noema/core/device_fingerprint.dart';
import 'package:noema/core/network/api_client.dart';
import 'package:noema/feature/config/data/config_dao.dart';
import 'package:noema/feature/config/data/user_dao.dart';
import 'package:noema/feature/auth/services/login_service.dart';

final authStateProvider = FutureProvider<bool>((ref) async {
  final storage = ref.read(secureSorageProvider);
  final apiClient = ref.read(apiClientProvider);
  final db = ref.read(appDatabaseProvider);
  final userDao = AppUserDao(db);
  final configDao = ConfigDao(db);
  final colorThemeDao = ColorThemeDao(db);
  final typographyThemeDao = TypographyThemeDao(db);
  final fingerprint = await DeviceFingerprint.get();

  final token = await storage.read(key: 'access_token');

  if (token == null || token.isEmpty) {
    return false;
  }

  apiClient.setOAuthToken('OAuth2PasswordBearer', token);

  final localUser = await userDao.getActiveUser();

  if (localUser != null) {
    try {
      final response = await ref
          .read(userApiProvider)
          .currentUserApiV1UserGetGet();

      final remoteUser = response.data;

      if (remoteUser != null) {
        await userDao.insertUser(
          remoteId: remoteUser.id,
          userName: remoteUser.userName,
          displayName: remoteUser.userDisplayName,
          primaryEmail: remoteUser.primaryEmail,
        );
      }
    } catch (_) {}

    final config = await configDao.getConfigByUser(userId: localUser.id);

    // Todo puxar dados remotos caso seja null ou não
    if (config == null) {
      final colorThemeId = await colorThemeDao.insertColorTheme(
        userId: localUser.id,
        name: "Default",
        seedColor: 0x0000FF,
      );

      final typographThemeId = await typographyThemeDao.insertTypographyTheme(
        userId: localUser.id,
        name: "Default",
        fontScale: 1,
      );

      configDao.insertConfig(
        userId: localUser.id,
        colorThemeId: colorThemeId.toString(),
        typographyThemeId: typographThemeId.toString(),
        preferences: "{}",
        deviceFingerprint: fingerprint,
      );
    }

    return true;
  }

  try {
    final response = await ref
        .read(userApiProvider)
        .currentUserApiV1UserGetGet();

    final remoteUser = response.data;

    if (remoteUser == null) {
      return false;
    }

    await userDao.insertUser(
      remoteId: remoteUser.id,
      userName: remoteUser.userName,
      displayName: remoteUser.userDisplayName,
      primaryEmail: remoteUser.primaryEmail,
      isActive: remoteUser.isActive,
    );

    return true;
  } catch (_) {
    return false;
  }
});
