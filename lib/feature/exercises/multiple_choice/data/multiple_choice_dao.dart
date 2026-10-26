import 'package:drift/drift.dart';
import 'package:noema/core/database/database.dart';
import 'package:uuid/uuid.dart';

part 'multiple_choice_dao.g.dart';

@DriftAccessor(tables: [MultipleChoice])
class MultipleChoiceDao extends DatabaseAccessor<AppDatabase> with _$MultipleChoiceDaoMixin {
  MultipleChoiceDao(super.db);

  Future<String> insertMultipleChoice({
    required String nodeId,
    required String title,
    required String statement,
    bool? isAiGenerated,
  }) async {
    final id = Uuid().v4();
    await into(attachedDatabase.multipleChoice).insert(
      MultipleChoiceCompanion.insert(
        id: id,
        nodeId: nodeId,
        title: title,
        statement: statement,
        isAiGenerated: Value(isAiGenerated ?? false),
      ),
    );
    return id;
  }

  Future<int> updateMultipleChoice({
    required String id,
    String? nodeId,
    String? title,
    String? statement,
    bool? isAiGenerated,
  }) {
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    return (update(
      attachedDatabase.multipleChoice,
    )..where((tbl) => tbl.id.equals(id))).write(
      MultipleChoiceCompanion(
        nodeId: nodeId == null ? const Value.absent() : Value(nodeId),
        title: title == null ? const Value.absent() : Value(title),
        statement: statement == null ? const Value.absent() : Value(statement),
        isAiGenerated: isAiGenerated == null ? const Value.absent() : Value(isAiGenerated),
        updatedAt: Value(now),
      ),
    );
  }

  Future<MultipleChoiceData?> getMultipleChoice({required String id}) {
    return (select(attachedDatabase.multipleChoice)..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();
  }

  Future<List<MultipleChoiceData>> getMultipleChoicesByNode({required String nodeId}) {
    return (select(attachedDatabase.multipleChoice)
          ..where((tbl) => tbl.nodeId.equals(nodeId))
          ..where((tbl) => tbl.softDeleted.equals(false))
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.title)]))
        .get();
  }

  Future<int> deleteMultipleChoice({required String id}) {
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    return (update(
      attachedDatabase.multipleChoice,
    )..where((tbl) => tbl.id.equals(id))).write(
      MultipleChoiceCompanion(
        softDeleted: const Value(true),
        softDeletedAt: Value(now),
        updatedAt: Value(now),
      ),
    );
  }
}
