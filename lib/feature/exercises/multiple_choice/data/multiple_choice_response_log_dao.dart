import 'package:drift/drift.dart';
import 'package:noema/core/database/database.dart';
import 'package:uuid/uuid.dart';

part 'multiple_choice_response_log_dao.g.dart';

@DriftAccessor(tables: [MultipleChoiceResponseLog])
class MultipleChoiceResponseLogDao extends DatabaseAccessor<AppDatabase> with _$MultipleChoiceResponseLogDaoMixin {
  MultipleChoiceResponseLogDao(super.db);

  Future<int> insertMultipleChoiceResponseLog({
    required String multipleChoiceId,
    required String questionChoiceSnapshot,
    required String selectedChoiceIds,
    required int totalCorrectOption,
    required int correctSelected,
    required int wrongSelected,
    required double partialScore,
    String? aiFeedback,
    String? userNotes,
    double? score,
  }) {
    return into(attachedDatabase.multipleChoiceResponseLog).insert(
      MultipleChoiceResponseLogCompanion.insert(
        id: Uuid().v4(),
        multipleChoiceId: multipleChoiceId,
        questionChoiceSnapshot: questionChoiceSnapshot,
        selectedChoiceIds: selectedChoiceIds,
        totalCorrectOption: totalCorrectOption,
        correctSelected: correctSelected,
        wrongSelected: wrongSelected,
        partialScore: partialScore,
        aiFeedback: Value(aiFeedback),
        userNotes: Value(userNotes),
        score: Value(score),
      ),
    );
  }

  Future<int> updateMultipleChoiceResponseLog({
    required String id,
    String? multipleChoiceId,
    String? questionChoiceSnapshot,
    String? selectedChoiceIds,
    int? totalCorrectOption,
    int? correctSelected,
    int? wrongSelected,
    double? partialScore,
    String? aiFeedback,
    String? userNotes,
    double? score,
  }) {
    return (update(
      attachedDatabase.multipleChoiceResponseLog,
    )..where((tbl) => tbl.id.equals(id))).write(
      MultipleChoiceResponseLogCompanion(
        multipleChoiceId: multipleChoiceId == null ? const Value.absent() : Value(multipleChoiceId),
        questionChoiceSnapshot: questionChoiceSnapshot == null ? const Value.absent() : Value(questionChoiceSnapshot),
        selectedChoiceIds: selectedChoiceIds == null ? const Value.absent() : Value(selectedChoiceIds),
        totalCorrectOption: totalCorrectOption == null ? const Value.absent() : Value(totalCorrectOption),
        correctSelected: correctSelected == null ? const Value.absent() : Value(correctSelected),
        wrongSelected: wrongSelected == null ? const Value.absent() : Value(wrongSelected),
        partialScore: partialScore == null ? const Value.absent() : Value(partialScore),
        aiFeedback: aiFeedback == null ? const Value.absent() : Value(aiFeedback),
        userNotes: userNotes == null ? const Value.absent() : Value(userNotes),
        score: score == null ? const Value.absent() : Value(score),
      ),
    );
  }

  Future<MultipleChoiceResponseLogData?> getMultipleChoiceResponseLog({required String id}) {
    return (select(attachedDatabase.multipleChoiceResponseLog)..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();
  }

  Future<List<MultipleChoiceResponseLogData>> getMultipleChoiceResponseLogsByQuestion({required String multipleChoiceId}) {
    return (select(attachedDatabase.multipleChoiceResponseLog)
          ..where((tbl) => tbl.multipleChoiceId.equals(multipleChoiceId))
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.answeredAt)]))
        .get();
  }

  Future<int> deleteMultipleChoiceResponseLog({required String id}) {
    return (delete(attachedDatabase.multipleChoiceResponseLog)
          ..where((tbl) => tbl.id.equals(id)))
        .go();
  }
}
