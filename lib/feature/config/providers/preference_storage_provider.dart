import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noema/core/database/database_provider.dart';
import 'package:noema/core/device_fingerprint.dart';
import 'package:noema/core/network/api_client.dart';
import 'package:noema/feature/config/data/config_dao.dart';
import 'package:noema/feature/config/providers/user_provider.dart';
import 'package:openapi/openapi.dart';

const _localConfigIdKey = '__userLocalConfigId';
const _localOverridesKey = '__localPreferenceOverrides';

Map<String, dynamic> decodeConfigPreferences(String raw) {
  final decoded = jsonDecode(raw);
  if (decoded is Map<String, dynamic>) return decoded;
  throw const FormatException(
    'As preferências locais não estão em um formato válido.',
  );
}

Object? readConfigPreference(String raw, String key) {
  final preferences = decodeConfigPreferences(raw);
  final overrides = preferences[_localOverridesKey];
  if (overrides is Map && overrides.containsKey(key)) {
    return overrides[key];
  }
  return preferences[key];
}

String mergeRemoteConfigPreferences({
  required Map<String, dynamic> remotePreferences,
  required String localPreferences,
}) {
  final local = decodeConfigPreferences(localPreferences);
  final result = Map<String, dynamic>.from(remotePreferences);
  for (final key in const [
    _localConfigIdKey,
    _localOverridesKey,
  ]) {
    if (local.containsKey(key)) result[key] = local[key];
  }
  return jsonEncode(result);
}

Future<String?> _getDeviceId(
  Ref ref, {
  required String remoteUserId,
}) async {
  final client = ref.read(apiClientProvider);
  final fingerprint = await DeviceFingerprint.get();
  final response = await client
      .getDeviceApi()
      .listDeviceApiV1DeviceListGet(
        idUser: remoteUserId,
        deviceFingerprint: fingerprint,
      );
  final existing = response.data
      ?.where((device) => device.idUser == remoteUserId)
      .firstOrNull;
  if (existing != null) return existing.id;

  final created = await client.getDeviceApi().createDeviceApiV1DeviceCreatePost(
    deviceCreate: DeviceCreate((b) {
      b
        ..idUser = remoteUserId
        ..deviceName = 'Noema (${defaultTargetPlatform.name})'
        ..deviceFingerprint = fingerprint
        ..platform = defaultTargetPlatform.name;
    }),
  );
  final deviceId = created.data?.id;
  if (deviceId == null || deviceId.isEmpty) {
    throw StateError('O servidor não retornou o identificador do dispositivo.');
  }
  return deviceId;
}

Future<UserLocalConfigOut> _getOrCreateLocalConfig(
  Ref ref, {
  required String localUserId,
  required String remoteUserId,
}) async {
  final db = ref.read(appDatabaseProvider);
  final configDao = ConfigDao(db);
  var localConfig = await configDao.getConfigByUser(userId: localUserId);
  if (localConfig == null) {
    throw StateError('Configuração local do usuário não encontrada.');
  }
  final client = ref.read(apiClientProvider);
  final localApi = client.getUserLocalConfigApi();
  final cachedId = decodeConfigPreferences(localConfig.preferences)[
    _localConfigIdKey
  ];
  if (cachedId is String && cachedId.isNotEmpty) {
    final response = await localApi
        .getUserLocalConfigApiV1UserConfigUserLocalConfigGetIdentificatorGet(
          identificator: cachedId,
        );
    if (response.data != null) return response.data!;
  }

  final deviceId = await _getDeviceId(ref, remoteUserId: remoteUserId);
  if (deviceId == null) {
    throw StateError('Não foi possível identificar este dispositivo.');
  }

  final listed = await localApi
      .listUserLocalConfigsApiV1UserConfigUserLocalConfigListGet(
        idUser: remoteUserId,
        idDevice: deviceId,
        preferences: '{}',
      );
  final existing = listed.data
      ?.where(
        (item) => item.idUser == remoteUserId && item.idDevice == deviceId,
      )
      .firstOrNull;
  if (existing != null) {
    await _cacheLocalConfigId(
      ref,
      localUserId: localUserId,
      id: existing.id,
    );
    return existing;
  }

  final globalResponse = await client
      .getUserGlobalConfigApi()
      .getUserGlobalConfigApiV1UserConfigUserGlobalConfigGetIdentificatorGet(
        identificator: remoteUserId,
      );
  final global = globalResponse.data;
  if (global == null) {
    throw StateError('A configuração global da conta não foi encontrada.');
  }
  final created = await localApi
      .createUserLocalConfigApiV1UserConfigUserLocalConfigCreatePost(
        userLocalConfigCreate: UserLocalConfigCreate((b) {
          b
            ..idUser = remoteUserId
            ..idDevice = deviceId
            ..idLanguage = global.idLanguage
            ..idUserColorTheme = global.idUserColorTheme
            ..idUserTypographyTheme = global.idUserTypographyTheme
            ..preferences = '{}';
        }),
      );
  final data = created.data;
  if (data == null) {
    throw StateError('O servidor não retornou a configuração local criada.');
  }
  await _cacheLocalConfigId(ref, localUserId: localUserId, id: data.id);
  return data;
}

Future<void> _cacheLocalConfigId(
  Ref ref, {
  required String localUserId,
  required String id,
}) async {
  final dao = ConfigDao(ref.read(appDatabaseProvider));
  final config = await dao.getConfigByUser(userId: localUserId);
  if (config == null) {
    throw StateError('Configuração local do usuário não encontrada.');
  }
  final preferences = decodeConfigPreferences(config.preferences)
    ..[_localConfigIdKey] = id;
  await dao.updateConfig(id: config.id, preferences: jsonEncode(preferences));
}

Map<String, dynamic> _localOverrides(UserLocalConfigOut config) {
  final decoded = jsonDecode(jsonEncode(config.preferences));
  if (decoded is Map<String, dynamic>) return decoded;
  throw const FormatException(
    'As substituições locais do servidor estão em formato inválido.',
  );
}

Future<void> _saveLocalOverrides(
  Ref ref, {
  required String localUserId,
  required UserLocalConfigOut localConfig,
  required Map<String, dynamic> overrides,
}) async {
  await ref
      .read(apiClientProvider)
      .getUserLocalConfigApi()
      .updateUserLocalConfigApiV1UserConfigUserLocalConfigUpdateIdentificatorPut(
        identificator: localConfig.id,
        userLocalConfigUpdate: UserLocalConfigUpdate((b) {
          b.preferences = jsonEncode(overrides);
        }),
      );
  final dao = ConfigDao(ref.read(appDatabaseProvider));
  final config = await dao.getConfigByUser(userId: localUserId);
  if (config == null) {
    throw StateError('Configuração local do usuário não encontrada.');
  }
  final preferences = decodeConfigPreferences(config.preferences)
    ..[_localConfigIdKey] = localConfig.id
    ..[_localOverridesKey] = overrides;
  await dao.updateConfig(id: config.id, preferences: jsonEncode(preferences));
}

Future<bool> isPreferenceDeviceOnly(Ref ref, String key) async {
  final user = await ref.read(userProvider.future);
  final config = await ConfigDao(
    ref.read(appDatabaseProvider),
  ).getConfigByUser(userId: user.id);
  if (config == null) return false;
  final overrides = decodeConfigPreferences(config.preferences)[
    _localOverridesKey
  ];
  return overrides is Map && overrides.containsKey(key);
}

Future<void> setPreferenceDeviceOnly(
  Ref ref, {
  required String key,
  required Object effectiveValue,
  required bool deviceOnly,
  String? languageId,
}) async {
  final user = await ref.read(userProvider.future);
  final cacheDao = ConfigDao(ref.read(appDatabaseProvider));
  final userConfig = await cacheDao.getConfigByUser(userId: user.id);
  final cachedPreferences = userConfig == null
      ? <String, dynamic>{}
      : decodeConfigPreferences(userConfig.preferences);
  final cachedOverrides =
      cachedPreferences[_localOverridesKey] is Map
          ? Map<String, dynamic>.from(
              cachedPreferences[_localOverridesKey] as Map,
            )
          : <String, dynamic>{};
  if (!deviceOnly && !cachedOverrides.containsKey(key)) return;
  final localId = cachedPreferences[_localConfigIdKey];
  final local = localId is String && localId.isNotEmpty
      ? (await ref
                .read(apiClientProvider)
                .getUserLocalConfigApi()
                .getUserLocalConfigApiV1UserConfigUserLocalConfigGetIdentificatorGet(
                  identificator: localId,
                ))
            .data
      : null;
  final localConfig = local ??
      (deviceOnly
          ? await _getOrCreateLocalConfig(
              ref,
              localUserId: user.id,
              remoteUserId: user.remoteId,
            )
          : null);
  if (localConfig == null) {
    throw StateError('A configuração local do dispositivo não foi encontrada.');
  }
  final overrides = _localOverrides(localConfig);
  if (deviceOnly) {
    overrides[key] = effectiveValue;
    if (languageId != null) {
      await ref
          .read(apiClientProvider)
          .getUserLocalConfigApi()
          .updateUserLocalConfigApiV1UserConfigUserLocalConfigUpdateIdentificatorPut(
            identificator: localConfig.id,
            userLocalConfigUpdate: UserLocalConfigUpdate((b) {
              b
                ..preferences = jsonEncode(overrides)
                ..idLanguage = languageId;
            }),
          );
    } else {
      await _saveLocalOverrides(
        ref,
        localUserId: user.id,
        localConfig: localConfig,
        overrides: overrides,
      );
      return;
    }
    await _cacheLocalOverrideValues(
      ref,
      localUserId: user.id,
      localConfig: localConfig,
      overrides: overrides,
    );
    return;
  }

  final api = ref.read(apiClientProvider).getUserGlobalConfigApi();
  final remote = await api
      .getUserGlobalConfigApiV1UserConfigUserGlobalConfigGetIdentificatorGet(
        identificator: user.remoteId,
      );
  final globalPreferences = <String, dynamic>{
    for (final entry in remote.data!.preferences.entries)
      entry.key: entry.value?.value,
  };
  final globalValue = globalPreferences[key];
  overrides.remove(key);
  await _saveLocalOverrides(
    ref,
    localUserId: user.id,
    localConfig: localConfig,
    overrides: overrides,
  );
  if (key == 'locale' && languageId == null) return;
  if (key == 'locale' && languageId != null) {
    await api.updateUserGlobalConfigApiV1UserConfigUserGlobalConfigUpdateIdentificatorPut(
      identificator: user.remoteId,
      userGlobalConfigUpdate: UserGlobalConfigUpdate((b) {
        b.idLanguage = languageId;
      }),
    );
  }
  final dao = ConfigDao(ref.read(appDatabaseProvider));
  final config = await dao.getConfigByUser(userId: user.id);
  if (config == null) return;
  final preferences = decodeConfigPreferences(config.preferences);
  final cached = <String, dynamic>{
    if (preferences[_localOverridesKey] is Map)
      for (final entry in (preferences[_localOverridesKey] as Map).entries)
        if (entry.key is String) entry.key as String: entry.value,
  }..remove(key);
  preferences[_localOverridesKey] = cached;
  if (globalPreferences.containsKey(key)) {
    preferences[key] = globalValue;
  } else {
    preferences.remove(key);
  }
  await dao.updateConfig(id: config.id, preferences: jsonEncode(preferences));
}

Future<void> _cacheLocalOverrideValues(
  Ref ref, {
  required String localUserId,
  required UserLocalConfigOut localConfig,
  required Map<String, dynamic> overrides,
}) async {
  final dao = ConfigDao(ref.read(appDatabaseProvider));
  final config = await dao.getConfigByUser(userId: localUserId);
  if (config == null) {
    throw StateError('Configuração local do usuário não encontrada.');
  }
  final preferences = decodeConfigPreferences(config.preferences)
    ..[_localConfigIdKey] = localConfig.id
    ..[_localOverridesKey] = overrides;
  await dao.updateConfig(id: config.id, preferences: jsonEncode(preferences));
}

Future<void> saveConfigPreference(
  Ref ref, {
  required String key,
  required Object value,
  String? languageId,
}) async {
  final user = await ref.read(userProvider.future);
  final cacheDao = ConfigDao(ref.read(appDatabaseProvider));
  final localCache = await cacheDao.getConfigByUser(userId: user.id);
  final cachedOverrides = localCache == null
      ? <String, dynamic>{}
      : <String, dynamic>{
          if (decodeConfigPreferences(
                localCache.preferences,
              )[_localOverridesKey]
              is Map)
            for (final entry in (decodeConfigPreferences(
                  localCache.preferences,
                )[_localOverridesKey]
                as Map)
                .entries)
              if (entry.key is String) entry.key as String: entry.value,
        };
  if (cachedOverrides.containsKey(key)) {
    final localId = decodeConfigPreferences(
      localCache!.preferences,
    )[_localConfigIdKey];
    if (localId is! String || localId.isEmpty) {
      throw StateError('A configuração local do dispositivo não foi vinculada.');
    }
    final local = (await ref
            .read(apiClientProvider)
            .getUserLocalConfigApi()
            .getUserLocalConfigApiV1UserConfigUserLocalConfigGetIdentificatorGet(
              identificator: localId,
            ))
        .data;
    if (local == null) {
      throw StateError('A configuração local do dispositivo não foi encontrada.');
    }
    final overrides = _localOverrides(local);
    overrides[key] = value;
    if (languageId != null) {
      await ref
          .read(apiClientProvider)
          .getUserLocalConfigApi()
          .updateUserLocalConfigApiV1UserConfigUserLocalConfigUpdateIdentificatorPut(
            identificator: local.id,
            userLocalConfigUpdate: UserLocalConfigUpdate((b) {
              b
                ..preferences = jsonEncode(overrides)
                ..idLanguage = languageId;
            }),
          );
      await _cacheLocalOverrideValues(
        ref,
        localUserId: user.id,
        localConfig: local,
        overrides: overrides,
      );
    } else {
      await _saveLocalOverrides(
        ref,
        localUserId: user.id,
        localConfig: local,
        overrides: overrides,
      );
    }
    return;
  }

  final api = ref.read(apiClientProvider).getUserGlobalConfigApi();
  final remote = await api
      .getUserGlobalConfigApiV1UserConfigUserGlobalConfigGetIdentificatorGet(
        identificator: user.remoteId,
      );
  final preferences = <String, dynamic>{
    for (final entry in remote.data!.preferences.entries)
      entry.key: entry.value?.value,
  }..[key] = value;
  await api.updateUserGlobalConfigApiV1UserConfigUserGlobalConfigUpdateIdentificatorPut(
    identificator: user.remoteId,
    userGlobalConfigUpdate: UserGlobalConfigUpdate((b) {
      b.preferences = jsonEncode(preferences);
      if (languageId != null) b.idLanguage = languageId;
    }),
  );
  final dao = ConfigDao(ref.read(appDatabaseProvider));
  final config = await dao.getConfigByUser(userId: user.id);
  if (config != null) {
    await dao.updateConfig(
      id: config.id,
      preferences: mergeRemoteConfigPreferences(
        remotePreferences: preferences,
        localPreferences: config.preferences,
      ),
    );
  }
}

final preferenceDeviceOnlyProvider = FutureProvider.family<bool, String>((
  ref,
  key,
) {
  return isPreferenceDeviceOnly(ref, key);
});

class PreferenceStorageService {
  const PreferenceStorageService(this._ref);

  final Ref _ref;

  Future<bool> isDeviceOnly(String key) =>
      isPreferenceDeviceOnly(_ref, key);

  Future<void> setDeviceOnly({
    required String key,
    required Object effectiveValue,
    required bool deviceOnly,
    String? languageId,
  }) => setPreferenceDeviceOnly(
    _ref,
    key: key,
    effectiveValue: effectiveValue,
    deviceOnly: deviceOnly,
    languageId: languageId,
  );

  Future<void> save({
    required String key,
    required Object value,
    String? languageId,
  }) => saveConfigPreference(
    _ref,
    key: key,
    value: value,
    languageId: languageId,
  );
}

final preferenceStorageServiceProvider = Provider<PreferenceStorageService>(
  PreferenceStorageService.new,
);
