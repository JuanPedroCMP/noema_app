import 'package:drift/drift.dart';
import 'package:noema/core/database/database.dart';
import 'package:uuid/uuid.dart';

part 'open_ended_dao.g.dart';

@DriftAccessor(tables: [OpenEnded])
class OpenEndedDao extends DatabaseAccessor<AppDatabase> with _$OpenEndedDaoMixin {
  OpenEndedDao(super.db);

  Future<int> insertOpenEnded({
    required String nodeId,
    required String title,
    required String statement,
    required String type,
    String? referenceCorrectAnswer,
    bool? aiGenerated,
  }) {
    return into(attachedDatabase.openEnded).insert(
      OpenEndedCompanion.insert(
        id: Uuid().v4(),
        nodeId: nodeId,
        title: title,
        statement: statement,
        type: type,
        referenceCorrectAnswer: Value(referenceCorrectAnswer),
        aiGenerated: Value(aiGenerated),
        createdAt: Value(DateTime.now().millisecondsSinceEpoch),
      ),
    );
  }

  Future<int> updateOpenEnded({
    required String id,
    String? nodeId,
    String? title,
    String? statement,
    String? type,
    String? referenceCorrectAnswer,
    bool? aiGenerated,
  }) {
    return (update(
      attachedDatabase.openEnded,
    )..where((tbl) => tbl.id.equals(id))).write(
      OpenEndedCompanion(
        nodeId: nodeId == null ? const Value.absent() : Value(nodeId),
        title: title == null ? const Value.absent() : Value(title),
        statement: statement == null ? const Value.absent() : Value(statement),
        type: type == null ? const Value.absent() : Value(type),
        referenceCorrectAnswer: referenceCorrectAnswer == null ? const Value.absent() : Value(referenceCorrectAnswer),
        aiGenerated: aiGenerated == null ? const Value.absent() : Value(aiGenerated),
        updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
      ),
    );
  }

  Future<OpenEndedData?> getOpenEnded({required String id}) {
    return (select(attachedDatabase.openEnded)..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();
  }

  Future<List<OpenEndedData>> getOpenEndedsByNode({required String nodeId}) {
    return (select(attachedDatabase.openEnded)
          ..where((tbl) => tbl.nodeId.equals(nodeId))
          ..where((tbl) => tbl.softDeleted.equals(false)))
        .get();
  }

  Future<int> deleteOpenEnded({required String id}) {
    return (update(
      attachedDatabase.openEnded,
    )..where((tbl) => tbl.id.equals(id))).write(
      OpenEndedCompanion(
        softDeleted: const Value(true),
        softDeletedAt: Value(DateTime.now().millisecondsSinceEpoch),
      ),
    );
  }
}
