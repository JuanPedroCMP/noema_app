import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:fsrs/fsrs.dart' as fsrs;
import 'package:noema/core/database/database.dart';
import 'package:uuid/uuid.dart';

enum ReviewItemType {
  flashcard('FLASHCARD'),
  openEnded('OPEN_ENDED'),
  multipleChoice('MULTIPLE_CHOICE');

  const ReviewItemType(this.databaseValue);

  final String databaseValue;
}

enum ReviewMethod {
  selfRating('SELF_RATING'),
  autoScore('AUTO_SCORE'),
  aiCorrection('AI_CORRECTION'),
  manualCorrection('MANUAL_CORRECTION');

  const ReviewMethod(this.databaseValue);

  final String databaseValue;
}

class FsrsReviewResult {
  const FsrsReviewResult({
    required this.dueAt,
    required this.scheduledDays,
    required this.retrievabilityBeforeReview,
  });

  final DateTime dueAt;
  final int scheduledDays;
  final double? retrievabilityBeforeReview;
}

class FsrsReviewService {
  FsrsReviewService(this._database);

  final AppDatabase _database;

  static final fsrs.Scheduler _scheduler = fsrs.Scheduler(
    desiredRetention: 0.9,
    enableFuzzing: false,
  );

  Future<bool> isDue({
    required ReviewItemType itemType,
    required String itemId,
    DateTime? now,
  }) async {
    final state = await (_database.select(_database.reviewItemState)
          ..where(
            (row) =>
                row.itemType.equals(itemType.databaseValue) &
                row.itemId.equals(itemId),
          ))
        .getSingleOrNull();
    if (state == null) return true;
    final nowSeconds = (now ?? DateTime.now()).millisecondsSinceEpoch ~/ 1000;
    return state.nextReviewAt <= nowSeconds;
  }

  Future<FsrsReviewResult> review({
    required ReviewItemType itemType,
    required String itemId,
    required String nodeId,
    required fsrs.Rating rating,
    required int durationSeconds,
    required ReviewMethod method,
    double? score,
    String? sourceResponseId,
    DateTime? reviewedAt,
  }) async {
    if (itemId.trim().isEmpty || nodeId.trim().isEmpty) {
      throw ArgumentError('O item e o nó são obrigatórios para revisar.');
    }
    if (durationSeconds < 0) {
      throw ArgumentError.value(durationSeconds, 'durationSeconds');
    }
    if (score != null && (!score.isFinite || score < 0 || score > 1)) {
      throw ArgumentError.value(score, 'score', 'must be between 0 and 1');
    }

    final reviewTime = (reviewedAt ?? DateTime.now()).toUtc();
    final nowSeconds = reviewTime.millisecondsSinceEpoch ~/ 1000;
    final stateTable = _database.reviewItemState;
    final logTable = _database.reviewItemLog;
    final stateId = const Uuid().v4();

    late FsrsReviewResult result;
    await _database.transaction(() async {
      final existing = await (_database.select(stateTable)..where(
            (row) =>
                row.itemType.equals(itemType.databaseValue) &
                row.itemId.equals(itemId),
          ))
          .getSingleOrNull();
      if (existing != null && existing.nodeId != nodeId) {
        throw StateError('O item de revisão não pertence ao nó informado.');
      }

      final card = existing == null
          ? fsrs.Card(cardId: _stableCardId(itemType, itemId), due: reviewTime)
          : _decodeCard(existing.cardStateJson);
      final beforeRetrievability = card.lastReview == null
          ? null
          : _scheduler.getCardRetrievability(
              card,
              currentDateTime: reviewTime,
            );
      final scheduled = _scheduler.reviewCard(
        card,
        rating,
        reviewDateTime: reviewTime,
        reviewDuration: durationSeconds * 1000,
      );
      final nextDue = scheduled.card.due.toUtc();
      final intervalSeconds = nextDue.difference(reviewTime).inSeconds;
      final scheduledDays = (intervalSeconds / Duration.secondsPerDay)
          .round()
          .clamp(0, 36500);

      if (existing == null) {
        await _database.into(stateTable).insert(
          ReviewItemStateCompanion.insert(
            id: stateId,
            nodeId: nodeId,
            itemType: itemType.databaseValue,
            itemId: itemId,
            cardStateJson: jsonEncode(scheduled.card.toMap()),
            nextReviewAt: nextDue.millisecondsSinceEpoch ~/ 1000,
          ),
        );
      } else {
        await (_database.update(stateTable)
              ..where((row) => row.id.equals(existing.id)))
            .write(
              ReviewItemStateCompanion(
                cardStateJson: Value(jsonEncode(scheduled.card.toMap())),
                nextReviewAt: Value(
                  nextDue.millisecondsSinceEpoch ~/ 1000,
                ),
                updatedAt: Value(nowSeconds),
              ),
            );
      }

      await _database.into(logTable).insert(
        ReviewItemLogCompanion.insert(
          id: const Uuid().v4(),
          reviewItemStateId: existing?.id ?? stateId,
          rating: rating.value,
          durationSeconds: Value(durationSeconds),
          score: Value(score),
          reviewMethod: method.databaseValue,
          sourceResponseId: Value(sourceResponseId),
          retrievability: Value(beforeRetrievability),
          scheduledDays: Value(scheduledDays),
          reviewedAt: Value(nowSeconds),
        ),
      );

      result = FsrsReviewResult(
        dueAt: nextDue,
        scheduledDays: scheduledDays,
        retrievabilityBeforeReview: beforeRetrievability,
      );
    });
    return result;
  }

  fsrs.Card _decodeCard(String raw) {
    final decoded = jsonDecode(raw);
    if (decoded is! Map) {
      throw const FormatException('O estado FSRS armazenado é inválido.');
    }
    return fsrs.Card.fromMap(Map<String, dynamic>.from(decoded));
  }

  int _stableCardId(ReviewItemType type, String itemId) {
    var hash = 0x811c9dc5;
    for (final codeUnit in '${type.databaseValue}:$itemId'.codeUnits) {
      hash = ((hash ^ codeUnit) * 0x01000193) & 0x7fffffff;
    }
    return hash;
  }
}
