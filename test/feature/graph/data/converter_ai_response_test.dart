import 'package:flutter_test/flutter_test.dart';
import 'package:noema/feature/graph/data/converter_ai_response.dart';

GraphNode _node(
  int id,
  String title, {
  String type = 'CONCEPT',
  String? level,
}) => GraphNode(
  nodeId: id,
  title: title,
  description: '',
  type: GraphNodeType.fromString(type),
  level: level,
);

GraphEdge _edge(
  int source,
  int target, {
  String type = 'PREREQUISITE',
  double weight = 1,
}) => GraphEdge(
  sourceNode: source,
  targetNode: target,
  type: type,
  weight: weight,
);

void main() {
  test(
    'legacy JSON defaults weight but omits transient values when absent',
    () {
      final graph = GraphResponse.fromJson({
        'graph_title': 'Fundamentos',
        'nodes': [
          {'node_id': 1, 'title': 'Base', 'type': 'CONCEPT'},
        ],
        'edges': [
          {'source_node': 1, 'target_node': 2, 'type': 'PREREQUISITE'},
        ],
      });

      expect(graph.edges.single.weight, 1.0);
      expect(graph.nodes.single.level, isNull);
      expect(graph.toJson()['nodes'].single.containsKey('level'), isFalse);
      expect(graph.toJson()['edges'].single['weight'], 1.0);
      expect(graph.plan, isEmpty);
      expect(graph.coverage, isEmpty);
      expect(graph.toJson().containsKey('plan'), isFalse);
      expect(graph.toJson().containsKey('coverage'), isFalse);
    },
  );

  test('coverage audit maps every leaf outcome without persisting its plan', () {
    final graph = GraphResponse.fromJson({
      'graph_title': 'Equações',
      'plan':
          'Resolver equações de primeiro grau, partindo de operações inversas.',
      'coverage': [
        {
          'outcome': 'Aplicar operações inversas.',
          'node_ids': [3],
        },
        {
          'outcome': 'Resolver equações lineares.',
          'node_ids': [4],
        },
      ],
      'nodes': [
        {'node_id': 1, 'title': 'Matemática', 'type': 'AREA'},
        {'node_id': 2, 'title': 'Álgebra', 'type': 'TOPIC'},
        {
          'node_id': 3,
          'title': 'Operações inversas',
          'description': 'Isolar valores com operações inversas.',
          'type': 'CONCEPT',
          'level': 'foundation',
        },
        {
          'node_id': 4,
          'title': 'Equações lineares',
          'description': 'Resolver equações lineares de uma variável.',
          'type': 'CONCEPT',
          'level': 'core',
        },
      ],
      'edges': [
        {'source_node': 1, 'target_node': 2, 'type': 'SUBTOPIC'},
        {'source_node': 2, 'target_node': 3, 'type': 'SUBTOPIC'},
        {'source_node': 2, 'target_node': 4, 'type': 'SUBTOPIC'},
        {
          'source_node': 3,
          'target_node': 4,
          'type': 'PREREQUISITE',
          'weight': 1.0,
        },
      ],
    }).repair();

    expect(graph.hasCoverageAuditProblems, isFalse);
    expect(graph.validate().where((problem) => problem.retryable), isEmpty);
    expect(graph.toJson().containsKey('plan'), isFalse);
    expect(graph.toJson().containsKey('coverage'), isFalse);

    final incomplete = GraphResponse(
      graphTitle: graph.graphTitle,
      graphDescription: graph.graphDescription,
      plan: graph.plan,
      coverage: [graph.coverage.first],
      nodes: graph.nodes,
      edges: graph.edges,
    );
    expect(incomplete.hasCoverageAuditProblems, isTrue);
    expect(
      incomplete.validate().map((problem) => problem.code),
      contains('leaf_without_coverage'),
    );

    final invalid = GraphResponse(
      graphTitle: graph.graphTitle,
      graphDescription: graph.graphDescription,
      plan: graph.plan,
      coverage: [
        const GraphCoverageItem(
          outcome: 'Resolver equações.',
          nodeIds: [1, 999],
        ),
      ],
      nodes: graph.nodes,
      edges: graph.edges,
    );
    expect(
      invalid.validate().map((problem) => problem.code),
      containsAll(['coverage_container_node', 'coverage_unknown_node']),
    );
  });

  test(
    'blueprint dependencies must be represented by essential graph paths',
    () {
      final blueprint = GraphStudyBlueprint.fromJson({
        'scope': 'Train a model and evaluate its output.',
        'assumptions': [],
        'prior_knowledge': [],
        'outcomes': [
          {
            'id': 'outcome_1',
            'outcome': 'Prepare model inputs.',
            'evidence': 'Transform a small dataset into input features.',
            'prerequisite_ids': [],
          },
          {
            'id': 'outcome_2',
            'outcome': 'Evaluate model predictions.',
            'evidence': 'Compare predictions with a baseline.',
            'prerequisite_ids': ['outcome_1'],
          },
        ],
      });
      final graph = GraphResponse(
        graphTitle: 'Modelagem',
        graphDescription: '',
        plan: 'Preparar dados e avaliar previsões.',
        blueprint: blueprint,
        coverage: const [
          GraphCoverageItem(
            outcomeId: 'outcome_1',
            outcome: 'Prepare model inputs.',
            nodeIds: [3],
          ),
          GraphCoverageItem(
            outcomeId: 'outcome_2',
            outcome: 'Evaluate model predictions.',
            nodeIds: [4],
          ),
        ],
        nodes: [
          _node(1, 'Ciência de dados', type: 'AREA'),
          _node(2, 'Modelagem', type: 'TOPIC'),
          GraphNode(
            nodeId: 3,
            title: 'Preparação de dados',
            description: 'Transformar dados em atributos de entrada.',
            type: GraphNodeType.concept,
            level: 'foundation',
          ),
          GraphNode(
            nodeId: 4,
            title: 'Avaliação de modelos',
            description: 'Comparar previsões do modelo com uma linha de base.',
            type: GraphNodeType.concept,
            level: 'core',
          ),
        ],
        edges: [
          _edge(1, 2, type: 'SUBTOPIC'),
          _edge(2, 3, type: 'SUBTOPIC'),
          _edge(2, 4, type: 'SUBTOPIC'),
          _edge(3, 4, weight: 0.8),
        ],
      );

      expect(blueprint.startingOutcomes.single.id, 'outcome_1');
      expect(graph.validate().where((problem) => problem.retryable), isEmpty);
      expect(graph.hasCoverageAuditProblems, isFalse);
      expect(graph.toJson().containsKey('blueprint'), isFalse);
      expect(graph.toJson().containsKey('coverage'), isFalse);

      final missingDependency = GraphResponse(
        graphTitle: graph.graphTitle,
        graphDescription: graph.graphDescription,
        plan: graph.plan,
        blueprint: blueprint,
        coverage: graph.coverage,
        nodes: graph.nodes,
        edges: graph.edges.where((edge) => edge.type == 'SUBTOPIC').toList(),
      );
      expect(
        missingDependency.validate().map((problem) => problem.code),
        contains('blueprint_dependency_missing'),
      );
      expect(missingDependency.hasCoverageAuditProblems, isTrue);
    },
  );

  test('JSON rejects fractional graph-local identifiers', () {
    expect(
      () => GraphResponse.fromJson({
        'graph_title': 'Grafo inválido',
        'nodes': [
          {'node_id': 1.5, 'title': 'Nó', 'type': 'CONCEPT'},
        ],
        'edges': const [],
      }),
      throwsFormatException,
    );
  });

  test('leaf learning objectives are required and retained for import', () {
    final graph = GraphResponse.fromJson({
      'graph_title': 'Fundamentos',
      'nodes': [
        {'node_id': 1, 'title': 'Área', 'type': 'AREA'},
        {'node_id': 2, 'title': 'Tópico', 'type': 'TOPIC'},
        {
          'node_id': 3,
          'title': 'Frações',
          'description':
              'Comparar e operar frações com denominadores distintos.',
          'type': 'CONCEPT',
          'level': 'foundation',
        },
      ],
      'edges': [
        {'source_node': 1, 'target_node': 2, 'type': 'SUBTOPIC'},
        {'source_node': 2, 'target_node': 3, 'type': 'SUBTOPIC'},
      ],
    });

    expect(graph.nodes.last.description, contains('Comparar'));
    expect(
      graph.validate().any(
        (problem) => problem.code == 'missing_learning_objective',
      ),
      isFalse,
    );

    final missingObjective = GraphResponse(
      graphTitle: 'Fundamentos',
      graphDescription: '',
      nodes: [
        _node(1, 'Área', type: 'AREA'),
        _node(2, 'Tópico', type: 'TOPIC'),
        _node(3, 'Frações', level: 'foundation'),
      ],
      edges: [
        _edge(1, 2, type: 'SUBTOPIC'),
        _edge(2, 3, type: 'SUBTOPIC'),
      ],
    ).validate();
    expect(
      missingObjective
          .singleWhere(
            (problem) => problem.code == 'missing_learning_objective',
          )
          .retryable,
      isTrue,
    );
  });

  test('validation rejects repeated leaf learning objectives', () {
    final graph = GraphResponse(
      graphTitle: 'Fundamentos',
      graphDescription: '',
      nodes: [
        _node(1, 'Área', type: 'AREA'),
        _node(2, 'Tópico', type: 'TOPIC'),
        GraphNode(
          nodeId: 3,
          title: 'Frações',
          description: 'Comparar frações com denominadores distintos.',
          type: GraphNodeType.concept,
          level: 'foundation',
        ),
        GraphNode(
          nodeId: 4,
          title: 'Números racionais',
          description: '  Comparar frações com denominadores distintos. ',
          type: GraphNodeType.concept,
          level: 'foundation',
        ),
      ],
      edges: [
        _edge(1, 2, type: 'SUBTOPIC'),
        _edge(2, 3, type: 'SUBTOPIC'),
        _edge(2, 4, type: 'SUBTOPIC'),
      ],
    );

    final issue = graph.validate().singleWhere(
      (problem) => problem.code == 'duplicate_learning_objective',
    );
    expect(issue.nodeIds, [3, 4]);
    expect(issue.retryable, isTrue);
  });

  test('repair removes container prerequisites, self-loops and duplicates', () {
    final graph = GraphResponse(
      graphTitle: 'Grafo',
      graphDescription: '',
      nodes: [
        _node(1, 'Área', type: 'AREA'),
        _node(2, 'Tópico', type: 'TOPIC'),
        _node(3, 'Folha', level: 'foundation'),
      ],
      edges: [
        _edge(1, 2, type: 'SUBTOPIC'),
        _edge(2, 3, type: 'SUBTOPIC'),
        _edge(2, 3, weight: 0.4),
        _edge(2, 3, type: 'SUBTOPIC', weight: 0.4),
        _edge(3, 3),
      ],
    ).repair();

    expect(graph.edges.map((edge) => (edge.sourceNode, edge.targetNode)), [
      (1, 2),
      (2, 3),
    ]);
    expect(
      graph.problems.map((problem) => problem.code),
      containsAll(['container_prerequisite_removed', 'self_loop_removed']),
    );
    expect(
      graph.problems.map((problem) => problem.code),
      contains('duplicate_edge_removed'),
    );
    expect(graph.problems.every((problem) => problem.retryable), isTrue);
  });

  test(
    'repair removes unsupported relation types and requests regeneration',
    () {
      final graph = GraphResponse(
        graphTitle: 'Grafo',
        graphDescription: '',
        nodes: [
          _node(1, 'Área', type: 'AREA'),
          _node(2, 'Tópico', type: 'TOPIC'),
          _node(3, 'Fundamento', level: 'foundation'),
          _node(4, 'Núcleo'),
        ],
        edges: [
          _edge(1, 2, type: 'SUBTOPIC'),
          _edge(2, 3, type: 'SUBTOPIC'),
          _edge(3, 4, type: 'RELATED'),
          _edge(3, 4, weight: 1.5),
        ],
      ).repair();

      expect(graph.edges, hasLength(2));
      expect(
        graph.problems.map((problem) => problem.code),
        contains('invalid_edge_type_removed'),
      );
      expect(
        graph.problems.map((problem) => problem.code),
        contains('invalid_edge_weight_removed'),
      );
      expect(graph.problems.last.retryable, isTrue);
    },
  );

  test('legacy relation types remain non-fatal during graph transfer', () {
    final graph = GraphResponse(
      graphTitle: 'Legado',
      graphDescription: '',
      nodes: [_node(1, 'Questão'), _node(2, 'Conceito')],
      edges: [_edge(1, 2, type: 'CHECK')],
    );

    final issue = graph.validate().singleWhere(
      (problem) => problem.code == 'invalid_edge_type',
    );
    expect(issue.fatal, isFalse);
    expect(issue.retryable, isTrue);
  });

  test(
    'validation requires one hierarchy parent and progression by node type',
    () {
      final graph = GraphResponse(
        graphTitle: 'Progressão',
        graphDescription: '',
        nodes: [
          _node(1, 'Área', type: 'AREA'),
          _node(2, 'Tópico', type: 'TOPIC'),
          _node(3, 'Folha', level: 'foundation'),
          _node(4, 'Avançado', level: 'advanced'),
        ],
        edges: [
          _edge(1, 2, type: 'SUBTOPIC'),
          _edge(2, 3, type: 'SUBTOPIC'),
          _edge(2, 4, type: 'SUBTOPIC'),
          _edge(4, 3),
        ],
      );

      final codes = graph.validate().map((problem) => problem.code).toSet();
      expect(codes, contains('foundation_has_prerequisite'));
      expect(codes, contains('prerequisite_level_regression'));
      expect(codes, isNot(contains('invalid_hierarchy_parent_count')));
      expect(codes, isNot(contains('empty_container')));
    },
  );

  test('validation rejects orphan nodes and shared hierarchy children', () {
    final graph = GraphResponse(
      graphTitle: 'Hierarquia inválida',
      graphDescription: '',
      nodes: [
        _node(1, 'Área', type: 'AREA'),
        _node(2, 'Tópico A', type: 'TOPIC'),
        _node(3, 'Tópico B', type: 'TOPIC'),
        _node(4, 'Folha', level: 'foundation'),
        _node(5, 'Tópico vazio', type: 'TOPIC'),
      ],
      edges: [
        _edge(1, 2, type: 'SUBTOPIC'),
        _edge(1, 3, type: 'SUBTOPIC'),
        _edge(1, 5, type: 'SUBTOPIC'),
        _edge(2, 4, type: 'SUBTOPIC'),
        _edge(3, 4, type: 'SUBTOPIC'),
      ],
    );

    final issues = graph.validate();
    expect(
      issues.where(
        (problem) => problem.code == 'invalid_hierarchy_parent_count',
      ),
      hasLength(1),
    );
    expect(issues.any((problem) => problem.code == 'empty_container'), isTrue);
  });

  test(
    'repair removes the lowest-weight cycle edge and reduces transitivity',
    () {
      final graph = GraphResponse(
        graphTitle: 'Ciclo e transitividade',
        graphDescription: '',
        nodes: [
          _node(1, 'Fundamento', level: 'foundation'),
          _node(2, 'Núcleo'),
          _node(3, 'Avançado', level: 'advanced'),
          _node(4, 'Alternativo'),
        ],
        edges: [
          _edge(1, 2, weight: 0.8),
          _edge(2, 3, weight: 0.8),
          _edge(3, 1, weight: 0.2),
          _edge(1, 3, weight: 0.4),
          _edge(1, 4, weight: 0),
        ],
      ).repair();

      expect(
        graph.edges.any((edge) => edge.sourceNode == 3 && edge.targetNode == 1),
        isFalse,
      );
      expect(
        graph.edges.any((edge) => edge.sourceNode == 1 && edge.targetNode == 3),
        isFalse,
      );
      expect(
        graph.problems.map((problem) => problem.code),
        contains('cycle_edge_removed'),
      );
      expect(
        graph.problems.map((problem) => problem.code),
        contains('transitive_prerequisite_removed'),
      );
    },
  );

  test('transitive reduction preserves essential edges over weak paths', () {
    final graph = GraphResponse(
      graphTitle: 'Pré-requisitos opcionais',
      graphDescription: '',
      nodes: [
        _node(1, 'Base'),
        _node(2, 'Ideia intermediária'),
        _node(3, 'Alvo'),
      ],
      edges: [
        _edge(1, 2, weight: 0.5),
        _edge(2, 3, weight: 0.5),
        _edge(1, 3, weight: 1.0),
      ],
    ).repair();

    expect(graph.edges, hasLength(3));
    expect(
      graph.problems.map((problem) => problem.code),
      isNot(contains('transitive_prerequisite_removed')),
    );
  });

  test('validate returns structured retry feedback for generation gaps', () {
    final graph = GraphResponse(
      graphTitle: 'Base',
      graphDescription: '',
      nodes: [_node(1, 'Neural networks'), _node(2, 'Neural network')],
      edges: const [],
    );

    final problems = graph.validate();
    expect(problems, isNotEmpty);
    expect(problems.every((problem) => problem.retryable), isTrue);
    expect(
      problems.map((problem) => problem.code),
      containsAll([
        'leaf_without_prerequisite',
        'leaf_unreachable_from_foundation',
        'duplicate_or_similar_titles',
      ]),
    );
  });

  test('similar-title validation preserves non-Latin titles', () {
    final graph = GraphResponse(
      graphTitle: '数学',
      graphDescription: '',
      nodes: [_node(1, '数学'), _node(2, '数学')],
      edges: const [],
    );

    expect(
      graph.validate().map((problem) => problem.code),
      contains('duplicate_or_similar_titles'),
    );
  });
}
