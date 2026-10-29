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
}
