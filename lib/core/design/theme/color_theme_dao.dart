import 'package:drift/drift.dart';
import 'package:noema/core/database/database.dart';
import 'package:uuid/uuid.dart';

part 'color_theme_dao.g.dart';

@DriftAccessor(tables: [ColorTheme])
class ColorThemeDao extends DatabaseAccessor<AppDatabase> with _$ColorThemeDaoMixin {
  ColorThemeDao(super.db);

  Future<int> insertColorTheme({
    required String userId,
    required String name,
    required int seedColor,
    String? overridesJson,
    bool? systemDefault,
  }) {
    return into(attachedDatabase.colorTheme).insert(
      ColorThemeCompanion.insert(
        id: Uuid().v4(),
        userId: userId,
        name: name,
        seedColor: seedColor,
        overridesJson: Value(overridesJson),
        systemDefault: systemDefault == null ? const Value.absent() : Value(systemDefault),
      ),
    );
  }

  Future<int> updateColorTheme({
    required String id,
    String? userId,
    String? name,
    int? seedColor,
    String? overridesJson,
    bool? systemDefault,
  }) {
    return (update(
      attachedDatabase.colorTheme,
    )..where((tbl) => tbl.id.equals(id))).write(
      ColorThemeCompanion(
        userId: userId == null ? const Value.absent() : Value(userId),
        name: name == null ? const Value.absent() : Value(name),
        seedColor: seedColor == null ? const Value.absent() : Value(seedColor),
        overridesJson: overridesJson == null ? const Value.absent() : Value(overridesJson),
        systemDefault: systemDefault == null ? const Value.absent() : Value(systemDefault),
      ),
    );
  }

  Future<ColorThemeData?> getColorTheme({required String id}) {
    return (select(attachedDatabase.colorTheme)..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();
  }

  Future<List<ColorThemeData>> getColorThemesByUser({required String userId}) {
    return (select(attachedDatabase.colorTheme)
          ..where((tbl) => tbl.userId.equals(userId)))
        .get();
  }

  Future<int> deleteColorTheme({required String id}) {
    return (delete(attachedDatabase.colorTheme)
          ..where((tbl) => tbl.id.equals(id)))
        .go();
  }
}
