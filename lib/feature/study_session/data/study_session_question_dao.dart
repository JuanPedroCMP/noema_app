import 'package:drift/drift.dart';
import 'package:noema/core/database/database.dart';
import 'package:uuid/uuid.dart';

part 'study_session_question_dao.g.dart';

enum StudySessionQuestionType { multipleChoice, openEnded }

class StudySessionQuestionCandidate {
  const StudySessionQuestionCandidate({
    required this.id,
    required this.nodeId,
    required this.nodeTitle,
    required this.title,
    required this.statement,
    required this.type,
  });

  final String id;
  final String nodeId;
  final String nodeTitle;
  final String title;
  final String statement;
  final StudySessionQuestionType type;
}

@DriftAccessor(
  tables: [StudySessionQuestion, MultipleChoice, OpenEnded, GraphNode],
)
class StudySessionQuestionDao extends DatabaseAccessor<AppDatabase>
    with _$StudySessionQuestionDaoMixin {
  StudySessionQuestionDao(super.db);

  Future<List<StudySessionQuestionCandidate>> getQuestionsByGraph({
    required String graphId,
    required String userId,
  }) async {
    final rows = await customSelect(
      '''
      SELECT id, node_id, node_title, title, statement, question_type
      FROM (
        SELECT q.id, q.node_id, n.title AS node_title, q.title, q.statement,
               'MULTIPLE_CHOICE' AS question_type
        FROM multiple_choice q
        JOIN graph_node n ON n.id = q.node_id
        JOIN knowledge_graph g ON g.id = n.graph_id
        WHERE g.id = ? AND g.user_id = ? AND q.soft_deleted = 0
        UNION ALL
        SELECT q.id, q.node_id, n.title AS node_title, q.title, q.statement,
               'OPEN_ENDED' AS question_type
        FROM open_ended q
        JOIN graph_node n ON n.id = q.node_id
        JOIN knowledge_graph g ON g.id = n.graph_id
        WHERE g.id = ? AND g.user_id = ? AND q.soft_deleted = 0
      ) AS questions
      ORDER BY node_title COLLATE NOCASE, question_type, title COLLATE NOCASE
      ''',
      variables: [
        Variable.withString(graphId),
        Variable.withString(userId),
        Variable.withString(graphId),
        Variable.withString(userId),
      ],
    ).get();

    return rows.map((row) {
      final type = row.read<String>('question_type');
      return StudySessionQuestionCandidate(
        id: row.read<String>('id'),
        nodeId: row.read<String>('node_id'),
        nodeTitle: row.read<String>('node_title'),
        title: row.read<String>('title'),
        statement: row.read<String>('statement'),
        type: type == 'MULTIPLE_CHOICE'
            ? StudySessionQuestionType.multipleChoice
            : StudySessionQuestionType.openEnded,
      );
    }).toList();
  }

  Future<List<StudySessionQuestionCandidate>> getQuestionsBySession({
    required String studySessionId,
  }) async {
    final rows = await customSelect(
      '''
      SELECT q.multiple_choice_id AS id, n.id AS node_id, n.title AS node_title,
             mc.title, mc.statement, 'MULTIPLE_CHOICE' AS question_type,
             q.display_order
      FROM study_session_question q
      JOIN multiple_choice mc ON mc.id = q.multiple_choice_id
      JOIN graph_node n ON n.id = mc.node_id
      WHERE q.study_session_id = ? AND q.multiple_choice_id IS NOT NULL
        AND mc.soft_deleted = 0
      UNION ALL
      SELECT q.open_ended_id AS id, n.id AS node_id, n.title AS node_title,
             oe.title, oe.statement, 'OPEN_ENDED' AS question_type,
             q.display_order
      FROM study_session_question q
      JOIN open_ended oe ON oe.id = q.open_ended_id
      JOIN graph_node n ON n.id = oe.node_id
      WHERE q.study_session_id = ? AND q.open_ended_id IS NOT NULL
        AND oe.soft_deleted = 0
      ORDER BY display_order
      ''',
      variables: [
        Variable.withString(studySessionId),
        Variable.withString(studySessionId),
      ],
    ).get();

    return rows.map((row) {
      final type = row.read<String>('question_type');
      return StudySessionQuestionCandidate(
        id: row.read<String>('id'),
        nodeId: row.read<String>('node_id'),
        nodeTitle: row.read<String>('node_title'),
        title: row.read<String>('title'),
        statement: row.read<String>('statement'),
        type: type == 'MULTIPLE_CHOICE'
            ? StudySessionQuestionType.multipleChoice
            : StudySessionQuestionType.openEnded,
      );
    }).toList();
  }

  Future<void> replaceQuestions({
    required String studySessionId,
    required List<StudySessionQuestionCandidate> questions,
  }) async {
    await attachedDatabase.transaction(() async {
      await (delete(
        attachedDatabase.studySessionQuestion,
      )..where((tbl) => tbl.studySessionId.equals(studySessionId))).go();
      await batch((batch) {
        batch.insertAll(attachedDatabase.studySessionQuestion, [
          for (var index = 0; index < questions.length; index++)
            StudySessionQuestionCompanion.insert(
              id: const Uuid().v4(),
              studySessionId: studySessionId,
              multipleChoiceId: Value(
                questions[index].type == StudySessionQuestionType.multipleChoice
                    ? questions[index].id
                    : null,
              ),
              openEndedId: Value(
                questions[index].type == StudySessionQuestionType.openEnded
                    ? questions[index].id
                    : null,
              ),
              displayOrder: index,
            ),
        ]);
      });
    });
  }
}
