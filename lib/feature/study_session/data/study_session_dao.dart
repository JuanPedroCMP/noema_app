import 'package:drift/drift.dart';
import 'package:noema/core/database/database.dart';
import 'package:uuid/uuid.dart';

part 'study_session_dao.g.dart';

@DriftAccessor(tables: [StudySession])
class StudySessionDao extends DatabaseAccessor<AppDatabase>
    with _$StudySessionDaoMixin {
  StudySessionDao(super.db);

  Future<String> insertStudySession({
    required String userId,
    required String title,
    String? description,
    required String status,
    required int targetDurationMin,
    int? actualDurationMin,
    bool? interleavingEnabled,
    bool? diagnosticFocus,
    int? totalActivities,
  }) {
    final id = Uuid().v4();
    return into(attachedDatabase.studySession)
        .insert(
          StudySessionCompanion.insert(
            id: id,
            userId: userId,
            title: title,
            description: Value(description),
            status: status,
            targetDurationMin: targetDurationMin,
            actualDurationMin: Value(actualDurationMin),
            interleavingEnabled: interleavingEnabled == null
                ? const Value.absent()
                : Value(interleavingEnabled),
            diagnosticFocus: diagnosticFocus == null
                ? const Value.absent()
                : Value(diagnosticFocus),
            totalActivities: totalActivities == null
                ? const Value.absent()
                : Value(totalActivities),
          ),
        )
        .then((_) => id);
  }

  Future<int> updateStudySession({
    required String id,
    String? userId,
    String? title,
    String? description,
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
        title: title == null ? const Value.absent() : Value(title),
        description: description == null
            ? const Value.absent()
            : Value(description),
        status: status == null ? const Value.absent() : Value(status),
        targetDurationMin: targetDurationMin == null
            ? const Value.absent()
            : Value(targetDurationMin),
        actualDurationMin: actualDurationMin == null
            ? const Value.absent()
            : Value(actualDurationMin),
        interleavingEnabled: interleavingEnabled == null
            ? const Value.absent()
            : Value(interleavingEnabled),
        diagnosticFocus: diagnosticFocus == null
            ? const Value.absent()
            : Value(diagnosticFocus),
        totalActivities: totalActivities == null
            ? const Value.absent()
            : Value(totalActivities),
      ),
    );
  }

  Future<StudySessionData?> getStudySession({required String id}) {
    return (select(
      attachedDatabase.studySession,
    )..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  Future<List<StudySessionData>> getStudySessionsByUser({
    required String userId,
  }) {
    return (select(attachedDatabase.studySession)
          ..where((tbl) => tbl.userId.equals(userId))
          ..where((tbl) => tbl.softDeleted.equals(false))
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.updatedAt)]))
        .get();
  }

  Future<int> deleteStudySession({required String id}) {
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    return (update(
      attachedDatabase.studySession,
    )..where((tbl) => tbl.id.equals(id))).write(
      StudySessionCompanion(
        softDeleted: const Value(true),
        softDeletedAt: Value(now),
        updatedAt: Value(now),
      ),
    );
  }

  Future<void> markSessionCompleted({
    required String id,
    required int actualDurationMin,
    required int completedActivities,
    required int totalActivities,
  }) async {
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    await (update(
      attachedDatabase.studySession,
    )..where((tbl) => tbl.id.equals(id))).write(
      StudySessionCompanion(
        status: const Value('COMPLETED'),
        actualDurationMin: Value(actualDurationMin),
        completedActivities: Value(completedActivities),
        totalActivities: Value(totalActivities),
        endedAt: Value(now),
        updatedAt: Value(now),
      ),
    );
  }

  Future<void> markSessionStarted({
    required String id,
    required int totalActivities,
  }) async {
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    await (update(
      attachedDatabase.studySession,
    )..where((tbl) => tbl.id.equals(id))).write(
      StudySessionCompanion(
        status: const Value('IN_PROGRESS'),
        startedAt: Value(now),
        endedAt: const Value(null),
        completedActivities: const Value(0),
        totalActivities: Value(totalActivities),
        updatedAt: Value(now),
      ),
    );
  }

  Future<void> updateSessionProgress({
    required String id,
    required int completedActivities,
  }) async {
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    await (update(
      attachedDatabase.studySession,
    )..where((tbl) => tbl.id.equals(id))).write(
      StudySessionCompanion(
        completedActivities: Value(completedActivities),
        updatedAt: Value(now),
      ),
    );
  }

  Future<void> markSessionAbandoned({
    required String id,
    required int completedActivities,
  }) async {
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    await (update(
      attachedDatabase.studySession,
    )..where((tbl) => tbl.id.equals(id))).write(
      StudySessionCompanion(
        status: const Value('ABANDONED'),
        completedActivities: Value(completedActivities),
        endedAt: Value(now),
        updatedAt: Value(now),
      ),
    );
  }
}
