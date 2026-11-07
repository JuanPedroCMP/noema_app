import 'package:drift/drift.dart';
import 'package:fsrs/fsrs.dart' as fsrs;
import 'package:noema/core/database/database.dart';
import 'package:uuid/uuid.dart';

enum DomainEventOrigin {
  revision('REVISION'),
  studySession('STUDY_SESSION'),
  manual('MANUAL');

  const DomainEventOrigin(this.databaseValue);

  final String databaseValue;
}

class DomainMasteryUpdate {
  const DomainMasteryUpdate({
    required this.scoreBefore,
    required this.scoreAfter,
    required this.levelBefore,
    required this.levelAfter,
  });

  final double scoreBefore;
  final double scoreAfter;
  final String? levelBefore;
  final String levelAfter;

  static DomainMasteryUpdate calculate({
    required double? previousScore,
    required int previousReviewCount,
    required fsrs.Rating rating,
    int? exposureCount,
    double? assessmentScore,
    double? retrievability,
    double? historicalAccuracy,
  }) {
    if (previousReviewCount < 0) {
      throw ArgumentError.value(previousReviewCount, 'previousReviewCount');
    }
    if (exposureCount != null && exposureCount < 0) {
      throw ArgumentError.value(exposureCount, 'exposureCount');
    }
    if (previousScore != null &&
        (!previousScore.isFinite || previousScore < 0 || previousScore > 1)) {
      throw ArgumentError.value(previousScore, 'previousScore');
    }
    if (assessmentScore != null &&
        (!assessmentScore.isFinite ||
            assessmentScore < 0 ||
            assessmentScore > 1)) {
      throw ArgumentError.value(assessmentScore, 'assessmentScore');
    }
    if (retrievability != null &&
        (!retrievability.isFinite ||
            retrievability < 0 ||
            retrievability > 1)) {
      throw ArgumentError.value(retrievability, 'retrievability');
    }
    if (historicalAccuracy != null &&
        (!historicalAccuracy.isFinite ||
            historicalAccuracy < 0 ||
            historicalAccuracy > 1)) {
      throw ArgumentError.value(historicalAccuracy, 'historicalAccuracy');
    }

    final scoreBefore = previousScore ?? 0.5;
    final ratingEvidence = _ratingEvidence(rating);
    final currentEvidence = assessmentScore == null
        ? ratingEvidence
        : (assessmentScore * 0.8) + (ratingEvidence * 0.2);
    final observedExposureCount = exposureCount ?? previousReviewCount;
    final confidence = observedExposureCount / (observedExposureCount + 2.0);
    final evidence = historicalAccuracy == null
        ? currentEvidence
        : (historicalAccuracy * confidence) +
              (currentEvidence * (1 - confidence));
    final reviewWeight = 1 / (observedExposureCount.clamp(0, 4) + 1);
    final retainedMastery = previousScore == null
        ? evidence
        : scoreBefore * (retrievability ?? 1) +
              0.5 * (1 - (retrievability ?? 1));
    final scoreAfter =
        (retainedMastery * (1 - reviewWeight) + evidence * reviewWeight)
            .clamp(0.0, 1.0)
            .toDouble();

    return DomainMasteryUpdate(
      scoreBefore: scoreBefore,
      scoreAfter: scoreAfter,
      levelBefore: previousScore == null
          ? null
          : levelForScore(previousScore),
      levelAfter: levelForScore(scoreAfter),
    );
  }

  static String levelForScore(double? score) {
    if (score == null || score < 0.4) return 'WEAK';
    if (score < 0.6) return 'PARTIAL';
    if (score < 0.8) return 'ADEQUATE';
    return 'STRONG';
  }

  static double _ratingEvidence(fsrs.Rating rating) => switch (rating) {
    fsrs.Rating.again => 0,
    fsrs.Rating.hard => 0.4,
    fsrs.Rating.good => 0.75,
    fsrs.Rating.easy => 1,
  };
}

class DomainMasteryService {
  DomainMasteryService(this._database);

  final AppDatabase _database;

  Future<DomainMasteryUpdate> recordReview({
    required String nodeId,
    required fsrs.Rating rating,
    required double? assessmentScore,
    required double? retrievability,
    required DateTime reviewedAt,
    required DomainEventOrigin eventOrigin,
    required String sourceStudySessionType,
  }) async {
    final node = await (_database.select(_database.graphNode)
          ..where((row) => row.id.equals(nodeId))
          ..where((row) => row.softDeleted.equals(false)))
        .getSingleOrNull();
    if (node == null) {
      throw StateError('Não foi possível atualizar o domínio de um nó ausente.');
    }

    final state = _database.reviewItemState;
    final reviewLog = _database.reviewItemLog;
    final reviewRows =
        await (_database.select(reviewLog).join([
              innerJoin(
                state,
                state.id.equalsExp(reviewLog.reviewItemStateId),
              ),
            ])..where(state.nodeId.equals(nodeId)))
            .get();
    final previousReviewCount = reviewRows.length;
    final scoredReviews = reviewRows
        .map((row) => row.readTable(reviewLog).score)
        .whereType<double>()
        .where((score) => score.isFinite)
        .toList();
    final historicalAccuracy = scoredReviews.isEmpty
        ? null
        : scoredReviews.reduce((sum, score) => sum + score) /
              scoredReviews.length;
    final exposureCount = await _countExposureEvents(nodeId);
    final update = DomainMasteryUpdate.calculate(
      previousScore: node.masteryScore,
      previousReviewCount: previousReviewCount,
      rating: rating,
      exposureCount: exposureCount,
      assessmentScore: assessmentScore,
      retrievability: retrievability,
      historicalAccuracy: historicalAccuracy,
    );
    final nowSeconds = reviewedAt.toUtc().millisecondsSinceEpoch ~/ 1000;

    await (_database.update(_database.graphNode)
          ..where((row) => row.id.equals(nodeId)))
        .write(
          GraphNodeCompanion(
            masteryScore: Value(update.scoreAfter),
            fsrsRating: Value(rating.value),
            updatedAt: Value(nowSeconds),
          ),
        );
    await _database.into(_database.domainLog).insert(
      DomainLogCompanion.insert(
        id: const Uuid().v4(),
        nodeId: nodeId,
        scoreBefore: update.scoreBefore,
        scoreAfter: update.scoreAfter,
        levelBefore: Value(update.levelBefore),
        levelAfter: Value(update.levelAfter),
        eventOrigin: eventOrigin.databaseValue,
        sourceStudySessionType: Value(sourceStudySessionType),
        loggedAt: Value(nowSeconds),
      ),
    );
    return update;
  }

  Future<int> _countExposureEvents(String nodeId) async {
    final flashcardLog = _database.flashcardResponseLog;
    final flashcard = _database.flashcard;
    final flashcardCountQuery = _database.selectOnly(flashcardLog).join([
      innerJoin(flashcard, flashcard.id.equalsExp(flashcardLog.flashcardId)),
    ])
      ..addColumns([flashcardLog.id.count()])
      ..where(flashcard.nodeId.equals(nodeId));
    final flashcardCount = await flashcardCountQuery
        .map((row) => row.read(flashcardLog.id.count()) ?? 0)
        .getSingle();

    final multipleChoiceLog = _database.multipleChoiceResponseLog;
    final multipleChoice = _database.multipleChoice;
    final multipleChoiceCountQuery = _database
        .selectOnly(multipleChoiceLog)
        .join([
          innerJoin(
            multipleChoice,
            multipleChoice.id.equalsExp(multipleChoiceLog.multipleChoiceId),
          ),
        ])
      ..addColumns([multipleChoiceLog.id.count()])
      ..where(multipleChoice.nodeId.equals(nodeId));
    final multipleChoiceCount = await multipleChoiceCountQuery
        .map((row) => row.read(multipleChoiceLog.id.count()) ?? 0)
        .getSingle();

    final openEndedLog = _database.openEndedResponseLog;
    final openEnded = _database.openEnded;
    final openEndedCountQuery = _database.selectOnly(openEndedLog).join([
      innerJoin(
        openEnded,
        openEnded.id.equalsExp(openEndedLog.openEndedId),
      ),
    ])
      ..addColumns([openEndedLog.id.count()])
      ..where(openEnded.nodeId.equals(nodeId));
    final openEndedCount = await openEndedCountQuery
        .map((row) => row.read(openEndedLog.id.count()) ?? 0)
        .getSingle();

    return flashcardCount + multipleChoiceCount + openEndedCount;
  }
}
