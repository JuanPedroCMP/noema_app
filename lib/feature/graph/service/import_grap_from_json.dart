import 'package:drift/drift.dart';
import 'package:noema/core/database/database.dart' hide GraphNode;
import 'package:noema/feature/graph/data/converter_ai_response.dart' as ai;
import 'package:uuid/uuid.dart';

// TODO retirar, temp, apenas para testes

String _mapEdgeTypeToDb(String value) {
  switch (value.toUpperCase()) {
    case 'PREREQUISITE':
      return 'STRONG_PREREQUISITE';
    case 'SUBTOPIC':
      return 'RELATED';
    case 'RELATED':
      return 'RELATED';
    case 'APPLIES':
      return 'APPLIES';
    case 'GENERALIZES':
      return 'GENERALIZES';
    case 'INSTANTIATES':
      return 'INSTANTIATES';
    default:
      return 'RELATED';
  }
}

Future<String> importGraphFromJson({
  required AppDatabase db,
  required String userId,
  required String jsonString,
}) async {
  final graph = ai.GraphResponse.fromJsonString(jsonString);
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

    for (final edge in hierarchicalEdges.where((e) => e.sourceNode == current)) {
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
    await db.into(db.knowledgeGraph).insert(
      KnowledgeGraphCompanion.insert(
        id: graphId,
        userId: userId,
        title: graph.graphTitle,
        description: Value(graph.graphDescription),
      ),
    );

    const double xSpacing = 260;
    const double ySpacing = 180;
    const double startX = 220;
    const double startY = 180;

    await db.batch((batch) async {
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
              parentId: const Value.absent(),
              type: node.type.value,
              title: node.title,
              description: Value(node.description),
              positionX: startX + (index * xSpacing),
              positionY: startY + (level * ySpacing),
              masteryScore: const Value.absent(),
              isSkipped: const Value.absent(),
              aiSynthesis: const Value.absent(),
              synthesisEdited: const Value.absent(),
              fsrsRating: const Value.absent(),
            ),
          );
        }
      }

      for (final edge in graph.edges) {
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
            isBidirectional: const Value(false),
            weight: const Value.absent(),
            synced: const Value.absent(),
          ),
        );
      }
    });
  });

  return graphId;
}