import 'dart:convert';

class GraphResponse {
  final String graphTitle;
  final String graphDescription;
  final List<GraphNode> nodes;
  final List<GraphEdge> edges;

  const GraphResponse({
    required this.graphTitle,
    required this.graphDescription,
    required this.nodes,
    required this.edges,
  });

  factory GraphResponse.fromJson(Map<String, dynamic> json) {
    return GraphResponse(
      graphTitle: json['graph_title'] as String? ?? '',
      graphDescription:
          json['graph_description'] as String? ??
          json['description'] as String? ??
          '',
      nodes: (json['nodes'] as List<dynamic>? ?? [])
          .map((node) => GraphNode.fromJson(node as Map<String, dynamic>))
          .toList(),
      edges: (json['edges'] as List<dynamic>? ?? [])
          .map((edge) => GraphEdge.fromJson(edge as Map<String, dynamic>))
          .toList(),
    );
  }

  factory GraphResponse.fromJsonString(String source) {
    return GraphResponse.fromJson(jsonDecode(source) as Map<String, dynamic>);
  }

  Map<String, dynamic> toJson() {
    return {
      'graph_title': graphTitle,
      'graph_description': graphDescription,
      'nodes': nodes.map((node) => node.toJson()).toList(),
      'edges': edges.map((edge) => edge.toJson()).toList(),
    };
  }

  String toJsonString() {
    return jsonEncode(toJson());
  }

  /// Repairs common AI-generation defects (duplicate nodes, self-loops,
  /// dangling/duplicate edges, hierarchical cycles, and missing graph title)
  /// so a usable graph can still be imported.
  GraphResponse repair() {
    final seenNodeIds = <int>{};
    final repairedNodes = <GraphNode>[];
    for (final node in nodes) {
      if (node.title.trim().isEmpty) continue;
      if (seenNodeIds.add(node.nodeId)) {
        repairedNodes.add(node);
      }
    }

    final validNodeIds = repairedNodes.map((node) => node.nodeId).toSet();
    final seenEdgePairs = <(int, int)>{};
    final validEdges = <GraphEdge>[];
    for (final edge in edges) {
      if (edge.sourceNode == edge.targetNode) continue;
      if (!validNodeIds.contains(edge.sourceNode) ||
          !validNodeIds.contains(edge.targetNode)) {
        continue;
      }
      if (seenEdgePairs.add((edge.sourceNode, edge.targetNode))) {
        validEdges.add(edge);
      }
    }

    // Break cycles in hierarchical edges (SUBTOPIC / PREREQUISITE) using
    // iterative 3-color DFS, preserving non-hierarchical edges as-is.
    final adjacency = <int, List<({int target, GraphEdge edge})>>{
      for (final id in validNodeIds) id: [],
    };
    final nonHierarchicalEdges = <GraphEdge>[];
    for (final edge in validEdges) {
      final type = edge.type.toUpperCase();
      if (type == 'SUBTOPIC' || type == 'PREREQUISITE') {
        final source = type == 'SUBTOPIC' ? edge.targetNode : edge.sourceNode;
        final target = type == 'SUBTOPIC' ? edge.sourceNode : edge.targetNode;
        adjacency[source]!.add((target: target, edge: edge));
      } else {
        nonHierarchicalEdges.add(edge);
      }
    }

    const white = 0;
    const gray = 1;
    const black = 2;
    final color = <int, int>{for (final id in validNodeIds) id: white};
    final acyclicHierarchicalEdges = <GraphEdge>[];

    for (final startNode in repairedNodes) {
      final startId = startNode.nodeId;
      if (color[startId] != white) continue;

      final nodeStack = <int>[startId];
      final edgeIndexStack = <int>[0];
      color[startId] = gray;

      while (nodeStack.isNotEmpty) {
        final currentId = nodeStack.last;
        final neighbors = adjacency[currentId]!;
        final edgeIndex = edgeIndexStack.last;

        if (edgeIndex >= neighbors.length) {
          color[currentId] = black;
          nodeStack.removeLast();
          edgeIndexStack.removeLast();
          continue;
        }

        edgeIndexStack[edgeIndexStack.length - 1] = edgeIndex + 1;
        final entry = neighbors[edgeIndex];
        final targetColor = color[entry.target] ?? black;

        if (targetColor == gray) {
          // Back-edge closes a cycle; drop it.
          continue;
        }

        acyclicHierarchicalEdges.add(entry.edge);
        if (targetColor == white) {
          color[entry.target] = gray;
          nodeStack.add(entry.target);
          edgeIndexStack.add(0);
        }
      }
    }

    var repairedTitle = graphTitle.trim();
    if (repairedTitle.isEmpty) {
      final descLine = graphDescription.trim().split('\n').first.trim();
      if (descLine.isNotEmpty) {
        repairedTitle = descLine.length <= 80
            ? descLine
            : descLine.substring(0, 80).trim();
      } else if (repairedNodes.isNotEmpty) {
        repairedTitle = repairedNodes.first.title.trim();
      }
    }

    return GraphResponse(
      graphTitle: repairedTitle,
      graphDescription: graphDescription,
      nodes: repairedNodes,
      edges: [...acyclicHierarchicalEdges, ...nonHierarchicalEdges],
    );
  }

  void validate() {
    if (graphTitle.trim().isEmpty) {
      throw const FormatException('O grafo gerado está sem título.');
    }
    if (nodes.isEmpty) {
      throw const FormatException('A IA não gerou nenhum nó para o grafo.');
    }

    final nodeIds = <int>{};
    for (final node in nodes) {
      if (!nodeIds.add(node.nodeId)) {
        throw FormatException('A IA repetiu o identificador ${node.nodeId}.');
      }
      if (node.title.trim().isEmpty) {
        throw FormatException('O nó ${node.nodeId} gerado está sem título.');
      }
    }

    for (final edge in edges) {
      if (edge.sourceNode == edge.targetNode ||
          !nodeIds.contains(edge.sourceNode) ||
          !nodeIds.contains(edge.targetNode)) {
        throw const FormatException(
          'A estrutura do grafo contém uma relação inválida.',
        );
      }
    }

    final hierarchy = <int, List<int>>{
      for (final node in nodes) node.nodeId: <int>[],
    };
    for (final edge in edges) {
      final type = edge.type.toUpperCase();
      if (type == 'SUBTOPIC' || type == 'PREREQUISITE') {
        final source = type == 'SUBTOPIC' ? edge.targetNode : edge.sourceNode;
        final target = type == 'SUBTOPIC' ? edge.sourceNode : edge.targetNode;
        hierarchy[source]!.add(target);
      }
    }

    final visited = <int>{};
    final active = <int>{};

    bool hasCycle(int nodeId) {
      if (active.contains(nodeId)) return true;
      if (!visited.add(nodeId)) return false;
      active.add(nodeId);
      for (final targetId in hierarchy[nodeId]!) {
        if (hasCycle(targetId)) return true;
      }
      active.remove(nodeId);
      return false;
    }

    if (nodes.any((node) => hasCycle(node.nodeId))) {
      throw const FormatException(
        'As relações hierárquicas geradas contêm um ciclo.',
      );
    }
  }
}

int _parseNodeId(dynamic value, String fieldName) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) {
    final parsed = int.tryParse(value.trim());
    if (parsed != null) return parsed;
  }
  throw FormatException('Campo "$fieldName" inválido na resposta da IA.');
}

class GraphNode {
  final int nodeId;
  final String title;
  final String description;
  final GraphNodeType type;

  const GraphNode({
    required this.nodeId,
    required this.title,
    required this.description,
    required this.type,
  });

  factory GraphNode.fromJson(Map<String, dynamic> json) {
    return GraphNode(
      nodeId: _parseNodeId(json['node_id'], 'node_id'),
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      type: GraphNodeType.fromString(json['type']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'node_id': nodeId,
      'title': title,
      'description': description,
      'type': type.value,
    };
  }
}

enum GraphNodeType {
  area,
  topic,
  concept,
  subconcept;

  String get value {
    switch (this) {
      case GraphNodeType.area:
        return 'AREA';

      case GraphNodeType.topic:
        return 'TOPIC';

      case GraphNodeType.concept:
        return 'CONCEPT';

      case GraphNodeType.subconcept:
        return 'SUBCONCEPT';
    }
  }

  static GraphNodeType fromString(dynamic value) {
    switch (value?.toString().toUpperCase()) {
      case 'AREA':
        return GraphNodeType.area;

      case 'TOPIC':
        return GraphNodeType.topic;

      case 'CONCEPT':
        return GraphNodeType.concept;

      case 'SUBCONCEPT':
        return GraphNodeType.subconcept;

      default:
        return GraphNodeType.concept;
    }
  }
}

class GraphEdge {
  final int sourceNode;
  final int targetNode;
  final String type;

  const GraphEdge({
    required this.sourceNode,
    required this.targetNode,
    required this.type,
  });

  factory GraphEdge.fromJson(Map<String, dynamic> json) {
    return GraphEdge(
      sourceNode: _parseNodeId(json['source_node'], 'source_node'),
      targetNode: _parseNodeId(json['target_node'], 'target_node'),
      type: json['type'] as String? ?? 'SUBTOPIC',
    );
  }

  Map<String, dynamic> toJson() {
    return {'source_node': sourceNode, 'target_node': targetNode, 'type': type};
  }
}

enum GraphEdgeType {
  subtopic,
  prerequisite;

  String get value {
    switch (this) {
      case GraphEdgeType.subtopic:
        return 'SUBTOPIC';

      case GraphEdgeType.prerequisite:
        return 'PREREQUISITE';
    }
  }

  static GraphEdgeType fromString(dynamic value) {
    switch (value?.toString().toUpperCase()) {
      case 'SUBTOPIC':
        return GraphEdgeType.subtopic;

      case 'PREREQUISITE':
        return GraphEdgeType.prerequisite;

      default:
        return GraphEdgeType.subtopic;
    }
  }
}
