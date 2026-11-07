import 'dart:async';

import 'package:drift/drift.dart';
import 'package:noema/core/database/database.dart';

class DomainDashboardPoint {
  const DomainDashboardPoint({required this.date, required this.averageScore});

  final DateTime date;
  final double? averageScore;
}

class DomainDashboardSummary {
  const DomainDashboardSummary({
    required this.masteredConcepts,
    required this.fragileConcepts,
    required this.unassessedConcepts,
    required this.criticalPrerequisites,
    required this.recentProgress,
    required this.graphCount,
    required this.averageMastery,
    required this.reviewCount,
    required this.averageAccuracy,
    required this.sessionMinutes,
    required this.reviewMinutes,
    required this.nodePerformance,
    required this.graphPerformance,
    required this.recentActivity,
  });

  final int masteredConcepts;
  final int fragileConcepts;
  final int unassessedConcepts;
  final int criticalPrerequisites;
  final List<DomainDashboardPoint> recentProgress;
  final int graphCount;
  final double? averageMastery;
  final int reviewCount;
  final double? averageAccuracy;
  final int sessionMinutes;
  final int reviewMinutes;
  final List<DashboardNodeMetric> nodePerformance;
  final List<DashboardGraphMetric> graphPerformance;
  final List<DashboardActivity> recentActivity;
}

class DashboardNodeMetric {
  const DashboardNodeMetric({
    required this.nodeTitle,
    required this.graphTitle,
    required this.masteryScore,
    required this.reviewCount,
    required this.averageAccuracy,
  });

  final String nodeTitle;
  final String graphTitle;
  final double? masteryScore;
  final int reviewCount;
  final double? averageAccuracy;
}

class DashboardGraphMetric {
  const DashboardGraphMetric({
    required this.graphTitle,
    required this.nodeCount,
    required this.averageMastery,
  });

  final String graphTitle;
  final int nodeCount;
  final double? averageMastery;
}

class DashboardActivity {
  const DashboardActivity({
    required this.nodeTitle,
    required this.graphTitle,
    required this.score,
    required this.loggedAt,
    required this.eventOrigin,
    required this.activityType,
  });

  final String nodeTitle;
  final String graphTitle;
  final double score;
  final DateTime loggedAt;
  final String eventOrigin;
  final String activityType;
}

class DomainDashboardService {
  DomainDashboardService(this._database);

  final AppDatabase _database;

  Future<DomainDashboardSummary> load({
    required String userId,
    DateTime? now,
  }) async {
    final currentTime = now ?? DateTime.now();
    final nodeQuery = _database.select(_database.graphNode).join([
      innerJoin(
        _database.knowledgeGraph,
        _database.knowledgeGraph.id.equalsExp(_database.graphNode.graphId),
      ),
    ])
      ..where(
        _database.knowledgeGraph.userId.equals(userId) &
            _database.knowledgeGraph.softDeleted.equals(false) &
            _database.graphNode.softDeleted.equals(false),
      );
    final nodeRows = await nodeQuery.get();
    final graphRows =
        await (_database.select(_database.knowledgeGraph)
              ..where(
                (graph) =>
                    graph.userId.equals(userId) &
                    graph.softDeleted.equals(false),
              ))
            .get();
    final nodes = {
      for (final row in nodeRows)
        row.readTable(_database.graphNode).id: row.readTable(_database.graphNode),
    };
    final graphs = <String, KnowledgeGraphData>{
      for (final graph in graphRows) graph.id: graph,
    };

    final criticalPrerequisites = await _countCriticalPrerequisites(
      nodes: nodes,
      userId: userId,
    );
    final recentProgress = await _loadRecentProgress(
      userId: userId,
      now: currentTime,
    );
    final reviewRows = await _loadReviewRows(userId);
    final reviewsByNode = <String, List<ReviewItemLogData>>{};
    for (final row in reviewRows) {
      reviewsByNode.putIfAbsent(row.nodeId, () => []).add(row.log);
    }
    final nodeMetrics = [
      for (final node in nodes.values)
        DashboardNodeMetric(
          nodeTitle: node.title,
          graphTitle: graphs[node.graphId]?.title ?? 'Grafo',
          masteryScore: node.masteryScore,
          reviewCount: reviewsByNode[node.id]?.length ?? 0,
          averageAccuracy: _averageScore(reviewsByNode[node.id] ?? const []),
        ),
    ]..sort((a, b) {
      final aScore = a.masteryScore ?? -1;
      final bScore = b.masteryScore ?? -1;
      final scoreOrder = aScore.compareTo(bScore);
      return scoreOrder != 0 ? scoreOrder : a.nodeTitle.compareTo(b.nodeTitle);
    });
    final nodesByGraph = <String, List<GraphNodeData>>{
      for (final graphId in graphs.keys) graphId: <GraphNodeData>[],
    };
    for (final node in nodes.values) {
      nodesByGraph.putIfAbsent(node.graphId, () => []).add(node);
    }
    final graphMetrics = [
      for (final entry in nodesByGraph.entries)
        DashboardGraphMetric(
          graphTitle: graphs[entry.key]?.title ?? 'Grafo',
          nodeCount: entry.value.length,
          averageMastery: _averageMastery(entry.value),
        ),
    ]..sort((a, b) {
      final aScore = a.averageMastery ?? -1;
      final bScore = b.averageMastery ?? -1;
      return aScore.compareTo(bScore);
    });
    final sessionMinutes = await _loadRecordedSessionMinutes(userId);
    final activity = await _loadRecentActivity(userId);
    final reviewScores = reviewRows
        .map((row) => row.log.score)
        .whereType<double>()
        .where((score) => score.isFinite)
        .toList();
    return DomainDashboardSummary(
      masteredConcepts: nodes.values
          .where((node) => (node.masteryScore ?? -1) >= 0.8)
          .length,
      fragileConcepts: nodes.values
          .where(
            (node) => node.masteryScore != null && node.masteryScore! < 0.5,
          )
          .length,
      unassessedConcepts: nodes.values
          .where((node) => node.masteryScore == null)
          .length,
      criticalPrerequisites: criticalPrerequisites,
      recentProgress: recentProgress,
      graphCount: graphs.length,
      averageMastery: _averageMastery(nodes.values.toList()),
      reviewCount: reviewRows.length,
      averageAccuracy: reviewScores.isEmpty
          ? null
          : reviewScores.reduce((a, b) => a + b) / reviewScores.length,
      sessionMinutes: sessionMinutes,
      reviewMinutes:
          reviewRows.fold<int>(0, (sum, row) => sum + row.log.durationSeconds) ~/
          60,
      nodePerformance: List.unmodifiable(nodeMetrics),
      graphPerformance: List.unmodifiable(graphMetrics),
      recentActivity: activity,
    );
  }

  Stream<DomainDashboardSummary> watch({required String userId}) {
    return Stream<DomainDashboardSummary>.multi((controller) {
      final subscriptions = <StreamSubscription<dynamic>>[];
      var isLoading = false;
      var needsRefresh = false;
      var isCanceled = false;

      void refresh() {
        if (isCanceled) return;
        if (isLoading) {
          needsRefresh = true;
          return;
        }
        isLoading = true;
        unawaited(() async {
          do {
            needsRefresh = false;
            try {
              controller.add(await load(userId: userId));
            } catch (error, stackTrace) {
              controller.addError(error, stackTrace);
            }
          } while (needsRefresh && !isCanceled);
          isLoading = false;
        }());
      }

      subscriptions.add(
        _database.select(_database.graphNode).watch().listen((_) => refresh()),
      );
      subscriptions.add(
        _database
            .select(_database.knowledgeGraph)
            .watch()
            .listen((_) => refresh()),
      );
      subscriptions.add(
        _database.select(_database.graphEdge).watch().listen((_) => refresh()),
      );
      subscriptions.add(
        _database.select(_database.domainLog).watch().listen((_) => refresh()),
      );
      subscriptions.add(
        _database.select(_database.reviewItemLog).watch().listen((_) => refresh()),
      );
      subscriptions.add(
        _database.select(_database.studySessionLog).watch().listen((_) => refresh()),
      );
      refresh();

      controller.onCancel = () async {
        isCanceled = true;
        await Future.wait(
          subscriptions.map((subscription) => subscription.cancel()),
        );
      };
    });
  }

  Future<int> _countCriticalPrerequisites({
    required Map<String, GraphNodeData> nodes,
    required String userId,
  }) async {
    if (nodes.isEmpty) return 0;
    final source = _database.graphNode;
    final edge = _database.graphEdge;
    final graph = _database.knowledgeGraph;
    final query = _database.select(edge).join([
      innerJoin(source, source.id.equalsExp(edge.sourceNodeId)),
      innerJoin(graph, graph.id.equalsExp(source.graphId)),
    ])
      ..where(
        edge.type.isIn(['PREREQUISITE', 'SUBTOPIC']) &
            graph.userId.equals(userId) &
            graph.softDeleted.equals(false) &
            source.softDeleted.equals(false),
      );
    final rows = await query.get();
    final criticalTargets = <String>{};
    for (final row in rows) {
      final relation = row.readTable(edge);
      final prerequisite = relation.type == 'SUBTOPIC'
          ? nodes[relation.targetNodeId]
          : row.readTable(source);
      final targetId = relation.type == 'SUBTOPIC'
          ? relation.sourceNodeId
          : relation.targetNodeId;
      if (prerequisite == null) continue;
      if (!nodes.containsKey(targetId)) continue;
      if (prerequisite.masteryScore == null ||
          prerequisite.masteryScore! < 0.6) {
        criticalTargets.add(targetId);
      }
    }
    return criticalTargets.length;
  }

  Future<List<DomainDashboardPoint>> _loadRecentProgress({
    required String userId,
    required DateTime now,
  }) async {
    final startOfToday = DateTime.utc(now.year, now.month, now.day);
    final firstDay = startOfToday.subtract(const Duration(days: 13));
    final graphNode = _database.graphNode;
    final graph = _database.knowledgeGraph;
    final domainLog = _database.domainLog;
    final query = _database.select(domainLog).join([
      innerJoin(graphNode, graphNode.id.equalsExp(domainLog.nodeId)),
      innerJoin(graph, graph.id.equalsExp(graphNode.graphId)),
    ])
      ..where(
        graph.userId.equals(userId) &
            graph.softDeleted.equals(false) &
            domainLog.loggedAt.isBiggerOrEqualValue(
              firstDay.millisecondsSinceEpoch ~/ 1000,
            ),
      )
      ..orderBy([OrderingTerm.asc(domainLog.loggedAt)]);
    final rows = await query.get();
    final scoresByDay = <DateTime, List<double>>{};
    for (final row in rows) {
      final loggedAt = row.readTable(domainLog).loggedAt;
      final date = DateTime.fromMillisecondsSinceEpoch(
        loggedAt * 1000,
        isUtc: true,
      );
      final day = DateTime.utc(date.year, date.month, date.day);
      scoresByDay.putIfAbsent(day, () => []).add(
        row.readTable(domainLog).scoreAfter,
      );
    }

    return List.generate(14, (index) {
      final date = firstDay.add(Duration(days: index));
      final scores = scoresByDay[date];
      if (scores == null || scores.isEmpty) {
        return DomainDashboardPoint(date: date, averageScore: null);
      }
      final average = scores.reduce((sum, score) => sum + score) / scores.length;
      return DomainDashboardPoint(date: date, averageScore: average);
    });
  }

  Future<List<({String nodeId, ReviewItemLogData log})>> _loadReviewRows(
    String userId,
  ) async {
    final log = _database.reviewItemLog;
    final state = _database.reviewItemState;
    final node = _database.graphNode;
    final graph = _database.knowledgeGraph;
    final rows = await (_database.select(log).join([
      innerJoin(state, state.id.equalsExp(log.reviewItemStateId)),
      innerJoin(node, node.id.equalsExp(state.nodeId)),
      innerJoin(graph, graph.id.equalsExp(node.graphId)),
    ])..where(
      graph.userId.equals(userId) &
          graph.softDeleted.equals(false) &
          node.softDeleted.equals(false),
    )).get();
    return [
      for (final row in rows)
        (nodeId: row.readTable(node).id, log: row.readTable(log)),
    ];
  }

  double? _averageScore(List<ReviewItemLogData> reviews) {
    final scores = reviews
        .map((review) => review.score)
        .whereType<double>()
        .where((score) => score.isFinite)
        .toList();
    if (scores.isEmpty) return null;
    return scores.reduce((a, b) => a + b) / scores.length;
  }

  double? _averageMastery(List<GraphNodeData> nodes) {
    final scores = nodes
        .map((node) => node.masteryScore)
        .whereType<double>()
        .where((score) => score.isFinite)
        .toList();
    if (scores.isEmpty) return null;
    return scores.reduce((a, b) => a + b) / scores.length;
  }

  Future<int> _loadRecordedSessionMinutes(String userId) async {
    final session = _database.studySession;
    final log = _database.studySessionLog;
    final rows = await (_database.select(log).join([
      innerJoin(session, session.id.equalsExp(log.studySessionId)),
    ])..where(
      session.userId.equals(userId) &
          session.softDeleted.equals(false) &
          log.actualDurationMin.isNotNull(),
    )).get();
    return rows.fold<int>(
      0,
      (sum, row) => sum + (row.readTable(log).actualDurationMin ?? 0),
    );
  }

  Future<List<DashboardActivity>> _loadRecentActivity(String userId) async {
    final domainLog = _database.domainLog;
    final node = _database.graphNode;
    final graph = _database.knowledgeGraph;
    final rows =
        await (_database.select(domainLog).join([
              innerJoin(node, node.id.equalsExp(domainLog.nodeId)),
              innerJoin(graph, graph.id.equalsExp(node.graphId)),
            ])
              ..where(
                graph.userId.equals(userId) &
                    graph.softDeleted.equals(false) &
                    node.softDeleted.equals(false),
              )
              ..orderBy([OrderingTerm.desc(domainLog.loggedAt)])
              ..limit(12))
            .get();
    return [
      for (final row in rows)
        DashboardActivity(
          nodeTitle: row.readTable(node).title,
          graphTitle: row.readTable(graph).title,
          score: row.readTable(domainLog).scoreAfter,
          loggedAt: DateTime.fromMillisecondsSinceEpoch(
            row.readTable(domainLog).loggedAt * 1000,
            isUtc: true,
          ).toLocal(),
          eventOrigin: row.readTable(domainLog).eventOrigin,
          activityType: row.readTable(domainLog).sourceStudySessionType ?? '',
        ),
    ];
  }
}
