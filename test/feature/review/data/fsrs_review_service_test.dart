import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fsrs/fsrs.dart' as fsrs;
import 'package:noema/core/database/database.dart';
import 'package:noema/feature/review/data/fsrs_review_service.dart';

void main() {
  late AppDatabase database;
  late FsrsReviewService service;

  setUp(() async {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    service = FsrsReviewService(database);

    await database
        .into(database.appUser)
        .insert(
          AppUserCompanion.insert(
            id: 'user-id',
            remoteId: 'remote-user-id',
            userName: 'student',
            displayName: 'Student',
            primaryEmail: 'student@example.com',
            lastSeenAt: 0,
          ),
        );
    await database
        .into(database.knowledgeGraph)
        .insert(
          KnowledgeGraphCompanion.insert(
            id: 'graph-id',
            userId: 'user-id',
            title: 'Graph',
          ),
        );
    await database
        .into(database.graphNode)
        .insert(
          GraphNodeCompanion.insert(
            id: 'node-id',
            graphId: 'graph-id',
            type: 'CONCEPT',
            title: 'Node',
            positionX: 0,
            positionY: 0,
          ),
        );
  });

  tearDown(() async {
    await database.close();
  });

  test('schedules and persists a review for an individual item', () async {
    final reviewedAt = DateTime.utc(2025, 1, 1);
    expect(
      await service.isDue(
        itemType: ReviewItemType.openEnded,
        itemId: 'question-id',
        now: reviewedAt,
      ),
      isTrue,
    );

    final result = await service.review(
      itemType: ReviewItemType.openEnded,
      itemId: 'question-id',
      nodeId: 'node-id',
      rating: fsrs.Rating.good,
      durationSeconds: 42,
      method: ReviewMethod.manualCorrection,
      score: 0.8,
      sourceResponseId: 'response-id',
      reviewedAt: reviewedAt,
    );

    expect(result.dueAt.isAfter(reviewedAt), isTrue);
    expect(result.scheduledDays, greaterThanOrEqualTo(0));
    expect(result.retrievabilityBeforeReview, isNull);
    expect(
      await service.isDue(
        itemType: ReviewItemType.openEnded,
        itemId: 'question-id',
        now: reviewedAt,
      ),
      isFalse,
    );

    final state = await database.select(database.reviewItemState).getSingle();
    final log = await database.select(database.reviewItemLog).getSingle();
    expect(state.itemType, ReviewItemType.openEnded.databaseValue);
    expect(state.itemId, 'question-id');
    expect(state.nextReviewAt, result.dueAt.millisecondsSinceEpoch ~/ 1000);
    expect(log.rating, fsrs.Rating.good.value);
    expect(log.durationSeconds, 42);
    expect(log.score, 0.8);
    expect(log.reviewMethod, ReviewMethod.manualCorrection.databaseValue);
    expect(log.sourceResponseId, 'response-id');
    expect(log.scheduledDays, result.scheduledDays);
  });

  test('uses previous card state for the next review', () async {
    final firstReview = DateTime.utc(2025, 1, 1);
    final firstResult = await service.review(
      itemType: ReviewItemType.multipleChoice,
      itemId: 'question-id',
      nodeId: 'node-id',
      rating: fsrs.Rating.good,
      durationSeconds: 15,
      method: ReviewMethod.autoScore,
      score: 1,
      reviewedAt: firstReview,
    );

    final secondReview = firstResult.dueAt.add(const Duration(minutes: 2));
    final secondResult = await service.review(
      itemType: ReviewItemType.multipleChoice,
      itemId: 'question-id',
      nodeId: 'node-id',
      rating: fsrs.Rating.hard,
      durationSeconds: 30,
      method: ReviewMethod.autoScore,
      score: 0.5,
      reviewedAt: secondReview,
    );

    expect(secondResult.retrievabilityBeforeReview, isNotNull);
    expect(secondResult.dueAt.isAfter(secondReview), isTrue);
    expect(await database.select(database.reviewItemLog).get(), hasLength(2));
  });

  test('rejects invalid review inputs without persisting state', () async {
    await expectLater(
      service.review(
        itemType: ReviewItemType.flashcard,
        itemId: 'card-id',
        nodeId: 'node-id',
        rating: fsrs.Rating.easy,
        durationSeconds: -1,
        method: ReviewMethod.selfRating,
      ),
      throwsArgumentError,
    );
    await expectLater(
      service.review(
        itemType: ReviewItemType.flashcard,
        itemId: 'card-id',
        nodeId: 'node-id',
        rating: fsrs.Rating.easy,
        durationSeconds: 1,
        method: ReviewMethod.selfRating,
        score: 1.1,
      ),
      throwsArgumentError,
    );
    expect(await database.select(database.reviewItemState).get(), isEmpty);
    expect(await database.select(database.reviewItemLog).get(), isEmpty);
  });
}
