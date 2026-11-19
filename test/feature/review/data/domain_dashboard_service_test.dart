import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noema/core/database/database.dart';
import 'package:noema/feature/review/data/domain_dashboard_service.dart';

void main() {
  late AppDatabase database;
  late DomainDashboardService service;

  setUp(() async {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    service = DomainDashboardService(database);
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
    for (final node in [
      ('strong', 'STRONG', 0.9),
      ('weak', 'WEAK', 0.3),
      ('unknown', 'UNKNOWN', null),
    ]) {
      await database
          .into(database.graphNode)
          .insert(
            GraphNodeCompanion.insert(
              id: node.$1,
              graphId: 'graph-id',
              type: 'CONCEPT',
              title: node.$2,
              masteryScore: Value(node.$3),
              positionX: 0,
              positionY: 0,
            ),
          );
    }
    await database
        .into(database.graphNode)
        .insert(
          GraphNodeCompanion.insert(
            id: 'target',
            graphId: 'graph-id',
            type: 'CONCEPT',
            title: 'Target',
            positionX: 0,
            positionY: 0,
          ),
        );
    await database
        .into(database.graphEdge)
        .insert(
          GraphEdgeCompanion.insert(
            id: 'edge-id',
            graphId: 'graph-id',
            sourceNodeId: 'weak',
            targetNodeId: 'target',
            type: 'PREREQUISITE',
          ),
        );

    final day = DateTime.utc(2025, 1, 10).millisecondsSinceEpoch ~/ 1000;
    await database
        .into(database.domainLog)
        .insert(
          DomainLogCompanion.insert(
            id: 'domain-log-1',
            nodeId: 'strong',
            scoreBefore: 0.7,
            scoreAfter: 0.8,
            eventOrigin: 'REVISION',
            loggedAt: Value(day),
          ),
        );
    await database
        .into(database.reviewItemState)
        .insert(
          ReviewItemStateCompanion.insert(
            id: 'review-state',
            nodeId: 'strong',
            itemType: 'FLASHCARD',
            itemId: 'flashcard',
            cardStateJson: '{}',
            nextReviewAt: day + Duration.secondsPerDay,
          ),
        );
    await database
        .into(database.reviewItemLog)
        .insert(
          ReviewItemLogCompanion.insert(
            id: 'review-log',
            reviewItemStateId: 'review-state',
            rating: 3,
            durationSeconds: const Value(120),
            score: const Value(0.75),
            reviewMethod: 'AUTO_SCORE',
            retrievability: const Value(0.8),
            scheduledDays: const Value(4),
            reviewedAt: Value(day),
          ),
        );
    await database
        .into(database.domainLog)
        .insert(
          DomainLogCompanion.insert(
            id: 'domain-log-2',
            nodeId: 'strong',
            scoreBefore: 0.8,
            scoreAfter: 0.9,
            eventOrigin: 'REVISION',
            loggedAt: Value(day + Duration.secondsPerDay),
          ),
        );
  });

  tearDown(() async {
    await database.close();
  });

  test('summarizes mastery, weak prerequisites, and recent progress', () async {
    final summary = await service.load(
      userId: 'user-id',
      now: DateTime.utc(2025, 1, 11),
    );

    expect(summary.masteredConcepts, 1);
    expect(summary.fragileConcepts, 1);
    expect(summary.unassessedConcepts, 2);
    expect(summary.criticalPrerequisites, 1);
    expect(summary.recentProgress, hasLength(14));
    expect(
      summary.recentProgress.where((point) => point.averageScore != null),
      hasLength(2),
    );
    expect(summary.recentProgress.last.averageScore, 0.9);
  });

  test('does not expose another user’s domain data', () async {
    final summary = await service.load(
      userId: 'someone-else',
      now: DateTime.utc(2025, 1, 11),
    );

    expect(summary.masteredConcepts, 0);
    expect(summary.fragileConcepts, 0);
    expect(summary.unassessedConcepts, 0);
    expect(summary.criticalPrerequisites, 0);
    expect(summary.recentProgress, hasLength(14));
    expect(
      summary.recentProgress.every((point) => point.averageScore == null),
      isTrue,
    );
  });

  test('filters dashboard metrics by node and selected period', () async {
    final summary = await service.load(
      userId: 'user-id',
      now: DateTime.utc(2025, 1, 11),
      query: DomainDashboardQuery(
        graphId: 'graph-id',
        nodeId: 'strong',
        startAt: DateTime.utc(2025, 1, 10),
        endBefore: DateTime.utc(2025, 1, 11),
      ),
    );

    expect(summary.nodePerformance, hasLength(1));
    expect(summary.nodePerformance.single.nodeId, 'strong');
    expect(summary.reviewCount, 1);
    expect(summary.averageAccuracy, 0.75);
    expect(summary.averageRetrievability, 0.8);
    expect(summary.averageScheduledDays, 4);
    expect(summary.ratingCounts[3], 1);
    expect(summary.activeReviewDays, 1);
    expect(summary.recentProgress, hasLength(1));
    expect(summary.recentProgress.single.averageScore, 0.8);
  });
}
