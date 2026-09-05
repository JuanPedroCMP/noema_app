import 'package:drift/drift.dart';
import 'package:noema/core/database/database.dart';
import 'package:uuid/uuid.dart';

part 'study_session_has_open_ended_question_dao.g.dart';

@DriftAccessor(tables: [StudySessionHasOpenEndedQuestion])
class StudySessionHasOpenEndedQuestionDao extends DatabaseAccessor<AppDatabase>
    with _$StudySessionHasOpenEndedQuestionDaoMixin {
  StudySessionHasOpenEndedQuestionDao(super.db);

  Future<int> insertStudySessionHasOpenEndedQuestion({
    required String studySessionId,
    required String openEndedId,
  }) {
    return into(attachedDatabase.studySessionHasOpenEndedQuestion).insert(
      StudySessionHasOpenEndedQuestionCompanion.insert(
        id: Uuid().v4(),
        studySessionId: studySessionId,
        openEndedId: openEndedId,
      ),
    );
  }

  Future<int> updateStudySessionHasOpenEndedQuestion({
    required String id,
    String? studySessionId,
    String? openEndedId,
  }) {
    return (update(
      attachedDatabase.studySessionHasOpenEndedQuestion,
    )..where((tbl) => tbl.id.equals(id))).write(
      StudySessionHasOpenEndedQuestionCompanion(
        studySessionId: studySessionId == null ? const Value.absent() : Value(studySessionId),
        openEndedId: openEndedId == null ? const Value.absent() : Value(openEndedId),
      ),
    );
  }

  Future<StudySessionHasOpenEndedQuestionData?> getStudySessionHasOpenEndedQuestion({required String id}) {
    return (select(attachedDatabase.studySessionHasOpenEndedQuestion)..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();
  }

  Future<List<StudySessionHasOpenEndedQuestionData>> getStudySessionHasOpenEndedQuestionsBySession({
    required String studySessionId,
  }) {
    return (select(attachedDatabase.studySessionHasOpenEndedQuestion)
          ..where((tbl) => tbl.studySessionId.equals(studySessionId)))
        .get();
  }

  Future<int> deleteStudySessionHasOpenEndedQuestion({required String id}) {
    return (delete(attachedDatabase.studySessionHasOpenEndedQuestion)..where((tbl) => tbl.id.equals(id))).go();
  }
}