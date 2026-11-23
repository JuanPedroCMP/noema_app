import 'package:noema/core/database/database.dart';

class CompactGraphSnapshot {
  const CompactGraphSnapshot({
    required this.nodesByCompactId,
    required this.edgesByCompactId,
    required this.nodeCompactIdByLocalId,
    required this.edgeCompactIdByLocalId,
    required this.edges,
  });

  final Map<int, GraphNodeData> nodesByCompactId;
  final Map<int, GraphEdgeData> edgesByCompactId;
  final Map<String, int> nodeCompactIdByLocalId;
  final Map<String, int> edgeCompactIdByLocalId;
  final List<Map<String, Object?>> edges;

  Map<String, Object?> toJson({
    bool includeNodeTypes = false,
    String? targetNodeId,
  }) {
    final targetCompactId = targetNodeId == null
        ? null
        : nodeCompactIdByLocalId[targetNodeId];
    if (targetNodeId != null && targetCompactId == null) {
      throw StateError('O nó alvo não pertence ao grafo fornecido.');
    }

    return {
      'target_node': ?targetCompactId,
      'nodes': [
        for (final entry in nodesByCompactId.entries)
          {
            'id': entry.key,
            'title': entry.value.title,
            if (includeNodeTypes) 'type': entry.value.type,
          },
      ],
      'edges': edges,
    };
  }
}

CompactGraphSnapshot compactGraphSnapshot({
  required List<GraphNodeData> nodes,
  required List<GraphEdgeData> edges,
}) {
  final sortedNodes = nodes.toList()
    ..sort((first, second) {
      final titleComparison = first.title.toLowerCase().compareTo(
        second.title.toLowerCase(),
      );
      return titleComparison != 0
          ? titleComparison
          : first.id.compareTo(second.id);
    });
  final nodesByCompactId = <int, GraphNodeData>{};
  final nodeCompactIdByLocalId = <String, int>{};
  for (var index = 0; index < sortedNodes.length; index++) {
    final compactId = index + 1;
    final node = sortedNodes[index];
    nodesByCompactId[compactId] = node;
    nodeCompactIdByLocalId[node.id] = compactId;
  }

  final sortedEdges = edges
      .where(
        (edge) =>
            nodeCompactIdByLocalId.containsKey(edge.sourceNodeId) &&
            nodeCompactIdByLocalId.containsKey(edge.targetNodeId),
      )
      .toList()
    ..sort((first, second) {
      final sourceComparison = nodeCompactIdByLocalId[first.sourceNodeId]!
          .compareTo(nodeCompactIdByLocalId[second.sourceNodeId]!);
      if (sourceComparison != 0) return sourceComparison;
      final targetComparison = nodeCompactIdByLocalId[first.targetNodeId]!
          .compareTo(nodeCompactIdByLocalId[second.targetNodeId]!);
      if (targetComparison != 0) return targetComparison;
      final typeComparison = first.type.compareTo(second.type);
      return typeComparison != 0 ? typeComparison : first.id.compareTo(second.id);
    });

  final edgesByCompactId = <int, GraphEdgeData>{};
  final edgeCompactIdByLocalId = <String, int>{};
  final compactEdges = <Map<String, Object?>>[];
  for (var index = 0; index < sortedEdges.length; index++) {
    final compactId = index + 1;
    final edge = sortedEdges[index];
    edgesByCompactId[compactId] = edge;
    edgeCompactIdByLocalId[edge.id] = compactId;
    compactEdges.add({
      'id': compactId,
      'source_node': nodeCompactIdByLocalId[edge.sourceNodeId],
      'target_node': nodeCompactIdByLocalId[edge.targetNodeId],
      'type': edge.type,
      'weight': edge.weight,
    });
  }

  return CompactGraphSnapshot(
    nodesByCompactId: Map.unmodifiable(nodesByCompactId),
    edgesByCompactId: Map.unmodifiable(edgesByCompactId),
    nodeCompactIdByLocalId: Map.unmodifiable(nodeCompactIdByLocalId),
    edgeCompactIdByLocalId: Map.unmodifiable(edgeCompactIdByLocalId),
    edges: List.unmodifiable(compactEdges),
  );
}
