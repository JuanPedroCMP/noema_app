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
      graphDescription: json['graph_description'] as String? ?? '',
      nodes: (json['nodes'] as List<dynamic>? ?? [])
          .map(
            (node) => GraphNode.fromJson(
              node as Map<String, dynamic>,
            ),
          )
          .toList(),
      edges: (json['edges'] as List<dynamic>? ?? [])
          .map(
            (edge) => GraphEdge.fromJson(
              edge as Map<String, dynamic>,
            ),
          )
          .toList(),
    );
  }

  factory GraphResponse.fromJsonString(String source) {
    return GraphResponse.fromJson(
      jsonDecode(source) as Map<String, dynamic>,
    );
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
      nodeId: json['node_id'] as int,
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
      sourceNode: json['source_node'] as int,
      targetNode: json['target_node'] as int,
      type: "PREREQUISITE",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'source_node': sourceNode,
      'target_node': targetNode,
      'type': type,
    };
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