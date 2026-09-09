import 'package:drift/drift.dart';
import 'package:noema/core/database/database.dart';
import 'package:uuid/uuid.dart';

part 'typography_theme_dao.g.dart';

@DriftAccessor(tables: [TypographyTheme])
class TypographyThemeDao extends DatabaseAccessor<AppDatabase> with _$TypographyThemeDaoMixin {
  TypographyThemeDao(super.db);

  Future<int> insertTypographyTheme({
    required String userId,
    required String name,
    String? displayFont,
    String? bodyFont,
    String? monoFont,
    required int fontScale,
    String? overridesJson,
    bool? systemDefault,
  }) {
    return into(attachedDatabase.typographyTheme).insert(
      TypographyThemeCompanion.insert(
        id: Uuid().v4(),
        userId: userId,
        name: name,
        displayFont: Value(displayFont),
        bodyFont: Value(bodyFont),
        monoFont: Value(monoFont),
        fontScale: fontScale,
        overridesJson: Value(overridesJson),
        systemDefault: systemDefault == null ? const Value.absent() : Value(systemDefault),
      ),
    );
  }

  Future<int> updateTypographyTheme({
    required String id,
    String? userId,
    String? name,
    String? displayFont,
    String? bodyFont,
    String? monoFont,
    int? fontScale,
    String? overridesJson,
    bool? systemDefault,
  }) {
    return (update(
      attachedDatabase.typographyTheme,
    )..where((tbl) => tbl.id.equals(id))).write(
      TypographyThemeCompanion(
        userId: userId == null ? const Value.absent() : Value(userId),
        name: name == null ? const Value.absent() : Value(name),
        displayFont: displayFont == null ? const Value.absent() : Value(displayFont),
        bodyFont: bodyFont == null ? const Value.absent() : Value(bodyFont),
        monoFont: monoFont == null ? const Value.absent() : Value(monoFont),
        fontScale: fontScale == null ? const Value.absent() : Value(fontScale),
        overridesJson: overridesJson == null ? const Value.absent() : Value(overridesJson),
        systemDefault: systemDefault == null ? const Value.absent() : Value(systemDefault),
      ),
    );
  }

  Future<TypographyThemeData?> getTypographyTheme({required String id}) {
    return (select(attachedDatabase.typographyTheme)..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();
  }

  Future<List<TypographyThemeData>> getTypographyThemesByUser({required String userId}) {
    return (select(attachedDatabase.typographyTheme)
          ..where((tbl) => tbl.userId.equals(userId)))
        .get();
  }

  Future<int> deleteTypographyTheme({required String id}) {
    return (delete(attachedDatabase.typographyTheme)
          ..where((tbl) => tbl.id.equals(id)))
        .go();
  }
}
