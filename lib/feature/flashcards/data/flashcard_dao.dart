import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:noema/core/database/database.dart';
import 'package:uuid/uuid.dart';

part 'flashcard_dao.g.dart';

@DriftAccessor(
  tables: [Flashcard, FlashcardResponseLog, GraphNode, KnowledgeGraph],
)
class FlashcardDao extends DatabaseAccessor<AppDatabase>
    with _$FlashcardDaoMixin {
  FlashcardDao(super.db);

  Future<List<FlashcardData>> getByUser(String userId) async {
    final cards = attachedDatabase.flashcard;
    final nodes = attachedDatabase.graphNode;
    final graphs = attachedDatabase.knowledgeGraph;
    final query =
        select(cards).join([
            innerJoin(nodes, nodes.id.equalsExp(cards.nodeId)),
            innerJoin(graphs, graphs.id.equalsExp(nodes.graphId)),
          ])
          ..where(graphs.userId.equals(userId))
          ..where(cards.softDeleted.equals(false))
          ..orderBy([OrderingTerm.desc(cards.updatedAt)]);
    final rows = await query.get();
    return rows.map((row) => row.readTable(cards)).toList();
  }

  Future<String> create({
    required String nodeId,
    required String title,
    required String statement,
    String? targetSkill,
  }) async {
    final id = const Uuid().v4();
    await into(attachedDatabase.flashcard).insert(
      FlashcardCompanion.insert(
        id: id,
        nodeId: nodeId,
        title: title.trim(),
        statement: statement.trim(),
        targetSkill: Value(
          targetSkill?.trim().isEmpty == true ? null : targetSkill?.trim(),
        ),
      ),
    );
    return id;
  }

  Future<bool> updateCard({
    required String id,
    required String title,
    required String statement,
    String? targetSkill,
  }) async {
    final changed =
        await (update(
          attachedDatabase.flashcard,
        )..where((t) => t.id.equals(id))).write(
          FlashcardCompanion(
            title: Value(title.trim()),
            statement: Value(statement.trim()),
            targetSkill: Value(
              targetSkill?.trim().isEmpty == true ? null : targetSkill?.trim(),
            ),
            updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
          ),
        );
    return changed > 0;
  }

  Future<bool> deleteCard(String id) async {
    final changed =
        await (update(
          attachedDatabase.flashcard,
        )..where((t) => t.id.equals(id))).write(
          FlashcardCompanion(
            softDeleted: const Value(true),
            softDeletedAt: Value(DateTime.now().millisecondsSinceEpoch),
          ),
        );
    return changed > 0;
  }

  Future<void> logReview({
    required FlashcardData card,
    required String rating,
  }) {
    return into(attachedDatabase.flashcardResponseLog).insert(
      FlashcardResponseLogCompanion.insert(
        id: const Uuid().v4(),
        flashcardId: card.id,
        flashcardSnapshot: jsonEncode({
          'title': card.title,
          'statement': card.statement,
          'targetSkill': card.targetSkill,
        }),
        answer: rating,
      ),
    );
  }
}
