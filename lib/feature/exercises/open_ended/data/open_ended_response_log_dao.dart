import 'package:drift/drift.dart';
import 'package:noema/core/database/database.dart';
import 'package:uuid/uuid.dart';

part 'open_ended_response_log_dao.g.dart';

@DriftAccessor(tables: [OpenEndedResponseLog])
class OpenEndedResponseLogDao extends DatabaseAccessor<AppDatabase> with _$OpenEndedResponseLogDaoMixin {
  OpenEndedResponseLogDao(super.db);

  Future<int> insertOpenEndedResponseLog({
    required String openEndedId,
    required String questionSnapshot,
    String? userAnswer,
    String? aiFeedback,
    int? weight,
    String? userNotes,
    bool? isCorrect,
    String? masteryDemonstrated,
    double? score,
  }) {
    return into(attachedDatabase.openEndedResponseLog).insert(
      OpenEndedResponseLogCompanion.insert(
        id: Uuid().v4(),
        openEndedId: openEndedId,
        questionSnapshot: questionSnapshot,
        userAnswer: Value(userAnswer),
        aiFeedback: Value(aiFeedback),
        weight: Value(weight),
        userNotes: Value(userNotes),
        isCorrect: Value(isCorrect),
        masteryDemonstrated: Value(masteryDemonstrated),
        score: Value(score),
      ),
    );
  }

  Future<int> updateOpenEndedResponseLog({
    required String id,
    String? openEndedId,
    String? questionSnapshot,
    String? userAnswer,
    String? aiFeedback,
    int? weight,
    String? userNotes,
    bool? isCorrect,
    String? masteryDemonstrated,
    double? score,
  }) {
    return (update(
      attachedDatabase.openEndedResponseLog,
    )..where((tbl) => tbl.id.equals(id))).write(
      OpenEndedResponseLogCompanion(
        openEndedId: openEndedId == null ? const Value.absent() : Value(openEndedId),
        questionSnapshot: questionSnapshot == null ? const Value.absent() : Value(questionSnapshot),
        userAnswer: userAnswer == null ? const Value.absent() : Value(userAnswer),
        aiFeedback: aiFeedback == null ? const Value.absent() : Value(aiFeedback),
        weight: weight == null ? const Value.absent() : Value(weight),
        userNotes: userNotes == null ? const Value.absent() : Value(userNotes),
        isCorrect: isCorrect == null ? const Value.absent() : Value(isCorrect),
        masteryDemonstrated: masteryDemonstrated == null ? const Value.absent() : Value(masteryDemonstrated),
        score: score == null ? const Value.absent() : Value(score),
      ),
    );
  }

  Future<OpenEndedResponseLogData?> getOpenEndedResponseLog({required String id}) {
    return (select(attachedDatabase.openEndedResponseLog)..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();
  }

  Future<List<OpenEndedResponseLogData>> getOpenEndedResponseLogsByQuestion({required String openEndedId}) {
    return (select(attachedDatabase.openEndedResponseLog)
          ..where((tbl) => tbl.openEndedId.equals(openEndedId))
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.answeredAt)]))
        .get();
  }

  Future<int> deleteOpenEndedResponseLog({required String id}) {
    return (delete(attachedDatabase.openEndedResponseLog)
          ..where((tbl) => tbl.id.equals(id)))
        .go();
  }
}
