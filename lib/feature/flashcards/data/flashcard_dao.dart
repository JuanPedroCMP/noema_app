import 'package:drift/drift.dart';
import 'package:fsrs/fsrs.dart' as fsrs;
import 'package:noema/core/database/database.dart';
import 'package:noema/feature/review/data/fsrs_review_service.dart';
import 'package:uuid/uuid.dart';

part 'flashcard_dao.g.dart';

@DriftAccessor(
  tables: [
    Flashcard,
    FlashcardResponseLog,
    FlashcardGroup,
    FlashcardBelongsGroup,
    GraphNode,
    KnowledgeGraph,
  ],
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
          ..where(nodes.softDeleted.equals(false))
          ..where(graphs.softDeleted.equals(false))
          ..where(cards.softDeleted.equals(false))
          ..orderBy([OrderingTerm.desc(cards.updatedAt)]);
    final rows = await query.get();
    return rows.map((row) => row.readTable(cards)).toList();
  }

  Future<List<FlashcardData>> getByNode({
    required String nodeId,
    required String userId,
  }) async {
    final cards = attachedDatabase.flashcard;
    final nodes = attachedDatabase.graphNode;
    final graphs = attachedDatabase.knowledgeGraph;
    final query =
        select(cards).join([
            innerJoin(nodes, nodes.id.equalsExp(cards.nodeId)),
            innerJoin(graphs, graphs.id.equalsExp(nodes.graphId)),
          ])
          ..where(cards.nodeId.equals(nodeId))
          ..where(cards.softDeleted.equals(false))
          ..where(nodes.softDeleted.equals(false))
          ..where(graphs.softDeleted.equals(false))
          ..where(graphs.userId.equals(userId))
          ..orderBy([OrderingTerm.desc(cards.updatedAt)]);
    final rows = await query.get();
    return rows.map((row) => row.readTable(cards)).toList();
  }

  Future<List<GraphNodeData>> getNodesByUser(String userId) async {
    final nodes = attachedDatabase.graphNode;
    final graphs = attachedDatabase.knowledgeGraph;
    final query =
        select(
            nodes,
          ).join([innerJoin(graphs, graphs.id.equalsExp(nodes.graphId))])
          ..where(graphs.userId.equals(userId))
          ..where(nodes.softDeleted.equals(false))
          ..where(graphs.softDeleted.equals(false))
          ..orderBy([OrderingTerm.asc(nodes.title)]);
    final rows = await query.get();
    return rows.map((row) => row.readTable(nodes)).toList();
  }

  Future<List<KnowledgeGraphData>> getGraphsByUser(String userId) {
    return (select(attachedDatabase.knowledgeGraph)
          ..where((graph) => graph.userId.equals(userId))
          ..where((graph) => graph.softDeleted.equals(false))
          ..orderBy([(graph) => OrderingTerm.asc(graph.title)]))
        .get();
  }

  Future<List<({FlashcardGroupData deck, List<FlashcardData> cards})>>
  getCustomDecksByUser(String userId) async {
    final decks = attachedDatabase.flashcardGroup;
    final nodes = attachedDatabase.graphNode;
    final graphs = attachedDatabase.knowledgeGraph;
    final query =
        select(decks).join([
            innerJoin(nodes, nodes.id.equalsExp(decks.nodeId)),
            innerJoin(graphs, graphs.id.equalsExp(nodes.graphId)),
          ])
          ..where(graphs.userId.equals(userId))
          ..where(graphs.softDeleted.equals(false))
          ..where(nodes.softDeleted.equals(false))
          ..where(decks.softDeleted.equals(false))
          ..orderBy([OrderingTerm.asc(decks.name)]);
    final rows = await query.get();
    final result = <({FlashcardGroupData deck, List<FlashcardData> cards})>[];
    for (final row in rows) {
      final deck = row.readTable(decks);
      result.add((
        deck: deck,
        cards: await getCardsInCustomDeck(deckId: deck.id, userId: userId),
      ));
    }
    return result;
  }

  Future<List<FlashcardData>> getCardsInCustomDeck({
    required String deckId,
    required String userId,
  }) async {
    final deck = attachedDatabase.flashcardGroup;
    final anchorNode = attachedDatabase.graphNode;
    final anchorGraph = attachedDatabase.knowledgeGraph;
    final isOwnedDeck =
        await (select(deck).join([
              innerJoin(anchorNode, anchorNode.id.equalsExp(deck.nodeId)),
              innerJoin(
                anchorGraph,
                anchorGraph.id.equalsExp(anchorNode.graphId),
              ),
            ])..where(
              deck.id.equals(deckId) &
                  deck.softDeleted.equals(false) &
                  anchorNode.softDeleted.equals(false) &
                  anchorGraph.softDeleted.equals(false) &
                  anchorGraph.userId.equals(userId),
            ))
            .getSingleOrNull();
    if (isOwnedDeck == null) return const [];

    final cards = attachedDatabase.flashcard;
    final memberships = attachedDatabase.flashcardBelongsGroup;
    final nodes = attachedDatabase.graphNode;
    final graphs = attachedDatabase.knowledgeGraph;
    final query =
        select(cards).join([
            innerJoin(memberships, memberships.flashcardId.equalsExp(cards.id)),
            innerJoin(
              attachedDatabase.flashcardGroup,
              attachedDatabase.flashcardGroup.id.equalsExp(
                memberships.flashcardGroupId,
              ),
            ),
            innerJoin(nodes, nodes.id.equalsExp(cards.nodeId)),
            innerJoin(graphs, graphs.id.equalsExp(nodes.graphId)),
          ])
          ..where(memberships.flashcardGroupId.equals(deckId))
          ..where(cards.softDeleted.equals(false))
          ..where(nodes.softDeleted.equals(false))
          ..where(graphs.softDeleted.equals(false))
          ..where(graphs.userId.equals(userId))
          ..orderBy([OrderingTerm.desc(cards.updatedAt)]);
    final rows = await query.get();
    return rows.map((row) => row.readTable(cards)).toList();
  }

  Future<String> saveCustomDeck({
    String? deckId,
    required String userId,
    required String name,
    required List<String> flashcardIds,
  }) async {
    final normalizedName = name.trim();
    final uniqueIds = flashcardIds.toSet().toList();
    if (normalizedName.isEmpty) {
      throw ArgumentError.value(name, 'name', 'O nome do deck é obrigatório.');
    }
    if (uniqueIds.isEmpty) {
      throw ArgumentError.value(
        flashcardIds,
        'flashcardIds',
        'Selecione pelo menos um flashcard.',
      );
    }

    final cards = attachedDatabase.flashcard;
    final nodes = attachedDatabase.graphNode;
    final graphs = attachedDatabase.knowledgeGraph;
    final query =
        select(cards).join([
            innerJoin(nodes, nodes.id.equalsExp(cards.nodeId)),
            innerJoin(graphs, graphs.id.equalsExp(nodes.graphId)),
          ])
          ..where(cards.id.isIn(uniqueIds))
          ..where(cards.softDeleted.equals(false))
          ..where(nodes.softDeleted.equals(false))
          ..where(graphs.softDeleted.equals(false))
          ..where(graphs.userId.equals(userId));
    final rows = await query.get();
    final ownedCards = rows.map((row) => row.readTable(cards)).toList();
    if (ownedCards.length != uniqueIds.length) {
      throw StateError(
        'Um ou mais flashcards não estão disponíveis para este usuário.',
      );
    }

    final id = deckId ?? const Uuid().v4();
    await attachedDatabase.transaction(() async {
      if (deckId != null) {
        final existingDeck =
            await (select(attachedDatabase.flashcardGroup).join([
                  innerJoin(
                    nodes,
                    nodes.id.equalsExp(attachedDatabase.flashcardGroup.nodeId),
                  ),
                  innerJoin(graphs, graphs.id.equalsExp(nodes.graphId)),
                ])..where(
                  attachedDatabase.flashcardGroup.id.equals(deckId) &
                      attachedDatabase.flashcardGroup.softDeleted.equals(
                        false,
                      ) &
                      nodes.softDeleted.equals(false) &
                      graphs.softDeleted.equals(false) &
                      graphs.userId.equals(userId),
                ))
                .getSingleOrNull();
        if (existingDeck == null) {
          throw StateError('Deck não encontrado.');
        }
      }
      if (deckId == null) {
        await into(attachedDatabase.flashcardGroup).insert(
          FlashcardGroupCompanion.insert(
            id: id,
            nodeId: ownedCards.first.nodeId,
            name: normalizedName,
          ),
        );
      } else {
        final changed =
            await (update(attachedDatabase.flashcardGroup)
                  ..where((deck) => deck.id.equals(deckId))
                  ..where((deck) => deck.softDeleted.equals(false)))
                .write(
                  FlashcardGroupCompanion(
                    name: Value(normalizedName),
                    updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
                  ),
                );
        if (changed == 0) throw StateError('Deck não encontrado.');
        await (delete(attachedDatabase.flashcardBelongsGroup)..where(
              (membership) => membership.flashcardGroupId.equals(deckId),
            ))
            .go();
      }
      for (final cardId in uniqueIds) {
        await into(attachedDatabase.flashcardBelongsGroup).insert(
          FlashcardBelongsGroupCompanion.insert(
            id: const Uuid().v4(),
            flashcardId: cardId,
            flashcardGroupId: id,
          ),
        );
      }
    });
    return id;
  }

  Future<bool> deleteCustomDeck({
    required String deckId,
    required String userId,
  }) async {
    final decks = attachedDatabase.flashcardGroup;
    final nodes = attachedDatabase.graphNode;
    final graphs = attachedDatabase.knowledgeGraph;
    final ownedDeck =
        await (select(decks).join([
              innerJoin(nodes, nodes.id.equalsExp(decks.nodeId)),
              innerJoin(graphs, graphs.id.equalsExp(nodes.graphId)),
            ])..where(
              decks.id.equals(deckId) &
                  decks.softDeleted.equals(false) &
                  nodes.softDeleted.equals(false) &
                  graphs.softDeleted.equals(false) &
                  graphs.userId.equals(userId),
            ))
            .getSingleOrNull();
    if (ownedDeck == null) return false;

    final changed = await (update(
      decks,
    )..where((deck) => deck.id.equals(deckId))).write(
      FlashcardGroupCompanion(
        softDeleted: const Value(true),
        softDeletedAt: Value(DateTime.now().millisecondsSinceEpoch),
        updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
      ),
    );
    return changed > 0;
  }

  Future<List<FlashcardData>> getDueCards(List<FlashcardData> cards) async {
    if (cards.isEmpty) return const [];

    final cardIds = cards.map((card) => card.id).toSet();
    final states =
        await (select(attachedDatabase.reviewItemState)
              ..where((state) => state.itemType.equals('FLASHCARD'))
              ..where((state) => state.itemId.isIn(cardIds)))
            .get();
    final legacyLogs =
        await (select(attachedDatabase.flashcardResponseLog)
              ..where((review) => review.flashcardId.isIn(cardIds))
              ..orderBy([(review) => OrderingTerm.desc(review.answeredAt)]))
            .get();
    final latestLegacyReview = <String, FlashcardResponseLogData>{};
    for (final review in legacyLogs) {
      latestLegacyReview.putIfAbsent(review.flashcardId, () => review);
    }
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final nextReviewById = {
      for (final state in states) state.itemId: state.nextReviewAt,
    };
    return cards.where((card) {
      final nextReviewAt = nextReviewById[card.id];
      if (nextReviewAt != null) return nextReviewAt <= now;
      final legacyReview = latestLegacyReview[card.id];
      if (legacyReview == null) return true;
      final interval = switch (legacyReview.answer.toLowerCase()) {
        'again' => const Duration(minutes: 10),
        'hard' => const Duration(days: 1),
        'good' => const Duration(days: 3),
        'easy' => const Duration(days: 7),
        _ => Duration.zero,
      };
      return legacyReview.answeredAt + interval.inSeconds <= now;
    }).toList();
  }

  Future<String> create({
    required String userId,
    required String nodeId,
    required String title,
    required String statement,
    String? targetSkill,
  }) async {
    final nodes = attachedDatabase.graphNode;
    final graphs = attachedDatabase.knowledgeGraph;
    final node =
        await (select(nodes).join([
              innerJoin(graphs, graphs.id.equalsExp(nodes.graphId)),
            ])..where(
              nodes.id.equals(nodeId) &
                  nodes.softDeleted.equals(false) &
                  graphs.softDeleted.equals(false) &
                  graphs.userId.equals(userId),
            ))
            .getSingleOrNull();
    if (node == null) {
      throw StateError('Nó não encontrado ou indisponível para este usuário.');
    }

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

  Future<FsrsReviewResult> logReview({
    required FlashcardData card,
    required String rating,
    required int durationSeconds,
  }) {
    final fsrsRating = switch (rating.toLowerCase()) {
      'again' => fsrs.Rating.again,
      'hard' => fsrs.Rating.hard,
      'good' => fsrs.Rating.good,
      'easy' => fsrs.Rating.easy,
      _ => throw ArgumentError.value(rating, 'rating'),
    };
    return FsrsReviewService(attachedDatabase).review(
      itemType: ReviewItemType.flashcard,
      itemId: card.id,
      nodeId: card.nodeId,
      rating: fsrsRating,
      durationSeconds: durationSeconds,
      method: ReviewMethod.selfRating,
    );
  }
}
