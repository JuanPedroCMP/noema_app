import 'dart:convert';

import 'package:built_value/json_object.dart';
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
import 'package:noema/feature/config/providers/preference_storage_provider.dart';
import 'package:noema/feature/auth/services/login_service.dart';

final authStateProvider = FutureProvider<bool>((ref) async {
  final storage = ref.read(secureSorageProvider);
  final apiClient = ref.read(apiClientProvider);
  clearApiAccessToken(apiClient);
  final db = ref.read(appDatabaseProvider);
  final userDao = AppUserDao(db);
  final token = await storage.read(key: 'access_token');
  final tokenOwnerId =
      await storage.read(key: 'access_token_remote_owner_id') ??
      await storage.read(key: 'access_token_remote_onwer_id');

  if (token == null || token.isEmpty) {
    await userDao.deactivateAllUsers();
    return false;
  }
  if (tokenOwnerId == null || tokenOwnerId.isEmpty) {
    await userDao.deactivateAllUsers();
    return false;
  }

  setApiAccessToken(apiClient, token);
  await storage.write(key: 'access_token_remote_owner_id', value: tokenOwnerId);

  final isConnected = ref.read(serverConnectionChecker).value ?? false;
  var localUser = await userDao.getUserByRemoteId(id: tokenOwnerId);

  if (localUser == null) {
    try {
      final response = await ref
          .read(userApiProvider)
          .currentUserApiV1UserGetGet()
          .timeout(const Duration(seconds: 5));
      final remoteUser = response.data;
      if (remoteUser == null || remoteUser.id != tokenOwnerId) {
        await userDao.deactivateAllUsers();
        return false;
      }
      await userDao.insertUser(
        remoteId: remoteUser.id,
        userName: remoteUser.userName,
        displayName: remoteUser.userDisplayName,
        primaryEmail: remoteUser.primaryEmail,
        isActive: false,
      );
      localUser = await userDao.getUserByRemoteId(id: tokenOwnerId);
      if (localUser == null) {
        throw StateError('Não foi possível recuperar o usuário local criado.');
      }
    } catch (error, stackTrace) {
      await userDao.deactivateAllUsers();
      debugPrint('Falha ao preparar usuário local: $error');
      debugPrintStack(stackTrace: stackTrace);
      return false;
    }
  } else if (isConnected) {
    try {
      final response = await ref
          .read(userApiProvider)
          .currentUserApiV1UserGetGet()
          .timeout(const Duration(seconds: 5));
      final remoteUser = response.data;
      if (remoteUser != null) {
        if (remoteUser.id != tokenOwnerId) {
          await userDao.deactivateAllUsers();
          return false;
        }
        await userDao.updateUser(
          id: localUser.id,
          remoteId: remoteUser.id,
          userName: remoteUser.userName,
          displayName: remoteUser.userDisplayName,
          primaryEmail: remoteUser.primaryEmail,
        );
      }
    } catch (error, stackTrace) {
      debugPrint('Falha ao atualizar o perfil local: $error');
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  await userDao.activateUser(id: localUser.id);
  await _ensureUserConfig(
    ref: ref,
    userId: localUser.id,
    remoteId: localUser.remoteId,
    isConnected: isConnected,
  );
  return true;
});

Future<void> _ensureUserConfig({
  required Ref ref,
  required String userId,
  required String remoteId,
  required bool isConnected,
}) async {
  final db = ref.read(appDatabaseProvider);
  final configDao = ConfigDao(db);
  final colorDao = ColorThemeDao(db);
  final typographyDao = TypographyThemeDao(db);
  final fingerprint = await DeviceFingerprint.get();

  final colorTheme =
      await colorDao.getColorThemeByName(name: 'Default', userId: userId) ??
      await _createDefaultColorTheme(colorDao, userId);
  final typographyTheme =
      await typographyDao.getTypographyThemeByName(
        name: 'Default',
        userId: userId,
      ) ??
      await _createDefaultTypographyTheme(typographyDao, userId);

  var config = await configDao.getConfigByUser(userId: userId);
  if (config == null) {
    var preferences = '{}';
    if (isConnected) {
      try {
        final response = await ref
            .read(apiClientProvider)
            .getUserGlobalConfigApi()
            .getUserGlobalConfigApiV1UserConfigUserGlobalConfigGetIdentificatorGet(
              identificator: remoteId,
            )
            .timeout(const Duration(seconds: 5));
        final remotePreferences = <String, dynamic>{
          for (final entry in response.data?.preferences.entries ??
              const <MapEntry<String, JsonObject?>>[])
            entry.key: entry.value?.value,
        };
        preferences = jsonEncode(remotePreferences);
      } catch (error, stackTrace) {
        debugPrint('Falha ao sincronizar a configuração local: $error');
        debugPrintStack(stackTrace: stackTrace);
      }
    }
    await configDao.insertConfig(
      userId: userId,
      colorThemeId: colorTheme.id,
      typographyThemeId: typographyTheme.id,
      preferences: preferences,
      deviceFingerprint: fingerprint,
    );
    return;
  }

  final selectedColor = await colorDao.getColorTheme(id: config.colorThemeId);
  final selectedTypography = await typographyDao.getTypographyTheme(
    id: config.typographyThemeId,
  );
  final colorBelongsToUser = selectedColor?.userId == userId;
  final typographyBelongsToUser = selectedTypography?.userId == userId;
  if (!colorBelongsToUser || !typographyBelongsToUser) {
    await configDao.updateConfig(
      id: config.id,
      userId: userId,
      colorThemeId: colorBelongsToUser ? config.colorThemeId : colorTheme.id,
      typographyThemeId: typographyBelongsToUser
          ? config.typographyThemeId
          : typographyTheme.id,
      deviceFingerprint: fingerprint,
    );
    config = await configDao.getConfigByUser(userId: userId);
  }

  if (isConnected && config != null) {
    try {
      final response = await ref
          .read(apiClientProvider)
          .getUserGlobalConfigApi()
          .getUserGlobalConfigApiV1UserConfigUserGlobalConfigGetIdentificatorGet(
            identificator: remoteId,
          )
          .timeout(const Duration(seconds: 5));
      await configDao.updateConfig(
        id: config.id,
        userId: userId,
        preferences: mergeRemoteConfigPreferences(
          remotePreferences: {
            for (final entry in response.data?.preferences.entries ??
                const <MapEntry<String, JsonObject?>>[])
              entry.key: entry.value?.value,
          },
          localPreferences: config.preferences,
        ),
        deviceFingerprint: fingerprint,
      );
    } catch (error, stackTrace) {
      debugPrint('Falha ao atualizar a configuração local: $error');
      debugPrintStack(stackTrace: stackTrace);
    }
  }
}

Future<ColorThemeData> _createDefaultColorTheme(
  ColorThemeDao dao,
  String userId,
) async {
  final id = await dao.insertColorTheme(
    userId: userId,
    name: 'Default',
    seedColor: 0xFF0000FF,
  );
  final theme = await dao.getColorTheme(id: id);
  if (theme == null) {
    throw StateError('Não foi possível criar o tema de cores padrão.');
  }
  return theme;
}

Future<TypographyThemeData> _createDefaultTypographyTheme(
  TypographyThemeDao dao,
  String userId,
) async {
  final id = await dao.insertTypographyTheme(
    userId: userId,
    name: 'Default',
    fontScale: 1,
  );
  final theme = await dao.getTypographyTheme(id: id);
  if (theme == null) {
    throw StateError('Não foi possível criar o tema de tipografia padrão.');
  }
  return theme;
}
