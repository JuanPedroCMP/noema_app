import 'package:drift/drift.dart';
import 'package:noema/core/database/database.dart';
import 'package:uuid/uuid.dart';

part 'choice_dao.g.dart'; 

@DriftAccessor(tables: [Choice])
class ChoiceDao extends DatabaseAccessor<AppDatabase> with _$ChoiceDaoMixin {
  ChoiceDao(super.db);

  Future<int> insertChoice({
    required String multipleChoiceId,
    required bool isCorrect,
    required String statement,
    String? explanation,
    int? weight,
    bool? isAiGenerated,
  }) {
    return into(attachedDatabase.choice).insert(
      ChoiceCompanion.insert(
        id: Uuid().v4(),
        multipleChoiceId: multipleChoiceId,
        isCorrect: isCorrect,
        statement: statement,
        explanation: Value(explanation),
        weight: Value(weight),
        isAiGenerated: Value(isAiGenerated ?? false),
      ),
    );
  }

  Future<int> updateChoice({
    required String id,
    String? multipleChoiceId,
    bool? isCorrect,
    String? statement,
    String? explanation,
    int? weight,
    bool? isAiGenerated,
  }) {
    return (update(
      attachedDatabase.choice,
    )..where((tbl) => tbl.id.equals(id))).write(
      ChoiceCompanion(
        multipleChoiceId: multipleChoiceId == null ? const Value.absent() : Value(multipleChoiceId),
        isCorrect: isCorrect == null ? const Value.absent() : Value(isCorrect),
        statement: statement == null ? const Value.absent() : Value(statement),
        explanation: explanation == null ? const Value.absent() : Value(explanation),
        weight: weight == null ? const Value.absent() : Value(weight),
        isAiGenerated: isAiGenerated == null ? const Value.absent() : Value(isAiGenerated),
      ),
    );
  }

  Future<ChoiceData?> getChoice({required String id}) {
    return (select(attachedDatabase.choice)..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();
  }

  Future<List<ChoiceData>> getChoicesByQuestion({required String multipleChoiceId}) {
    return (select(attachedDatabase.choice)
          ..where((tbl) => tbl.multipleChoiceId.equals(multipleChoiceId)))
        .get();
  }

  Future<int> deleteChoice({required String id}) {
    return (delete(attachedDatabase.choice)
          ..where((tbl) => tbl.id.equals(id)))
        .go();
  }
}
