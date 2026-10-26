import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:noema/core/database/database.dart';
import 'package:uuid/uuid.dart';

part 'study_session_log_dao.g.dart';

class StudySessionAnswerLog {
  const StudySessionAnswerLog({
    required this.questionId,
    required this.type,
    required this.title,
    required this.statement,
    required this.answeredAt,
    this.userAnswer,
    this.questionChoiceSnapshot,
    this.selectedChoiceIds,
    this.correctSelected,
    this.totalCorrectOption,
    this.wrongSelected,
    this.totalQuestions,
    this.score,
    this.feedback,
    this.notes,
  });

  final String questionId;
  final String type;
  final String title;
  final String statement;
  final int answeredAt;
  final String? userAnswer;
  final String? questionChoiceSnapshot;
  final String? selectedChoiceIds;
  final int? correctSelected;
  final int? totalCorrectOption;
  final int? wrongSelected;
  final int? totalQuestions;
  final double? score;
  final String? feedback;
  final String? notes;
}

@DriftAccessor(tables: [StudySessionLog])
class StudySessionLogDao extends DatabaseAccessor<AppDatabase>
    with _$StudySessionLogDaoMixin {
  StudySessionLogDao(super.db);

  Future<String> start({
    required String studySessionId,
    required String title,
    required String questionsSnapshot,
  }) async {
    final decodedSnapshot = jsonDecode(questionsSnapshot);
    final questions = decodedSnapshot is List
        ? decodedSnapshot
        : decodedSnapshot is Map
        ? decodedSnapshot['questions']
        : null;
    if (questions is! List) {
      throw const FormatException(
        'O snapshot da sessão não contém uma lista de questões.',
      );
    }
    final id = const Uuid().v4();
    await into(attachedDatabase.studySessionLog).insert(
      StudySessionLogCompanion.insert(
        id: id,
        studySessionId: studySessionId,
        sessionTitleSnapshot: title,
        questionsSnapshot: questionsSnapshot,
        totalActivities: Value(questions.length),
      ),
    );
    return id;
  }

  Future<int> updateProgress({
    required String id,
    required int completedActivities,
  }) {
    return (update(
      attachedDatabase.studySessionLog,
    )..where((tbl) => tbl.id.equals(id))).write(
      StudySessionLogCompanion(completedActivities: Value(completedActivities)),
    );
  }

  Future<void> finish({
    required String id,
    required String status,
    required int completedActivities,
    required int totalActivities,
    required int actualDurationMin,
  }) async {
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    await (update(
      attachedDatabase.studySessionLog,
    )..where((tbl) => tbl.id.equals(id))).write(
      StudySessionLogCompanion(
        status: Value(status),
        completedActivities: Value(completedActivities),
        totalActivities: Value(totalActivities),
        actualDurationMin: Value(actualDurationMin),
        endedAt: Value(now),
      ),
    );
  }

  Future<List<StudySessionLogData>> getBySession({
    required String studySessionId,
  }) {
    return (select(attachedDatabase.studySessionLog)
          ..where((tbl) => tbl.studySessionId.equals(studySessionId))
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.startedAt)]))
        .get();
  }

  Future<List<StudySessionAnswerLog>> getAnswerDetails({
    required String studySessionLogId,
  }) async {
    final rows = await customSelect(
      r'''
      SELECT question_id, type, title, statement, user_answer,
             question_choice_snapshot, selected_choice_ids,
             correct_selected, total_correct_option, wrong_selected,
             total_questions, score, feedback, notes, answered_at
      FROM (
        SELECT multiple_choice_id AS question_id,
               'MULTIPLE_CHOICE' AS type,
               json_extract(question_snapshot, '$.title') AS title,
               json_extract(question_snapshot, '$.statement') AS statement,
               NULL AS user_answer,
               question_choice_snapshot,
               selected_choice_ids,
               correct_selected,
               total_correct_option,
               wrong_selected,
               total_questions,
               score,
               ai_feedback AS feedback,
               user_notes AS notes,
               answered_at
        FROM multiple_choice_response_log
        WHERE study_session_log_id = ?
        UNION ALL
        SELECT open_ended_id AS question_id,
               'OPEN_ENDED' AS type,
               json_extract(question_snapshot, '$.title') AS title,
               json_extract(question_snapshot, '$.statement') AS statement,
               user_answer,
               NULL AS question_choice_snapshot,
               NULL AS selected_choice_ids,
               NULL AS correct_selected,
               NULL AS total_correct_option,
               NULL AS wrong_selected,
               NULL AS total_questions,
               score,
               ai_feedback AS feedback,
               user_notes AS notes,
               answered_at
        FROM open_ended_response_log
        WHERE study_session_log_id = ?
      )
      ORDER BY answered_at
      ''',
      variables: [
        Variable.withString(studySessionLogId),
        Variable.withString(studySessionLogId),
      ],
    ).get();

    return rows
        .map(
          (row) => StudySessionAnswerLog(
            questionId: row.read<String>('question_id'),
            type: row.read<String>('type'),
            title: row.readNullable<String>('title') ?? 'Questão',
            statement: row.readNullable<String>('statement') ?? '',
            answeredAt: row.read<int>('answered_at'),
            userAnswer: row.readNullable<String>('user_answer'),
            questionChoiceSnapshot: row.readNullable<String>(
              'question_choice_snapshot',
            ),
            selectedChoiceIds: row.readNullable<String>('selected_choice_ids'),
            correctSelected: row.readNullable<int>('correct_selected'),
            totalCorrectOption: row.readNullable<int>('total_correct_option'),
            wrongSelected: row.readNullable<int>('wrong_selected'),
            totalQuestions: row.readNullable<int>('total_questions'),
            score: row.readNullable<double>('score'),
            feedback: row.readNullable<String>('feedback'),
            notes: row.readNullable<String>('notes'),
          ),
        )
        .toList();
  }
}
