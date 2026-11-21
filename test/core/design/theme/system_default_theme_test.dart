import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noema/core/database/database.dart';
import 'package:noema/core/design/theme/color_theme_dao.dart';
import 'package:noema/core/design/theme/typography_theme_dao.dart';

void main() {
  late AppDatabase database;
  late String userId;

  setUp(() async {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    userId = 'user-id';
    await database
        .into(database.appUser)
        .insert(
          AppUserCompanion.insert(
            id: userId,
            remoteId: 'remote-user-id',
            userName: 'student',
            displayName: 'Student',
            primaryEmail: 'student@example.com',
            lastSeenAt: 0,
          ),
        );
  });

  tearDown(() async {
    await database.close();
  });

  test('system color theme cannot be edited or deleted', () async {
    final dao = ColorThemeDao(database);
    final themeId = await dao.insertColorTheme(
      userId: userId,
      name: 'Default',
      seedColor: 0xFF326D62,
      systemDefault: true,
    );

    expect(
      () => dao.updateColorTheme(id: themeId, seedColor: 0xFF000000),
      throwsA(isA<StateError>()),
    );
    expect(() => dao.deleteColorTheme(id: themeId), throwsA(isA<StateError>()));
  });

  test('system typography theme cannot be edited or deleted', () async {
    final dao = TypographyThemeDao(database);
    final themeId = await dao.insertTypographyTheme(
      userId: userId,
      name: 'Default',
      fontScale: 100,
      systemDefault: true,
    );

    expect(
      () => dao.updateTypographyTheme(id: themeId, fontScale: 125),
      throwsA(isA<StateError>()),
    );
    expect(
      () => dao.deleteTypographyTheme(id: themeId),
      throwsA(isA<StateError>()),
    );
  });
}
