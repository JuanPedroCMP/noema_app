import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noema/l10n/app_localizations.dart';

void main() {
  test('supports every requested application locale', () {
    final languageCodes = AppLocalizations.supportedLocales
        .map((locale) => locale.languageCode)
        .toSet();

    expect(languageCodes, {'en', 'ja', 'ko', 'pt', 'es', 'fr', 'de'});
  });

  test('bundles translations for language and typography settings', () {
    for (final locale in AppLocalizations.supportedLocales) {
      final strings = lookupAppLocalizations(locale);

      expect(strings.appLanguage, isNotEmpty);
      expect(strings.deviceLanguage, isNotEmpty);
      expect(strings.typographyThemes, isNotEmpty);
      expect(strings.scale, isNotEmpty);
      expect(strings.nativeTranslation, isNotEmpty);
      expect(strings.automaticTranslation, isNotEmpty);
      expect(strings.preferences, isNotEmpty);
      expect(strings.synchronizeAutomatically, isNotEmpty);
      expect(strings.preferredResponseLanguages, isNotEmpty);
      expect(strings.searchGoogleFonts, isNotEmpty);
    }
  });

  test('native locale catalogs do not fall back to English', () {
    for (final locale in const [
      Locale('ja'),
      Locale('ko'),
      Locale('es'),
      Locale('fr'),
      Locale('de'),
    ]) {
      final strings = lookupAppLocalizations(locale);
      expect(
        strings.appLanguage,
        isNot(equals(lookupAppLocalizations(const Locale('en')).appLanguage)),
      );
      expect(
        strings.typographyThemes,
        isNot(
          equals(lookupAppLocalizations(const Locale('en')).typographyThemes),
        ),
      );
    }
  });
}
