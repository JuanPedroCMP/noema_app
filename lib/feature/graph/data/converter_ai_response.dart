import 'dart:convert';

const _coverageAuditProblemCodes = {
  'missing_scope_plan',
  'missing_coverage_map',
  'empty_coverage_outcome',
  'duplicate_coverage_outcome',
  'coverage_without_nodes',
  'coverage_unknown_node',
  'coverage_container_node',
  'leaf_without_coverage',
  'blueprint_outcome_mapping_missing',
  'blueprint_duplicate_outcome_mapping',
  'blueprint_unknown_outcome',
  'blueprint_unmapped_outcome',
  'blueprint_outcome_text_mismatch',
  'blueprint_dependency_missing',
};

class GraphCoverageItem {
  const GraphCoverageItem({
    required this.outcome,
    required this.nodeIds,
    this.outcomeId,
  });

  final String? outcomeId;
  final String outcome;
  final List<int> nodeIds;

  factory GraphCoverageItem.fromJson(Map<String, dynamic> json) {
    final outcome = json['outcome'];
    final rawNodeIds = json['node_ids'];
    if (outcome is! String || rawNodeIds is! List) {
      throw const FormatException('Cobertura do grafo em formato inválido.');
    }

    final nodeIds = <int>[];
    for (final nodeId in rawNodeIds) {
      if (nodeId is! int) {
        throw const FormatException(
          'A cobertura contém um identificador de nó inválido.',
        );
      }
      nodeIds.add(nodeId);
    }

    return GraphCoverageItem(
      outcome: outcome,
      nodeIds: List.unmodifiable(nodeIds),
      outcomeId: json['outcome_id'] as String?,
    );
  }
}

class GraphBlueprintOutcome {
  const GraphBlueprintOutcome({
    required this.id,
    required this.outcome,
    required this.evidence,
    this.prerequisiteIds = const [],
  });

  final String id;
  final String outcome;
  final String evidence;
  final List<String> prerequisiteIds;

  factory GraphBlueprintOutcome.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final outcome = json['outcome'];
    final evidence = json['evidence'];
    final rawPrerequisites = json['prerequisite_ids'] ?? const [];
    if (id is! String ||
        outcome is! String ||
        evidence is! String ||
        rawPrerequisites is! List ||
        rawPrerequisites.any((value) => value is! String)) {
      throw const FormatException(
        'Um resultado do plano pedagógico está em formato inválido.',
      );
    }

    return GraphBlueprintOutcome(
      id: id,
      outcome: outcome,
      evidence: evidence,
      prerequisiteIds: List.unmodifiable(rawPrerequisites.cast<String>()),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'outcome': outcome,
    'evidence': evidence,
    'prerequisite_ids': prerequisiteIds,
  };
}

class GraphStudyBlueprint {
  const GraphStudyBlueprint({
    required this.scope,
    required this.outcomes,
    this.assumptions = const [],
    this.priorKnowledge = const [],
  });

  final String scope;
  final List<String> assumptions;
  final List<String> priorKnowledge;
  final List<GraphBlueprintOutcome> outcomes;

  factory GraphStudyBlueprint.fromJson(Map<String, dynamic> json) {
    final scope = json['scope'];
    final rawAssumptions = json['assumptions'] ?? const [];
    final rawPriorKnowledge = json['prior_knowledge'] ?? const [];
    final rawOutcomes = json['outcomes'];
    if (scope is! String ||
        rawAssumptions is! List ||
        rawAssumptions.any((value) => value is! String) ||
        rawPriorKnowledge is! List ||
        rawPriorKnowledge.any((value) => value is! String) ||
        rawOutcomes is! List ||
        rawOutcomes.any((item) => item is! Map)) {
      throw const FormatException(
        'O plano pedagógico está em formato inválido.',
      );
    }

    return GraphStudyBlueprint(
      scope: scope,
      assumptions: List.unmodifiable(rawAssumptions.cast<String>()),
      priorKnowledge: List.unmodifiable(rawPriorKnowledge.cast<String>()),
      outcomes: List.unmodifiable(
        rawOutcomes.map(
          (item) => GraphBlueprintOutcome.fromJson(
            Map<String, dynamic>.from(item as Map),
          ),
        ),
      ),
    );
  }

  List<GraphBlueprintOutcome> get startingOutcomes => outcomes
      .where((outcome) => outcome.prerequisiteIds.isEmpty)
      .toList(growable: false);

  List<GraphProblem> validate() {
    final issues = <GraphProblem>[];
    if (scope.trim().isEmpty) {
      issues.add(
        const GraphProblem(
          code: 'blueprint_missing_scope',
          message: 'O plano não definiu o escopo do aprendizado.',
          retryable: true,
        ),
      );
    }
    if (outcomes.isEmpty) {
      issues.add(
        const GraphProblem(
          code: 'blueprint_missing_outcomes',
          message: 'O plano não definiu resultados de aprendizagem.',
          retryable: true,
        ),
      );
      return issues;
    }

    final outcomesById = <String, GraphBlueprintOutcome>{};
    final normalizedTexts = <String>{};
    for (final outcome in outcomes) {
      if (!RegExp(r'^outcome_[1-9]\d*$').hasMatch(outcome.id) ||
          outcome.outcome.trim().isEmpty ||
          outcome.evidence.trim().isEmpty) {
        issues.add(
          GraphProblem(
            code: 'blueprint_incomplete_outcome',
            message:
                'Cada resultado precisa de ID, descrição e evidência avaliável.',
            retryable: true,
          ),
        );
      }
      if (outcomesById.containsKey(outcome.id)) {
        issues.add(
          GraphProblem(
            code: 'blueprint_duplicate_outcome_id',
            message: 'O ID "${outcome.id}" aparece mais de uma vez no plano.',
            retryable: true,
          ),
        );
      } else {
        outcomesById[outcome.id] = outcome;
      }
      final normalizedText = outcome.outcome
          .trim()
          .replaceAll(RegExp(r'\s+'), ' ')
          .toLowerCase();
      if (normalizedText.isNotEmpty && !normalizedTexts.add(normalizedText)) {
        issues.add(
          GraphProblem(
            code: 'blueprint_duplicate_outcome',
            message: 'O resultado "${outcome.outcome}" está duplicado.',
            retryable: true,
          ),
        );
      }
    }

    for (final outcome in outcomes) {
      if (outcome.prerequisiteIds.toSet().length !=
          outcome.prerequisiteIds.length) {
        issues.add(
          GraphProblem(
            code: 'blueprint_duplicate_prerequisite',
            message: '"${outcome.outcome}" repete um pré-requisito no plano.',
            retryable: true,
          ),
        );
      }
      for (final prerequisiteId in outcome.prerequisiteIds) {
        if (!outcomesById.containsKey(prerequisiteId)) {
          issues.add(
            GraphProblem(
              code: 'blueprint_unknown_prerequisite',
              message:
                  '"${outcome.outcome}" depende de um resultado inexistente.',
              retryable: true,
            ),
          );
        }
      }
    }

    if (startingOutcomes.isEmpty) {
      issues.add(
        const GraphProblem(
          code: 'blueprint_missing_starting_outcome',
          message: 'O plano não apresenta um ponto de partida legítimo.',
          retryable: true,
        ),
      );
    }

    final indegree = <String, int>{for (final id in outcomesById.keys) id: 0};
    final dependents = <String, List<String>>{};
    for (final outcome in outcomes) {
      for (final prerequisiteId in outcome.prerequisiteIds) {
        if (!outcomesById.containsKey(prerequisiteId)) continue;
        indegree[outcome.id] = indegree[outcome.id]! + 1;
        dependents.putIfAbsent(prerequisiteId, () => []).add(outcome.id);
      }
    }
    final ready = <String>[
      for (final entry in indegree.entries)
        if (entry.value == 0) entry.key,
    ];
    var visitedCount = 0;
    while (ready.isNotEmpty) {
      final current = ready.removeLast();
      visitedCount++;
      for (final dependent in dependents[current] ?? const <String>[]) {
        indegree[dependent] = indegree[dependent]! - 1;
        if (indegree[dependent] == 0) ready.add(dependent);
      }
    }
    if (visitedCount != outcomesById.length) {
      issues.add(
        const GraphProblem(
          code: 'blueprint_dependency_cycle',
          message: 'Os resultados do plano contêm dependências circulares.',
          retryable: true,
        ),
      );
    }
    return issues;
  }

  Map<String, dynamic> toJson() => {
    'scope': scope,
    'assumptions': assumptions,
    'prior_knowledge': priorKnowledge,
    'outcomes': outcomes.map((outcome) => outcome.toJson()).toList(),
  };
}

class GraphResponse {
  final String graphTitle;
  final String graphDescription;
  final String plan;
  final List<GraphCoverageItem> coverage;
  final GraphStudyBlueprint? blueprint;
  final List<GraphNode> nodes;
  final List<GraphEdge> edges;
  final List<GraphProblem> problems;
  final bool qualityFallback;

  const GraphResponse({
    required this.graphTitle,
    required this.graphDescription,
    this.plan = '',
    this.coverage = const [],
    this.blueprint,
    required this.nodes,
    required this.edges,
    this.problems = const [],
    this.qualityFallback = false,
  });

  factory GraphResponse.fromJson(Map<String, dynamic> json) {
    final rawBlueprint = json['blueprint'];
    final rawQualityFallback = json['quality_fallback'] ?? false;
    if (rawBlueprint != null && rawBlueprint is! Map) {
      throw const FormatException('O plano do grafo está em formato inválido.');
    }
    if (rawQualityFallback is! bool) {
      throw const FormatException(
        'O indicador de qualidade do grafo está em formato inválido.',
      );
    }
    return GraphResponse(
      graphTitle: json['graph_title'] as String? ?? '',
      graphDescription:
          json['graph_description'] as String? ??
          json['description'] as String? ??
          '',
      plan: json['plan'] as String? ?? '',
      coverage: (json['coverage'] as List<dynamic>? ?? [])
          .map(
            (item) => GraphCoverageItem.fromJson(item as Map<String, dynamic>),
          )
          .toList(growable: false),
      blueprint: rawBlueprint == null
          ? null
          : GraphStudyBlueprint.fromJson(
              Map<String, dynamic>.from(rawBlueprint as Map),
            ),
      nodes: (json['nodes'] as List<dynamic>? ?? [])
          .map((node) => GraphNode.fromJson(node as Map<String, dynamic>))
          .toList(),
      edges: (json['edges'] as List<dynamic>? ?? [])
          .map((edge) => GraphEdge.fromJson(edge as Map<String, dynamic>))
          .toList(),
      problems: const [],
      qualityFallback: rawQualityFallback,
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

  bool get hasCoverageAuditProblems => validate().any(
    (problem) =>
        _coverageAuditProblemCodes.contains(problem.code) ||
        problem.code.startsWith('blueprint_'),
  );

  bool get blocksSaveForCoverage =>
      hasCoverageAuditProblems && !qualityFallback;

  String toJsonString() {
    return jsonEncode(toJson());
  }

  /// Applies deterministic repairs and preserves warnings for the preview.
  GraphResponse repair() {
    final repairs = <GraphProblem>[];
    final seenNodeIds = <int>{};
    final repairedNodes = <GraphNode>[];
    for (final node in nodes) {
      if (node.title.trim().isEmpty) {
        repairs.add(
          GraphProblem(
            code: 'empty_node_removed',
            message: 'Um nó sem título foi removido.',
            nodeIds: [node.nodeId],
            retryable: true,
          ),
        );
        continue;
      }
      if (!seenNodeIds.add(node.nodeId)) {
        repairs.add(
          GraphProblem(
            code: 'duplicate_node_id_removed',
            message: 'Um nó com identificador repetido foi removido.',
            nodeIds: [node.nodeId],
            retryable: true,
          ),
        );
        continue;
      }
      repairedNodes.add(node);
    }

    final validNodeIds = repairedNodes.map((node) => node.nodeId).toSet();
    final nodesById = {for (final node in repairedNodes) node.nodeId: node};
    final containerIds = <int>{
      for (final node in nodes)
        if (_isContainer(node)) node.nodeId,
      for (final edge in edges.where(
        (edge) => edge.type.toUpperCase() == 'SUBTOPIC',
      ))
        edge.sourceNode,
    };
    final seenEdgePairs = <(int, int)>{};
    final validEdges = <GraphEdge>[];
    for (final edge in edges) {
      final edgeType = edge.type.toUpperCase();
      if (edgeType != 'SUBTOPIC' && edgeType != 'PREREQUISITE') {
        repairs.add(
          GraphProblem(
            code: 'invalid_edge_type_removed',
            message: 'Uma relação com tipo inválido foi removida.',
            nodeIds: [edge.sourceNode, edge.targetNode],
            retryable: true,
          ),
        );
        continue;
      }
      if (!validNodeIds.contains(edge.sourceNode) ||
          !validNodeIds.contains(edge.targetNode)) {
        repairs.add(
          GraphProblem(
            code: 'dangling_edge_removed',
            message: 'Uma relação com nó inexistente foi removida.',
            nodeIds: [edge.sourceNode, edge.targetNode],
            retryable: true,
          ),
        );
        continue;
      }
      if (edge.weight != null &&
          (!edge.weight!.isFinite || edge.weight! < 0 || edge.weight! > 1)) {
        repairs.add(
          GraphProblem(
            code: 'invalid_edge_weight_removed',
            message: 'Uma relação com peso inválido foi removida.',
            nodeIds: [edge.sourceNode, edge.targetNode],
            retryable: true,
          ),
        );
        continue;
      }
      if (edge.sourceNode == edge.targetNode) {
        repairs.add(
          GraphProblem(
            code: 'self_loop_removed',
            message: 'Uma autorrelação foi removida.',
            nodeIds: [edge.sourceNode],
            retryable: true,
          ),
        );
        continue;
      }
      if (edge.type.toUpperCase() == 'PREREQUISITE' &&
          (_isContainer(nodesById[edge.sourceNode]!) ||
              _isContainer(nodesById[edge.targetNode]!) ||
              containerIds.contains(edge.sourceNode) ||
              containerIds.contains(edge.targetNode))) {
        repairs.add(
          GraphProblem(
            code: 'container_prerequisite_removed',
            message:
                'Uma relação de pré-requisito ligada a um contêiner foi removida.',
            nodeIds: [edge.sourceNode, edge.targetNode],
            retryable: true,
          ),
        );
        continue;
      }
      final edgeKey = (edge.sourceNode, edge.targetNode);
      if (!seenEdgePairs.add(edgeKey)) {
        repairs.add(
          GraphProblem(
            code: 'duplicate_edge_removed',
            message: 'Uma relação duplicada foi removida.',
            nodeIds: [edge.sourceNode, edge.targetNode],
            retryable: true,
          ),
        );
        continue;
      }
      validEdges.add(edge);
    }

    for (final cycleType in const ['PREREQUISITE', 'SUBTOPIC']) {
      while (true) {
        final cycle = _findCycleEdges(
          validEdges
              .where((edge) => edge.type.toUpperCase() == cycleType)
              .toList(),
        );
        if (cycle == null) break;
        cycle.sort((first, second) {
          final byWeight = (first.weight ?? 1).compareTo(second.weight ?? 1);
          if (byWeight != 0) return byWeight;
          final firstDistance = _learningLevelDistance(first, nodesById);
          final secondDistance = _learningLevelDistance(second, nodesById);
          final byDistance = secondDistance.compareTo(firstDistance);
          if (byDistance != 0) return byDistance;
          final bySource = first.sourceNode.compareTo(second.sourceNode);
          return bySource != 0
              ? bySource
              : first.targetNode.compareTo(second.targetNode);
        });
        final removed = cycle.first;
        validEdges.remove(removed);
        repairs.add(
          GraphProblem(
            code: 'cycle_edge_removed',
            message:
                'Uma aresta de ciclo foi removida (menor peso; desempate por níveis).',
            nodeIds: [removed.sourceNode, removed.targetNode],
            retryable: true,
          ),
        );
      }
    }

    for (final edge in validEdges.toList()) {
      if (edge.type.toUpperCase() != 'PREREQUISITE') continue;
      final alternativeEdges = validEdges
          .where((item) => item != edge)
          .toList();
      if (_hasPath(
        from: edge.sourceNode,
        to: edge.targetNode,
        edges: alternativeEdges,
        type: 'PREREQUISITE',
        minimumWeight: 0.7,
      )) {
        validEdges.remove(edge);
        repairs.add(
          GraphProblem(
            code: 'transitive_prerequisite_removed',
            message: 'Um pré-requisito transitivo redundante foi removido.',
            nodeIds: [edge.sourceNode, edge.targetNode],
            retryable: true,
          ),
        );
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
      plan: plan,
      coverage: coverage,
      blueprint: blueprint,
      nodes: repairedNodes,
      edges: validEdges,
      problems: repairs,
      qualityFallback: qualityFallback,
    );
  }

  List<GraphProblem> validate() {
    final issues = [...problems];
    if (graphTitle.trim().isEmpty) {
      issues.add(
        const GraphProblem(
          code: 'missing_graph_title',
          message: 'O grafo está sem título.',
          fatal: true,
        ),
      );
    }
    if (nodes.isEmpty) {
      issues.add(
        const GraphProblem(
          code: 'empty_graph',
          message: 'A IA não gerou nenhum nó para o grafo.',
          fatal: true,
        ),
      );
    }

    final nodeIds = <int, GraphNode>{};
    for (final node in nodes) {
      if (nodeIds.containsKey(node.nodeId)) {
        issues.add(
          GraphProblem(
            code: 'duplicate_node_id',
            message: 'O identificador ${node.nodeId} aparece mais de uma vez.',
            nodeIds: [node.nodeId],
            fatal: true,
          ),
        );
      }
      if (node.title.trim().isEmpty) {
        issues.add(
          GraphProblem(
            code: 'empty_node_title',
            message: 'O nó ${node.nodeId} está sem título.',
            nodeIds: [node.nodeId],
            fatal: true,
          ),
        );
      }
      if (node.level != null &&
          !_learningLevelOrder.containsKey(node.level!.toLowerCase())) {
        issues.add(
          GraphProblem(
            code: 'invalid_learning_level',
            message: 'O nível de aprendizagem do nó ${node.nodeId} é inválido.',
            nodeIds: [node.nodeId],
            retryable: true,
          ),
        );
      }
      nodeIds[node.nodeId] = node;
    }

    final prerequisites = <GraphEdge>[];
    final containerIds = <int>{
      for (final node in nodeIds.values)
        if (_isContainer(node)) node.nodeId,
      for (final edge in edges.where(
        (edge) => edge.type.toUpperCase() == 'SUBTOPIC',
      ))
        edge.sourceNode,
    };
    for (final edge in edges) {
      if (edge.sourceNode == edge.targetNode ||
          !nodeIds.containsKey(edge.sourceNode) ||
          !nodeIds.containsKey(edge.targetNode)) {
        issues.add(
          GraphProblem(
            code: 'invalid_edge',
            message: 'A estrutura do grafo contém uma relação inválida.',
            nodeIds: [edge.sourceNode, edge.targetNode],
            fatal: true,
          ),
        );
        continue;
      }
      if (edge.type.toUpperCase() != 'SUBTOPIC' &&
          edge.type.toUpperCase() != 'PREREQUISITE') {
        issues.add(
          GraphProblem(
            code: 'invalid_edge_type',
            message: 'A relação tem um tipo não reconhecido.',
            nodeIds: [edge.sourceNode, edge.targetNode],
            retryable: true,
          ),
        );
      }
      if (edge.weight == null ||
          !edge.weight!.isFinite ||
          edge.weight! < 0 ||
          edge.weight! > 1) {
        issues.add(
          GraphProblem(
            code: 'invalid_edge_weight',
            message: 'O peso de uma relação precisa estar entre 0 e 1.',
            nodeIds: [edge.sourceNode, edge.targetNode],
            retryable: true,
          ),
        );
      }
      if (edge.type.toUpperCase() == 'PREREQUISITE') {
        prerequisites.add(edge);
        if (_isContainer(nodeIds[edge.sourceNode]!) ||
            _isContainer(nodeIds[edge.targetNode]!) ||
            containerIds.contains(edge.sourceNode) ||
            containerIds.contains(edge.targetNode)) {
          issues.add(
            GraphProblem(
              code: 'container_prerequisite',
              message:
                  'Pré-requisitos só podem ligar folhas, não AREA/TOPIC ou contêineres.',
              nodeIds: [edge.sourceNode, edge.targetNode],
              retryable: true,
            ),
          );
        }
      }
    }

    final cycle =
        _findCycleEdges(
          edges
              .where((edge) => edge.type.toUpperCase() == 'PREREQUISITE')
              .toList(),
        ) ??
        _findCycleEdges(
          edges.where((edge) => edge.type.toUpperCase() == 'SUBTOPIC').toList(),
        );
    if (cycle != null) {
      issues.add(
        GraphProblem(
          code: 'cycle',
          message: 'As relações hierárquicas ou de pré-requisito contêm ciclo.',
          nodeIds: cycle
              .expand((edge) => [edge.sourceNode, edge.targetNode])
              .toSet()
              .toList(),
          fatal: true,
          retryable: true,
        ),
      );
    }

    final edgeKeys = <(int, int)>{};
    for (final edge in edges) {
      if (!edgeKeys.add((edge.sourceNode, edge.targetNode))) {
        issues.add(
          GraphProblem(
            code: 'duplicate_edge',
            message: 'Há relações duplicadas entre os mesmos nós.',
            nodeIds: [edge.sourceNode, edge.targetNode],
            fatal: true,
          ),
        );
      }
    }

    final subtopicEdges = edges
        .where((edge) => edge.type.toUpperCase() == 'SUBTOPIC')
        .toList();
    final parentsByChild = <int, Set<int>>{};
    final childrenByParent = <int, List<int>>{};
    for (final edge in subtopicEdges) {
      if (!nodeIds.containsKey(edge.sourceNode) ||
          !nodeIds.containsKey(edge.targetNode)) {
        continue;
      }
      final parent = nodeIds[edge.sourceNode]!;
      final child = nodeIds[edge.targetNode]!;
      if (_hierarchyRank(parent.type) >= _hierarchyRank(child.type)) {
        issues.add(
          GraphProblem(
            code: 'invalid_hierarchy_order',
            message:
                '"${parent.title}" não pode conter "${child.title}" nesta ordem.',
            nodeIds: [parent.nodeId, child.nodeId],
            retryable: true,
          ),
        );
      }
      parentsByChild.putIfAbsent(child.nodeId, () => {}).add(parent.nodeId);
      childrenByParent
          .putIfAbsent(edge.sourceNode, () => [])
          .add(edge.targetNode);
    }
    for (final node in nodes) {
      final parentCount = parentsByChild[node.nodeId]?.length ?? 0;
      final invalidParentCount = node.type == GraphNodeType.area
          ? parentCount > 1
          : parentCount != 1;
      if (invalidParentCount) {
        issues.add(
          GraphProblem(
            code: 'invalid_hierarchy_parent_count',
            message: node.type == GraphNodeType.area
                ? '"${node.title}" está ligado a mais de um contêiner pai.'
                : '"${node.title}" precisa ter exatamente um contêiner pai.',
            nodeIds: [node.nodeId],
            retryable: true,
          ),
        );
      }
      if (_isContainer(node) &&
          (childrenByParent[node.nodeId]?.isEmpty ?? true)) {
        issues.add(
          GraphProblem(
            code: 'empty_container',
            message: 'O contêiner "${node.title}" não agrupa nenhum nó.',
            nodeIds: [node.nodeId],
            retryable: true,
          ),
        );
      }
    }

    final leaves = nodes
        .where(
          (node) =>
              !containerIds.contains(node.nodeId) &&
              !childrenByParent.containsKey(node.nodeId),
        )
        .toList();
    if (plan.trim().isEmpty) {
      issues.add(
        const GraphProblem(
          code: 'missing_scope_plan',
          message:
              'A IA não informou o escopo, as suposições e o ponto de partida do grafo.',
          retryable: true,
        ),
      );
    }
    if (coverage.isEmpty) {
      issues.add(
        const GraphProblem(
          code: 'missing_coverage_map',
          message:
              'A IA não apresentou o mapa que liga os resultados de aprendizagem aos conceitos.',
          retryable: true,
        ),
      );
    }
    final leafIds = leaves.map((node) => node.nodeId).toSet();
    final mappedLeafIds = <int>{};
    final outcomes = <String>{};
    for (final item in coverage) {
      final outcome = item.outcome.trim().replaceAll(RegExp(r'\s+'), ' ');
      if (outcome.isEmpty) {
        issues.add(
          const GraphProblem(
            code: 'empty_coverage_outcome',
            message: 'Um resultado do mapa de cobertura está vazio.',
            retryable: true,
          ),
        );
      } else if (!outcomes.add(outcome.toLowerCase())) {
        issues.add(
          GraphProblem(
            code: 'duplicate_coverage_outcome',
            message:
                'O resultado "$outcome" aparece mais de uma vez na cobertura.',
            retryable: true,
          ),
        );
      }
      if (item.nodeIds.isEmpty) {
        issues.add(
          GraphProblem(
            code: 'coverage_without_nodes',
            message:
                'O resultado "$outcome" não está ligado a nenhum conceito.',
            retryable: true,
          ),
        );
      }
      for (final nodeId in item.nodeIds) {
        if (!nodeIds.containsKey(nodeId)) {
          issues.add(
            GraphProblem(
              code: 'coverage_unknown_node',
              message:
                  'A cobertura de "$outcome" aponta para o nó inexistente $nodeId.',
              nodeIds: [nodeId],
              retryable: true,
            ),
          );
        } else if (!leafIds.contains(nodeId)) {
          issues.add(
            GraphProblem(
              code: 'coverage_container_node',
              message:
                  'A cobertura de "$outcome" deve apontar para conceitos, não contêineres.',
              nodeIds: [nodeId],
              retryable: true,
            ),
          );
        } else {
          mappedLeafIds.add(nodeId);
        }
      }
    }
    for (final leaf in leaves) {
      if (!mappedLeafIds.contains(leaf.nodeId)) {
        issues.add(
          GraphProblem(
            code: 'leaf_without_coverage',
            message:
                '"${leaf.title}" não está associado a nenhum resultado da cobertura.',
            nodeIds: [leaf.nodeId],
            retryable: true,
          ),
        );
      }
    }
    final prereqsByTarget = <int, List<GraphEdge>>{};
    for (final edge in prerequisites) {
      prereqsByTarget.putIfAbsent(edge.targetNode, () => []).add(edge);
    }
    final foundationIds = leaves
        .where((node) => node.level?.toLowerCase() == 'foundation')
        .map((node) => node.nodeId)
        .toSet();
    final objectiveByText = <String, int>{};

    for (final leaf in leaves) {
      final objective = leaf.description
          .trim()
          .replaceAll(RegExp(r'\s+'), ' ')
          .toLowerCase();
      if (objective.isEmpty) {
        issues.add(
          GraphProblem(
            code: 'missing_learning_objective',
            message:
                '"${leaf.title}" precisa de um objetivo de aprendizagem observável.',
            nodeIds: [leaf.nodeId],
            retryable: true,
          ),
        );
      } else {
        final previousNodeId = objectiveByText[objective];
        if (previousNodeId != null) {
          issues.add(
            GraphProblem(
              code: 'duplicate_learning_objective',
              message:
                  '"${leaf.title}" repete o objetivo de aprendizagem de outro nó.',
              nodeIds: [previousNodeId, leaf.nodeId],
              retryable: true,
            ),
          );
        } else {
          objectiveByText[objective] = leaf.nodeId;
        }
      }
      final incoming = prereqsByTarget[leaf.nodeId] ?? const <GraphEdge>[];
      if (leaf.level?.toLowerCase() == 'foundation' && incoming.isNotEmpty) {
        issues.add(
          GraphProblem(
            code: 'foundation_has_prerequisite',
            message:
                '"${leaf.title}" está marcado como foundation, mas tem pré-requisitos.',
            nodeIds: [leaf.nodeId],
            retryable: true,
          ),
        );
      }
      if (leaf.level?.toLowerCase() != 'foundation' && incoming.isEmpty) {
        issues.add(
          GraphProblem(
            code: 'leaf_without_prerequisite',
            message:
                '"${leaf.title}" não é foundation e não tem pré-requisito.',
            nodeIds: [leaf.nodeId],
            retryable: true,
          ),
        );
      }
      if (leaf.level?.toLowerCase() != 'foundation' &&
          !incoming.any((edge) => (edge.weight ?? 1) >= 0.7)) {
        issues.add(
          GraphProblem(
            code: 'leaf_ready_on_day_one',
            message:
                '"${leaf.title}" pode ficar pronto no primeiro dia sem pré-requisito essencial.',
            nodeIds: [leaf.nodeId],
            retryable: true,
          ),
        );
      }
      for (final edge in incoming) {
        final sourceLevel =
            _learningLevelOrder[nodeIds[edge.sourceNode]?.level?.toLowerCase()];
        final targetLevel = _learningLevelOrder[leaf.level?.toLowerCase()];
        if (sourceLevel != null &&
            targetLevel != null &&
            sourceLevel > targetLevel) {
          issues.add(
            GraphProblem(
              code: 'prerequisite_level_regression',
              message:
                  '"${leaf.title}" depende de um conceito de nível superior.',
              nodeIds: [edge.sourceNode, leaf.nodeId],
              retryable: true,
            ),
          );
        }
      }
    }

    final reachableFromFoundation = <int>{...foundationIds};
    final pending = <int>[...foundationIds];
    while (pending.isNotEmpty) {
      final current = pending.removeLast();
      for (final edge in prerequisites.where(
        (edge) => edge.sourceNode == current,
      )) {
        if (reachableFromFoundation.add(edge.targetNode)) {
          pending.add(edge.targetNode);
        }
      }
    }
    for (final leaf in leaves) {
      if (!reachableFromFoundation.contains(leaf.nodeId)) {
        issues.add(
          GraphProblem(
            code: 'leaf_unreachable_from_foundation',
            message: '"${leaf.title}" não tem caminho a partir de foundation.',
            nodeIds: [leaf.nodeId],
            retryable: true,
          ),
        );
      }
    }

    final studyBlueprint = blueprint;
    if (studyBlueprint != null) {
      issues.addAll(studyBlueprint.validate());
      issues.addAll(
        _validateBlueprintCoverage(
          studyBlueprint,
          nodeIds: nodeIds,
          leafIds: leafIds,
        ),
      );
    }

    for (var first = 0; first < nodes.length; first++) {
      for (var second = first + 1; second < nodes.length; second++) {
        if (_similarTitles(nodes[first].title, nodes[second].title)) {
          issues.add(
            GraphProblem(
              code: 'duplicate_or_similar_titles',
              message:
                  '"${nodes[first].title}" e "${nodes[second].title}" são duplicados ou muito semelhantes.',
              nodeIds: [nodes[first].nodeId, nodes[second].nodeId],
              retryable: true,
            ),
          );
        }
      }
    }

    return issues;
  }

  GraphResponse withBlueprint(GraphStudyBlueprint value) => GraphResponse(
    graphTitle: graphTitle,
    graphDescription: graphDescription,
    plan: plan,
    coverage: coverage,
    blueprint: value,
    nodes: nodes,
    edges: edges,
    problems: problems,
    qualityFallback: qualityFallback,
  );

  List<GraphProblem> _validateBlueprintCoverage(
    GraphStudyBlueprint studyBlueprint, {
    required Map<int, GraphNode> nodeIds,
    required Set<int> leafIds,
  }) {
    final issues = <GraphProblem>[];
    final outcomesById = {
      for (final outcome in studyBlueprint.outcomes) outcome.id: outcome,
    };
    final mappingsById = <String, GraphCoverageItem>{};

    for (final item in coverage) {
      final outcomeId = item.outcomeId?.trim() ?? '';
      if (outcomeId.isEmpty) {
        issues.add(
          GraphProblem(
            code: 'blueprint_outcome_mapping_missing',
            message:
                'O resultado "${item.outcome}" não está ligado ao ID do plano.',
            retryable: true,
          ),
        );
        continue;
      }
      if (!outcomesById.containsKey(outcomeId)) {
        issues.add(
          GraphProblem(
            code: 'blueprint_unknown_outcome',
            message:
                'A cobertura referencia o resultado desconhecido "$outcomeId".',
            retryable: true,
          ),
        );
        continue;
      }
      if (mappingsById.containsKey(outcomeId)) {
        issues.add(
          GraphProblem(
            code: 'blueprint_duplicate_outcome_mapping',
            message:
                'O resultado "$outcomeId" aparece mais de uma vez na cobertura.',
            retryable: true,
          ),
        );
        continue;
      }
      mappingsById[outcomeId] = item;
      final expected = outcomesById[outcomeId]!.outcome
          .trim()
          .replaceAll(RegExp(r'\s+'), ' ')
          .toLowerCase();
      final actual = item.outcome
          .trim()
          .replaceAll(RegExp(r'\s+'), ' ')
          .toLowerCase();
      if (expected != actual) {
        issues.add(
          GraphProblem(
            code: 'blueprint_outcome_text_mismatch',
            message:
                'A cobertura do resultado "$outcomeId" deve manter o texto do plano.',
            retryable: true,
          ),
        );
      }
    }

    for (final outcome in studyBlueprint.outcomes) {
      final targetMapping = mappingsById[outcome.id];
      if (targetMapping == null) {
        issues.add(
          GraphProblem(
            code: 'blueprint_unmapped_outcome',
            message:
                'O resultado planejado "${outcome.outcome}" não foi coberto.',
            retryable: true,
          ),
        );
        continue;
      }
      final targetLeaves = targetMapping.nodeIds
          .where(leafIds.contains)
          .toSet();
      for (final prerequisiteId in outcome.prerequisiteIds) {
        final sourceMapping = mappingsById[prerequisiteId];
        if (sourceMapping == null) continue;
        final sourceLeaves = sourceMapping.nodeIds
            .where(leafIds.contains)
            .toSet();
        final dependencyExists = sourceLeaves.any(
          (sourceId) => targetLeaves.any(
            (targetId) => _hasPath(
              from: sourceId,
              to: targetId,
              edges: edges,
              type: 'PREREQUISITE',
              minimumWeight: 0.7,
            ),
          ),
        );
        if (!dependencyExists) {
          issues.add(
            GraphProblem(
              code: 'blueprint_dependency_missing',
              message:
                  'O plano exige "${outcomesById[prerequisiteId]?.outcome}", '
                  'mas não há caminho de pré-requisito essencial até '
                  '"${outcome.outcome}".',
              nodeIds: [...sourceLeaves, ...targetLeaves],
              retryable: true,
            ),
          );
        }
      }
    }
    return issues;
  }
}

class GraphProblem {
  const GraphProblem({
    required this.code,
    required this.message,
    this.nodeIds = const [],
    this.fatal = false,
    this.retryable = false,
  });

  final String code;
  final String message;
  final List<int> nodeIds;
  final bool fatal;
  final bool retryable;

  @override
  String toString() => message;
}

bool _isContainer(GraphNode node) =>
    node.type == GraphNodeType.area || node.type == GraphNodeType.topic;

int _hierarchyRank(GraphNodeType type) => switch (type) {
  GraphNodeType.area => 0,
  GraphNodeType.topic => 1,
  GraphNodeType.concept => 2,
  GraphNodeType.subconcept => 3,
};

const _learningLevelOrder = {'foundation': 0, 'core': 1, 'advanced': 2};

List<GraphEdge>? _findCycleEdges(List<GraphEdge> edges) {
  final adjacency = <int, List<({int target, GraphEdge edge})>>{};
  for (final edge in edges) {
    final type = edge.type.toUpperCase();
    if (type != 'SUBTOPIC' && type != 'PREREQUISITE') continue;
    adjacency.putIfAbsent(edge.sourceNode, () => []).add((
      target: edge.targetNode,
      edge: edge,
    ));
  }
  final colors = <int, int>{};
  final nodeStack = <int>[];
  final pathEdges = <GraphEdge>[];

  List<GraphEdge>? visit(int nodeId) {
    colors[nodeId] = 1;
    nodeStack.add(nodeId);
    for (final entry in adjacency[nodeId] ?? const []) {
      final targetColor = colors[entry.target] ?? 0;
      if (targetColor == 1) {
        final cycleStart = nodeStack.indexOf(entry.target);
        return [...pathEdges.skip(cycleStart), entry.edge];
      }
      if (targetColor == 0) {
        pathEdges.add(entry.edge);
        final cycle = visit(entry.target);
        if (cycle != null) return cycle;
        pathEdges.removeLast();
      }
    }
    nodeStack.removeLast();
    colors[nodeId] = 2;
    return null;
  }

  for (final nodeId in adjacency.keys) {
    if ((colors[nodeId] ?? 0) == 0) {
      final cycle = visit(nodeId);
      if (cycle != null) return cycle;
    }
  }
  return null;
}

bool _hasPath({
  required int from,
  required int to,
  required List<GraphEdge> edges,
  required String type,
  double minimumWeight = 0,
}) {
  final pending = <int>[from];
  final visited = <int>{from};
  while (pending.isNotEmpty) {
    final current = pending.removeLast();
    for (final edge in edges.where(
      (edge) =>
          edge.type.toUpperCase() == type &&
          edge.sourceNode == current &&
          (edge.weight ?? 1) >= minimumWeight,
    )) {
      if (edge.targetNode == to) return true;
      if (visited.add(edge.targetNode)) pending.add(edge.targetNode);
    }
  }
  return false;
}

int _learningLevelDistance(GraphEdge edge, Map<int, GraphNode> nodesById) {
  final source =
      _learningLevelOrder[nodesById[edge.sourceNode]?.level?.toLowerCase()];
  final target =
      _learningLevelOrder[nodesById[edge.targetNode]?.level?.toLowerCase()];
  if (source == null || target == null) return 0;
  return (source - target).abs();
}

bool _similarTitles(String first, String second) {
  String normalize(String title) =>
      title.toLowerCase().replaceAll(RegExp(r'\s+'), '');
  final normalizedA = normalize(first);
  final normalizedB = normalize(second);
  final a = normalizedA.runes.toList();
  final b = normalizedB.runes.toList();
  if (a.isEmpty || b.isEmpty) return false;
  if (normalizedA == normalizedB) return true;
  if (a.length < 5 || b.length < 5) return false;
  final previous = List<int>.generate(b.length + 1, (index) => index);
  for (var i = 1; i <= a.length; i++) {
    var diagonal = previous[0];
    previous[0] = i;
    for (var j = 1; j <= b.length; j++) {
      final above = previous[j];
      previous[j] = [
        previous[j] + 1,
        previous[j - 1] + 1,
        diagonal + (a[i - 1] == b[j - 1] ? 0 : 1),
      ].reduce((left, right) => left < right ? left : right);
      diagonal = above;
    }
  }
  final ratio = 1 - previous.last / (a.length > b.length ? a.length : b.length);
  return ratio >= 0.88;
}

int _parseNodeId(dynamic value, String fieldName) {
  if (value is int) return value;
  if (value is num && value.isFinite && value == value.toInt()) {
    return value.toInt();
  }
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
  final String? level;

  const GraphNode({
    required this.nodeId,
    required this.title,
    required this.description,
    required this.type,
    this.level,
  });

  factory GraphNode.fromJson(Map<String, dynamic> json) {
    return GraphNode(
      nodeId: _parseNodeId(json['node_id'], 'node_id'),
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      type: GraphNodeType.fromString(json['type']),
      level: json['level'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'node_id': nodeId,
      'title': title,
      'description': description,
      'type': type.value,
      if (level != null) 'level': level,
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
  final double? weight;

  const GraphEdge({
    required this.sourceNode,
    required this.targetNode,
    required this.type,
    this.weight = 1.0,
  });

  factory GraphEdge.fromJson(Map<String, dynamic> json) {
    return GraphEdge(
      sourceNode: _parseNodeId(json['source_node'], 'source_node'),
      targetNode: _parseNodeId(json['target_node'], 'target_node'),
      type: json['type'] as String? ?? 'SUBTOPIC',
      weight: (json['weight'] as num?)?.toDouble() ?? 1.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'source_node': sourceNode,
      'target_node': targetNode,
      'type': type,
      'weight': weight,
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
