import 'dart:async';

import 'package:drift/drift.dart';
import 'package:noema/core/database/database.dart';
import 'package:noema/feature/review/data/fsrs_review_service.dart';

class ExerciseReviewItem {
  const ExerciseReviewItem({
    required this.id,
    required this.type,
    required this.graphId,
    required this.graphTitle,
    required this.nodeId,
    required this.nodeTitle,
    required this.title,
    required this.dueAt,
  });

  final String id;
  final ReviewItemType type;
  final String graphId;
  final String graphTitle;
  final String nodeId;
  final String nodeTitle;
  final String title;
  final DateTime dueAt;
}

class ExerciseReviewGroup {
  const ExerciseReviewGroup({
    required this.graphId,
    required this.graphTitle,
    required this.nodeId,
    required this.nodeTitle,
    required this.items,
  });

  final String graphId;
  final String graphTitle;
  final String nodeId;
  final String nodeTitle;
  final List<ExerciseReviewItem> items;
}

class ExerciseReviewQueueService {
  ExerciseReviewQueueService(this._database);

  final AppDatabase _database;

  Future<List<ExerciseReviewGroup>> load({
    required String userId,
    DateTime? now,
  }) async {
    final nowSeconds =
        (now ?? DateTime.now()).millisecondsSinceEpoch ~/ 1000;
    final graphNode = _database.graphNode;
    final graph = _database.knowledgeGraph;
    final nodeRows =
        await (_database.select(graphNode).join([
              innerJoin(graph, graph.id.equalsExp(graphNode.graphId)),
            ])..where(
              graph.userId.equals(userId) &
                  graph.softDeleted.equals(false) &
                  graphNode.softDeleted.equals(false),
            ))
            .get();
    final nodes = {
      for (final row in nodeRows)
        row.readTable(graphNode).id: (
          row.readTable(graphNode),
          row.readTable(graph),
        ),
    };

    final openEndedRows =
        await (_database.select(_database.openEnded)
              ..where((row) => row.softDeleted.equals(false)))
            .get();
    final multipleChoiceRows =
        await (_database.select(_database.multipleChoice)
              ..where((row) => row.softDeleted.equals(false)))
            .get();
    final openEndedById = {for (final row in openEndedRows) row.id: row};
    final multipleChoiceById = {
      for (final row in multipleChoiceRows) row.id: row,
    };
    final dueStates =
        await (_database.select(_database.reviewItemState)
              ..where(
                (row) =>
                    row.itemType.isIn([
                      ReviewItemType.openEnded.databaseValue,
                      ReviewItemType.multipleChoice.databaseValue,
                    ]) &
                    row.nextReviewAt.isSmallerOrEqualValue(nowSeconds),
              )
              ..orderBy([(row) => OrderingTerm.asc(row.nextReviewAt)]))
            .get();
    final grouped = <String, List<ExerciseReviewItem>>{};
    for (final state in dueStates) {
      final location = nodes[state.nodeId];
      if (location == null) continue;
      final (node, graphData) = location;
      final type = state.itemType == ReviewItemType.openEnded.databaseValue
          ? ReviewItemType.openEnded
          : ReviewItemType.multipleChoice;
      final title = switch (type) {
        ReviewItemType.openEnded => openEndedById[state.itemId]?.title,
        ReviewItemType.multipleChoice =>
          multipleChoiceById[state.itemId]?.title,
        ReviewItemType.flashcard => null,
      };
      if (title == null) continue;
      final item = ExerciseReviewItem(
        id: state.itemId,
        type: type,
        graphId: graphData.id,
        graphTitle: graphData.title,
        nodeId: node.id,
        nodeTitle: node.title,
        title: title,
        dueAt: DateTime.fromMillisecondsSinceEpoch(
          state.nextReviewAt * 1000,
          isUtc: true,
        ).toLocal(),
      );
      grouped.putIfAbsent('${graphData.id}/${node.id}', () => []).add(item);
    }

    final groups = [
      for (final entry in grouped.entries)
        ExerciseReviewGroup(
          graphId: entry.value.first.graphId,
          graphTitle: entry.value.first.graphTitle,
          nodeId: entry.value.first.nodeId,
          nodeTitle: entry.value.first.nodeTitle,
          items: List.unmodifiable(entry.value),
        ),
    ]..sort((a, b) {
      final dueTime = a.items.first.dueAt.compareTo(b.items.first.dueAt);
      if (dueTime != 0) return dueTime;
      final graphOrder = a.graphTitle.compareTo(b.graphTitle);
      return graphOrder != 0 ? graphOrder : a.nodeTitle.compareTo(b.nodeTitle);
    });
    return List.unmodifiable(groups);
  }

  Stream<List<ExerciseReviewGroup>> watch({required String userId}) {
    return Stream<List<ExerciseReviewGroup>>.multi((controller) {
      final subscriptions = <StreamSubscription<dynamic>>[];
      var loading = false;
      var pending = false;
      var canceled = false;

      void refresh() {
        if (canceled) return;
        if (loading) {
          pending = true;
          return;
        }
        loading = true;
        unawaited(() async {
          do {
            pending = false;
            try {
              controller.add(await load(userId: userId));
            } catch (error, stackTrace) {
              controller.addError(error, stackTrace);
            }
          } while (pending && !canceled);
          loading = false;
        }());
      }

      subscriptions.add(
        _database.select(_database.reviewItemState).watch().listen((_) => refresh()),
      );
      subscriptions.add(
        _database.select(_database.openEnded).watch().listen((_) => refresh()),
      );
      subscriptions.add(
        _database.select(_database.multipleChoice).watch().listen((_) => refresh()),
      );
      subscriptions.add(
        _database.select(_database.graphNode).watch().listen((_) => refresh()),
      );
      refresh();
      controller.onCancel = () async {
        canceled = true;
        await Future.wait(subscriptions.map((subscription) => subscription.cancel()));
      };
    });
  }
}
