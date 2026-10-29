import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noema/core/database/database.dart';
import 'package:noema/feature/config/data/config_dao.dart';

void main() {
  late AppDatabase database;
  late String configId;

  setUp(() async {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    await database
        .into(database.appUser)
        .insert(
          AppUserCompanion.insert(
            id: 'user-id',
            remoteId: 'remote-user-id',
            userName: 'student',
            displayName: 'Student',
            primaryEmail: 'student@example.com',
            lastSeenAt: 0,
          ),
        );
    await database
        .into(database.colorTheme)
        .insert(
          ColorThemeCompanion.insert(
            id: 'color-theme-id',
            userId: 'user-id',
            name: 'Default',
            seedColor: 0xFF0000FF,
          ),
        );
    await database
        .into(database.typographyTheme)
        .insert(
          TypographyThemeCompanion.insert(
            id: 'typography-theme-id',
            userId: 'user-id',
            name: 'Default',
            fontScale: 1,
          ),
        );
    final dao = ConfigDao(database);
    await dao.insertConfig(
      userId: 'user-id',
      colorThemeId: 'color-theme-id',
      typographyThemeId: 'typography-theme-id',
      preferences: '{}',
      deviceFingerprint: 'test-device',
    );
    configId = (await dao.getConfigByUser(userId: 'user-id'))!.id;
  });

  tearDown(() async {
    await database.close();
  });

  test('persists the per-user background request concurrency limit', () async {
    final dao = ConfigDao(database);
    final initial = await dao.getConfigByUser(userId: 'user-id');
    expect(initial!.aiMaxConcurrentRequests, 1);

    await dao.updateConfig(id: configId, aiMaxConcurrentRequests: 3);

    final updated = await dao.getConfigByUser(userId: 'user-id');
    expect(updated!.aiMaxConcurrentRequests, 3);
  });
}
