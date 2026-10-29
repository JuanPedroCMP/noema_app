import 'package:drift/drift.dart';
import 'package:noema/core/database/database.dart' hide GraphNode;
import 'package:noema/feature/ai/data/ai_background_task_dao.dart';
import 'package:noema/feature/graph/data/converter_ai_response.dart' as ai;
import 'package:uuid/uuid.dart';

// TODO retirar, temp, apenas para testes

String _mapEdgeTypeToDb(String value) {
  switch (value.toUpperCase()) {
    case 'PREREQUISITE':
      return 'PREREQUISITE';
    case 'SUBTOPIC':
      return 'SUBTOPIC';
    case 'RELATED':
      return 'SUBTOPIC';
    case 'APPLIES':
      return 'SUBTOPIC';
    case 'GENERALIZES':
      return 'SUBTOPIC';
    case 'INSTANTIATES':
      return 'SUBTOPIC';
    default:
      return 'SUBTOPIC';
  }
}

Future<String> importGraphFromJson({
  required AppDatabase db,
  required String userId,
  required String jsonString,
  bool isAiGenerated = false,
  bool queueMissingAiDescriptions = false,
}) async {
  final graph = ai.GraphResponse.fromJsonString(jsonString);
  graph.validate();
  final graphId = const Uuid().v4();

  final nodeIdMap = <int, String>{};
  final nodesById = <int, ai.GraphNode>{
    for (final node in graph.nodes) node.nodeId: node,
  };

  final incomingCount = <int, int>{};
  for (final node in graph.nodes) {
    incomingCount[node.nodeId] = 0;
  }

  final hierarchicalEdges = graph.edges.where((edge) {
    final type = edge.type.toUpperCase();
    return type == 'SUBTOPIC' || type == 'PREREQUISITE';
  }).toList();

  for (final edge in hierarchicalEdges) {
    incomingCount[edge.targetNode] = (incomingCount[edge.targetNode] ?? 0) + 1;
  }

  final roots = graph.nodes
      .where((node) => (incomingCount[node.nodeId] ?? 0) == 0)
      .map((node) => node.nodeId)
      .toList();

  final levelByNodeId = <int, int>{};
  final queue = <int>[];

  for (final root in roots) {
    levelByNodeId[root] = 0;
    queue.add(root);
  }

  while (queue.isNotEmpty) {
    final current = queue.removeAt(0);
    final currentLevel = levelByNodeId[current] ?? 0;

    for (final edge in hierarchicalEdges.where(
      (e) => e.sourceNode == current,
    )) {
      final nextLevel = currentLevel + 1;
      final previousLevel = levelByNodeId[edge.targetNode];

      if (previousLevel == null || nextLevel > previousLevel) {
        levelByNodeId[edge.targetNode] = nextLevel;
        queue.add(edge.targetNode);
      }
    }
  }

  for (final node in graph.nodes) {
    levelByNodeId.putIfAbsent(node.nodeId, () => 0);
  }

  final levels = <int, List<int>>{};
  for (final node in graph.nodes) {
    final level = levelByNodeId[node.nodeId] ?? 0;
    levels.putIfAbsent(level, () => []).add(node.nodeId);
  }

  await db.transaction(() async {
    await db
        .into(db.knowledgeGraph)
        .insert(
          KnowledgeGraphCompanion.insert(
            id: graphId,
            userId: userId,
            title: graph.graphTitle,
            description: Value(graph.graphDescription),
            isAiGenerated: Value(isAiGenerated),
          ),
        );

    const double xSpacing = 260;
    const double ySpacing = 180;
    const double startX = 220;
    const double startY = 180;

    await db.batch((batch) async {
      final insertedEdgePairs = <(int, int)>{};

      for (final entry in levels.entries) {
        final level = entry.key;
        final nodeIds = entry.value;

        for (var index = 0; index < nodeIds.length; index++) {
          final jsonNodeId = nodeIds[index];
          final node = nodesById[jsonNodeId]!;
          final dbNodeId = const Uuid().v4();
          nodeIdMap[jsonNodeId] = dbNodeId;

          batch.insert(
            db.graphNode,
            GraphNodeCompanion.insert(
              id: dbNodeId,
              graphId: graphId,
              type: node.type.value,
              title: node.title,
              description: Value(node.description),
              positionX: startX + (index * xSpacing),
              positionY: startY + (level * ySpacing),
              isAiGenerated: Value(isAiGenerated),
              masteryScore: const Value.absent(),
              isSkipped: const Value.absent(),
              fsrsRating: const Value.absent(),
            ),
          );
        }
      }

      if (isAiGenerated && queueMissingAiDescriptions) {
        final now = DateTime.now().millisecondsSinceEpoch;
        for (final node in graph.nodes) {
          if (node.description.trim().isNotEmpty) continue;
          final dbNodeId = nodeIdMap[node.nodeId];
          if (dbNodeId == null) continue;
          batch.insert(
            db.aiBackgroundTask,
            AiBackgroundTaskCompanion.insert(
              id: const Uuid().v4(),
              nodeId: dbNodeId,
              taskType: aiNodeDescriptionTaskType,
              createdAt: Value(now),
              updatedAt: Value(now),
            ),
          );
        }
      }

      for (final edge in graph.edges) {
        if (!insertedEdgePairs.add((edge.sourceNode, edge.targetNode))) {
          continue;
        }

        final sourceId = nodeIdMap[edge.sourceNode];
        final targetId = nodeIdMap[edge.targetNode];

        if (sourceId == null || targetId == null) {
          continue;
        }

        batch.insert(
          db.graphEdge,
          GraphEdgeCompanion.insert(
            id: const Uuid().v4(),
            graphId: graphId,
            sourceNodeId: sourceId,
            targetNodeId: targetId,
            type: _mapEdgeTypeToDb(edge.type),
            weight: const Value.absent(),
          ),
        );
      }
    });
  });

  return graphId;
}
