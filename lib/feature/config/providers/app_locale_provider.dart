import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noema/core/database/database_provider.dart';
import 'package:noema/feature/config/data/config_dao.dart';
import 'package:noema/feature/config/providers/preference_storage_provider.dart';
import 'package:noema/feature/config/providers/user_provider.dart';
import 'package:noema/core/network/api_client.dart';

class AppLocaleNotifier extends AsyncNotifier<Locale?> {
  @override
  Future<Locale?> build() async {
    final user = await ref.watch(userProvider.future);
    final config = await ConfigDao(
      ref.watch(appDatabaseProvider),
    ).getConfigByUser(userId: user.id);
    if (config == null) return null;
    final languageCode = readConfigPreference(
      config.preferences,
      'locale',
    );
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
    String? languageId;
    if (languageCode != null) {
      final languages = await ref
          .read(apiClientProvider)
          .getLanguageApi()
          .listLanguagesApiV1UserConfigLanguageListGet();
      final matchingLanguage = languages.data
          ?.where((language) {
            final normalized = language.name.toLowerCase();
            return languageCode == 'pt'
                ? normalized.contains('portugu') || normalized.startsWith('pt')
                : normalized.contains('english') ||
                      normalized.contains('inglês') ||
                      normalized.startsWith('en');
          })
          .firstOrNull;
      if (matchingLanguage == null) {
        throw StateError(
          'O idioma escolhido não está disponível na configuração da conta.',
        );
      }
      languageId = matchingLanguage.id;
    }

    await saveConfigPreference(
      ref,
      key: 'locale',
      value: languageCode ?? 'system',
      languageId: languageId,
    );
    state = AsyncData(locale);
  }
}

final appLocaleProvider =
    AsyncNotifierProvider<AppLocaleNotifier, Locale?>(AppLocaleNotifier.new);
