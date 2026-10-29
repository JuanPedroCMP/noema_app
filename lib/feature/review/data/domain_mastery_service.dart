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
    double? assessmentScore,
    double? retrievability,
  }) {
    if (previousReviewCount < 0) {
      throw ArgumentError.value(previousReviewCount, 'previousReviewCount');
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

    final scoreBefore = previousScore ?? 0.5;
    final ratingEvidence = _ratingEvidence(rating);
    final evidence = assessmentScore == null
        ? ratingEvidence
        : (assessmentScore * 0.8) + (ratingEvidence * 0.2);
    final reviewWeight = 1 / (previousReviewCount.clamp(0, 4) + 1);
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

    final previousReviewCount = await (_database.selectOnly(
      _database.domainLog,
    )..addColumns([_database.domainLog.id.count()])
          ..where(_database.domainLog.nodeId.equals(nodeId)))
        .map((row) => row.read(_database.domainLog.id.count()) ?? 0)
        .getSingle();
    final update = DomainMasteryUpdate.calculate(
      previousScore: node.masteryScore,
      previousReviewCount: previousReviewCount,
      rating: rating,
      assessmentScore: assessmentScore,
      retrievability: retrievability,
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
}
