import 'package:flutter/foundation.dart';
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
  final connectionState = ref.read(serverConnectionChecker);

  final token = await storage.read(key: 'access_token');
  final tokenOwnerId =
      await storage.read(key: 'access_token_remote_owner_id') ??
      await storage.read(key: 'access_token_remote_onwer_id');

  if (token == null || token.isEmpty) {
    return false;
  }

  apiClient.setOAuthToken('OAuth2PasswordBearer', token);

  if (tokenOwnerId == null || tokenOwnerId.isEmpty) {
    return false;
  }

  await storage.write(key: 'access_token_remote_owner_id', value: tokenOwnerId);

  final localUser = await userDao.getUserByRemoteId(id: tokenOwnerId);

  final isConnected = connectionState.value ?? false;

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

        try {
          final configApi = ref
              .read(apiClientProvider)
              .getUserGlobalConfigApi();
          final configResponse = await configApi
              .getUserGlobalConfigApiV1UserConfigUserGlobalConfigGetIdentificatorGet(
                identificator: localUser.remoteId,
              )
              .timeout(const Duration(seconds: 5));

          await configDao.insertConfig(
            userId: localUser.id,
            colorThemeId: idColorTheme,
            typographyThemeId: typographThemeId,
            preferences: configResponse.data?.preferences.toString() ?? "{}",
            deviceFingerprint: fingerprint,
          );
        } catch (error, stackTrace) {
          debugPrint('Falha ao sincronizar configuração: $error');
          debugPrintStack(stackTrace: stackTrace);
          await configDao.insertConfig(
            userId: localUser.id,
            colorThemeId: idColorTheme,
            typographyThemeId: typographThemeId,
            preferences: "{}",
            deviceFingerprint: fingerprint,
          );
        }
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

        try {
          final configApi = ref
              .read(apiClientProvider)
              .getUserGlobalConfigApi();
          final configResponse = await configApi
              .getUserGlobalConfigApiV1UserConfigUserGlobalConfigGetIdentificatorGet(
                identificator: localUser.remoteId,
              )
              .timeout(const Duration(seconds: 5));

          await configDao.updateConfig(
            id: config.id,
            userId: localUser.id,
            preferences: configResponse.data?.preferences.toString() ?? "{}",
            deviceFingerprint: fingerprint,
          );
        } catch (error, stackTrace) {
          debugPrint('Falha ao atualizar configuração: $error');
          debugPrintStack(stackTrace: stackTrace);
        }
        debugPrint("7");
      }
    }
    debugPrint("9");

    return true;
  }

  try {
    final response = await ref
        .read(userApiProvider)
        .currentUserApiV1UserGetGet()
        .timeout(const Duration(seconds: 5));

    final remoteUser = response.data;

    if (remoteUser == null) {
      debugPrint('Usuário remoto não encontrado');
      return false;
    }

    await userDao.insertUser(
      remoteId: remoteUser.id,
      userName: remoteUser.userName,
      displayName: remoteUser.userDisplayName,
      primaryEmail: remoteUser.primaryEmail,
      isActive: true,
    );
    debugPrint('Usuário salvo localmente');

    return true;
  } catch (error, stackTrace) {
    debugPrint('Falha ao criar usuário local: $error');
    debugPrintStack(stackTrace: stackTrace);
    return false;
  }
});

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
