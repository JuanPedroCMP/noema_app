import 'package:drift/drift.dart';
import 'package:noema/core/database/database.dart';
import 'package:uuid/uuid.dart';

part 'multiple_choice_dao.g.dart';

@DriftAccessor(tables: [MultipleChoice])
class MultipleChoiceDao extends DatabaseAccessor<AppDatabase> with _$MultipleChoiceDaoMixin {
  MultipleChoiceDao(super.db);

  Future<int> insertMultipleChoice({
    required String nodeId,
    required String title,
    required String statement,
    bool? aiGenerated,
  }) {
    return into(attachedDatabase.multipleChoice).insert(
      MultipleChoiceCompanion.insert(
        id: Uuid().v4(),
        nodeId: nodeId,
        title: title,
        statement: statement,
        aiGenerated: Value(aiGenerated),
      ),
    );
  }

  Future<int> updateMultipleChoice({
    required String id,
    String? nodeId,
    String? title,
    String? statement,
    bool? aiGenerated,
  }) {
    return (update(
      attachedDatabase.multipleChoice,
    )..where((tbl) => tbl.id.equals(id))).write(
      MultipleChoiceCompanion(
        nodeId: nodeId == null ? const Value.absent() : Value(nodeId),
        title: title == null ? const Value.absent() : Value(title),
        statement: statement == null ? const Value.absent() : Value(statement),
        aiGenerated: aiGenerated == null ? const Value.absent() : Value(aiGenerated),
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
          ..where((tbl) => tbl.softDeleted.equals(false)))
        .get();
  }

  Future<int> deleteMultipleChoice({required String id}) {
    return (update(
      attachedDatabase.multipleChoice,
    )..where((tbl) => tbl.id.equals(id))).write(
      MultipleChoiceCompanion(
        softDeleted: const Value(true),
        softDeletedAt: Value(DateTime.now().millisecondsSinceEpoch),
      ),
    );
  }
}
