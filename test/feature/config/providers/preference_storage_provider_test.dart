import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:noema/feature/config/providers/preference_storage_provider.dart';

void main() {
  group('readConfigPreference', () {
    test('prefers a device override over the global value', () {
      const raw =
          '{"locale":"en","__localPreferenceOverrides":{"locale":"pt"}}';

      expect(readConfigPreference(raw, 'locale'), 'pt');
    });

    test('falls back to the global value when there is no device override', () {
      expect(
        readConfigPreference(
          '{"locale":"en","__localPreferenceOverrides":{"studyAssistantPinPanel":true}}',
          'locale',
        ),
        'en',
      );
    });

    test('reads global preferences without an override map', () {
      expect(readConfigPreference('{"locale":"pt"}', 'locale'), 'pt');
    });
  });

  group('mergeRemoteConfigPreferences', () {
    test(
      'refreshes global values and preserves device overrides and metadata',
      () {
        final merged =
            jsonDecode(
                  mergeRemoteConfigPreferences(
                    remotePreferences: const {
                      'locale': 'en',
                      'responseStyle': 'concise',
                    },
                    localPreferences:
                        '{"__userLocalConfigId":"local-1",'
                        '"__localPreferenceOverrides":{"locale":"pt"},'
                        '"studyAssistantPinPanel":true}',
                  ),
                )
                as Map<String, dynamic>;

        expect(merged['locale'], 'en');
        expect(merged['responseStyle'], 'concise');
        expect(merged['__userLocalConfigId'], 'local-1');
        expect(merged['__localPreferenceOverrides'], {'locale': 'pt'});
        expect(merged.containsKey('studyAssistantPinPanel'), isFalse);
      },
    );
  });
}
