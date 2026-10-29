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
  });

  final int masteredConcepts;
  final int fragileConcepts;
  final int unassessedConcepts;
  final int criticalPrerequisites;
  final List<DomainDashboardPoint> recentProgress;
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
    final nodes = {
      for (final row in nodeRows)
        row.readTable(_database.graphNode).id: row.readTable(_database.graphNode),
    };

    final criticalPrerequisites = await _countCriticalPrerequisites(
      nodes: nodes,
      userId: userId,
    );
    final recentProgress = await _loadRecentProgress(
      userId: userId,
      now: currentTime,
    );
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
        _database.select(_database.graphEdge).watch().listen((_) => refresh()),
      );
      subscriptions.add(
        _database.select(_database.domainLog).watch().listen((_) => refresh()),
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
        edge.type.equals('PREREQUISITE') &
            graph.userId.equals(userId) &
            graph.softDeleted.equals(false) &
            source.softDeleted.equals(false),
      );
    final rows = await query.get();
    final criticalTargets = <String>{};
    for (final row in rows) {
      final prerequisite = row.readTable(source);
      final targetId = row.readTable(edge).targetNodeId;
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
}
