import 'package:drift/drift.dart';
import 'package:noema/core/database/database.dart';
import 'package:uuid/uuid.dart';

part 'session_node_dao.g.dart';

@DriftAccessor(tables: [SessionNode])
class SessionNodeDao extends DatabaseAccessor<AppDatabase> with _$SessionNodeDaoMixin {
  SessionNodeDao(super.db);

  Future<int> insertSessionNode({
    required String studySessionId,
    required String nodeId,
    required int displayOrder,
  }) {
    return into(attachedDatabase.sessionNode).insert(
      SessionNodeCompanion.insert(
        id: Uuid().v4(),
        studySessionId: studySessionId,
        nodeId: nodeId,
        displayOrder: displayOrder,
      ),
    );
  }

  Future<int> updateSessionNode({
    required String id,
    String? studySessionId,
    String? nodeId,
    int? displayOrder,
  }) {
    return (update(
      attachedDatabase.sessionNode,
    )..where((tbl) => tbl.id.equals(id))).write(
      SessionNodeCompanion(
        studySessionId: studySessionId == null ? const Value.absent() : Value(studySessionId),
        nodeId: nodeId == null ? const Value.absent() : Value(nodeId),
        displayOrder: displayOrder == null ? const Value.absent() : Value(displayOrder),
      ),
    );
  }

  Future<SessionNodeData?> getSessionNode({required String id}) {
    return (select(attachedDatabase.sessionNode)..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();
  }

  Future<List<SessionNodeData>> getSessionNodesBySession({required String studySessionId}) {
    return (select(attachedDatabase.sessionNode)
          ..where((tbl) => tbl.studySessionId.equals(studySessionId))
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.displayOrder)]))
        .get();
  }

  Future<int> deleteSessionNode({required String id}) {
    return (delete(attachedDatabase.sessionNode)
          ..where((tbl) => tbl.id.equals(id)))
        .go();
  }
}
