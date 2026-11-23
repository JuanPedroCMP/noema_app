import 'dart:collection';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:noema/core/database/database.dart';
import 'package:noema/core/database/database_provider.dart';
import 'package:noema/feature/graph/data/graph_node_dao.dart';
import 'package:noema/feature/graph/provider/graph_provider.dart';

// OBS.: Gerei com IA
//
// ============================================================================
// O QUE MUDOU NESTA VERSÃO
// ============================================================================
//
// CAMADAS
//   - Antes: Kahn com limite de largura (sqrt(n)). Isso empurrava irmãos para
//     camadas diferentes e criava arestas longas. Agora: caminho mais longo +
//     "tightening" (nós com folga descem até ficarem logo acima dos filhos,
//     encurtando arestas). O limite de largura virou opcional (null = sem
//     limite) e as camadas vazias são comprimidas.
//
// COMPONENTES
//   - Componentes conexos são diagramados separadamente e depois empacotados
//     (shelf packing). Grafos desconexos deixam de se misturar na mesma
//     camada, e nós isolados não formam mais uma linha gigante.
//
// QUEBRA DE CICLOS
//   - O DFS agora começa pelos nós "fonte" e explora primeiro as arestas de
//     maior peso. Assim as arestas hierárquicas viram arestas de árvore e as
//     de menor importância é que são invertidas.
//
// CRUZAMENTOS
//   - Nós sem vizinhos na camada de referência mantêm o próprio slot (antes
//     eram jogados para a direita).
//   - Mediana ponderada com desempate pela média ponderada.
//   - Transpose passou de O(E log V) por troca para O(grau²) por troca
//     (conta só os cruzamentos entre os dois nós trocados).
//   - Parada antecipada (estagnação / zero cruzamentos).
//
// COORDENADAS X
//   - Projeção por camada DENTRO de cada passada (antes só no fim, então a
//     camada seguinte se baseava em posições inviáveis).
//   - PAVA ponderada com folgas variáveis: dummy nodes ocupam menos espaço e
//     têm prioridade maior, o que mantém arestas longas retas.
//   - Posição desejada ponderada pelo peso das arestas.
//   - Posição inicial centralizada por camada.
//   - A última passada é sempre "para trás": pais centralizados sobre filhos.
//   - A "compactação" por deslocamento médio de camada (que não tinha base
//     teórica) foi removida. `compact` agora controla o empacotamento 2D dos
//     componentes.
//
// ============================================================================
// CONFIGURAÇÃO
// ============================================================================

enum SugiyamaLayoutMode {
  /// Cada nó tenta se aproximar da média ponderada de seus vizinhos.
  balanced,

  /// Cada nó é centralizado entre o vizinho mais à esquerda e o mais à
  /// direita. Visual de organograma / árvore genealógica. Recomendado para
  /// grafos predominantemente hierárquicos.
  centered,
}

class SugiyamaConfig {
  /// Espaçamento horizontal preferido entre nós reais na posição inicial.
  /// O resultado final respeita `minimumHorizontalGap`.
  final double horizontalSpacing;

  /// Distância vertical entre camadas.
  final double verticalSpacing;

  /// Distância mínima entre os centros de dois nós reais da mesma camada.
  final double minimumHorizontalGap;

  /// Distância mínima entre dois dummy nodes (pontos de passagem de arestas
  /// longas). Menor que `minimumHorizontalGap`, pois dummies não têm largura.
  final double dummyGap;

  /// Distância horizontal entre componentes desconexos.
  final double componentGap;

  /// Ciclos de downward sweep -> upward sweep -> transpose.
  final int crossingIterations;

  /// Rodadas de refinamento por troca adjacente.
  final int transposeIterations;

  /// Iterações de ajuste das coordenadas X (arredondado para par).
  final int coordinateIterations;

  /// Limite opcional de nós por camada. `null` = sem limite (recomendado:
  /// limitar quebra a hierarquia visual).
  final int? maxNodesPerLayer;

  /// Usa a posição X anterior como ordem inicial.
  final bool preservePreviousOrder;

  /// Quando true, empacota componentes desconexos em linhas (proporção
  /// ~16:9). Quando false, coloca todos lado a lado em uma única linha.
  final bool compact;

  /// Aproxima nós com folga vertical dos filhos (arestas mais curtas).
  final bool tightenLayers;

  /// Estratégia de posicionamento horizontal. Veja `SugiyamaLayoutMode`.
  final SugiyamaLayoutMode mode;

  const SugiyamaConfig({
    this.horizontalSpacing = 250.0,
    this.verticalSpacing = 190.0,
    this.minimumHorizontalGap = 250.0,
    this.dummyGap = 80.0,
    this.componentGap = 300.0,
    this.crossingIterations = 36,
    this.transposeIterations = 10,
    this.coordinateIterations = 12,
    this.maxNodesPerLayer,
    this.preservePreviousOrder = true,
    this.compact = true,
    this.tightenLayers = true,
    this.mode = SugiyamaLayoutMode.balanced,
  });
}

/// Prioridade de um dummy node na projeção horizontal. Maior que 1 faz com
/// que ele se mova menos, mantendo arestas longas retas.
const double _dummyPriority = 4.0;

// ============================================================================
// TIPOS INTERNOS
// ============================================================================

class _InputEdge {
  final String source;
  final String target;
  final String type;
  final double? weight;

  const _InputEdge({
    required this.source,
    required this.target,
    required this.type,
    this.weight,
  });
}

class _LayoutNode {
  final String id;
  final bool isDummy;
  final String? realNodeId;

  const _LayoutNode({required this.id, required this.isDummy, this.realNodeId});
}

class _LayoutEdge {
  final String source;
  final String target;
  final bool isHierarchical;
  final int crossingWeight;

  const _LayoutEdge({
    required this.source,
    required this.target,
    required this.isHierarchical,
    required this.crossingWeight,
  });
}

class _GraphModel {
  final Map<String, _LayoutNode> nodes;
  final List<_LayoutEdge> edges;

  final Map<String, List<String>> parents;
  final Map<String, List<String>> children;
  final Map<String, List<String>> hierarchyParents;
  final Map<String, List<String>> hierarchyChildren;
  final Map<(String, String), int> edgeWeights;

  final Map<String, int> indegree;

  /// Arestas invertidas apenas no layout por `_breakCycles`.
  final int cyclesBrokenCount;

  const _GraphModel({
    required this.nodes,
    required this.edges,
    required this.parents,
    required this.children,
    required this.hierarchyParents,
    required this.hierarchyChildren,
    required this.edgeWeights,
    required this.indegree,
    this.cyclesBrokenCount = 0,
  });
}

class _ExpandedGraph {
  final _GraphModel graph;
  final Map<String, int> layers;

  const _ExpandedGraph({required this.graph, required this.layers});
}

class _LayerOrderResult {
  final Map<int, List<String>> nodesByLayer;
  final int crossingCount;

  const _LayerOrderResult({
    required this.nodesByLayer,
    required this.crossingCount,
  });
}

class _Component {
  final List<GraphNodeData> nodes;
  final List<_InputEdge> edges;

  const _Component({required this.nodes, required this.edges});
}

class _ComponentLayout {
  /// Posições apenas dos nós reais, normalizadas (canto superior esquerdo
  /// do `bounds` em 0,0).
  final Map<String, Offset> positions;
  final Map<String, int> layers;
  final int cyclesBroken;
  final int nodeCount;

  /// Retângulo que envolve também os dummy nodes (por onde as arestas
  /// passam), para que componentes vizinhos não colidam com elas.
  final Rect bounds;

  const _ComponentLayout({
    required this.positions,
    required this.layers,
    required this.cyclesBroken,
    required this.nodeCount,
    required this.bounds,
  });
}

class SugiyamaLayoutResult {
  final Map<String, Offset> positions;
  final Map<String, int> layers;
  final int cyclesBrokenCount;

  const SugiyamaLayoutResult({
    required this.positions,
    required this.layers,
    required this.cyclesBrokenCount,
  });
}

SugiyamaLayoutResult calculateSugiyamaLayout({
  required List<GraphNodeData> nodes,
  required List<GraphEdgeData> edges,
  Map<String, double> previousX = const {},
  SugiyamaConfig config = const SugiyamaConfig(),
}) {
  return _runSugiyama(
    nodes: nodes,
    edges: [
      for (final edge in edges)
        _InputEdge(
          source: edge.sourceNodeId,
          target: edge.targetNodeId,
          type: edge.type,
          weight: edge.weight,
        ),
    ],
    previousX: previousX,
    config: _sanitizeConfig(config),
  );
}

// ============================================================================
// RESULTADO DE UMA EXECUÇÃO
// ============================================================================

class SugiyamaRunResult {
  /// Nós reais cuja posição foi salva com sucesso.
  final int nodesUpdated;

  /// Nós reais que falharam ao salvar (detalhes em `debugPrint`).
  final int nodesFailed;

  /// Arestas invertidas apenas no cálculo do layout para quebrar ciclos.
  final int cyclesBroken;

  /// Retângulo que envolve todas as posições calculadas.
  final Rect? bounds;

  const SugiyamaRunResult({
    required this.nodesUpdated,
    required this.nodesFailed,
    required this.cyclesBroken,
    required this.bounds,
  });

  static const empty = SugiyamaRunResult(
    nodesUpdated: 0,
    nodesFailed: 0,
    cyclesBroken: 0,
    bounds: null,
  );
}

/// Mantida apenas por compatibilidade com código externo. O algoritmo não
/// lança mais essa exceção.
class SugiyamaLayoutException implements Exception {
  final String message;

  const SugiyamaLayoutException(this.message);

  @override
  String toString() => 'SugiyamaLayoutException: $message';
}

// ============================================================================
// FENWICK TREE
// ============================================================================

class _FenwickTree {
  final List<int> _tree;

  _FenwickTree(int size) : _tree = List<int>.filled(size + 1, 0);

  void add(int index, int value) {
    var i = index + 1;

    while (i < _tree.length) {
      _tree[i] += value;
      i += i & -i;
    }
  }

  int query(int index) {
    var i = index + 1;
    var result = 0;

    while (i > 0) {
      result += _tree[i];
      i -= i & -i;
    }

    return result;
  }
}

// ============================================================================
// API PRINCIPAL
// ============================================================================

/// Ponto de entrada público. Nunca lança exceções: qualquer falha é
/// registrada via `debugPrint` e a função retorna `SugiyamaRunResult.empty`
/// sem alterar o que já estava salvo.
Future<SugiyamaRunResult> sugiyama(
  String graphId,
  WidgetRef ref, {
  SugiyamaConfig config = const SugiyamaConfig(),
}) async {
  try {
    return await _runAndPersistSugiyama(
      graphId: graphId,
      ref: ref,
      config: _sanitizeConfig(config),
    );
  } catch (error, stackTrace) {
    debugPrint(
      'Sugiyama: falha inesperada no auto-layout do grafo "$graphId". '
      'As posições anteriores foram preservadas. Erro: $error',
    );
    debugPrint('$stackTrace');

    return SugiyamaRunResult.empty;
  }
}

Future<SugiyamaRunResult> _runAndPersistSugiyama({
  required String graphId,
  required WidgetRef ref,
  required SugiyamaConfig config,
}) async {
  final db = ref.read(appDatabaseProvider);
  final graphNodeDao = GraphNodeDao(db);

  final nodes = await ref.read(nodesProvider(graphId).future);
  final edges = await ref.read(edgesProvider(graphId).future);

  if (nodes.isEmpty) {
    return SugiyamaRunResult.empty;
  }

  final previousX = <String, double>{};

  if (config.preservePreviousOrder) {
    for (final node in nodes) {
      final x = node.positionX;

      if (x.isFinite) {
        previousX[node.id] = x;
      }
    }
  }

  final result = calculateSugiyamaLayout(
    nodes: nodes,
    edges: edges,
    previousX: previousX,
    config: config,
  );

  var succeeded = 0;
  var failed = 0;

  double? minX;
  double? minY;
  double? maxX;
  double? maxY;

  for (final node in nodes) {
    final position = result.positions[node.id];

    if (position == null) {
      continue;
    }

    minX = (minX == null) ? position.dx : math.min(minX, position.dx);
    maxX = (maxX == null) ? position.dx : math.max(maxX, position.dx);
    minY = (minY == null) ? position.dy : math.min(minY, position.dy);
    maxY = (maxY == null) ? position.dy : math.max(maxY, position.dy);

    try {
      await graphNodeDao.updateGraphNode(
        id: node.id,
        positionX: position.dx,
        positionY: position.dy,
      );

      succeeded++;
    } catch (error) {
      failed++;

      debugPrint(
        'Sugiyama: falha ao persistir a posição do nó ${node.id} '
        '("${node.title}"). Os demais nós continuam sendo processados. '
        'Erro: $error',
      );
    }
  }

  debugPrint(
    'Sugiyama finalizado: '
    '${nodes.length} nós reais '
    '($succeeded atualizados, $failed com falha, '
    '${result.cyclesBrokenCount} ciclo(s) quebrado(s)).',
  );

  final bounds = (minX != null && minY != null && maxX != null && maxY != null)
      ? Rect.fromLTRB(minX, minY, maxX, maxY)
      : null;

  return SugiyamaRunResult(
    nodesUpdated: succeeded,
    nodesFailed: failed,
    cyclesBroken: result.cyclesBrokenCount,
    bounds: bounds,
  );
}

// ============================================================================
// SANITIZAÇÃO DE CONFIGURAÇÃO
// ============================================================================

SugiyamaConfig _sanitizeConfig(SugiyamaConfig config) {
  double safeSpacing(double value, double fallback) {
    if (!value.isFinite || value <= 0) {
      return fallback;
    }

    return value;
  }

  int safeIterations(int value) => value < 0 ? 0 : value;

  final minimumGap = safeSpacing(config.minimumHorizontalGap, 220.0);

  return SugiyamaConfig(
    horizontalSpacing: safeSpacing(config.horizontalSpacing, 220.0),
    verticalSpacing: safeSpacing(config.verticalSpacing, 180.0),
    minimumHorizontalGap: minimumGap,
    dummyGap: math.min(safeSpacing(config.dummyGap, 70.0), minimumGap),
    componentGap: safeSpacing(config.componentGap, 300.0),
    crossingIterations: safeIterations(config.crossingIterations),
    transposeIterations: safeIterations(config.transposeIterations),
    coordinateIterations: safeIterations(config.coordinateIterations),
    maxNodesPerLayer:
        config.maxNodesPerLayer != null && config.maxNodesPerLayer! > 0
        ? config.maxNodesPerLayer
        : null,
    preservePreviousOrder: config.preservePreviousOrder,
    compact: config.compact,
    tightenLayers: config.tightenLayers,
    mode: config.mode,
  );
}

// ============================================================================
// PIPELINE
// ============================================================================

SugiyamaLayoutResult _runSugiyama({
  required List<GraphNodeData> nodes,
  required List<_InputEdge> edges,
  required Map<String, double> previousX,
  required SugiyamaConfig config,
}) {
  // 1. Cada componente conexo é diagramado de forma independente, exceto
  // quando o limite de largura precisa ser aplicado ao grafo inteiro.
  final components = config.maxNodesPerLayer == null
      ? _splitComponents(nodes: nodes, edges: edges)
      : [_Component(nodes: nodes, edges: edges)];

  final layouts = <_ComponentLayout>[
    for (final component in components)
      _layoutComponent(
        component: component,
        previousX: previousX,
        config: config,
      ),
  ];

  // 2. Os componentes são empacotados na tela.
  final offsets = _packComponents(layouts: layouts, config: config);

  final positions = <String, Offset>{};
  final layers = <String, int>{};
  var cycles = 0;

  for (var i = 0; i < layouts.length; i++) {
    final layout = layouts[i];
    final offset = offsets[i];

    for (final entry in layout.positions.entries) {
      positions[entry.key] = entry.value + offset;
    }

    layers.addAll(layout.layers);
    cycles += layout.cyclesBroken;
  }

  return SugiyamaLayoutResult(
    positions: positions,
    layers: layers,
    cyclesBrokenCount: cycles,
  );
}

_ComponentLayout _layoutComponent({
  required _Component component,
  required Map<String, double> previousX,
  required SugiyamaConfig config,
}) {
  final graph = _buildGraph(nodes: component.nodes, edges: component.edges);

  final layers = _assignLayers(
    graph: graph,
    maxNodesPerLayer: config.maxNodesPerLayer,
    tighten: config.tightenLayers,
  );

  final expanded = _insertDummyNodes(graph: graph, layers: layers);

  final initialLayers = _buildInitialLayerOrder(
    layers: expanded.layers,
    graph: expanded.graph,
    previousX: previousX,
  );

  final crossingResult = _minimizeCrossings(
    graph: expanded.graph,
    initialLayers: initialLayers,
    config: config,
  );

  final all = _assignCoordinates(
    graph: expanded.graph,
    nodesByLayer: crossingResult.nodesByLayer,
    config: config,
  );

  var minX = double.infinity;
  var minY = double.infinity;
  var maxX = double.negativeInfinity;
  var maxY = double.negativeInfinity;

  for (final position in all.values) {
    minX = math.min(minX, position.dx);
    maxX = math.max(maxX, position.dx);
    minY = math.min(minY, position.dy);
    maxY = math.max(maxY, position.dy);
  }

  if (!minX.isFinite) {
    minX = 0;
    minY = 0;
    maxX = 0;
    maxY = 0;
  }

  return _ComponentLayout(
    positions: {
      for (final node in component.nodes)
        if (all[node.id] != null) node.id: all[node.id]!,
    },
    layers: {
      for (final node in component.nodes)
        if (layers[node.id] != null) node.id: layers[node.id]!,
    },
    cyclesBroken: graph.cyclesBrokenCount,
    nodeCount: component.nodes.length,
    bounds: Rect.fromLTRB(minX, minY, maxX, maxY),
  );
}

// ============================================================================
// COMPONENTES CONEXOS E EMPACOTAMENTO
// ============================================================================

List<_Component> _splitComponents({
  required List<GraphNodeData> nodes,
  required List<_InputEdge> edges,
}) {
  final parent = <String, String>{for (final node in nodes) node.id: node.id};

  String find(String x) {
    var root = x;
    while (parent[root] != root) {
      root = parent[root]!;
    }

    var current = x;
    while (parent[current] != root) {
      final next = parent[current]!;
      parent[current] = root;
      current = next;
    }

    return root;
  }

  bool isValid(_InputEdge edge) =>
      parent.containsKey(edge.source) &&
      parent.containsKey(edge.target) &&
      edge.source != edge.target;

  for (final edge in edges) {
    if (!isValid(edge)) continue;

    final a = find(edge.source);
    final b = find(edge.target);

    if (a != b) {
      parent[b] = a;
    }
  }

  final nodesByRoot = <String, List<GraphNodeData>>{};
  for (final node in nodes) {
    nodesByRoot.putIfAbsent(find(node.id), () => <GraphNodeData>[]).add(node);
  }

  final edgesByRoot = <String, List<_InputEdge>>{};
  for (final edge in edges) {
    if (!isValid(edge)) continue;

    edgesByRoot.putIfAbsent(find(edge.source), () => <_InputEdge>[]).add(edge);
  }

  return [
    for (final entry in nodesByRoot.entries)
      _Component(
        nodes: entry.value,
        edges: edgesByRoot[entry.key] ?? const <_InputEdge>[],
      ),
  ];
}

/// Shelf packing: componentes maiores primeiro, preenchendo linhas até uma
/// largura-alvo (~16:9). Retorna o deslocamento a somar em cada layout.
List<Offset> _packComponents({
  required List<_ComponentLayout> layouts,
  required SugiyamaConfig config,
}) {
  final offsets = List<Offset>.filled(layouts.length, Offset.zero);

  if (layouts.length <= 1) {
    return offsets;
  }

  final order = List<int>.generate(layouts.length, (i) => i)
    ..sort((a, b) {
      final byCount = layouts[b].nodeCount.compareTo(layouts[a].nodeCount);
      return byCount != 0 ? byCount : a.compareTo(b);
    });

  var maxWidth = 0.0;
  var totalArea = 0.0;

  for (final layout in layouts) {
    maxWidth = math.max(maxWidth, layout.bounds.width);
    totalArea +=
        (layout.bounds.width + config.componentGap) *
        (layout.bounds.height + config.verticalSpacing);
  }

  final targetWidth = config.compact
      ? math.max(maxWidth, math.sqrt(totalArea) * 1.8)
      : double.infinity;

  var cursorX = 0.0;
  var cursorY = 0.0;
  var rowHeight = 0.0;

  for (final index in order) {
    final layout = layouts[index];
    final width = layout.bounds.width;
    final height = layout.bounds.height;

    if (cursorX > 0 && cursorX + width > targetWidth) {
      cursorX = 0;
      cursorY += rowHeight + config.verticalSpacing;
      rowHeight = 0;
    }

    offsets[index] = Offset(
      cursorX - layout.bounds.left,
      cursorY - layout.bounds.top,
    );

    cursorX += width + config.componentGap;
    rowHeight = math.max(rowHeight, height);
  }

  return offsets;
}

// ============================================================================
// CONSTRUIR GRAFO
// ============================================================================

int? _hierarchyLevel(String type) => switch (type.toUpperCase()) {
  'AREA' => 0,
  'TOPIC' => 1,
  'CONCEPT' => 2,
  'SUBCONCEPT' => 3,
  _ => null,
};

/// Arestas SUBTOPIC são armazenadas como filho -> pai. Aqui elas são
/// normalizadas para pai -> filho. Quando os níveis hierárquicos dos dois
/// nós são conhecidos e já estão em ordem (pai de nível menor), a aresta é
/// mantida; em qualquer outro caso ela é invertida.
_InputEdge _normalizeEdgeDirection(
  _InputEdge edge,
  Map<String, String> nodeTypes,
) {
  if (edge.type.toUpperCase() != 'SUBTOPIC') return edge;

  final sourceLevel = _hierarchyLevel(nodeTypes[edge.source] ?? '');
  final targetLevel = _hierarchyLevel(nodeTypes[edge.target] ?? '');

  if (sourceLevel != null && targetLevel != null && sourceLevel < targetLevel) {
    return edge;
  }

  return _InputEdge(
    source: edge.target,
    target: edge.source,
    type: edge.type,
    weight: edge.weight,
  );
}

int _edgeCrossingWeight(_InputEdge edge) {
  final configuredWeight = edge.weight;
  final importance =
      configuredWeight != null &&
          configuredWeight.isFinite &&
          configuredWeight > 0
      ? configuredWeight.clamp(0.25, 4.0)
      : 1.0;
  final hierarchyPriority = edge.type.toUpperCase() == 'SUBTOPIC' ? 4.0 : 1.0;
  return (hierarchyPriority * importance * 4).round().clamp(1, 64).toInt();
}

_GraphModel _buildGraph({
  required List<GraphNodeData> nodes,
  required List<_InputEdge> edges,
}) {
  final layoutNodes = <String, _LayoutNode>{
    for (final node in nodes)
      node.id: _LayoutNode(id: node.id, isDummy: false, realNodeId: node.id),
  };

  final nodeIds = layoutNodes.keys.toSet();
  final nodeTypes = {for (final node in nodes) node.id: node.type};

  // Primeiro filtro: descarta arestas inválidas, self-loops e duplicatas.
  final candidateEdgesByPair = <(String, String), _InputEdge>{};

  for (final rawEdge in edges) {
    final edge = _normalizeEdgeDirection(rawEdge, nodeTypes);
    final source = edge.source;
    final target = edge.target;

    if (!nodeIds.contains(source) || !nodeIds.contains(target)) {
      continue;
    }

    if (source == target) {
      continue;
    }

    final edgeKey = (source, target);
    final existing = candidateEdgesByPair[edgeKey];
    if (existing == null ||
        _edgeCrossingWeight(edge) > _edgeCrossingWeight(existing)) {
      candidateEdgesByPair[edgeKey] = edge;
    }
  }

  final candidateEdges = candidateEdgesByPair.values.toList(growable: false);

  // Segundo filtro: quebra ciclos.
  final cycleResult = _breakCycles(nodeIds: nodeIds, edges: candidateEdges);

  if (cycleResult.reversedEdges.isNotEmpty) {
    final reversedDescription = cycleResult.reversedEdges
        .map((edge) => '${edge.source}->${edge.target}')
        .join(', ');

    debugPrint(
      'Sugiyama: ${cycleResult.reversedEdges.length} aresta(s) '
      'invertida(s) apenas no layout para quebrar ciclo(s): '
      '$reversedDescription',
    );
  }

  final acyclicEdgesByPair = <(String, String), _InputEdge>{};
  for (final edge in cycleResult.acyclicEdges) {
    final key = (edge.source, edge.target);
    final existing = acyclicEdgesByPair[key];
    if (existing == null ||
        _edgeCrossingWeight(edge) > _edgeCrossingWeight(existing)) {
      acyclicEdgesByPair[key] = edge;
    }
  }

  final parents = <String, List<String>>{
    for (final node in nodes) node.id: <String>[],
  };
  final children = <String, List<String>>{
    for (final node in nodes) node.id: <String>[],
  };
  final hierarchyParents = <String, List<String>>{
    for (final node in nodes) node.id: <String>[],
  };
  final hierarchyChildren = <String, List<String>>{
    for (final node in nodes) node.id: <String>[],
  };

  final edgeWeights = <(String, String), int>{};
  final indegree = <String, int>{for (final node in nodes) node.id: 0};
  final layoutEdges = <_LayoutEdge>[];

  for (final edge in acyclicEdgesByPair.values) {
    final source = edge.source;
    final target = edge.target;
    final isHierarchical = edge.type.toUpperCase() == 'SUBTOPIC';
    final crossingWeight = _edgeCrossingWeight(edge);

    layoutEdges.add(
      _LayoutEdge(
        source: source,
        target: target,
        isHierarchical: isHierarchical,
        crossingWeight: crossingWeight,
      ),
    );

    children[source]?.add(target);
    parents[target]?.add(source);
    edgeWeights[(source, target)] = crossingWeight;

    if (isHierarchical) {
      hierarchyChildren[source]?.add(target);
      hierarchyParents[target]?.add(source);
    }

    indegree[target] = (indegree[target] ?? 0) + 1;
  }

  return _GraphModel(
    nodes: layoutNodes,
    edges: layoutEdges,
    parents: parents,
    children: children,
    hierarchyParents: hierarchyParents,
    hierarchyChildren: hierarchyChildren,
    edgeWeights: edgeWeights,
    indegree: indegree,
    cyclesBrokenCount: cycleResult.reversedEdges.length,
  );
}

// ============================================================================
// REMOÇÃO AUTOMÁTICA DE CICLOS
// ============================================================================
//
// DFS iterativo com três cores. Heurísticas para inverter as arestas "certas":
//
//   - o DFS começa pelos nós com maior (saída - entrada), ou seja, as fontes;
//   - as arestas de maior peso são exploradas primeiro, virando arestas de
//     árvore; as de menor peso é que tendem a ser a "back edge" invertida.

class _CycleBreakResult {
  final List<_InputEdge> acyclicEdges;
  final List<_InputEdge> reversedEdges;

  const _CycleBreakResult({
    required this.acyclicEdges,
    required this.reversedEdges,
  });
}

const _dfsWhite = 0;
const _dfsGray = 1;
const _dfsBlack = 2;

_CycleBreakResult _breakCycles({
  required Set<String> nodeIds,
  required List<_InputEdge> edges,
}) {
  final adjacency = <String, List<_InputEdge>>{
    for (final id in nodeIds) id: <_InputEdge>[],
  };
  final indeg = <String, int>{for (final id in nodeIds) id: 0};
  final outdeg = <String, int>{for (final id in nodeIds) id: 0};

  for (final edge in edges) {
    adjacency[edge.source]?.add(edge);
    outdeg[edge.source] = (outdeg[edge.source] ?? 0) + 1;
    indeg[edge.target] = (indeg[edge.target] ?? 0) + 1;
  }

  for (final list in adjacency.values) {
    list.sort(
      (a, b) => _edgeCrossingWeight(b).compareTo(_edgeCrossingWeight(a)),
    );
  }

  final startOrder = nodeIds.toList();
  final originalIndex = {
    for (var i = 0; i < startOrder.length; i++) startOrder[i]: i,
  };

  startOrder.sort((a, b) {
    final scoreA = (outdeg[a] ?? 0) - (indeg[a] ?? 0);
    final scoreB = (outdeg[b] ?? 0) - (indeg[b] ?? 0);
    final byScore = scoreB.compareTo(scoreA);
    if (byScore != 0) return byScore;
    return originalIndex[a]!.compareTo(originalIndex[b]!);
  });

  final color = <String, int>{for (final id in nodeIds) id: _dfsWhite};

  final acyclicEdges = <_InputEdge>[];
  final reversedEdges = <_InputEdge>[];

  for (final startId in startOrder) {
    if (color[startId] != _dfsWhite) {
      continue;
    }

    final nodeStack = <String>[startId];
    final edgeIndexStack = <int>[0];

    color[startId] = _dfsGray;

    while (nodeStack.isNotEmpty) {
      final currentId = nodeStack.last;
      final neighbors = adjacency[currentId] ?? const <_InputEdge>[];
      final edgeIndex = edgeIndexStack.last;

      if (edgeIndex >= neighbors.length) {
        color[currentId] = _dfsBlack;

        nodeStack.removeLast();
        edgeIndexStack.removeLast();

        continue;
      }

      edgeIndexStack[edgeIndexStack.length - 1] = edgeIndex + 1;

      final edge = neighbors[edgeIndex];
      final targetColor = color[edge.target] ?? _dfsBlack;

      if (targetColor == _dfsGray) {
        reversedEdges.add(edge);
        acyclicEdges.add(
          _InputEdge(
            source: edge.target,
            target: edge.source,
            type: edge.type,
            weight: edge.weight,
          ),
        );
        continue;
      }

      acyclicEdges.add(edge);

      if (targetColor == _dfsWhite) {
        color[edge.target] = _dfsGray;

        nodeStack.add(edge.target);
        edgeIndexStack.add(0);
      }
    }
  }

  return _CycleBreakResult(
    acyclicEdges: acyclicEdges,
    reversedEdges: reversedEdges,
  );
}

// ============================================================================
// LAYER ASSIGNMENT
// ============================================================================
//
// 1. Caminho mais longo (camada mínima que respeita as precedências).
// 2. Tightening: um nó com folga desce até ficar logo acima do filho mais
//    próximo, se isso encurtar o peso total das arestas (fontes soltas no
//    topo deixam de gerar arestas longas).
// 3. (Opcional) limite de largura por camada.
// 4. Compressão de camadas vazias.

({List<String> sorted, List<String> leftover}) _topologicalOrder(
  _GraphModel graph,
) {
  final indegree = <String, int>{...graph.indegree};
  final queue = Queue<String>();

  for (final id in graph.nodes.keys) {
    if ((indegree[id] ?? 0) == 0) {
      queue.add(id);
    }
  }

  final sorted = <String>[];
  final processed = <String>{};

  while (queue.isNotEmpty) {
    final current = queue.removeFirst();
    sorted.add(current);
    processed.add(current);

    for (final child in graph.children[current] ?? const <String>[]) {
      final remaining = (indegree[child] ?? 0) - 1;
      indegree[child] = remaining;

      if (remaining == 0) {
        queue.add(child);
      }
    }
  }

  final leftover = <String>[
    for (final id in graph.nodes.keys)
      if (!processed.contains(id)) id,
  ];

  return (sorted: sorted, leftover: leftover);
}

Map<String, int> _assignLayers({
  required _GraphModel graph,
  required int? maxNodesPerLayer,
  required bool tighten,
}) {
  final topo = _topologicalOrder(graph);
  final layers = <String, int>{};

  for (final id in topo.sorted) {
    var layer = 0;

    for (final parent in graph.parents[id] ?? const <String>[]) {
      final parentLayer = layers[parent];
      if (parentLayer != null) {
        layer = math.max(layer, parentLayer + 1);
      }
    }

    layers[id] = layer;
  }

  // Rede de segurança: não deveria acontecer, o grafo chega sem ciclos.
  if (topo.leftover.isNotEmpty) {
    debugPrint(
      'Sugiyama: ${topo.leftover.length} nó(s) fora da ordenação '
      'topológica (ciclo residual inesperado). Usando camada de fallback.',
    );

    final fallbackLayer =
        (layers.values.isEmpty ? -1 : layers.values.reduce(math.max)) + 1;

    for (final id in topo.leftover) {
      layers[id] = fallbackLayer;
    }
  } else if (tighten) {
    _tightenLayers(graph, layers, topo.sorted);
  }

  if (maxNodesPerLayer != null) {
    _enforceLayerWidth(graph, layers, maxNodesPerLayer);
  }

  return _compressLayers(layers);
}

void _tightenLayers(
  _GraphModel graph,
  Map<String, int> layers,
  List<String> topologicalOrder,
) {
  for (var pass = 0; pass < 4; pass++) {
    var changed = false;

    for (final id in topologicalOrder.reversed) {
      final childIds = graph.children[id] ?? const <String>[];
      if (childIds.isEmpty) continue;

      var minChildLayer = layers[childIds.first] ?? 0;
      for (final child in childIds) {
        minChildLayer = math.min(minChildLayer, layers[child] ?? minChildLayer);
      }

      final upperBound = minChildLayer - 1;
      final current = layers[id] ?? 0;

      if (upperBound <= current) continue;

      var outWeight = 0;
      for (final child in childIds) {
        outWeight += graph.edgeWeights[(id, child)] ?? 1;
      }

      var inWeight = 0;
      for (final parent in graph.parents[id] ?? const <String>[]) {
        inWeight += graph.edgeWeights[(parent, id)] ?? 1;
      }

      // Descer encurta as arestas de saída e alonga as de entrada.
      if (outWeight > inWeight) {
        layers[id] = upperBound;
        changed = true;
      }
    }

    if (!changed) break;
  }
}

void _enforceLayerWidth(_GraphModel graph, Map<String, int> layers, int cap) {
  var layer = 0;

  while (layer <= layers.values.fold<int>(0, math.max)) {
    final inLayer = <String>[
      for (final entry in layers.entries)
        if (entry.value == layer) entry.key,
    ];

    if (inLayer.length > cap) {
      final index = {for (var i = 0; i < inLayer.length; i++) inLayer[i]: i};

      // Nós com mais filhos permanecem; os demais descem uma camada.
      inLayer.sort((a, b) {
        final byChildren = (graph.children[b]?.length ?? 0).compareTo(
          graph.children[a]?.length ?? 0,
        );
        return byChildren != 0 ? byChildren : index[a]!.compareTo(index[b]!);
      });

      for (final id in inLayer.skip(cap)) {
        _pushDown(graph, layers, id, layer + 1);
      }
    }

    layer++;
  }
}

void _pushDown(
  _GraphModel graph,
  Map<String, int> layers,
  String start,
  int newLayer,
) {
  final stack = <(String, int)>[(start, newLayer)];
  var budget = graph.nodes.length * graph.nodes.length + 16;

  while (stack.isNotEmpty && budget-- > 0) {
    final (id, target) = stack.removeLast();

    if ((layers[id] ?? 0) >= target) continue;

    layers[id] = target;

    for (final child in graph.children[id] ?? const <String>[]) {
      if ((layers[child] ?? 0) <= target) {
        stack.add((child, target + 1));
      }
    }
  }
}

Map<String, int> _compressLayers(Map<String, int> layers) {
  final used = layers.values.toSet().toList()..sort();
  final remap = {for (var i = 0; i < used.length; i++) used[i]: i};

  return {for (final entry in layers.entries) entry.key: remap[entry.value]!};
}

// ============================================================================
// INSERIR DUMMY NODES
// ============================================================================

_ExpandedGraph _insertDummyNodes({
  required _GraphModel graph,
  required Map<String, int> layers,
}) {
  final expandedNodes = <String, _LayoutNode>{...graph.nodes};
  final expandedEdges = <_LayoutEdge>[];
  final expandedLayers = <String, int>{...layers};

  var dummyCounter = 0;

  for (final edge in graph.edges) {
    final sourceLayer = layers[edge.source] ?? 0;
    final targetLayer = layers[edge.target] ?? 0;

    final distance = targetLayer - sourceLayer;

    if (distance <= 1) {
      expandedEdges.add(edge);
      continue;
    }

    // A -----> D  vira  A -> d1 -> d2 -> D
    var previousNode = edge.source;

    for (var layer = sourceLayer + 1; layer < targetLayer; layer++) {
      final dummyId = '__dummy__$dummyCounter';

      dummyCounter++;

      expandedNodes[dummyId] = _LayoutNode(
        id: dummyId,
        isDummy: true,
        realNodeId: null,
      );

      expandedLayers[dummyId] = layer;

      expandedEdges.add(
        _LayoutEdge(
          source: previousNode,
          target: dummyId,
          isHierarchical: edge.isHierarchical,
          crossingWeight: edge.crossingWeight,
        ),
      );

      previousNode = dummyId;
    }

    expandedEdges.add(
      _LayoutEdge(
        source: previousNode,
        target: edge.target,
        isHierarchical: edge.isHierarchical,
        crossingWeight: edge.crossingWeight,
      ),
    );
  }

  final parents = <String, List<String>>{
    for (final nodeId in expandedNodes.keys) nodeId: <String>[],
  };
  final children = <String, List<String>>{
    for (final nodeId in expandedNodes.keys) nodeId: <String>[],
  };
  final hierarchyParents = <String, List<String>>{
    for (final nodeId in expandedNodes.keys) nodeId: <String>[],
  };
  final hierarchyChildren = <String, List<String>>{
    for (final nodeId in expandedNodes.keys) nodeId: <String>[],
  };

  final edgeWeights = <(String, String), int>{};
  final indegree = <String, int>{
    for (final nodeId in expandedNodes.keys) nodeId: 0,
  };

  for (final edge in expandedEdges) {
    children[edge.source]?.add(edge.target);
    parents[edge.target]?.add(edge.source);
    edgeWeights[(edge.source, edge.target)] = edge.crossingWeight;

    if (edge.isHierarchical) {
      hierarchyChildren[edge.source]?.add(edge.target);
      hierarchyParents[edge.target]?.add(edge.source);
    }

    indegree[edge.target] = (indegree[edge.target] ?? 0) + 1;
  }

  return _ExpandedGraph(
    graph: _GraphModel(
      nodes: expandedNodes,
      edges: expandedEdges,
      parents: parents,
      children: children,
      hierarchyParents: hierarchyParents,
      hierarchyChildren: hierarchyChildren,
      edgeWeights: edgeWeights,
      indegree: indegree,
    ),
    layers: expandedLayers,
  );
}

// ============================================================================
// ORDEM INICIAL DAS CAMADAS
// ============================================================================

Map<int, List<String>> _buildInitialLayerOrder({
  required Map<String, int> layers,
  required _GraphModel graph,
  required Map<String, double> previousX,
}) {
  final result = <int, List<String>>{};

  for (final entry in layers.entries) {
    result.putIfAbsent(entry.value, () => <String>[]).add(entry.key);
  }

  for (final layerNodes in result.values) {
    final originalOrder = _positionMap(layerNodes);

    layerNodes.sort((a, b) {
      final xA = previousX[a];
      final xB = previousX[b];

      if (xA != null && xB != null) {
        final comparison = xA.compareTo(xB);

        if (comparison != 0) {
          return comparison;
        }

        return originalOrder[a]!.compareTo(originalOrder[b]!);
      }

      if (xA != null) {
        return -1;
      }

      if (xB != null) {
        return 1;
      }

      final aDummy = graph.nodes[a]?.isDummy ?? false;
      final bDummy = graph.nodes[b]?.isDummy ?? false;

      if (aDummy != bDummy) {
        return aDummy ? 1 : -1;
      }

      return originalOrder[a]!.compareTo(originalOrder[b]!);
    });
  }

  return result;
}

// ============================================================================
// MINIMIZAÇÃO DE CRUZAMENTOS
// ============================================================================

_LayerOrderResult _minimizeCrossings({
  required _GraphModel graph,
  required Map<int, List<String>> initialLayers,
  required SugiyamaConfig config,
}) {
  final seeds = <Map<int, List<String>>>[
    _cloneLayers(initialLayers),
    _reverseLayerSeed(initialLayers),
    _degreeLayerSeed(graph, initialLayers),
    _hierarchyLayerSeed(graph, initialLayers),
  ];

  var best = _cloneLayers(initialLayers);
  var bestCrossings = _countAllCrossings(graph: graph, nodesByLayer: best);

  bool consider(Map<int, List<String>> candidate) {
    final crossings = _countAllCrossings(graph: graph, nodesByLayer: candidate);

    if (crossings < bestCrossings) {
      best = _cloneLayers(candidate);
      bestCrossings = crossings;
      return true;
    }

    return false;
  }

  for (final seed in seeds) {
    if (bestCrossings == 0) break;

    var current = _cloneLayers(seed);
    consider(current);

    var stagnant = 0;

    for (
      var iteration = 0;
      iteration < config.crossingIterations;
      iteration++
    ) {
      var improved = false;

      current = _sweep(graph: graph, nodesByLayer: current, downward: true);
      improved = consider(current) || improved;

      current = _sweep(graph: graph, nodesByLayer: current, downward: false);
      improved = consider(current) || improved;

      current = _transposeLayers(
        graph: graph,
        nodesByLayer: current,
        maxIterations: config.transposeIterations,
      );
      improved = consider(current) || improved;

      if (bestCrossings == 0) break;

      stagnant = improved ? 0 : stagnant + 1;
      if (stagnant >= 4) break;
    }
  }

  return _LayerOrderResult(nodesByLayer: best, crossingCount: bestCrossings);
}

Map<int, List<String>> _reverseLayerSeed(Map<int, List<String>> initialLayers) {
  final reversed = _cloneLayers(initialLayers);
  for (final entry in reversed.entries) {
    reversed[entry.key] = entry.value.reversed.toList();
  }
  return reversed;
}

Map<int, List<String>> _degreeLayerSeed(
  _GraphModel graph,
  Map<int, List<String>> initialLayers,
) {
  final seeded = _cloneLayers(initialLayers);
  for (final entry in seeded.entries) {
    final oldPosition = _positionMap(entry.value);
    entry.value.sort((a, b) {
      final degreeA =
          (graph.parents[a]?.length ?? 0) + (graph.children[a]?.length ?? 0);
      final degreeB =
          (graph.parents[b]?.length ?? 0) + (graph.children[b]?.length ?? 0);
      final byDegree = degreeB.compareTo(degreeA);
      if (byDegree != 0) return byDegree;
      return oldPosition[a]!.compareTo(oldPosition[b]!);
    });
  }
  return seeded;
}

/// Semente baseada numa DFS na floresta hierárquica: irmãos e descendentes
/// ficam contíguos desde o início.
Map<int, List<String>> _hierarchyLayerSeed(
  _GraphModel graph,
  Map<int, List<String>> initialLayers,
) {
  final order = <String, int>{};
  final visited = <String>{};

  void visitFrom(String start) {
    final pending = <String>[start];
    while (pending.isNotEmpty) {
      final nodeId = pending.removeLast();
      if (!visited.add(nodeId)) continue;
      order[nodeId] = order.length;
      final children = graph.hierarchyChildren[nodeId] ?? const <String>[];
      pending.addAll(children.reversed);
    }
  }

  for (final nodeId in graph.nodes.keys) {
    if ((graph.hierarchyParents[nodeId] ?? const <String>[]).isEmpty) {
      visitFrom(nodeId);
    }
  }
  for (final nodeId in graph.nodes.keys) {
    visitFrom(nodeId);
  }

  final seeded = _cloneLayers(initialLayers);
  for (final nodes in seeded.values) {
    final originalOrder = _positionMap(nodes);
    nodes.sort((first, second) {
      final byHierarchy = (order[first] ?? originalOrder[first]!).compareTo(
        order[second] ?? originalOrder[second]!,
      );
      return byHierarchy != 0
          ? byHierarchy
          : originalOrder[first]!.compareTo(originalOrder[second]!);
    });
  }
  return seeded;
}

/// Varredura para baixo (referência: pais) ou para cima (referência: filhos).
Map<int, List<String>> _sweep({
  required _GraphModel graph,
  required Map<int, List<String>> nodesByLayer,
  required bool downward,
}) {
  final result = _cloneLayers(nodesByLayer);
  final maxLayer = _maxLayer(result);

  if (downward) {
    for (var layer = 1; layer <= maxLayer; layer++) {
      final current = result[layer];
      final reference = result[layer - 1];

      if (current == null || current.length <= 1 || reference == null) {
        continue;
      }

      _reorderLayer(
        graph: graph,
        layerNodes: current,
        referencePosition: _positionMap(reference),
        useParents: true,
      );
    }
  } else {
    for (var layer = maxLayer - 1; layer >= 0; layer--) {
      final current = result[layer];
      final reference = result[layer + 1];

      if (current == null || current.length <= 1 || reference == null) {
        continue;
      }

      _reorderLayer(
        graph: graph,
        layerNodes: current,
        referencePosition: _positionMap(reference),
        useParents: false,
      );
    }
  }

  return result;
}

/// Reordena a camada pela mediana ponderada (desempate: média ponderada).
/// Nós sem vizinhos na camada de referência mantêm o próprio slot, em vez de
/// serem empurrados para o fim.
void _reorderLayer({
  required _GraphModel graph,
  required List<String> layerNodes,
  required Map<String, int> referencePosition,
  required bool useParents,
}) {
  final oldPosition = _positionMap(layerNodes);
  final scores = <String, (double, double)>{};

  for (final id in layerNodes) {
    final neighbors =
        (useParents ? graph.parents[id] : graph.children[id]) ??
        const <String>[];

    scores[id] = _neighborScore(
      neighbors: neighbors,
      position: referencePosition,
      weightOf: (neighbor) => useParents
          ? (graph.edgeWeights[(neighbor, id)] ?? 1)
          : (graph.edgeWeights[(id, neighbor)] ?? 1),
    );
  }

  final movable = <String>[];
  final slots = <int>[];

  for (var i = 0; i < layerNodes.length; i++) {
    final id = layerNodes[i];

    if (scores[id]!.$1.isInfinite) {
      continue;
    }

    movable.add(id);
    slots.add(i);
  }

  movable.sort((a, b) {
    final scoreA = scores[a]!;
    final scoreB = scores[b]!;

    final byMedian = scoreA.$1.compareTo(scoreB.$1);
    if (byMedian != 0) return byMedian;

    final byMean = scoreA.$2.compareTo(scoreB.$2);
    if (byMean != 0) return byMean;

    return oldPosition[a]!.compareTo(oldPosition[b]!);
  });

  for (var k = 0; k < movable.length; k++) {
    layerNodes[slots[k]] = movable[k];
  }
}

/// Retorna (mediana ponderada, média ponderada). Infinito quando não há
/// vizinhos posicionados.
(double, double) _neighborScore({
  required List<String> neighbors,
  required Map<String, int> position,
  required int Function(String) weightOf,
}) {
  final entries = <(int, int)>[];

  for (final neighbor in neighbors) {
    final index = position[neighbor];
    if (index == null) continue;
    entries.add((index, math.max(1, weightOf(neighbor))));
  }

  if (entries.isEmpty) {
    return (double.infinity, double.infinity);
  }

  entries.sort((a, b) => a.$1.compareTo(b.$1));

  var totalWeight = 0;
  var weightedSum = 0;

  for (final entry in entries) {
    totalWeight += entry.$2;
    weightedSum += entry.$1 * entry.$2;
  }

  final mean = weightedSum / totalWeight;

  var cumulative = 0;
  for (var i = 0; i < entries.length; i++) {
    cumulative += entries[i].$2;
    final midpoint = cumulative * 2;

    if (midpoint > totalWeight) {
      return (entries[i].$1.toDouble(), mean);
    }

    if (midpoint == totalWeight && i + 1 < entries.length) {
      return ((entries[i].$1 + entries[i + 1].$1) / 2, mean);
    }
  }

  return (entries.last.$1.toDouble(), mean);
}

// ============================================================================
// ADJACENT TRANSPOSE
// ============================================================================
//
// Para dois nós adjacentes u (esquerda) e v (direita), os únicos cruzamentos
// afetados pela troca são os entre arestas de u e arestas de v (para cima e
// para baixo). Contamos só esses, em O(grau(u) * grau(v)).

Map<int, List<String>> _transposeLayers({
  required _GraphModel graph,
  required Map<int, List<String>> nodesByLayer,
  required int maxIterations,
}) {
  final result = _cloneLayers(nodesByLayer);

  if (maxIterations <= 0) {
    return result;
  }

  final maxLayer = _maxLayer(result);

  for (var iteration = 0; iteration < maxIterations; iteration++) {
    var changed = false;

    for (var layer = 0; layer <= maxLayer; layer++) {
      final nodes = result[layer];

      if (nodes == null || nodes.length <= 1) {
        continue;
      }

      final upperPosition = layer > 0
          ? _positionMap(result[layer - 1] ?? const <String>[])
          : const <String, int>{};
      final lowerPosition = _positionMap(result[layer + 1] ?? const <String>[]);

      for (var i = 0; i < nodes.length - 1; i++) {
        final left = nodes[i];
        final right = nodes[i + 1];

        final leftUp = _sideEntries(
          graph.parents[left],
          upperPosition,
          (neighbor) => graph.edgeWeights[(neighbor, left)] ?? 1,
        );
        final rightUp = _sideEntries(
          graph.parents[right],
          upperPosition,
          (neighbor) => graph.edgeWeights[(neighbor, right)] ?? 1,
        );
        final leftDown = _sideEntries(
          graph.children[left],
          lowerPosition,
          (neighbor) => graph.edgeWeights[(left, neighbor)] ?? 1,
        );
        final rightDown = _sideEntries(
          graph.children[right],
          lowerPosition,
          (neighbor) => graph.edgeWeights[(right, neighbor)] ?? 1,
        );

        final keep =
            _orderedCrossings(leftUp, rightUp) +
            _orderedCrossings(leftDown, rightDown);
        final swapped =
            _orderedCrossings(rightUp, leftUp) +
            _orderedCrossings(rightDown, leftDown);

        if (swapped < keep) {
          nodes[i] = right;
          nodes[i + 1] = left;
          changed = true;
        }
      }
    }

    if (!changed) {
      break;
    }
  }

  return result;
}

List<(int, int)> _sideEntries(
  List<String>? neighbors,
  Map<String, int> position,
  int Function(String) weightOf,
) {
  final entries = <(int, int)>[];

  if (neighbors == null) return entries;

  for (final neighbor in neighbors) {
    final index = position[neighbor];
    if (index == null) continue;
    entries.add((index, weightOf(neighbor)));
  }

  return entries;
}

/// Cruzamentos (ponderados) se o nó dono de `left` ficar à esquerda do dono
/// de `right`: um par cruza quando o vizinho da esquerda está mais à direita.
int _orderedCrossings(List<(int, int)> left, List<(int, int)> right) {
  var total = 0;

  for (final l in left) {
    for (final r in right) {
      if (l.$1 > r.$1) {
        total += l.$2 * r.$2;
      }
    }
  }

  return total;
}

// ============================================================================
// COORDINATE ASSIGNMENT
// ============================================================================
//
// 1. Posição inicial: cada camada centralizada em torno de x = 0.
// 2. Passadas alternadas (frente: pais -> filhos; trás: filhos -> pais). Em
//    CADA camada, a posição desejada é projetada (PAVA ponderada) antes de
//    passar para a próxima, de modo que a camada seguinte se baseie em
//    posições viáveis.
// 3. A última passada é sempre para trás: pais centralizados sobre filhos.

double _gapBetween(
  _GraphModel graph,
  String a,
  String b,
  SugiyamaConfig config,
) {
  final aDummy = graph.nodes[a]?.isDummy ?? false;
  final bDummy = graph.nodes[b]?.isDummy ?? false;

  if (aDummy && bDummy) return config.dummyGap;
  if (aDummy || bDummy) {
    return (config.minimumHorizontalGap + config.dummyGap) / 2;
  }
  return config.minimumHorizontalGap;
}

Map<String, Offset> _assignCoordinates({
  required _GraphModel graph,
  required Map<int, List<String>> nodesByLayer,
  required SugiyamaConfig config,
}) {
  final positions = <String, Offset>{};

  if (nodesByLayer.isEmpty) {
    return positions;
  }

  // 1. Posição inicial, centralizada por camada.
  for (final entry in nodesByLayer.entries) {
    final layer = entry.key;
    final nodes = entry.value;

    final xs = <double>[];
    var offset = 0.0;

    for (var i = 0; i < nodes.length; i++) {
      if (i > 0) {
        final gap = _gapBetween(graph, nodes[i - 1], nodes[i], config);
        final bothReal =
            !(graph.nodes[nodes[i - 1]]?.isDummy ?? false) &&
            !(graph.nodes[nodes[i]]?.isDummy ?? false);

        offset += bothReal ? math.max(gap, config.horizontalSpacing) : gap;
      }

      xs.add(offset);
    }

    for (var i = 0; i < nodes.length; i++) {
      positions[nodes[i]] = Offset(
        xs[i] - offset / 2,
        layer * config.verticalSpacing,
      );
    }
  }

  // 2. Ajuste iterativo (número par de passadas: termina "para trás").
  var iterations = config.coordinateIterations;
  if (iterations.isOdd) {
    iterations++;
  }

  for (var iteration = 0; iteration < iterations; iteration++) {
    _coordinatePass(
      graph: graph,
      nodesByLayer: nodesByLayer,
      positions: positions,
      config: config,
      forward: iteration.isEven,
    );
  }

  // 3. Origem em (0, 0).
  _normalizeCoordinates(positions);

  return positions;
}

List<String> _coordinateNeighbors(
  _GraphModel graph,
  String nodeId, {
  required bool parents,
}) {
  final hierarchyNeighbors = parents
      ? graph.hierarchyParents[nodeId]
      : graph.hierarchyChildren[nodeId];

  if (hierarchyNeighbors != null && hierarchyNeighbors.isNotEmpty) {
    return hierarchyNeighbors;
  }

  return parents
      ? graph.parents[nodeId] ?? const <String>[]
      : graph.children[nodeId] ?? const <String>[];
}

void _coordinatePass({
  required _GraphModel graph,
  required Map<int, List<String>> nodesByLayer,
  required Map<String, Offset> positions,
  required SugiyamaConfig config,
  required bool forward,
}) {
  final maxLayer = _maxLayer(nodesByLayer);

  final layerOrder = forward
      ? [for (var layer = 1; layer <= maxLayer; layer++) layer]
      : [for (var layer = maxLayer; layer >= 0; layer--) layer];

  for (final layer in layerOrder) {
    final nodes = nodesByLayer[layer];

    if (nodes == null || nodes.isEmpty) {
      continue;
    }

    final desired = <double>[];

    for (final id in nodes) {
      final neighbors = _coordinateNeighbors(graph, id, parents: forward);

      final x = _computeDesiredX(
        neighbors: neighbors,
        positions: positions,
        mode: config.mode,
        weightOf: (neighbor) =>
            (forward
                    ? graph.edgeWeights[(neighbor, id)]
                    : graph.edgeWeights[(id, neighbor)])
                ?.toDouble() ??
            1.0,
      );

      // Sem vizinhos nessa direção: o nó funciona como âncora.
      desired.add(x ?? positions[id]!.dx);
    }

    _projectNodes(
      graph: graph,
      nodes: nodes,
      desired: desired,
      positions: positions,
      config: config,
    );
  }
}

/// X que um nó "gostaria" de ter.
///
///   - `balanced`: média ponderada pelo peso das arestas.
///   - `centered`: ponto médio entre o vizinho mais à esquerda e o mais à
///     direita.
double? _computeDesiredX({
  required List<String> neighbors,
  required Map<String, Offset> positions,
  required SugiyamaLayoutMode mode,
  required double Function(String) weightOf,
}) {
  var weightedSum = 0.0;
  var totalWeight = 0.0;

  double? minX;
  double? maxX;

  for (final neighbor in neighbors) {
    final position = positions[neighbor];

    if (position == null) {
      continue;
    }

    final weight = math.max(0.0001, weightOf(neighbor));

    weightedSum += position.dx * weight;
    totalWeight += weight;

    minX = (minX == null) ? position.dx : math.min(minX, position.dx);
    maxX = (maxX == null) ? position.dx : math.max(maxX, position.dx);
  }

  if (totalWeight == 0) {
    return null;
  }

  if (mode == SugiyamaLayoutMode.centered && minX != null && maxX != null) {
    return (minX + maxX) / 2;
  }

  return weightedSum / totalWeight;
}

/// Projeta as posições desejadas de uma camada nas restrições
/// `x[i+1] >= x[i] + gap(i, i+1)`, minimizando a soma ponderada dos
/// quadrados dos deslocamentos.
void _projectNodes({
  required _GraphModel graph,
  required List<String> nodes,
  required List<double> desired,
  required Map<String, Offset> positions,
  required SugiyamaConfig config,
}) {
  final count = nodes.length;

  if (count == 0) {
    return;
  }

  final weights = <double>[
    for (final id in nodes)
      (graph.nodes[id]?.isDummy ?? false) ? _dummyPriority : 1.0,
  ];

  final offsets = List<double>.filled(count, 0);
  for (var i = 1; i < count; i++) {
    offsets[i] =
        offsets[i - 1] + _gapBetween(graph, nodes[i - 1], nodes[i], config);
  }

  final projected = _isotonicProject(desired, weights, offsets);

  for (var i = 0; i < count; i++) {
    final current = positions[nodes[i]]!;
    positions[nodes[i]] = Offset(projected[i], current.dy);
  }
}

// ============================================================================
// REGRESSÃO ISOTÔNICA PONDERADA (PAVA)
// ============================================================================
//
// Com y[i] = desired[i] - offsets[i], a restrição de distância mínima vira
// y[i + 1] >= y[i]. O PAVA resolve em O(n) minimizando
// soma(weights[i] * (y[i] - desired_y[i])²). Quando várias posições
// desejadas coincidem (irmãos querendo a posição do pai), o resultado é
// distribuído simetricamente em torno dela.

List<double> _isotonicProject(
  List<double> desired,
  List<double> weights,
  List<double> offsets,
) {
  final n = desired.length;

  if (n == 0) {
    return const [];
  }

  final blockSum = <double>[];
  final blockWeight = <double>[];
  final blockSize = <int>[];

  for (var i = 0; i < n; i++) {
    final weight = weights[i] > 0 ? weights[i] : 1.0;

    blockSum.add((desired[i] - offsets[i]) * weight);
    blockWeight.add(weight);
    blockSize.add(1);

    while (blockSum.length > 1 &&
        (blockSum[blockSum.length - 1] / blockWeight[blockWeight.length - 1]) <
            (blockSum[blockSum.length - 2] /
                blockWeight[blockWeight.length - 2])) {
      final lastSum = blockSum.removeLast();
      final lastWeight = blockWeight.removeLast();
      final lastSize = blockSize.removeLast();

      blockSum[blockSum.length - 1] += lastSum;
      blockWeight[blockWeight.length - 1] += lastWeight;
      blockSize[blockSize.length - 1] += lastSize;
    }
  }

  final result = List<double>.filled(n, 0);
  var index = 0;

  for (var block = 0; block < blockSum.length; block++) {
    final average = blockSum[block] / blockWeight[block];

    for (var k = 0; k < blockSize[block]; k++) {
      result[index] = average + offsets[index];
      index++;
    }
  }

  return result;
}

// ============================================================================
// CONTAGEM DE CRUZAMENTOS
// ============================================================================

int _countAllCrossings({
  required _GraphModel graph,
  required Map<int, List<String>> nodesByLayer,
}) {
  var total = 0;

  final maxLayer = _maxLayer(nodesByLayer);

  for (var layer = 0; layer < maxLayer; layer++) {
    total += _countLayerCrossings(
      graph: graph,
      upperLayer: nodesByLayer[layer] ?? const <String>[],
      lowerLayer: nodesByLayer[layer + 1] ?? const <String>[],
    );
  }

  return total;
}

/// Conta cruzamentos ponderados entre duas camadas consecutivas usando uma
/// Fenwick Tree: O(E log V).
int _countLayerCrossings({
  required _GraphModel graph,
  required List<String> upperLayer,
  required List<String> lowerLayer,
}) {
  if (upperLayer.isEmpty || lowerLayer.isEmpty) {
    return 0;
  }

  final upperPosition = _positionMap(upperLayer);
  final lowerPosition = _positionMap(lowerLayer);

  final segmentsByUpper = <int, List<(int, int)>>{};

  for (final source in upperLayer) {
    final sourcePosition = upperPosition[source]!;

    final children = graph.children[source] ?? const <String>[];

    for (final target in children) {
      final targetPosition = lowerPosition[target];

      if (targetPosition == null) {
        continue;
      }

      segmentsByUpper.putIfAbsent(sourcePosition, () => <(int, int)>[]).add((
        targetPosition,
        graph.edgeWeights[(source, target)] ?? 1,
      ));
    }
  }

  if (segmentsByUpper.isEmpty) {
    return 0;
  }

  final fenwick = _FenwickTree(lowerLayer.length);

  var seenWeight = 0;
  var crossings = 0;

  final upperPositions = segmentsByUpper.keys.toList()..sort();

  for (final upperPositionValue in upperPositions) {
    final targets = segmentsByUpper[upperPositionValue]!;

    // Consulta todas e só depois adiciona: arestas do mesmo nó nunca
    // contam como cruzamento entre si.
    for (final (targetPosition, edgeWeight) in targets) {
      final weightAtOrBefore = fenwick.query(targetPosition);
      crossings += (seenWeight - weightAtOrBefore) * edgeWeight;
    }

    for (final (targetPosition, edgeWeight) in targets) {
      fenwick.add(targetPosition, edgeWeight);
      seenWeight += edgeWeight;
    }
  }

  return crossings;
}

// ============================================================================
// UTILITÁRIOS
// ============================================================================

Map<String, int> _positionMap(List<String> nodes) {
  return <String, int>{for (var i = 0; i < nodes.length; i++) nodes[i]: i};
}

int _maxLayer(Map<int, List<String>> nodesByLayer) {
  if (nodesByLayer.isEmpty) {
    return 0;
  }

  return nodesByLayer.keys.reduce(math.max);
}

Map<int, List<String>> _cloneLayers(Map<int, List<String>> source) {
  return <int, List<String>>{
    for (final entry in source.entries)
      entry.key: List<String>.from(entry.value),
  };
}

/// Move o desenho para que o menor X e o menor Y sejam 0.
void _normalizeCoordinates(Map<String, Offset> positions) {
  if (positions.isEmpty) {
    return;
  }

  var minimumX = double.infinity;
  var minimumY = double.infinity;

  for (final position in positions.values) {
    minimumX = math.min(minimumX, position.dx);
    minimumY = math.min(minimumY, position.dy);
  }

  final shiftX = minimumX.isFinite ? -minimumX : 0.0;
  final shiftY = minimumY.isFinite ? -minimumY : 0.0;

  if (shiftX == 0 && shiftY == 0) {
    return;
  }

  for (final nodeId in positions.keys.toList()) {
    final position = positions[nodeId]!;

    positions[nodeId] = Offset(position.dx + shiftX, position.dy + shiftY);
  }
}
