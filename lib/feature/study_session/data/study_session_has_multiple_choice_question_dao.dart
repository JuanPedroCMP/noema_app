import 'package:drift/drift.dart';
import 'package:noema/core/database/database.dart';
import 'package:uuid/uuid.dart';

part 'study_session_has_multiple_choice_question_dao.g.dart';

@DriftAccessor(tables: [StudySessionHasMultipleChoiceQuestion])
class StudySessionHasMultipleChoiceQuestionDao extends DatabaseAccessor<AppDatabase>
    with _$StudySessionHasMultipleChoiceQuestionDaoMixin {
  StudySessionHasMultipleChoiceQuestionDao(super.db);

  Future<int> insertStudySessionHasMultipleChoiceQuestion({
    required String studySessionId,
    required String multipleChoiceId,
  }) {
    return into(attachedDatabase.studySessionHasMultipleChoiceQuestion).insert(
      StudySessionHasMultipleChoiceQuestionCompanion.insert(
        id: Uuid().v4(),
        studySessionId: studySessionId,
        multipleChoiceId: multipleChoiceId,
      ),
    );
  }

  Future<int> updateStudySessionHasMultipleChoiceQuestion({
    required String id,
    String? studySessionId,
    String? multipleChoiceId,
  }) {
    return (update(
      attachedDatabase.studySessionHasMultipleChoiceQuestion,
    )..where((tbl) => tbl.id.equals(id))).write(
      StudySessionHasMultipleChoiceQuestionCompanion(
        studySessionId: studySessionId == null ? const Value.absent() : Value(studySessionId),
        multipleChoiceId: multipleChoiceId == null ? const Value.absent() : Value(multipleChoiceId),
      ),
    );
  }

  Future<StudySessionHasMultipleChoiceQuestionData?> getStudySessionHasMultipleChoiceQuestion({required String id}) {
    return (select(attachedDatabase.studySessionHasMultipleChoiceQuestion)..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();
  }

  Future<List<StudySessionHasMultipleChoiceQuestionData>> getStudySessionHasMultipleChoiceQuestionsBySession({
    required String studySessionId,
  }) {
    return (select(attachedDatabase.studySessionHasMultipleChoiceQuestion)
          ..where((tbl) => tbl.studySessionId.equals(studySessionId)))
        .get();
  }

  Future<int> deleteStudySessionHasMultipleChoiceQuestion({required String id}) {
    return (delete(attachedDatabase.studySessionHasMultipleChoiceQuestion)..where((tbl) => tbl.id.equals(id))).go();
  }
}