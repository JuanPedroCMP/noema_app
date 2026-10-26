import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noema/core/database/database_provider.dart';
import 'package:noema/feature/config/data/config_dao.dart';
import 'package:noema/feature/config/providers/user_provider.dart';

class AppLocaleNotifier extends AsyncNotifier<Locale?> {
  @override
  Future<Locale?> build() async {
    final user = await ref.watch(userProvider.future);
    final db = ref.watch(appDatabaseProvider);
    final config = await ConfigDao(db).getConfigByUser(userId: user.id);
    if (config == null) return null;
    final preferences = _decode(config.preferences);
    final languageCode = preferences['locale'];
    if (languageCode is! String ||
        !const {'en', 'pt'}.contains(languageCode)) {
      return null;
    }
    return Locale(languageCode);
  }

  Future<void> setLocale(Locale? locale) async {
    final languageCode = locale?.languageCode;
    if (languageCode != null && !const {'en', 'pt'}.contains(languageCode)) {
      throw ArgumentError.value(languageCode, 'locale', 'is not supported');
    }
    final user = await ref.read(userProvider.future);
    final db = ref.read(appDatabaseProvider);
    final dao = ConfigDao(db);
    final config = await dao.getConfigByUser(userId: user.id);
    if (config == null) {
      throw StateError('Configuração local do usuário não encontrada.');
    }
    final preferences = _decode(config.preferences);
    if (languageCode == null) {
      preferences.remove('locale');
    } else {
      preferences['locale'] = languageCode;
    }
    await dao.updateConfig(
      id: config.id,
      preferences: jsonEncode(preferences),
    );
    state = AsyncData(locale);
  }

  Map<String, dynamic> _decode(String json) {
    final decoded = jsonDecode(json);
    if (decoded is Map<String, dynamic>) return decoded;
    throw const FormatException(
      'As preferências locais não estão em um formato válido.',
    );
  }
}

final appLocaleProvider =
    AsyncNotifierProvider<AppLocaleNotifier, Locale?>(AppLocaleNotifier.new);
