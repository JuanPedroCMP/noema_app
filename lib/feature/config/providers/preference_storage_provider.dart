import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noema/core/database/database_provider.dart';
import 'package:noema/core/network/api_client.dart';
import 'package:noema/core/network/connetction_checker.dart';
import 'package:noema/feature/config/data/config_dao.dart';
import 'package:noema/feature/config/providers/user_provider.dart';
import 'package:openapi/openapi.dart';

const _localConfigIdKey = '__userLocalConfigId';
const _localOverridesKey = '__localPreferenceOverrides';
const _localOnlyPreferencesKey = '__localOnlyPreferences';
const _pendingPreferenceSyncKey = '__pendingPreferenceSync';
const responseLanguagePreferenceOrderKey = 'responseLanguagePreferenceOrder';
const fallbackPortugueseLanguageId = '__localLanguage_pt';
const fallbackEnglishLanguageId = '__localLanguage_en';

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
  final localOnlyPreferences = preferences[_localOnlyPreferencesKey];
  if (localOnlyPreferences is Map && localOnlyPreferences.containsKey(key)) {
    return localOnlyPreferences[key];
  }
  return preferences[key];
}

String mergeRemoteConfigPreferences({
  required Map<String, dynamic> remotePreferences,
  required String localPreferences,
}) {
  final local = decodeConfigPreferences(localPreferences);
  final pending = _stringMap(local[_pendingPreferenceSyncKey]);
  final result = Map<String, dynamic>.from(remotePreferences)..addAll(pending);
  for (final key in const [
    _localConfigIdKey,
    _localOverridesKey,
    _localOnlyPreferencesKey,
    _pendingPreferenceSyncKey,
  ]) {
    if (local.containsKey(key)) result[key] = local[key];
  }
  return jsonEncode(result);
}

String updateConfigPreferenceLocally({
  required String currentPreferences,
  required String key,
  required Object value,
  required bool deviceOnly,
}) {
  final preferences = decodeConfigPreferences(currentPreferences);
  final overrides = _stringMap(preferences[_localOverridesKey]);
  final pending = _stringMap(preferences[_pendingPreferenceSyncKey]);

  if (deviceOnly) {
    overrides[key] = value;
    pending.remove(key);
  } else {
    overrides.remove(key);
    preferences[key] = value;
    pending[key] = value;
  }

  preferences[_localOverridesKey] = overrides;
  preferences[_pendingPreferenceSyncKey] = pending;
  return jsonEncode(preferences);
}

String updateLocalOnlyConfigPreference({
  required String currentPreferences,
  required String key,
  required Object value,
}) {
  final preferences = decodeConfigPreferences(currentPreferences);
  final localOnly = _stringMap(preferences[_localOnlyPreferencesKey]);
  final pending = _stringMap(preferences[_pendingPreferenceSyncKey]);
  localOnly[key] = value;
  pending.remove(key);
  preferences[_localOnlyPreferencesKey] = localOnly;
  preferences[_pendingPreferenceSyncKey] = pending;
  return jsonEncode(preferences);
}

int pendingConfigPreferenceCount(String preferencesJson) => _stringMap(
  decodeConfigPreferences(preferencesJson)[_pendingPreferenceSyncKey],
).length;

Map<String, dynamic> _stringMap(Object? value) {
  if (value is! Map) return <String, dynamic>{};
  return {
    for (final entry in value.entries)
      if (entry.key is String) entry.key as String: entry.value,
  };
}

Future<void> saveLocalConfigPreference(
  Ref ref, {
  required String key,
  required Object value,
}) async {
  final user = await ref.read(userProvider.future);
  final dao = ConfigDao(ref.read(appDatabaseProvider));
  final config = await dao.getConfigByUser(userId: user.id);
  if (config == null) {
    throw StateError('Configuração local do usuário não encontrada.');
  }
  await dao.updateConfig(
    id: config.id,
    preferences: updateLocalOnlyConfigPreference(
      currentPreferences: config.preferences,
      key: key,
      value: value,
    ),
  );
}

Future<bool> isPreferenceDeviceOnly(Ref ref, String key) async {
  final user = await ref.read(userProvider.future);
  final config = await ConfigDao(
    ref.read(appDatabaseProvider),
  ).getConfigByUser(userId: user.id);
  if (config == null) return false;
  final overrides = decodeConfigPreferences(
    config.preferences,
  )[_localOverridesKey];
  return overrides is Map && overrides.containsKey(key);
}

Future<void> setPreferenceDeviceOnly(
  Ref ref, {
  required String key,
  required Object effectiveValue,
  required bool deviceOnly,
}) async {
  final user = await ref.read(userProvider.future);
  final dao = ConfigDao(ref.read(appDatabaseProvider));
  final config = await dao.getConfigByUser(userId: user.id);
  if (config == null) {
    throw StateError('Configuração local do usuário não encontrada.');
  }

  await dao.updateConfig(
    id: config.id,
    preferences: updateConfigPreferenceLocally(
      currentPreferences: config.preferences,
      key: key,
      value: effectiveValue,
      deviceOnly: deviceOnly,
    ),
  );
  if (!deviceOnly && config.autoSync) {
    ref.read(configPreferenceSyncRequestProvider.notifier).request();
  }
}

Future<void> saveConfigPreference(
  Ref ref, {
  required String key,
  required Object value,
}) async {
  final user = await ref.read(userProvider.future);
  final dao = ConfigDao(ref.read(appDatabaseProvider));
  final config = await dao.getConfigByUser(userId: user.id);
  if (config == null) {
    throw StateError('Configuração local do usuário não encontrada.');
  }
  final overrides = _stringMap(
    decodeConfigPreferences(config.preferences)[_localOverridesKey],
  );
  final deviceOnly = overrides.containsKey(key);
  await dao.updateConfig(
    id: config.id,
    preferences: updateConfigPreferenceLocally(
      currentPreferences: config.preferences,
      key: key,
      value: value,
      deviceOnly: deviceOnly,
    ),
  );
  if (!deviceOnly && config.autoSync) {
    ref.read(configPreferenceSyncRequestProvider.notifier).request();
  }
}

class PreferenceStorageService {
  const PreferenceStorageService(this._ref);

  final Ref _ref;

  Future<bool> isDeviceOnly(String key) => isPreferenceDeviceOnly(_ref, key);

  Future<void> setDeviceOnly({
    required String key,
    required Object effectiveValue,
    required bool deviceOnly,
  }) => setPreferenceDeviceOnly(
    _ref,
    key: key,
    effectiveValue: effectiveValue,
    deviceOnly: deviceOnly,
  );

  Future<void> save({required String key, required Object value}) =>
      saveConfigPreference(_ref, key: key, value: value);

  Future<void> saveLocally({required String key, required Object value}) =>
      saveLocalConfigPreference(_ref, key: key, value: value);
}

final preferenceStorageServiceProvider = Provider<PreferenceStorageService>(
  PreferenceStorageService.new,
);

final preferenceDeviceOnlyProvider = FutureProvider.family<bool, String>((
  ref,
  key,
) {
  return isPreferenceDeviceOnly(ref, key);
});

class AutomaticConfigSyncNotifier extends AsyncNotifier<bool> {
  @override
  Future<bool> build() async {
    final user = await ref.watch(userProvider.future);
    final config = await ConfigDao(
      ref.watch(appDatabaseProvider),
    ).getConfigByUser(userId: user.id);
    return config?.autoSync ?? true;
  }

  Future<void> setEnabled(bool enabled) async {
    final user = await ref.read(userProvider.future);
    final dao = ConfigDao(ref.read(appDatabaseProvider));
    final config = await dao.getConfigByUser(userId: user.id);
    if (config == null) {
      throw StateError('Configuração local do usuário não encontrada.');
    }
    await dao.updateConfig(id: config.id, autoSync: enabled);
    state = AsyncData(enabled);
    if (enabled) {
      ref.read(configPreferenceSyncRequestProvider.notifier).request();
    }
  }
}

final automaticConfigSyncProvider =
    AsyncNotifierProvider<AutomaticConfigSyncNotifier, bool>(
      AutomaticConfigSyncNotifier.new,
    );

final pendingConfigPreferenceCountProvider = StreamProvider.autoDispose<int>((
  ref,
) async* {
  final user = await ref.watch(userProvider.future);
  final db = ref.watch(appDatabaseProvider);
  final query = db.select(db.config)
    ..where((config) => config.userId.equals(user.id));
  await for (final config in query.watchSingleOrNull()) {
    yield config == null ? 0 : pendingConfigPreferenceCount(config.preferences);
  }
});

class ConfigPreferenceSyncRequestNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void request() => state++;
}

final configPreferenceSyncRequestProvider =
    NotifierProvider<ConfigPreferenceSyncRequestNotifier, int>(
      ConfigPreferenceSyncRequestNotifier.new,
    );

class ConfigPreferenceSyncService {
  ConfigPreferenceSyncService(this._ref);

  final Ref _ref;
  Future<void>? _activeSync;

  Future<void> syncPending({bool force = false}) {
    final active = _activeSync;
    if (active != null) return active;
    final operation = _syncPending(force: force);
    _activeSync = operation;
    return operation.whenComplete(() {
      if (identical(_activeSync, operation)) _activeSync = null;
    });
  }

  Future<void> _syncPending({required bool force}) async {
    final user = await _ref.read(userProvider.future);
    final dao = ConfigDao(_ref.read(appDatabaseProvider));
    final config = await dao.getConfigByUser(userId: user.id);
    if (config == null) {
      throw StateError('Configuração local do usuário não encontrada.');
    }
    if (!force && !config.autoSync) return;

    final pending = _stringMap(
      decodeConfigPreferences(config.preferences)[_pendingPreferenceSyncKey],
    );
    if (pending.isEmpty) return;

    final successful = <String, Object?>{};
    Map<String, dynamic>? remotePreferences;
    Object? firstError;
    StackTrace? firstStackTrace;

    final accountPreferences = Map<String, dynamic>.from(pending)
      ..remove(responseLanguagePreferenceOrderKey);
    if (accountPreferences.isNotEmpty) {
      try {
        final api = _ref.read(apiClientProvider).getUserGlobalConfigApi();
        final response = await api
            .getUserGlobalConfigApiV1UserConfigUserGlobalConfigGetIdentificatorGet(
              identificator: user.remoteId,
            );
        final remoteConfig = response.data;
        if (remoteConfig == null) {
          throw StateError('A configuração da conta não foi encontrada.');
        }
        remotePreferences = {
          for (final entry in remoteConfig.preferences.entries)
            entry.key: entry.value?.value,
          ...accountPreferences,
        };
        await api
            .updateUserGlobalConfigApiV1UserConfigUserGlobalConfigUpdateIdentificatorPut(
              identificator: user.remoteId,
              userGlobalConfigUpdate: UserGlobalConfigUpdate((builder) {
                builder.preferences = jsonEncode(remotePreferences);
              }),
            );
        successful.addAll(accountPreferences);
      } catch (error, stackTrace) {
        firstError ??= error;
        firstStackTrace ??= stackTrace;
      }
    }

    final responseLanguageOrder = pending[responseLanguagePreferenceOrderKey];
    if (responseLanguageOrder is List) {
      try {
        await _syncResponseLanguageOrder(
          user.remoteId,
          responseLanguageOrder.whereType<String>().toList(growable: false),
        );
        successful[responseLanguagePreferenceOrderKey] = responseLanguageOrder;
      } catch (error, stackTrace) {
        firstError ??= error;
        firstStackTrace ??= stackTrace;
      }
    }

    if (successful.isNotEmpty) {
      await _acknowledgeSync(
        dao: dao,
        userId: user.id,
        successful: successful,
        remotePreferences: remotePreferences,
      );
    }
    if (firstError != null) {
      Error.throwWithStackTrace(firstError, firstStackTrace!);
    }
  }

  Future<void> _syncResponseLanguageOrder(
    String remoteUserId,
    List<String> languageIds,
  ) async {
    final syncLanguageIds = await _resolveLanguageIds(languageIds);
    final api = _ref
        .read(apiClientProvider)
        .getResponseResponseLanguagePreferenceOrderApi();
    final response = await api
        .listResponseLanguagePreferenceOrdersApiV1UserConfigResponseResponseLanguagePreferenceOrderListGet();
    final existing =
        response.data?.where((item) => item.idUser == remoteUserId).toList() ??
        <ResponseLanguagePreferenceOrderOut>[];
    final byLanguage = {for (final item in existing) item.idLanguage: item};

    for (final item in existing) {
      if (!syncLanguageIds.contains(item.idLanguage)) {
        await api
            .updateResponseLanguagePreferenceOrderApiV1UserConfigResponseResponseLanguagePreferenceOrderDeleteIdentificatorDelete(
              identificator: item.id,
            );
      }
    }
    for (var index = 0; index < syncLanguageIds.length; index++) {
      final languageId = syncLanguageIds[index];
      final existingItem = byLanguage[languageId];
      if (existingItem == null) {
        await api
            .createResponseLanguagePreferenceOrderApiV1UserConfigResponseResponseLanguagePreferenceOrderCreatePost(
              responseLanguagePreferenceOrderCreate:
                  ResponseLanguagePreferenceOrderCreate((builder) {
                    builder
                      ..preferenceOrder = index + 1
                      ..idUser = remoteUserId
                      ..idLanguage = languageId;
                  }),
            );
      } else {
        await api
            .updateResponseLanguagePreferenceOrderApiV1UserConfigResponseResponseLanguagePreferenceOrderUpdateIdentificatorPut(
              identificator: existingItem.id,
              responseLanguagePreferenceOrderUpdate:
                  ResponseLanguagePreferenceOrderUpdate(
                    (builder) => builder.preferenceOrder = index + 1,
                  ),
            );
      }
    }
  }

  Future<List<String>> _resolveLanguageIds(List<String> languageIds) async {
    final needsFallbackMapping = languageIds.any(
      (id) =>
          id == fallbackPortugueseLanguageId || id == fallbackEnglishLanguageId,
    );
    if (!needsFallbackMapping) return languageIds;

    final response = await _ref
        .read(apiClientProvider)
        .getLanguageApi()
        .listLanguagesApiV1UserConfigLanguageListGet();
    final languages = response.data?.toList() ?? <LanguageOut>[];
    return [
      for (final id in languageIds)
        if (id == fallbackPortugueseLanguageId)
          _findLanguageId(languages, 'pt')
        else if (id == fallbackEnglishLanguageId)
          _findLanguageId(languages, 'en')
        else
          id,
    ];
  }

  String _findLanguageId(List<LanguageOut> languages, String code) {
    final match = languages.where((language) {
      final normalized = language.name.toLowerCase();
      return code == 'pt'
          ? normalized.contains('portugu') || normalized.startsWith('pt')
          : normalized.contains('english') ||
                normalized.contains('inglês') ||
                normalized.startsWith('en');
    }).firstOrNull;
    if (match == null) {
      throw StateError(
        'O idioma escolhido não está disponível na configuração da conta.',
      );
    }
    return match.id;
  }

  Future<void> _acknowledgeSync({
    required ConfigDao dao,
    required String userId,
    required Map<String, Object?> successful,
    required Map<String, dynamic>? remotePreferences,
  }) async {
    final config = await dao.getConfigByUser(userId: userId);
    if (config == null) {
      throw StateError('Configuração local do usuário não encontrada.');
    }
    final local = decodeConfigPreferences(config.preferences);
    final pending = _stringMap(local[_pendingPreferenceSyncKey]);
    final base = remotePreferences == null
        ? Map<String, dynamic>.from(local)
        : Map<String, dynamic>.from(remotePreferences);

    for (final entry in successful.entries) {
      if (_sameJsonValue(pending[entry.key], entry.value)) {
        pending.remove(entry.key);
      }
      base[entry.key] = entry.value;
    }

    for (final key in const [
      _localConfigIdKey,
      _localOverridesKey,
      _localOnlyPreferencesKey,
    ]) {
      if (local.containsKey(key)) base[key] = local[key];
    }
    base[_pendingPreferenceSyncKey] = pending;
    base.addAll(pending);
    await dao.updateConfig(id: config.id, preferences: jsonEncode(base));
  }

  bool _sameJsonValue(Object? left, Object? right) =>
      jsonEncode(left) == jsonEncode(right);
}

final configPreferenceSyncServiceProvider =
    Provider<ConfigPreferenceSyncService>(ConfigPreferenceSyncService.new);

final configPreferenceSyncLifecycleProvider = Provider<void>((ref) {
  void syncIfConnected() {
    if (ref.read(serverConnectionChecker).value != true) return;
    unawaited(
      ref.read(configPreferenceSyncServiceProvider).syncPending().catchError((
        Object error,
        StackTrace stackTrace,
      ) {
        debugPrint('Falha ao sincronizar preferências: $error');
        debugPrintStack(stackTrace: stackTrace);
      }),
    );
  }

  ref.listen(configPreferenceSyncRequestProvider, (_, _) {
    syncIfConnected();
  });
  ref.listen(serverConnectionChecker, (_, next) {
    if (next.value == true) syncIfConnected();
  });
  final retryTimer = Timer.periodic(
    const Duration(minutes: 2),
    (_) => syncIfConnected(),
  );
  ref.onDispose(retryTimer.cancel);
  syncIfConnected();
});
