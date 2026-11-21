class AiGraphPatch {
  const AiGraphPatch({
    required this.deletedNodeIds,
    required this.renamedNodes,
    required this.addedNodes,
    required this.deletedEdgeIds,
    required this.addedEdges,
  });

  final List<int> deletedNodeIds;
  final List<AiGraphNodeRename> renamedNodes;
  final List<AiGraphNodeAddition> addedNodes;
  final List<int> deletedEdgeIds;
  final List<AiGraphEdgeAddition> addedEdges;

  factory AiGraphPatch.fromJson(Map<String, dynamic> json) {
    return AiGraphPatch(
      deletedNodeIds: _parseIds(json['delete_nodes'], 'delete_nodes'),
      renamedNodes: _parseList(
        json['rename_nodes'],
        'rename_nodes',
      ).map(AiGraphNodeRename.fromJson).toList(growable: false),
      addedNodes: _parseList(
        json['add_nodes'],
        'add_nodes',
      ).map(AiGraphNodeAddition.fromJson).toList(growable: false),
      deletedEdgeIds: _parseIds(json['delete_edges'], 'delete_edges'),
      addedEdges: _parseList(
        json['add_edges'],
        'add_edges',
      ).map(AiGraphEdgeAddition.fromJson).toList(growable: false),
    );
  }

  void validate({
    required Set<int> existingNodeIds,
    required Set<int> existingEdgeIds,
  }) {
    _ensureUnique(deletedNodeIds, 'delete_nodes');
    _ensureUnique(deletedEdgeIds, 'delete_edges');
    if (!existingNodeIds.containsAll(deletedNodeIds)) {
      throw const FormatException('O patch referencia um nó inexistente.');
    }
    if (!existingEdgeIds.containsAll(deletedEdgeIds)) {
      throw const FormatException(
        'O patch referencia uma relação inexistente.',
      );
    }

    final deletedNodes = deletedNodeIds.toSet();
    final renamedIds = <int>{};
    for (final node in renamedNodes) {
      if (!existingNodeIds.contains(node.id) ||
          deletedNodes.contains(node.id) ||
          !renamedIds.add(node.id)) {
        throw const FormatException('O patch contém uma renomeação inválida.');
      }
    }

    final newNodeIds = <String>{};
    for (final node in addedNodes) {
      if (!newNodeIds.add(node.id)) {
        throw const FormatException('O patch repetiu o ID de um novo nó.');
      }
    }

    final addedEdgeKeys = <String>{};
    for (final edge in addedEdges) {
      _validateEndpoint(
        edge.sourceNode,
        existingNodeIds,
        deletedNodes,
        newNodeIds,
      );
      _validateEndpoint(
        edge.targetNode,
        existingNodeIds,
        deletedNodes,
        newNodeIds,
      );
      if (edge.sourceNode == edge.targetNode) {
        throw const FormatException(
          'Uma relação não pode ligar um nó a si mesmo.',
        );
      }
      final key = '${edge.sourceNode}|${edge.targetNode}|${edge.type}';
      if (!addedEdgeKeys.add(key)) {
        throw const FormatException('O patch repetiu uma relação.');
      }
    }
  }

  static void _validateEndpoint(
    Object id,
    Set<int> existingNodeIds,
    Set<int> deletedNodeIds,
    Set<String> newNodeIds,
  ) {
    if (id is int) {
      if (!existingNodeIds.contains(id) || deletedNodeIds.contains(id)) {
        throw const FormatException('Uma relação aponta para um nó inválido.');
      }
      return;
    }
    if (newNodeIds.contains(id)) return;
    throw const FormatException('Uma relação aponta para um nó novo inválido.');
  }
}

const _graphNodeTypes = {'AREA', 'TOPIC', 'CONCEPT', 'SUBCONCEPT'};
const _graphEdgeTypes = {'PREREQUISITE', 'SUBTOPIC'};

class AiGraphNodeRename {
  const AiGraphNodeRename({required this.id, required this.title});

  final int id;
  final String title;

  factory AiGraphNodeRename.fromJson(Object? json) {
    final map = _asMap(json, 'rename_nodes');
    final title = map['title'];
    if (title is! String || title.trim().isEmpty) {
      throw const FormatException('Uma renomeação está sem título.');
    }
    return AiGraphNodeRename(
      id: _parseId(map['id'], 'rename_nodes.id'),
      title: title.trim(),
    );
  }
}

class AiGraphNodeAddition {
  const AiGraphNodeAddition({
    required this.id,
    required this.title,
    required this.type,
  });

  final String id;
  final String title;
  final String type;

  factory AiGraphNodeAddition.fromJson(Object? json) {
    final map = _asMap(json, 'add_nodes');
    final id = map['id'];
    final title = map['title'];
    final type = map['type'] ?? 'CONCEPT';
    if (id is! String || !RegExp(r'^new_[1-9]\d*$').hasMatch(id)) {
      throw const FormatException('Um novo nó deve usar um ID new_N.');
    }
    if (title is! String || title.trim().isEmpty || type is! String) {
      throw const FormatException('Um novo nó está incompleto.');
    }
    final normalizedType = type.trim().isEmpty
        ? 'CONCEPT'
        : type.trim().toUpperCase();
    if (!_graphNodeTypes.contains(normalizedType)) {
      throw const FormatException('O tipo de um novo nó não é suportado.');
    }
    return AiGraphNodeAddition(
      id: id,
      title: title.trim(),
      type: normalizedType,
    );
  }
}

class AiGraphEdgeAddition {
  const AiGraphEdgeAddition({
    required this.sourceNode,
    required this.targetNode,
    required this.type,
    required this.weight,
  });

  final Object sourceNode;
  final Object targetNode;
  final String type;
  final double? weight;

  factory AiGraphEdgeAddition.fromJson(Object? json) {
    final map = _asMap(json, 'add_edges');
    final type = map['type'];
    final rawWeight = map['weight'];
    if (type is! String || type.trim().isEmpty) {
      throw const FormatException('Uma nova relação está sem tipo.');
    }
    final normalizedType = type.trim().toUpperCase();
    if (!_graphEdgeTypes.contains(normalizedType)) {
      throw const FormatException('O tipo de relação não é suportado.');
    }
    if (rawWeight != null && rawWeight is! num) {
      throw const FormatException('O peso de uma relação é inválido.');
    }
    return AiGraphEdgeAddition(
      sourceNode: _parseNodeReference(map['source_node'], 'source_node'),
      targetNode: _parseNodeReference(map['target_node'], 'target_node'),
      type: normalizedType,
      weight: (rawWeight as num?)?.toDouble(),
    );
  }
}

Map<String, dynamic> _asMap(Object? value, String field) {
  if (value is! Map) throw FormatException('Campo "$field" inválido.');
  return Map<String, dynamic>.from(value);
}

List<Object?> _parseList(Object? value, String field) {
  if (value == null) return const [];
  if (value is! List) throw FormatException('Campo "$field" inválido.');
  return value.cast<Object?>();
}

List<int> _parseIds(Object? value, String field) => _parseList(
  value,
  field,
).map((item) => _parseId(item, field)).toList(growable: false);

int _parseId(Object? value, String field) {
  if (value is int && value > 0) return value;
  throw FormatException('ID inválido em "$field".');
}

Object _parseNodeReference(Object? value, String field) {
  if (value is int && value > 0) return value;
  if (value is String && RegExp(r'^new_[1-9]\d*$').hasMatch(value)) {
    return value;
  }
  throw FormatException('Referência inválida em "$field".');
}

void _ensureUnique(List<int> ids, String field) {
  if (ids.toSet().length != ids.length) {
    throw FormatException('IDs repetidos em "$field".');
  }
}
