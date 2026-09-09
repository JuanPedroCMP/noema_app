import 'package:drift/drift.dart';
import 'package:noema/core/database/database.dart';
import 'package:uuid/uuid.dart';

part 'config_dao.g.dart';

@DriftAccessor(tables: [Config])
class ConfigDao extends DatabaseAccessor<AppDatabase> with _$ConfigDaoMixin {
  ConfigDao(super.db);

  Future<int> insertConfig({
    required String userId,
    required String colorThemeId,
    required String typographyThemeId,
    required String preferences,
    DateTime? lastSync,
    bool? autoSync,
    required String deviceFingerprint,
  }) {
    return into(attachedDatabase.config).insert(
      ConfigCompanion.insert(
        id: Uuid().v4(),
        userId: userId,
        colorThemeId: colorThemeId,
        typographyThemeId: typographyThemeId,
        preferences: preferences,
        lastSync: Value(lastSync?.millisecondsSinceEpoch),
        autoSync: autoSync == null ? const Value.absent() : Value(autoSync),
        deviceFingerprint: deviceFingerprint,
      ),
    );
  }

  Future<int> updateConfig({
    required String id,
    String? userId,
    String? colorThemeId,
    String? typographyThemeId,
    String? preferences,
    DateTime? lastSync,
    bool? autoSync,
    String? deviceFingerprint,
  }) {
    return (update(
      attachedDatabase.config,
    )..where((tbl) => tbl.id.equals(id))).write(
      ConfigCompanion(
        userId: userId == null ? const Value.absent() : Value(userId),
        colorThemeId: colorThemeId == null ? const Value.absent() : Value(colorThemeId),
        typographyThemeId: typographyThemeId == null ? const Value.absent() : Value(typographyThemeId),
        preferences: preferences == null ? const Value.absent() : Value(preferences),
        lastSync: lastSync == null ? const Value.absent() : Value(lastSync.millisecondsSinceEpoch),
        autoSync: autoSync == null ? const Value.absent() : Value(autoSync),
        deviceFingerprint: deviceFingerprint == null ? const Value.absent() : Value(deviceFingerprint),
      ),
    );
  }

  Future<ConfigData?> getConfig({required String id}) {
    return (select(attachedDatabase.config)..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();
  }

  Future<ConfigData?> getConfigByUser({required String userId}) {
    return (select(attachedDatabase.config)
          ..where((tbl) => tbl.userId.equals(userId)))
        .getSingleOrNull();
  }

  Future<int> deleteConfig({required String id}) {
    return (delete(attachedDatabase.config)
          ..where((tbl) => tbl.id.equals(id)))
        .go();
  }
}
