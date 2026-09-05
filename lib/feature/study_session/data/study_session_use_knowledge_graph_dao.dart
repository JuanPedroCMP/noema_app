import 'package:drift/drift.dart';
import 'package:noema/core/database/database.dart';
import 'package:uuid/uuid.dart';

part 'study_session_use_knowledge_graph_dao.g.dart';

@DriftAccessor(tables: [StudySessionUseKnowledgeGraph])
class StudySessionUseKnowledgeGraphDao extends DatabaseAccessor<AppDatabase> with _$StudySessionUseKnowledgeGraphDaoMixin {
  StudySessionUseKnowledgeGraphDao(super.db);

  Future<int> insertStudySessionUseKnowledgeGraph({
    required String graphId,
    required String studySessionId,
  }) {
    return into(attachedDatabase.studySessionUseKnowledgeGraph).insert(
      StudySessionUseKnowledgeGraphCompanion.insert(
        id: Uuid().v4(),
        graphId: graphId,
        studySessionId: studySessionId,
      ),
    );
  }

  Future<int> updateStudySessionUseKnowledgeGraph({
    required String id,
    String? graphId,
    String? studySessionId,
  }) {
    return (update(
      attachedDatabase.studySessionUseKnowledgeGraph,
    )..where((tbl) => tbl.id.equals(id))).write(
      StudySessionUseKnowledgeGraphCompanion(
        graphId: graphId == null ? const Value.absent() : Value(graphId),
        studySessionId: studySessionId == null ? const Value.absent() : Value(studySessionId),
      ),
    );
  }

  Future<StudySessionUseKnowledgeGraphData?> getStudySessionUseKnowledgeGraph({required String id}) {
    return (select(attachedDatabase.studySessionUseKnowledgeGraph)..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();
  }

  Future<List<StudySessionUseKnowledgeGraphData>> getStudySessionUseKnowledgeGraphsBySession({required String studySessionId}) {
    return (select(attachedDatabase.studySessionUseKnowledgeGraph)
          ..where((tbl) => tbl.studySessionId.equals(studySessionId)))
        .get();
  }

  Future<int> deleteStudySessionUseKnowledgeGraph({required String id}) {
    return (delete(attachedDatabase.studySessionUseKnowledgeGraph)
          ..where((tbl) => tbl.id.equals(id)))
        .go();
  }
}
