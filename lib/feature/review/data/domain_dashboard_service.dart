import 'dart:async';

import 'package:drift/drift.dart';
import 'package:noema/core/database/database.dart';

class DomainDashboardPoint {
  const DomainDashboardPoint({required this.date, required this.averageScore});

  final DateTime date;
  final double? averageScore;
}

class DashboardReviewPoint {
  const DashboardReviewPoint({
    required this.date,
    required this.reviewCount,
    required this.averageAccuracy,
  });

  final DateTime date;
  final int reviewCount;
  final double? averageAccuracy;
}

class DashboardGraphOption {
  const DashboardGraphOption({
    required this.id,
    required this.title,
    required this.nodeCount,
  });

  final String id;
  final String title;
  final int nodeCount;
}

class DashboardNodeOption {
  const DashboardNodeOption({
    required this.id,
    required this.graphId,
    required this.title,
  });

  final String id;
  final String graphId;
  final String title;
}

class DomainDashboardQuery {
  const DomainDashboardQuery({
    this.graphId,
    this.nodeId,
    this.startAt,
    this.endBefore,
    this.allTime = false,
  });

  final String? graphId;
  final String? nodeId;
  final DateTime? startAt;
  final DateTime? endBefore;
  final bool allTime;

  @override
  bool operator ==(Object other) =>
      other is DomainDashboardQuery &&
      other.graphId == graphId &&
      other.nodeId == nodeId &&
      other.startAt == startAt &&
      other.endBefore == endBefore &&
      other.allTime == allTime;

  @override
  int get hashCode => Object.hash(graphId, nodeId, startAt, endBefore, allTime);
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
    required this.averageRetrievability,
    required this.averageScheduledDays,
    required this.ratingCounts,
    required this.reviewFrequency,
    required this.activeReviewDays,
    required this.sessionMinutes,
    required this.sessionCount,
    required this.reviewMinutes,
    required this.nodePerformance,
    required this.graphPerformance,
    required this.availableGraphs,
    required this.availableNodes,
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
  final double? averageRetrievability;
  final double? averageScheduledDays;
  final Map<int, int> ratingCounts;
  final List<DashboardReviewPoint> reviewFrequency;
  final int activeReviewDays;
  final int sessionMinutes;
  final int sessionCount;
  final int reviewMinutes;
  final List<DashboardNodeMetric> nodePerformance;
  final List<DashboardGraphMetric> graphPerformance;
  final List<DashboardGraphOption> availableGraphs;
  final List<DashboardNodeOption> availableNodes;
  final List<DashboardActivity> recentActivity;
}

class DashboardNodeMetric {
  const DashboardNodeMetric({
    required this.nodeId,
    required this.nodeTitle,
    required this.graphId,
    required this.graphTitle,
    required this.masteryScore,
    required this.reviewCount,
    required this.averageAccuracy,
  });

  final String nodeId;
  final String nodeTitle;
  final String graphId;
  final String graphTitle;
  final double? masteryScore;
  final int reviewCount;
  final double? averageAccuracy;
}

class DashboardGraphMetric {
  const DashboardGraphMetric({
    required this.graphId,
    required this.graphTitle,
    required this.nodeCount,
    required this.averageMastery,
  });

  final String graphId;
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
    DomainDashboardQuery? query,
  }) async {
    final currentTime = (now ?? DateTime.now()).toUtc();
    final startOfToday = DateTime.utc(
      currentTime.year,
      currentTime.month,
      currentTime.day,
    );
    final effectiveQuery =
        query ??
        DomainDashboardQuery(
          startAt: startOfToday.subtract(const Duration(days: 13)),
          endBefore: startOfToday.add(const Duration(days: 1)),
        );
    final nodeQuery =
        _database.select(_database.graphNode).join([
          innerJoin(
            _database.knowledgeGraph,
            _database.knowledgeGraph.id.equalsExp(_database.graphNode.graphId),
          ),
        ])..where(
          _database.knowledgeGraph.userId.equals(userId) &
              _database.knowledgeGraph.softDeleted.equals(false) &
              _database.graphNode.softDeleted.equals(false),
        );
    final nodeRows = await nodeQuery.get();
    final graphRows =
        await (_database.select(_database.knowledgeGraph)..where(
              (graph) =>
                  graph.userId.equals(userId) & graph.softDeleted.equals(false),
            ))
            .get();
    final nodes = {
      for (final row in nodeRows)
        row.readTable(_database.graphNode).id: row.readTable(
          _database.graphNode,
        ),
    };
    final graphs = <String, KnowledgeGraphData>{
      for (final graph in graphRows) graph.id: graph,
    };
    final scopedNodes = {
      for (final node in nodes.values)
        if ((effectiveQuery.graphId == null ||
                node.graphId == effectiveQuery.graphId) &&
            (effectiveQuery.nodeId == null || node.id == effectiveQuery.nodeId))
          node.id: node,
    };
    final scopedGraphs = graphs.entries
        .where(
          (entry) =>
              (effectiveQuery.graphId == null ||
                  entry.key == effectiveQuery.graphId) &&
              (effectiveQuery.nodeId == null ||
                  scopedNodes.values.any((node) => node.graphId == entry.key)),
        )
        .map((entry) => MapEntry(entry.key, entry.value))
        .toList();
    final scopedGraphMap = Map<String, KnowledgeGraphData>.fromEntries(
      scopedGraphs,
    );
    final scopedNodeIds = scopedNodes.keys.toSet();

    final criticalPrerequisites = await _countCriticalPrerequisites(
      nodes: nodes,
      targetNodeIds: scopedNodes.keys.toSet(),
      userId: userId,
    );
    final recentProgress = await _loadRecentProgress(
      userId: userId,
      now: currentTime,
      query: effectiveQuery,
    );
    final reviewRows = await _loadReviewRows(
      userId,
      nodeIds: scopedNodeIds,
      query: effectiveQuery,
    );
    final reviewsByNode = <String, List<ReviewItemLogData>>{};
    for (final row in reviewRows) {
      reviewsByNode.putIfAbsent(row.nodeId, () => []).add(row.log);
    }
    final nodeMetrics =
        [
          for (final node in scopedNodes.values)
            DashboardNodeMetric(
              nodeId: node.id,
              nodeTitle: node.title,
              graphId: node.graphId,
              graphTitle: graphs[node.graphId]?.title ?? 'Grafo',
              masteryScore: node.masteryScore,
              reviewCount: reviewsByNode[node.id]?.length ?? 0,
              averageAccuracy: _averageScore(
                reviewsByNode[node.id] ?? const [],
              ),
            ),
        ]..sort((a, b) {
          final aScore = a.masteryScore ?? -1;
          final bScore = b.masteryScore ?? -1;
          final scoreOrder = aScore.compareTo(bScore);
          return scoreOrder != 0
              ? scoreOrder
              : a.nodeTitle.compareTo(b.nodeTitle);
        });
    final nodesByGraph = <String, List<GraphNodeData>>{
      for (final graphId in scopedGraphMap.keys) graphId: <GraphNodeData>[],
    };
    for (final node in scopedNodes.values) {
      nodesByGraph.putIfAbsent(node.graphId, () => []).add(node);
    }
    final graphMetrics =
        [
          for (final entry in nodesByGraph.entries)
            DashboardGraphMetric(
              graphId: entry.key,
              graphTitle: scopedGraphMap[entry.key]?.title ?? 'Grafo',
              nodeCount: entry.value.length,
              averageMastery: _averageMastery(entry.value),
            ),
        ]..sort((a, b) {
          final aScore = a.averageMastery ?? -1;
          final bScore = b.averageMastery ?? -1;
          return aScore.compareTo(bScore);
        });
    final sessionStats = await _loadRecordedSessionStats(
      userId,
      query: effectiveQuery,
      nodeIds: scopedNodeIds,
    );
    final activity = await _loadRecentActivity(
      userId,
      nodeIds: scopedNodeIds,
      query: effectiveQuery,
    );
    final reviewScores = reviewRows
        .map((row) => row.log.score)
        .whereType<double>()
        .where((score) => score.isFinite)
        .toList();
    final retrievabilities = reviewRows
        .map((row) => row.log.retrievability)
        .whereType<double>()
        .where((value) => value.isFinite)
        .toList();
    final scheduledDays = reviewRows
        .map((row) => row.log.scheduledDays)
        .toList();
    final ratingCounts = <int, int>{
      for (var rating = 1; rating <= 4; rating++) rating: 0,
    };
    for (final row in reviewRows) {
      ratingCounts.update(
        row.log.rating,
        (count) => count + 1,
        ifAbsent: () => 1,
      );
    }
    final reviewFrequency = _buildReviewFrequency(
      reviewRows,
      effectiveQuery,
      currentTime,
    );
    final activeReviewDays = {
      for (final row in reviewRows)
        _utcDay(
          DateTime.fromMillisecondsSinceEpoch(
            row.log.reviewedAt * 1000,
            isUtc: true,
          ),
        ),
    }.length;
    final availableGraphs = [
        for (final graph in graphRows)
          DashboardGraphOption(
            id: graph.id,
            title: graph.title,
            nodeCount: nodes.values
                .where((node) => node.graphId == graph.id)
                .length,
          ),
    ]..sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
    final availableNodes = [
        for (final node in nodes.values)
          DashboardNodeOption(
            id: node.id,
            graphId: node.graphId,
            title: node.title,
          ),
    ]..sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
    return DomainDashboardSummary(
      masteredConcepts: scopedNodes.values
          .where((node) => (node.masteryScore ?? -1) >= 0.8)
          .length,
      fragileConcepts: scopedNodes.values
          .where(
            (node) => node.masteryScore != null && node.masteryScore! < 0.5,
          )
          .length,
      unassessedConcepts: scopedNodes.values
          .where((node) => node.masteryScore == null)
          .length,
      criticalPrerequisites: criticalPrerequisites,
      recentProgress: recentProgress,
      graphCount: scopedGraphMap.length,
      averageMastery: _averageMastery(scopedNodes.values.toList()),
      reviewCount: reviewRows.length,
      averageAccuracy: reviewScores.isEmpty
          ? null
          : reviewScores.reduce((a, b) => a + b) / reviewScores.length,
      averageRetrievability: retrievabilities.isEmpty
          ? null
          : retrievabilities.reduce((a, b) => a + b) / retrievabilities.length,
      averageScheduledDays: scheduledDays.isEmpty
          ? null
          : scheduledDays.reduce((a, b) => a + b) / scheduledDays.length,
      ratingCounts: Map.unmodifiable(ratingCounts),
      reviewFrequency: List.unmodifiable(reviewFrequency),
      activeReviewDays: activeReviewDays,
      sessionMinutes: sessionStats.minutes,
      sessionCount: sessionStats.count,
      reviewMinutes:
          reviewRows.fold<int>(
            0,
            (sum, row) => sum + row.log.durationSeconds,
          ) ~/
          60,
      nodePerformance: List.unmodifiable(nodeMetrics),
      graphPerformance: List.unmodifiable(graphMetrics),
      availableGraphs: List.unmodifiable(availableGraphs),
      availableNodes: List.unmodifiable(availableNodes),
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
        _database
            .select(_database.reviewItemLog)
            .watch()
            .listen((_) => refresh()),
      );
      subscriptions.add(
        _database
            .select(_database.studySessionLog)
            .watch()
            .listen((_) => refresh()),
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
    required Set<String> targetNodeIds,
    required String userId,
  }) async {
    if (targetNodeIds.isEmpty) return 0;
    final source = _database.graphNode;
    final edge = _database.graphEdge;
    final graph = _database.knowledgeGraph;
    final query =
        _database.select(edge).join([
          innerJoin(source, source.id.equalsExp(edge.sourceNodeId)),
          innerJoin(graph, graph.id.equalsExp(source.graphId)),
        ])..where(
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
      if (!targetNodeIds.contains(targetId)) continue;
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
    required DomainDashboardQuery query,
  }) async {
    final graphNode = _database.graphNode;
    final graph = _database.knowledgeGraph;
    final domainLog = _database.domainLog;
    final statement = _database.select(domainLog).join([
      innerJoin(graphNode, graphNode.id.equalsExp(domainLog.nodeId)),
      innerJoin(graph, graph.id.equalsExp(graphNode.graphId)),
    ])..orderBy([OrderingTerm.asc(domainLog.loggedAt)]);
    var condition =
        graph.userId.equals(userId) &
        graph.softDeleted.equals(false) &
        graphNode.softDeleted.equals(false);
    if (query.graphId != null) {
      condition = condition & graph.id.equals(query.graphId!);
    }
    if (query.nodeId != null) {
      condition = condition & graphNode.id.equals(query.nodeId!);
    }
    if (query.startAt != null) {
      condition =
          condition &
          domainLog.loggedAt.isBiggerOrEqualValue(
            query.startAt!.millisecondsSinceEpoch ~/ 1000,
          );
    }
    if (query.endBefore != null) {
      condition =
          condition &
          domainLog.loggedAt.isSmallerThanValue(
            query.endBefore!.millisecondsSinceEpoch ~/ 1000,
          );
    }
    statement.where(condition);
    final rows = await statement.get();
    final scoresByDay = <DateTime, List<double>>{};
    for (final row in rows) {
      final loggedAt = row.readTable(domainLog).loggedAt;
      final date = DateTime.fromMillisecondsSinceEpoch(
        loggedAt * 1000,
        isUtc: true,
      );
      final day = DateTime.utc(date.year, date.month, date.day);
      scoresByDay
          .putIfAbsent(day, () => [])
          .add(row.readTable(domainLog).scoreAfter);
    }

    final today = DateTime.utc(now.year, now.month, now.day);
    final firstLoggedDay = scoresByDay.keys.isEmpty
        ? null
        : scoresByDay.keys.reduce((a, b) => a.isBefore(b) ? a : b);
    final firstDay = query.allTime && firstLoggedDay != null
        ? firstLoggedDay
        : query.startAt == null
        ? today.subtract(const Duration(days: 13))
        : DateTime.utc(
            query.startAt!.year,
            query.startAt!.month,
            query.startAt!.day,
          );
    final lastDay = query.endBefore == null
        ? today
        : DateTime.utc(
            query.endBefore!.year,
            query.endBefore!.month,
            query.endBefore!.day,
          ).subtract(const Duration(days: 1));
    final dayCount = lastDay.difference(firstDay).inDays + 1;
    if (dayCount <= 0) return const [];
    final bucketDays = dayCount <= 90
        ? 1
        : dayCount <= 365
        ? 7
        : 30;
    final bucketScores = <int, List<double>>{};
    for (final entry in scoresByDay.entries) {
      final index = entry.key.difference(firstDay).inDays ~/ bucketDays;
      if (index >= 0) {
        bucketScores.putIfAbsent(index, () => []).addAll(entry.value);
      }
    }
    final pointCount = (dayCount - 1) ~/ bucketDays + 1;
    return List.generate(pointCount, (index) {
      final scores = bucketScores[index];
      final average = scores == null || scores.isEmpty
          ? null
          : scores.reduce((sum, score) => sum + score) / scores.length;
      return DomainDashboardPoint(
        date: firstDay.add(Duration(days: index * bucketDays)),
        averageScore: average,
      );
    });
  }

  Future<List<({String nodeId, ReviewItemLogData log})>> _loadReviewRows(
    String userId, {
    required Set<String> nodeIds,
    required DomainDashboardQuery query,
  }) async {
    if ((query.graphId != null || query.nodeId != null) && nodeIds.isEmpty) {
      return const [];
    }
    final log = _database.reviewItemLog;
    final state = _database.reviewItemState;
    final node = _database.graphNode;
    final graph = _database.knowledgeGraph;
    final statement = _database.select(log).join([
      innerJoin(state, state.id.equalsExp(log.reviewItemStateId)),
      innerJoin(node, node.id.equalsExp(state.nodeId)),
      innerJoin(graph, graph.id.equalsExp(node.graphId)),
    ]);
    var condition =
        graph.userId.equals(userId) &
        graph.softDeleted.equals(false) &
        node.softDeleted.equals(false);
    if (query.graphId != null) {
      condition = condition & graph.id.equals(query.graphId!);
    }
    if (query.nodeId != null) {
      condition = condition & node.id.equals(query.nodeId!);
    }
    if (query.startAt != null) {
      condition =
          condition &
          log.reviewedAt.isBiggerOrEqualValue(
            query.startAt!.millisecondsSinceEpoch ~/ 1000,
          );
    }
    if (query.endBefore != null) {
      condition =
          condition &
          log.reviewedAt.isSmallerThanValue(
            query.endBefore!.millisecondsSinceEpoch ~/ 1000,
          );
    }
    statement.where(condition);
    final rows = await statement.get();
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

  Future<({int minutes, int count})> _loadRecordedSessionStats(
    String userId, {
    required DomainDashboardQuery query,
    required Set<String> nodeIds,
  }) async {
    final session = _database.studySession;
    final log = _database.studySessionLog;
    Set<String>? allowedSessionIds;
    if (query.graphId != null || query.nodeId != null) {
      allowedSessionIds = {};
      if (query.nodeId != null) {
        final nodeRows = await (_database.select(
          _database.sessionNode,
        )..where((relation) => relation.nodeId.equals(query.nodeId!))).get();
        allowedSessionIds.addAll(nodeRows.map((row) => row.studySessionId));
      } else if (query.graphId != null) {
        final graphRows = await (_database.select(
          _database.studySessionUseKnowledgeGraph,
        )..where((use) => use.graphId.equals(query.graphId!))).get();
        allowedSessionIds.addAll(graphRows.map((row) => row.studySessionId));
      }
      if (query.nodeId == null && nodeIds.isNotEmpty) {
        final nodeRows = await (_database.select(
          _database.sessionNode,
        )..where((relation) => relation.nodeId.isIn(nodeIds))).get();
        allowedSessionIds.addAll(nodeRows.map((row) => row.studySessionId));
      }
      if (allowedSessionIds.isEmpty) return (minutes: 0, count: 0);
    }
    final statement = _database.select(log).join([
      innerJoin(session, session.id.equalsExp(log.studySessionId)),
    ]);
    var condition =
        session.userId.equals(userId) &
        session.softDeleted.equals(false) &
        log.actualDurationMin.isNotNull();
    if (allowedSessionIds != null) {
      condition = condition & session.id.isIn(allowedSessionIds);
    }
    if (query.startAt != null) {
      condition =
          condition &
          log.startedAt.isBiggerOrEqualValue(
            query.startAt!.millisecondsSinceEpoch ~/ 1000,
          );
    }
    if (query.endBefore != null) {
      condition =
          condition &
          log.startedAt.isSmallerThanValue(
            query.endBefore!.millisecondsSinceEpoch ~/ 1000,
          );
    }
    statement.where(condition);
    final rows = await statement.get();
    return (
      minutes: rows.fold<int>(
        0,
        (sum, row) => sum + (row.readTable(log).actualDurationMin ?? 0),
      ),
      count: rows.length,
    );
  }

  List<DashboardReviewPoint> _buildReviewFrequency(
    List<({String nodeId, ReviewItemLogData log})> reviewRows,
    DomainDashboardQuery query,
    DateTime now,
  ) {
    final today = DateTime.utc(now.year, now.month, now.day);
    final reviewDays = reviewRows.map((row) {
      final date = DateTime.fromMillisecondsSinceEpoch(
        row.log.reviewedAt * 1000,
        isUtc: true,
      );
      return DateTime.utc(date.year, date.month, date.day);
    }).toList();
    final firstReviewDay = reviewDays.isEmpty
        ? null
        : reviewDays.reduce((a, b) => a.isBefore(b) ? a : b);
    final firstDay = query.allTime && firstReviewDay != null
        ? firstReviewDay
        : query.startAt == null
        ? today.subtract(const Duration(days: 13))
        : DateTime.utc(
            query.startAt!.year,
            query.startAt!.month,
            query.startAt!.day,
          );
    final lastDay = query.endBefore == null
        ? today
        : DateTime.utc(
            query.endBefore!.year,
            query.endBefore!.month,
            query.endBefore!.day,
          ).subtract(const Duration(days: 1));
    final dayCount = lastDay.difference(firstDay).inDays + 1;
    if (dayCount <= 0) return const [];
    final bucketDays = dayCount <= 90
        ? 1
        : dayCount <= 365
        ? 7
        : 30;
    final counts = <int, List<double>>{};
    for (var index = 0; index < reviewRows.length; index++) {
      final bucket =
          reviewDays[index].difference(firstDay).inDays ~/ bucketDays;
      if (bucket < 0) continue;
      counts
          .putIfAbsent(bucket, () => [])
          .add(reviewRows[index].log.score ?? double.nan);
    }
    final pointCount = (dayCount - 1) ~/ bucketDays + 1;
    return List.generate(pointCount, (index) {
      final scores = counts[index] ?? const <double>[];
      final validScores = scores.where((score) => score.isFinite).toList();
      return DashboardReviewPoint(
        date: firstDay.add(Duration(days: index * bucketDays)),
        reviewCount: scores.length,
        averageAccuracy: validScores.isEmpty
            ? null
            : validScores.reduce((a, b) => a + b) / validScores.length,
      );
    });
  }

  DateTime _utcDay(DateTime date) =>
      DateTime.utc(date.year, date.month, date.day);

  Future<List<DashboardActivity>> _loadRecentActivity(
    String userId, {
    required Set<String> nodeIds,
    required DomainDashboardQuery query,
  }) async {
    if ((query.graphId != null || query.nodeId != null) && nodeIds.isEmpty) {
      return const [];
    }
    final domainLog = _database.domainLog;
    final node = _database.graphNode;
    final graph = _database.knowledgeGraph;
    final statement = _database.select(domainLog).join([
      innerJoin(node, node.id.equalsExp(domainLog.nodeId)),
      innerJoin(graph, graph.id.equalsExp(node.graphId)),
    ]);
    var condition =
        graph.userId.equals(userId) &
        graph.softDeleted.equals(false) &
        node.softDeleted.equals(false);
    if (query.graphId != null) {
      condition = condition & graph.id.equals(query.graphId!);
    }
    if (query.nodeId != null) {
      condition = condition & node.id.equals(query.nodeId!);
    }
    if (query.startAt != null) {
      condition =
          condition &
          domainLog.loggedAt.isBiggerOrEqualValue(
            query.startAt!.millisecondsSinceEpoch ~/ 1000,
          );
    }
    if (query.endBefore != null) {
      condition =
          condition &
          domainLog.loggedAt.isSmallerThanValue(
            query.endBefore!.millisecondsSinceEpoch ~/ 1000,
          );
    }
    statement
      ..where(condition)
      ..orderBy([OrderingTerm.desc(domainLog.loggedAt)])
      ..limit(12);
    final rows = await statement.get();
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
