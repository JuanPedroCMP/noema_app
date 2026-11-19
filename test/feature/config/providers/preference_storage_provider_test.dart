import 'dart:convert';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noema/core/database/database.dart';
import 'package:noema/core/database/database_provider.dart';
import 'package:noema/core/design/theme/color_theme_dao.dart';
import 'package:noema/core/design/theme/typography_theme_dao.dart';
import 'package:noema/feature/config/data/config_dao.dart';
import 'package:noema/feature/config/providers/preference_storage_provider.dart';
import 'package:noema/feature/config/providers/user_provider.dart';

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

    test('prefers a local-only preference over the global value', () {
      expect(
        readConfigPreference(
          '{"superDashboardSections":["evolution"],'
              '"__localOnlyPreferences":{"superDashboardSections":["ai"]}}',
          'superDashboardSections',
        ),
        ['ai'],
      );
    });
  });

  group('mergeRemoteConfigPreferences', () {
    test('refreshes global values and preserves local settings and metadata', () {
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
                      '"__localOnlyPreferences":{"superDashboardSections":["ai"]},'
                      '"studyAssistantPinPanel":true}',
                ),
              )
              as Map<String, dynamic>;

      expect(merged['locale'], 'en');
      expect(merged['responseStyle'], 'concise');
      expect(merged['__userLocalConfigId'], 'local-1');
      expect(merged['__localPreferenceOverrides'], {'locale': 'pt'});
      expect(merged['__localOnlyPreferences'], {
        'superDashboardSections': ['ai'],
      });
      expect(merged.containsKey('studyAssistantPinPanel'), isFalse);
    });

    test('keeps unsynced local edits newer than a server refresh', () {
      final merged =
          jsonDecode(
                mergeRemoteConfigPreferences(
                  remotePreferences: const {'locale': 'en'},
                  localPreferences:
                      '{"locale":"pt","__pendingPreferenceSync":{"locale":"pt"}}',
                ),
              )
              as Map<String, dynamic>;

      expect(merged['locale'], 'pt');
      expect(merged['__pendingPreferenceSync'], {'locale': 'pt'});
    });
  });

  group('local preference updates', () {
    test('queues account changes locally without requiring the API', () {
      final updated = updateConfigPreferenceLocally(
        currentPreferences: '{"locale":"en"}',
        key: 'locale',
        value: 'pt',
        deviceOnly: false,
      );

      expect(readConfigPreference(updated, 'locale'), 'pt');
      expect(pendingConfigPreferenceCount(updated), 1);
    });

    test('keeps device-only changes out of the cloud queue', () {
      final updated = updateConfigPreferenceLocally(
        currentPreferences: '{"locale":"en"}',
        key: 'locale',
        value: 'pt',
        deviceOnly: true,
      );

      expect(readConfigPreference(updated, 'locale'), 'pt');
      expect(pendingConfigPreferenceCount(updated), 0);
    });

    test('switches a local override to an account-scoped queued value', () {
      final updated = updateConfigPreferenceLocally(
        currentPreferences:
            '{"locale":"en","__localPreferenceOverrides":{"locale":"pt"}}',
        key: 'locale',
        value: 'pt',
        deviceOnly: false,
      );
      final decoded = jsonDecode(updated) as Map<String, dynamic>;

      expect(readConfigPreference(updated, 'locale'), 'pt');
      expect(decoded['__localPreferenceOverrides'], isEmpty);
      expect(pendingConfigPreferenceCount(updated), 1);
    });

    test('stores explicitly local settings without queueing cloud work', () {
      final updated = updateLocalOnlyConfigPreference(
        currentPreferences: '{}',
        key: 'superDashboardSections',
        value: ['ai'],
      );

      expect(readConfigPreference(updated, 'superDashboardSections'), ['ai']);
      expect(pendingConfigPreferenceCount(updated), 0);
    });
  });

  group('PreferenceStorageService', () {
    late AppDatabase database;
    late ProviderContainer container;
    late AppUserData user;

    setUp(() async {
      database = AppDatabase.forTesting(NativeDatabase.memory());
      await database
          .into(database.appUser)
          .insert(
            AppUserCompanion.insert(
              id: 'local-user',
              remoteId: 'remote-user',
              userName: 'student',
              displayName: 'Student',
              primaryEmail: 'student@example.com',
              lastSeenAt: 0,
            ),
          );
      user = await (database.select(
        database.appUser,
      )..where((row) => row.id.equals('local-user'))).getSingle();
      final colorThemeId = await ColorThemeDao(database).insertColorTheme(
        userId: user.id,
        name: 'Default',
        seedColor: 0xff006b5f,
      );
      final typographyThemeId = await TypographyThemeDao(
        database,
      ).insertTypographyTheme(userId: user.id, name: 'Default', fontScale: 100);
      await ConfigDao(database).insertConfig(
        userId: user.id,
        colorThemeId: colorThemeId,
        typographyThemeId: typographyThemeId,
        preferences: '{}',
        autoSync: false,
        deviceFingerprint: 'test-device',
      );
      container = ProviderContainer(
        overrides: [
          appDatabaseProvider.overrideWithValue(database),
          userProvider.overrideWith(() => _TestUserNotifier(user)),
        ],
      );
    });

    tearDown(() {
      container.dispose();
      return database.close();
    });

    test('saves account preferences locally without calling the API', () async {
      await container
          .read(preferenceStorageServiceProvider)
          .save(key: 'locale', value: 'pt');

      final config = await ConfigDao(database).getConfigByUser(userId: user.id);
      expect(config, isNotNull);
      expect(readConfigPreference(config!.preferences, 'locale'), 'pt');
      expect(pendingConfigPreferenceCount(config.preferences), 1);
    });

    test(
      'saves device-only preferences locally without queueing sync',
      () async {
        await container
            .read(preferenceStorageServiceProvider)
            .setDeviceOnly(
              key: 'locale',
              effectiveValue: 'en',
              deviceOnly: true,
            );

        final config = await ConfigDao(
          database,
        ).getConfigByUser(userId: user.id);
        expect(readConfigPreference(config!.preferences, 'locale'), 'en');
        expect(pendingConfigPreferenceCount(config.preferences), 0);
      },
    );
  });
}

class _TestUserNotifier extends UserNotifier {
  _TestUserNotifier(this._user);

  final AppUserData _user;

  @override
  Future<AppUserData> build() async => _user;
}
