import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noema/core/database/database.dart'
    show ColorThemeData, TypographyThemeData;
import 'package:noema/core/database/database_provider.dart';
import 'package:noema/core/design/theme/color_theme_dao.dart';
import 'package:noema/core/design/theme/typography_theme_dao.dart';
import 'package:noema/core/device_fingerprint.dart';
import 'package:noema/core/network/api_client.dart';
import 'package:noema/core/network/connetction_checker.dart';
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
  final connectionAsync = ref.watch(serverConnectionChecker);

  final token = await storage.read(key: 'access_token');
  final tokenOnwerId = await storage.read(key: 'access_token_remote_onwer_id');

  if (token == null || token.isEmpty) {
    return false;
  }

  apiClient.setOAuthToken('OAuth2PasswordBearer', token);

  final localUser = await userDao.getUserByRemoteId(id: tokenOnwerId ?? "");

  final isConnected = connectionAsync.value ?? true;

  if (localUser != null) {
    if (isConnected) {
      debugPrint("1");

      try {
        final response = await ref
            .read(userApiProvider)
            .currentUserApiV1UserGetGet();

        final remoteUser = response.data;

        if (remoteUser != null) {
          await userDao.updateUser(
            id: localUser.id,
            remoteId: remoteUser.id,
            userName: remoteUser.userName,
            displayName: remoteUser.userDisplayName,
            primaryEmail: remoteUser.primaryEmail,
          );
        }
        debugPrint("2");
      } catch (error, stackTrace) {
        debugPrint("3");
        debugPrint('Erro ao validar usuário: $error');
        debugPrintStack(stackTrace: stackTrace);
      }
    }

    final config = await configDao.getConfigByUser(userId: localUser.id);
    debugPrint("4");

    if (config == null) {
      debugPrint("5");
      final ColorThemeData? colorTheme = await colorThemeDao
          .getColorThemeByName(name: "Default");
      String idColorTheme = "";
      if (colorTheme == null) {
        final id = await colorThemeDao.insertColorTheme(
          userId: localUser.id,
          name: "Default",
          seedColor: 0x0000FF,
        );

        idColorTheme = id.toString();
      } else {
        idColorTheme = colorTheme.id;
      }

      debugPrint("5");
      final TypographyThemeData? typographTheme = await typographyThemeDao
          .getTypographyThemeByName(name: "Default");

      String typographThemeId = "";
      if (typographTheme == null) {
        final id = await typographyThemeDao.insertTypographyTheme(
          userId: localUser.id,
          name: "Default",
          fontScale: 1,
        );
        typographThemeId = id.toString();
      } else {
        typographThemeId = typographTheme.id;
      }
      debugPrint("5");

      if (isConnected) {
        debugPrint("6");

        final configApi = ref.watch(apiClientProvider).getUserGlobalConfigApi();

        final configResponse = await configApi
            .getUserGlobalConfigApiV1UserConfigUserGlobalConfigGetIdentificatorGet(
              identificator: localUser.remoteId,
            );

        final configResponseData = configResponse.data;

        await configDao.insertConfig(
          userId: localUser.id,
          colorThemeId: idColorTheme,
          typographyThemeId: typographThemeId,
          preferences: configResponseData?.preferences.toString() ?? "{}",
          deviceFingerprint: fingerprint,
        );
        debugPrint("7");
      } else {
        debugPrint("8");

        await configDao.insertConfig(
          userId: localUser.id,
          colorThemeId: idColorTheme,
          typographyThemeId: typographThemeId,
          preferences: "{}",
          deviceFingerprint: fingerprint,
        );
      }
    } else {
      if (isConnected) {
        debugPrint("6");

        final configApi = ref.watch(apiClientProvider).getUserGlobalConfigApi();

        final configResponse = await configApi
            .getUserGlobalConfigApiV1UserConfigUserGlobalConfigGetIdentificatorGet(
              identificator: localUser.remoteId,
            );

        final configResponseData = configResponse.data;

        await configDao.updateConfig(
          id: config.id,
          userId: localUser.id,
          preferences: configResponseData?.preferences.toString() ?? "{}",
          deviceFingerprint: fingerprint,
        );
        debugPrint("7");
      }
    }
    debugPrint("9");

    return true;
  }
  try {
    if (isConnected) {
      final response = await ref
          .read(userApiProvider)
          .currentUserApiV1UserGetGet();

      final remoteUser = response.data;

      if (remoteUser == null) {
        debugPrint("10");

        return false;
      }

      await userDao.insertUser(
        remoteId: remoteUser.id,
        userName: remoteUser.userName,
        displayName: remoteUser.userDisplayName,
        primaryEmail: remoteUser.primaryEmail,
        isActive: remoteUser.isActive,
      );
      debugPrint("11");

      return true;
    }
  } catch (_) {
    debugPrint("12");

    return false;
  }
  debugPrint("13");
  return false;
});

// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:noema/core/database/database.dart';
// import 'package:noema/core/database/database_provider.dart';
// import 'package:noema/core/network/api_client.dart';
// import 'package:noema/core/network/connetction_checker.dart';
// import 'package:noema/feature/config/data/user_dao.dart';
// import 'package:noema/feature/auth/services/login_service.dart';
// import 'package:openapi/openapi.dart';

// final authStateProvider = FutureProvider<bool>((ref) async {
//   final storage = ref.read(secureSorageProvider);
//   final token = await storage.read(key: "access_token");
//   final db = ref.read(appDatabaseProvider);
//   final connectionAsync = ref.watch(serverConnectionChecker);

//   final isConnected = connectionAsync.value ?? true;

//   if(isConnected) {

//   } else {

//   }

//   if (token == null || token.isEmpty || token == "") {
//     return false;
//   }
//   print(token);

//   ref.read(apiClientProvider).setOAuthToken("OAuth2PasswordBearer", token);

//   try {
//     print("sem user");

//     var response = await ref.read(userApiProvider).currentUserApiV1UserGetGet();

//     UserOut? remoteUser = response.data;

//     AppUserData? user = await AppUserDao(db).getActiveUser();

//     if (remoteUser == null) {
//       print("Remote user null");
//       return false;
//     }

//     if (user == null) {
//       AppUserDao(db).insertUser(
//         remoteId: remoteUser.id,
//         userName: remoteUser.userName,
//         displayName: remoteUser.userDisplayName,
//         primaryEmail: remoteUser.primaryEmail,
//         isActive: true,
//       );
//     }
//     return true;
//   } catch (e) {
//     print("erro");
//     print(e.toString());
//     await storage.delete(key: "access_token");
//     return false;
//   }
// });
