import 'package:drift/drift.dart';
import 'package:noema/core/database/database.dart';
import 'package:uuid/uuid.dart';

part 'study_session_dao.g.dart';

@DriftAccessor(tables: [StudySession])
class StudySessionDao extends DatabaseAccessor<AppDatabase> with _$StudySessionDaoMixin {
  StudySessionDao(super.db);

  Future<int> insertStudySession({
    required String userId,
    required String status,
    required int targetDurationMin,
    int? actualDurationMin,
    bool? interleavingEnabled,
    bool? diagnosticFocus,
    int? totalActivities,
  }) {
    return into(attachedDatabase.studySession).insert(
      StudySessionCompanion.insert(
        id: Uuid().v4(),
        userId: userId,
        status: status,
        targetDurationMin: targetDurationMin,
        actualDurationMin: Value(actualDurationMin),
        interleavingEnabled: interleavingEnabled == null ? const Value.absent() : Value(interleavingEnabled),
        diagnosticFocus: diagnosticFocus == null ? const Value.absent() : Value(diagnosticFocus),
        totalActivities: totalActivities == null ? const Value.absent() : Value(totalActivities),
      ),
    );
  }

  Future<int> updateStudySession({
    required String id,
    String? userId,
    String? status,
    int? targetDurationMin,
    int? actualDurationMin,
    bool? interleavingEnabled,
    bool? diagnosticFocus,
    int? totalActivities,
  }) {
    return (update(
      attachedDatabase.studySession,
    )..where((tbl) => tbl.id.equals(id))).write(
      StudySessionCompanion(
        userId: userId == null ? const Value.absent() : Value(userId),
        status: status == null ? const Value.absent() : Value(status),
        targetDurationMin: targetDurationMin == null ? const Value.absent() : Value(targetDurationMin),
        actualDurationMin: actualDurationMin == null ? const Value.absent() : Value(actualDurationMin),
        interleavingEnabled: interleavingEnabled == null ? const Value.absent() : Value(interleavingEnabled),
        diagnosticFocus: diagnosticFocus == null ? const Value.absent() : Value(diagnosticFocus),
        totalActivities: totalActivities == null ? const Value.absent() : Value(totalActivities),
      ),
    );
  }

  Future<StudySessionData?> getStudySession({required String id}) {
    return (select(attachedDatabase.studySession)..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();
  }

  Future<List<StudySessionData>> getStudySessionsByUser({required String userId}) {
    return (select(attachedDatabase.studySession)
          ..where((tbl) => tbl.userId.equals(userId))
          ..where((tbl) => tbl.softDeleted.equals(false)))
        .get();
  }

  Future<int> deleteStudySession({required String id}) {
    return (update(
      attachedDatabase.studySession,
    )..where((tbl) => tbl.id.equals(id))).write(
      StudySessionCompanion(
        softDeleted: const Value(true),
        softDeletedAt: Value(DateTime.now().millisecondsSinceEpoch),
      ),
    );
  }
}
