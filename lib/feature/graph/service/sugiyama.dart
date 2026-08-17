import 'dart:collection';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:noema/core/database/database.dart';
import 'package:noema/core/database/database_provider.dart';
import 'package:noema/feature/graph/data/graph_node_dao.dart';
import 'package:noema/feature/graph/provider/graph_provider.dart';

// OBS.: Gerei com IA

/// ============================================================================
/// CONFIGURAÇÃO
/// ============================================================================

class SugiyamaConfig {
  /// Distância entre os centros dos nós na horizontal.
  ///
  /// Esse valor deve ser maior ou igual à largura do maior nó
  /// + o espaço desejado entre eles.
  final double horizontalSpacing;

  /// Distância vertical entre camadas.
  final double verticalSpacing;

  /// Distância mínima entre os centros de dois nós da mesma camada.
  final double minimumHorizontalGap;

  /// Quantidade de ciclos de:
  ///
  ///   downward sweep -> upward sweep
  final int crossingIterations;

  /// Quantidade de refinamentos por troca adjacente.
  final int transposeIterations;

  /// Quantidade de iterações utilizadas para melhorar as coordenadas X.
  final int coordinateIterations;

  /// Tenta preservar a posição X dos nós antes do auto-layout.
  final bool preservePreviousOrder;

  /// Quando true, tenta compactar o grafo depois do posicionamento.
  final bool compact;

  const SugiyamaConfig({
    this.horizontalSpacing = 220.0,
    this.verticalSpacing = 180.0,
    this.minimumHorizontalGap = 220.0,
    this.crossingIterations = 12,
    this.transposeIterations = 4,
    this.coordinateIterations = 6,
    this.preservePreviousOrder = true,
    this.compact = true,
  });
}


/// ============================================================================
/// TIPOS INTERNOS
/// ============================================================================

class _InputEdge {
  final String source;
  final String target;

  const _InputEdge({
    required this.source,
    required this.target,
  });
}


class _LayoutNode {
  final String id;

  /// true para dummy nodes.
  final bool isDummy;

  /// ID do nó real.
  ///
  /// null para dummy nodes.
  final String? realNodeId;

  const _LayoutNode({
    required this.id,
    required this.isDummy,
    this.realNodeId,
  });
}


class _LayoutEdge {
  final String source;
  final String target;

  const _LayoutEdge({
    required this.source,
    required this.target,
  });
}


class _GraphModel {
  final Map<String, _LayoutNode> nodes;
  final List<_LayoutEdge> edges;

  final Map<String, List<String>> parents;
  final Map<String, List<String>> children;

  final Map<String, int> indegree;

  const _GraphModel({
    required this.nodes,
    required this.edges,
    required this.parents,
    required this.children,
    required this.indegree,
  });
}


class _ExpandedGraph {
  final _GraphModel graph;
  final Map<String, int> layers;

  const _ExpandedGraph({
    required this.graph,
    required this.layers,
  });
}


class _LayerOrderResult {
  final Map<int, List<String>> nodesByLayer;
  final int crossingCount;

  const _LayerOrderResult({
    required this.nodesByLayer,
    required this.crossingCount,
  });
}


class _SugiyamaResult {
  final Map<String, Offset> positions;
  final Map<String, int> layers;

  const _SugiyamaResult({
    required this.positions,
    required this.layers,
  });
}


/// ============================================================================
/// ERRO ESPECÍFICO
/// ============================================================================

class SugiyamaLayoutException implements Exception {
  final String message;

  const SugiyamaLayoutException(this.message);

  @override
  String toString() => 'SugiyamaLayoutException: $message';
}


/// ============================================================================
/// FENWICK TREE
/// ============================================================================
///
/// Usada para contar inversões de forma eficiente.
///
/// Sem ela:
///
///     O(E²)
///
/// Com ela:
///
///     O(E log V)
///
/// por par de camadas.
///

class _FenwickTree {
  final List<int> _tree;

  _FenwickTree(int size)
      : _tree = List<int>.filled(
          size + 1,
          0,
        );

  void add(
    int index,
    int value,
  ) {
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

  int queryRange(
    int left,
    int right,
  ) {
    if (right < left) {
      return 0;
    }

    return query(right) -
        (left == 0 ? 0 : query(left - 1));
  }
}


/// ============================================================================
/// API PRINCIPAL
/// ============================================================================

Future<void> sugiyama(
  String graphId,
  WidgetRef ref, {
  SugiyamaConfig config = const SugiyamaConfig(),
}) async {
  final db = ref.read(appDatabaseProvider);
  final graphNodeDao = GraphNodeDao(db);

  final nodes = await ref.read(
    nodesProvider(graphId).future,
  );

  final edges = await ref.read(
    edgesProvider(graphId).future,
  );

  if (nodes.isEmpty) {
    return;
  }

  // --------------------------------------------------------------------------
  // Extrai as posições atuais.
  //
  // Elas são usadas apenas para definir uma ordem inicial mais estável.
  // --------------------------------------------------------------------------

  final previousX = <String, double>{};

  if (config.preservePreviousOrder) {
    for (final node in nodes) {
      final x = node.positionX;

      if (x != null && x.isFinite) {
        previousX[node.id] = x;
      }
    }
  }

  // --------------------------------------------------------------------------
  // Converte as arestas do banco para o modelo interno.
  // --------------------------------------------------------------------------

  final inputEdges = <_InputEdge>[];

  for (final edge in edges) {
    inputEdges.add(
      _InputEdge(
        source: edge.sourceNodeId,
        target: edge.targetNodeId,
      ),
    );
  }

  // --------------------------------------------------------------------------
  // Executa o algoritmo puro.
  // --------------------------------------------------------------------------

  final result = _runSugiyama(
    nodes: nodes,
    edges: inputEdges,
    previousX: previousX,
    config: config,
  );

  // --------------------------------------------------------------------------
  // Persiste somente nós reais.
  // --------------------------------------------------------------------------

  for (final node in nodes) {
    final position = result.positions[node.id];

    if (position == null) {
      continue;
    }

    await graphNodeDao.updateGraphNode(
      id: node.id,
      positionX: position.dx,
      positionY: position.dy,
    );

    debugPrint(
      'Sugiyama\n'
      'Node: ${node.title}\n'
      'Layer: ${result.layers[node.id]}\n'
      'X: ${position.dx.toStringAsFixed(1)}\n'
      'Y: ${position.dy.toStringAsFixed(1)}',
    );
  }

  debugPrint(
    'Sugiyama finalizado: '
    '${nodes.length} nós reais.',
  );
}


/// ============================================================================
/// PIPELINE
/// ============================================================================

_SugiyamaResult _runSugiyama({
  required List<GraphNodeData> nodes,
  required List<_InputEdge> edges,
  required Map<String, double> previousX,
  required SugiyamaConfig config,
}) {
  // ==========================================================================
  // 1. Construir o grafo
  // ==========================================================================

  final graph = _buildGraph(
    nodes: nodes,
    edges: edges,
  );

  // ==========================================================================
  // 2. Atribuir camadas
  // ==========================================================================

  final layers = _assignLayers(
    graph: graph,
  );

  // ==========================================================================
  // 3. Inserir dummy nodes
  // ==========================================================================

  final expanded = _insertDummyNodes(
    graph: graph,
    layers: layers,
  );

  // ==========================================================================
  // 4. Ordem inicial
  // ==========================================================================

  final initialLayers = _buildInitialLayerOrder(
    layers: expanded.layers,
    graph: expanded.graph,
    previousX: previousX,
  );

  // ==========================================================================
  // 5. Minimização de cruzamentos
  // ==========================================================================

  final crossingResult = _minimizeCrossings(
    graph: expanded.graph,
    initialLayers: initialLayers,
    config: config,
  );

  // ==========================================================================
  // 6. Coordenadas
  // ==========================================================================

  final positions = _assignCoordinates(
    graph: expanded.graph,
    nodesByLayer: crossingResult.nodesByLayer,
    config: config,
  );

  return _SugiyamaResult(
    positions: positions,
    layers: expanded.layers,
  );
}


/// ============================================================================
/// CONSTRUIR GRAFO
/// ============================================================================

_GraphModel _buildGraph({
  required List<GraphNodeData> nodes,
  required List<_InputEdge> edges,
}) {
  final layoutNodes = <String, _LayoutNode>{
    for (final node in nodes)
      node.id: _LayoutNode(
        id: node.id,
        isDummy: false,
        realNodeId: node.id,
      ),
  };

  final parents = <String, List<String>>{
    for (final node in nodes)
      node.id: <String>[],
  };

  final children = <String, List<String>>{
    for (final node in nodes)
      node.id: <String>[],
  };

  final indegree = <String, int>{
    for (final node in nodes)
      node.id: 0,
  };

  final nodeIds = layoutNodes.keys.toSet();

  final layoutEdges = <_LayoutEdge>[];

  // Evita arestas duplicadas.
  final seenEdges = <String>{};

  for (final edge in edges) {
    final source = edge.source;
    final target = edge.target;

    // ------------------------------------------------------------------------
    // Aresta apontando para nó inexistente.
    // ------------------------------------------------------------------------

    if (!nodeIds.contains(source) ||
        !nodeIds.contains(target)) {
      continue;
    }

    // ------------------------------------------------------------------------
    // Self-loop.
    // ------------------------------------------------------------------------

    if (source == target) {
      continue;
    }

    // ------------------------------------------------------------------------
    // Duplicata.
    // ------------------------------------------------------------------------

    final edgeKey = '$source::$target';

    if (!seenEdges.add(edgeKey)) {
      continue;
    }

    final layoutEdge = _LayoutEdge(
      source: source,
      target: target,
    );

    layoutEdges.add(layoutEdge);

    children[source]!.add(target);
    parents[target]!.add(source);

    indegree[target] =
        indegree[target]! + 1;
  }

  return _GraphModel(
    nodes: layoutNodes,
    edges: layoutEdges,
    parents: parents,
    children: children,
    indegree: indegree,
  );
}


/// ============================================================================
/// LAYER ASSIGNMENT
/// ============================================================================
///
/// Kahn + longest path.
///
/// Para cada aresta:
///
///     source -> target
///
/// temos:
///
///     layer[target] >= layer[source] + 1
///
/// Portanto:
///
///     layer[target] = max(layer[target], layer[source] + 1)
///

Map<String, int> _assignLayers({
  required _GraphModel graph,
}) {
  final indegree = <String, int>{
    ...graph.indegree,
  };

  final layers = <String, int>{
    for (final nodeId in graph.nodes.keys)
      nodeId: 0,
  };

  final queue = Queue<String>();

  for (final entry in indegree.entries) {
    if (entry.value == 0) {
      queue.add(entry.key);
    }
  }

  var processed = 0;

  while (queue.isNotEmpty) {
    final current = queue.removeFirst();

    processed++;

    final currentLayer = layers[current]!;

    for (final child in graph.children[current]!) {
      layers[child] = math.max(
        layers[child]!,
        currentLayer + 1,
      );

      indegree[child] =
          indegree[child]! - 1;

      if (indegree[child] == 0) {
        queue.add(child);
      }
    }
  }

  // --------------------------------------------------------------------------
  // Ciclo.
  // --------------------------------------------------------------------------

  if (processed != graph.nodes.length) {
    final cycleNodes = indegree.entries
        .where(
          (entry) => entry.value > 0,
        )
        .map(
          (entry) => entry.key,
        )
        .toList();

    throw SugiyamaLayoutException(
      'O grafo contém um ciclo. '
      'Nós não processados: $cycleNodes',
    );
  }

  return layers;
}


/// ============================================================================
/// INSERIR DUMMY NODES
/// ============================================================================

_ExpandedGraph _insertDummyNodes({
  required _GraphModel graph,
  required Map<String, int> layers,
}) {
  final expandedNodes = <String, _LayoutNode>{
    ...graph.nodes,
  };

  final expandedEdges = <_LayoutEdge>[];

  final expandedLayers = <String, int>{
    ...layers,
  };

  var dummyCounter = 0;

  for (final edge in graph.edges) {
    final sourceLayer = layers[edge.source]!;
    final targetLayer = layers[edge.target]!;

    final distance =
        targetLayer - sourceLayer;

    // ------------------------------------------------------------------------
    // Aresta entre camadas consecutivas.
    // ------------------------------------------------------------------------

    if (distance <= 1) {
      expandedEdges.add(edge);
      continue;
    }

    // ------------------------------------------------------------------------
    // Aresta longa.
    //
    // A -----> D
    //
    // vira:
    //
    // A -> d1 -> d2 -> D
    // ------------------------------------------------------------------------

    var previousNode = edge.source;

    for (
      var layer = sourceLayer + 1;
      layer < targetLayer;
      layer++
    ) {
      final dummyId =
          '__dummy__$dummyCounter';

      dummyCounter++;

      expandedNodes[dummyId] =
          _LayoutNode(
        id: dummyId,
        isDummy: true,
        realNodeId: null,
      );

      expandedLayers[dummyId] = layer;

      expandedEdges.add(
        _LayoutEdge(
          source: previousNode,
          target: dummyId,
        ),
      );

      previousNode = dummyId;
    }

    expandedEdges.add(
      _LayoutEdge(
        source: previousNode,
        target: edge.target,
      ),
    );
  }

  final parents = <String, List<String>>{
    for (final nodeId in expandedNodes.keys)
      nodeId: <String>[],
  };

  final children = <String, List<String>>{
    for (final nodeId in expandedNodes.keys)
      nodeId: <String>[],
  };

  final indegree = <String, int>{
    for (final nodeId in expandedNodes.keys)
      nodeId: 0,
  };

  for (final edge in expandedEdges) {
    children[edge.source]!.add(edge.target);
    parents[edge.target]!.add(edge.source);

    indegree[edge.target] =
        indegree[edge.target]! + 1;
  }

  return _ExpandedGraph(
    graph: _GraphModel(
      nodes: expandedNodes,
      edges: expandedEdges,
      parents: parents,
      children: children,
      indegree: indegree,
    ),
    layers: expandedLayers,
  );
}


/// ============================================================================
/// ORDEM INICIAL DAS CAMADAS
/// ============================================================================

Map<int, List<String>> _buildInitialLayerOrder({
  required Map<String, int> layers,
  required _GraphModel graph,
  required Map<String, double> previousX,
}) {
  final result = <int, List<String>>{};

  for (final entry in layers.entries) {
    result
        .putIfAbsent(
          entry.value,
          () => <String>[],
        )
        .add(entry.key);
  }

  for (final layerNodes in result.values) {
    final originalOrder = _positionMap(
      layerNodes,
    );

    layerNodes.sort(
      (a, b) {
        final xA = previousX[a];
        final xB = previousX[b];

        // --------------------------------------------------------------------
        // Ambos possuem posição anterior.
        // --------------------------------------------------------------------

        if (xA != null && xB != null) {
          final comparison =
              xA.compareTo(xB);

          if (comparison != 0) {
            return comparison;
          }

          return originalOrder[a]!
              .compareTo(
                originalOrder[b]!,
              );
        }

        // --------------------------------------------------------------------
        // Apenas A possui posição.
        // --------------------------------------------------------------------

        if (xA != null) {
          return -1;
        }

        // --------------------------------------------------------------------
        // Apenas B possui posição.
        // --------------------------------------------------------------------

        if (xB != null) {
          return 1;
        }

        // --------------------------------------------------------------------
        // Dummy nodes sem posição anterior.
        // --------------------------------------------------------------------

        final aDummy =
            graph.nodes[a]!.isDummy;

        final bDummy =
            graph.nodes[b]!.isDummy;

        if (aDummy != bDummy) {
          return aDummy ? 1 : -1;
        }

        return originalOrder[a]!
            .compareTo(
              originalOrder[b]!,
            );
      },
    );
  }

  return result;
}


/// ============================================================================
/// MINIMIZAÇÃO DE CRUZAMENTOS
/// ============================================================================

_LayerOrderResult _minimizeCrossings({
  required _GraphModel graph,
  required Map<int, List<String>> initialLayers,
  required SugiyamaConfig config,
}) {
  var current =
      _cloneLayers(initialLayers);

  var currentCrossings =
      _countAllCrossings(
    graph: graph,
    nodesByLayer: current,
  );

  var best =
      _cloneLayers(current);

  var bestCrossings =
      currentCrossings;

  for (
    var iteration = 0;
    iteration < config.crossingIterations;
    iteration++
  ) {
    // ========================================================================
    // Downward sweep
    // ========================================================================

    final downward =
        _downwardSweep(
      graph: graph,
      nodesByLayer: current,
    );

    final downwardCrossings =
        _countAllCrossings(
      graph: graph,
      nodesByLayer: downward,
    );

    current = downward;
    currentCrossings =
        downwardCrossings;

    if (currentCrossings <
        bestCrossings) {
      best =
          _cloneLayers(current);

      bestCrossings =
          currentCrossings;
    }

    // ========================================================================
    // Upward sweep
    // ========================================================================

    final upward =
        _upwardSweep(
      graph: graph,
      nodesByLayer: current,
    );

    final upwardCrossings =
        _countAllCrossings(
      graph: graph,
      nodesByLayer: upward,
    );

    current = upward;
    currentCrossings =
        upwardCrossings;

    if (currentCrossings <
        bestCrossings) {
      best =
          _cloneLayers(current);

      bestCrossings =
          currentCrossings;
    }

    // ========================================================================
    // Adjacent transpose
    //
    // Tenta trocar pares vizinhos quando isso reduz cruzamentos.
    // ========================================================================

    final transposed =
        _transposeLayers(
      graph: graph,
      nodesByLayer: current,
      maxIterations:
          config.transposeIterations,
    );

    final transposedCrossings =
        _countAllCrossings(
      graph: graph,
      nodesByLayer: transposed,
    );

    current = transposed;
    currentCrossings =
        transposedCrossings;

    if (currentCrossings <
        bestCrossings) {
      best =
          _cloneLayers(current);

      bestCrossings =
          currentCrossings;
    }

    // ========================================================================
    // Convergência.
    // ========================================================================

    if (bestCrossings == 0) {
      break;
    }
  }

  return _LayerOrderResult(
    nodesByLayer: best,
    crossingCount: bestCrossings,
  );
}


/// ============================================================================
/// DOWNWARD SWEEP
/// ============================================================================
///
/// Cada nó da camada atual é ordenado pelo barycenter dos pais.
///
/// Exemplo:
///
///     A   B   C
///      \  |  /
///        X
///
/// Se X possui pais nas posições:
///
///     0, 1, 2
///
/// barycenter(X) = 1
///

Map<int, List<String>> _downwardSweep({
  required _GraphModel graph,
  required Map<int, List<String>> nodesByLayer,
}) {
  final result =
      _cloneLayers(nodesByLayer);

  final maxLayer =
      _maxLayer(result);

  for (
    var layer = 1;
    layer <= maxLayer;
    layer++
  ) {
    final currentLayer =
        result[layer];

    if (currentLayer == null ||
        currentLayer.length <= 1) {
      continue;
    }

    final upperLayer =
        result[layer - 1] ?? const [];

    final upperPosition =
        _positionMap(upperLayer);

    final oldPosition =
        _positionMap(currentLayer);

    final score = <String, double>{};

    for (final nodeId
        in currentLayer) {
      score[nodeId] =
          _barycenter(
        neighbors:
            graph.parents[nodeId] ??
                const [],
        position:
            upperPosition,
      );
    }

    currentLayer.sort(
      (a, b) {
        final comparison =
            _compareScores(
          score[a]!,
          score[b]!,
        );

        if (comparison != 0) {
          return comparison;
        }

        // Mantém estabilidade.
        return oldPosition[a]!
            .compareTo(
              oldPosition[b]!,
            );
      },
    );
  }

  return result;
}


/// ============================================================================
/// UPWARD SWEEP
/// ============================================================================

Map<int, List<String>> _upwardSweep({
  required _GraphModel graph,
  required Map<int, List<String>> nodesByLayer,
}) {
  final result =
      _cloneLayers(nodesByLayer);

  final maxLayer =
      _maxLayer(result);

  for (
    var layer = maxLayer - 1;
    layer >= 0;
    layer--
  ) {
    final currentLayer =
        result[layer];

    if (currentLayer == null ||
        currentLayer.length <= 1) {
      continue;
    }

    final lowerLayer =
        result[layer + 1] ?? const [];

    final lowerPosition =
        _positionMap(lowerLayer);

    final oldPosition =
        _positionMap(currentLayer);

    final score = <String, double>{};

    for (final nodeId
        in currentLayer) {
      score[nodeId] =
          _barycenter(
        neighbors:
            graph.children[nodeId] ??
                const [],
        position:
            lowerPosition,
      );
    }

    currentLayer.sort(
      (a, b) {
        final comparison =
            _compareScores(
          score[a]!,
          score[b]!,
        );

        if (comparison != 0) {
          return comparison;
        }

        return oldPosition[a]!
            .compareTo(
              oldPosition[b]!,
            );
      },
    );
  }

  return result;
}


/// ============================================================================
/// BARYCENTER
/// ============================================================================

double _barycenter({
  required List<String> neighbors,
  required Map<String, int> position,
}) {
  var sum = 0.0;
  var count = 0;

  for (final neighbor
      in neighbors) {
    final index =
        position[neighbor];

    if (index == null) {
      continue;
    }

    sum += index;
    count++;
  }

  if (count == 0) {
    return double.infinity;
  }

  return sum / count;
}


/// ============================================================================
/// COMPARADOR DE SCORES
/// ============================================================================

int _compareScores(
  double a,
  double b,
) {
  if (a.isInfinite &&
      b.isInfinite) {
    return 0;
  }

  if (a.isInfinite) {
    return 1;
  }

  if (b.isInfinite) {
    return -1;
  }

  return a.compareTo(b);
}


/// ============================================================================
/// ADJACENT TRANSPOSE
/// ============================================================================
///
/// Tenta:
///
///     A B C D
///
/// trocar:
///
///     A C B D
///
/// sempre que a troca reduzir o número de cruzamentos.
///
/// Isso é uma técnica importante de refinamento após barycenter.
///

Map<int, List<String>> _transposeLayers({
  required _GraphModel graph,
  required Map<int, List<String>> nodesByLayer,
  required int maxIterations,
}) {
  final result =
      _cloneLayers(nodesByLayer);

  if (maxIterations <= 0) {
    return result;
  }

  for (
    var iteration = 0;
    iteration < maxIterations;
    iteration++
  ) {
    var changed = false;

    final maxLayer =
        _maxLayer(result);

    // ------------------------------------------------------------------------
    // Alternamos a direção para evitar viés.
    // ------------------------------------------------------------------------

    final forward =
        iteration.isEven;

    final start =
        forward ? 0 : maxLayer;

    final end =
        forward ? maxLayer : 0;

    final step =
        forward ? 1 : -1;

    for (
      var layer = start;
      forward
          ? layer <= end
          : layer >= end;
      layer += step
    ) {
      final nodes =
          result[layer];

      if (nodes == null ||
          nodes.length <= 1) {
        continue;
      }

      var i = forward
          ? 0
          : nodes.length - 2;

      while (
          forward
              ? i < nodes.length - 1
              : i >= 0) {
        if (i < 0 ||
            i + 1 >= nodes.length) {
          break;
        }

        final before =
            _localCrossingsForNodeLayer(
          graph: graph,
          nodesByLayer: result,
          layer: layer,
        );

        final temp = nodes[i];

        nodes[i] = nodes[i + 1];
        nodes[i + 1] = temp;

        final after =
            _localCrossingsForNodeLayer(
          graph: graph,
          nodesByLayer: result,
          layer: layer,
        );

        if (after < before) {
          changed = true;

          // Mantém a troca e avança.
          if (forward) {
            i++;
          } else {
            i--;
          }
        } else {
          // Desfaz.
          final rollback =
              nodes[i];

          nodes[i] = nodes[i + 1];
          nodes[i + 1] = rollback;

          if (forward) {
            i++;
          } else {
            i--;
          }
        }
      }
    }

    if (!changed) {
      break;
    }
  }

  return result;
}


/// ============================================================================
/// CROSSINGS LOCAIS
/// ============================================================================
///
/// Só as relações da camada acima e abaixo podem ser afetadas pela troca
/// de dois nós dentro de uma determinada camada.
///

int _localCrossingsForNodeLayer({
  required _GraphModel graph,
  required Map<int, List<String>> nodesByLayer,
  required int layer,
}) {
  var result = 0;

  final upper =
      nodesByLayer[layer - 1];

  final current =
      nodesByLayer[layer];

  final lower =
      nodesByLayer[layer + 1];

  if (upper != null &&
      current != null) {
    result += _countLayerCrossings(
      graph: graph,
      upperLayer: upper,
      lowerLayer: current,
    );
  }

  if (current != null &&
      lower != null) {
    result += _countLayerCrossings(
      graph: graph,
      upperLayer: current,
      lowerLayer: lower,
    );
  }

  return result;
}


/// ============================================================================
/// COORDINATE ASSIGNMENT
/// ============================================================================
///
/// Depois que a ordem de cada camada está definida, podemos determinar X.
///
/// O algoritmo mantém a ordem encontrada pelo crossing minimization.
///
/// Inicialmente:
///
///     x = índice * spacing
///
/// Depois:
///
///     x -> média das posições dos vizinhos
///
/// Finalmente:
///
///     projeção sobre as restrições de distância mínima.
///

Map<String, Offset> _assignCoordinates({
  required _GraphModel graph,
  required Map<int, List<String>> nodesByLayer,
  required SugiyamaConfig config,
}) {
  final positions =
      <String, Offset>{};

  if (nodesByLayer.isEmpty) {
    return positions;
  }

  // ==========================================================================
  // 1. Posição inicial
  // ==========================================================================

  for (final entry
      in nodesByLayer.entries) {
    final layer =
        entry.key;

    final nodes =
        entry.value;

    for (var i = 0;
        i < nodes.length;
        i++) {
      positions[nodes[i]] =
          Offset(
        i *
            config.horizontalSpacing,
        layer *
            config.verticalSpacing,
      );
    }
  }

  // ==========================================================================
  // 2. Ajuste iterativo
  // ==========================================================================

  for (
    var iteration = 0;
    iteration <
        config.coordinateIterations;
    iteration++
  ) {
    final forward =
        iteration.isEven;

    if (forward) {
      _coordinateForwardPass(
        graph: graph,
        nodesByLayer:
            nodesByLayer,
        positions:
            positions,
      );
    } else {
      _coordinateBackwardPass(
        graph: graph,
        nodesByLayer:
            nodesByLayer,
        positions:
            positions,
      );
    }

    _projectLayerPositions(
      nodesByLayer:
          nodesByLayer,
      positions:
          positions,
      minimumGap:
          config.minimumHorizontalGap,
    );
  }

  // ==========================================================================
  // 3. Compactação
  // ==========================================================================

  if (config.compact) {
    _compactGraph(
      graph: graph,
      nodesByLayer: nodesByLayer,
      positions: positions,
      minimumGap:
          config.minimumHorizontalGap,
    );
  }

  // ==========================================================================
  // 4. Garantir coordenadas positivas
  // ==========================================================================

  _normalizeCoordinates(
    positions,
  );

  return positions;
}


/// ============================================================================
/// PASSAGEM PARA FRENTE
/// ============================================================================

void _coordinateForwardPass({
  required _GraphModel graph,
  required Map<int, List<String>> nodesByLayer,
  required Map<String, Offset> positions,
}) {
  final maxLayer =
      _maxLayer(nodesByLayer);

  for (
    var layer = 1;
    layer <= maxLayer;
    layer++
  ) {
    final current =
        nodesByLayer[layer];

    if (current == null) {
      continue;
    }

    for (final nodeId in current) {
      final neighbors =
          graph.parents[nodeId] ??
              const [];

      final desired =
          _desiredX(
        neighbors:
            neighbors,
        positions:
            positions,
      );

      if (desired == null) {
        continue;
      }

      final position =
          positions[nodeId]!;

      positions[nodeId] =
          Offset(
        desired,
        position.dy,
      );
    }
  }
}


/// ============================================================================
/// PASSAGEM PARA TRÁS
/// ============================================================================

void _coordinateBackwardPass({
  required _GraphModel graph,
  required Map<int, List<String>> nodesByLayer,
  required Map<String, Offset> positions,
}) {
  final maxLayer =
      _maxLayer(nodesByLayer);

  for (
    var layer = maxLayer - 1;
    layer >= 0;
    layer--
  ) {
    final current =
        nodesByLayer[layer];

    if (current == null) {
      continue;
    }

    for (final nodeId in current) {
      final neighbors =
          graph.children[nodeId] ??
              const [];

      final desired =
          _desiredX(
        neighbors:
            neighbors,
        positions:
            positions,
      );

      if (desired == null) {
        continue;
      }

      final position =
          positions[nodeId]!;

      positions[nodeId] =
          Offset(
        desired,
        position.dy,
      );
    }
  }
}


/// ============================================================================
/// X DESEJADO
/// ============================================================================

double? _desiredX({
  required List<String> neighbors,
  required Map<String, Offset> positions,
}) {
  var sum = 0.0;
  var count = 0;

  for (final neighbor
      in neighbors) {
    final position =
        positions[neighbor];

    if (position == null) {
      continue;
    }

    sum += position.dx;
    count++;
  }

  if (count == 0) {
    return null;
  }

  return sum / count;
}


/// ============================================================================
/// PROJEÇÃO NAS RESTRIÇÕES DE ORDEM
/// ============================================================================
///
/// Garante:
///
///     x[i + 1] >= x[i] + minimumGap
///
/// sem alterar a ordem da camada.
///

void _projectLayerPositions({
  required Map<int, List<String>> nodesByLayer,
  required Map<String, Offset> positions,
  required double minimumGap,
}) {
  for (final nodes
      in nodesByLayer.values) {
    if (nodes.length <= 1) {
      continue;
    }

    // ------------------------------------------------------------------------
    // Forward projection
    // ------------------------------------------------------------------------

    for (var i = 1;
        i < nodes.length;
        i++) {
      final previous =
          positions[nodes[i - 1]]!;

      final current =
          positions[nodes[i]]!;

      final minimumX =
          previous.dx +
              minimumGap;

      if (current.dx < minimumX) {
        positions[nodes[i]] =
            Offset(
          minimumX,
          current.dy,
        );
      }
    }

    // ------------------------------------------------------------------------
    // Backward projection.
    //
    // Isso diminui deslocamentos acumulados.
    // ------------------------------------------------------------------------

    for (
      var i = nodes.length - 2;
      i >= 0;
      i--
    ) {
      final current =
          positions[nodes[i]]!;

      final next =
          positions[nodes[i + 1]]!;

      final maximumX =
          next.dx -
              minimumGap;

      if (current.dx > maximumX) {
        positions[nodes[i]] =
            Offset(
          maximumX,
          current.dy,
        );
      }
    }

    // ------------------------------------------------------------------------
    // Uma segunda projeção forward garante novamente a restrição.
    // ------------------------------------------------------------------------

    for (var i = 1;
        i < nodes.length;
        i++) {
      final previous =
          positions[nodes[i - 1]]!;

      final current =
          positions[nodes[i]]!;

      final minimumX =
          previous.dx +
              minimumGap;

      if (current.dx < minimumX) {
        positions[nodes[i]] =
            Offset(
          minimumX,
          current.dy,
        );
      }
    }
  }
}


/// ============================================================================
/// COMPACTAÇÃO
/// ============================================================================
///
/// Remove espaço horizontal desnecessário sem destruir a ordem.
///
/// O algoritmo encontra o menor deslocamento global possível para cada
/// camada enquanto respeita as restrições dos vizinhos.
///

void _compactGraph({
  required _GraphModel graph,
  required Map<int, List<String>> nodesByLayer,
  required Map<String, Offset> positions,
  required double minimumGap,
}) {
  final maxLayer =
      _maxLayer(nodesByLayer);

  for (
    var layer = 0;
    layer <= maxLayer;
    layer++
  ) {
    final current =
        nodesByLayer[layer];

    if (current == null ||
        current.isEmpty) {
      continue;
    }

    // ------------------------------------------------------------------------
    // Deslocamento médio recomendado pelos vizinhos.
    // ------------------------------------------------------------------------

    var totalDesiredShift = 0.0;
    var desiredCount = 0;

    for (final nodeId
        in current) {
      final nodePosition =
          positions[nodeId]!;

      final neighbors = <String>[
        ...graph.parents[nodeId] ??
            const [],
        ...graph.children[nodeId] ??
            const [],
      ];

      if (neighbors.isEmpty) {
        continue;
      }

      var neighborSum = 0.0;
      var neighborCount = 0;

      for (final neighbor
          in neighbors) {
        final neighborPosition =
            positions[neighbor];

        if (neighborPosition == null) {
          continue;
        }

        neighborSum +=
            neighborPosition.dx;

        neighborCount++;
      }

      if (neighborCount == 0) {
        continue;
      }

      final desiredX =
          neighborSum /
              neighborCount;

      totalDesiredShift +=
          desiredX -
              nodePosition.dx;

      desiredCount++;
    }

    if (desiredCount == 0) {
      continue;
    }

    final shift =
        totalDesiredShift /
            desiredCount;

    // Limita a compactação para não destruir uma estrutura boa.
    final clampedShift =
        shift.clamp(
          -minimumGap,
          minimumGap,
        );

    for (final nodeId
        in current) {
      final position =
          positions[nodeId]!;

      positions[nodeId] =
          Offset(
        position.dx +
            clampedShift,
        position.dy,
      );
    }

    _projectLayerPositions(
      nodesByLayer:
          nodesByLayer,
      positions:
          positions,
      minimumGap:
          minimumGap,
    );
  }
}


/// ============================================================================
/// COUNTING DE CROSSINGS
/// ============================================================================

int _countAllCrossings({
  required _GraphModel graph,
  required Map<int, List<String>> nodesByLayer,
}) {
  var total = 0;

  final maxLayer =
      _maxLayer(nodesByLayer);

  for (
    var layer = 0;
    layer < maxLayer;
    layer++
  ) {
    total +=
        _countLayerCrossings(
      graph: graph,
      upperLayer:
          nodesByLayer[layer] ??
              const [],
      lowerLayer:
          nodesByLayer[layer + 1] ??
              const [],
    );
  }

  return total;
}


/// ============================================================================
/// COUNT CROSSINGS ENTRE DUAS CAMADAS
/// ============================================================================
///
/// Considere:
///
/// camada superior:
///
///     A B C D
///
/// camada inferior:
///
///     X Y Z W
///
/// Uma aresta A->Z e outra B->Y cruzam porque:
///
///     A < B
///     Z > Y
///
/// Isso é exatamente uma inversão.
///
/// O Fenwick Tree conta essas inversões em O(E log V).
///

int _countLayerCrossings({
  required _GraphModel graph,
  required List<String> upperLayer,
  required List<String> lowerLayer,
}) {
  if (upperLayer.isEmpty ||
      lowerLayer.isEmpty) {
    return 0;
  }

  final upperPosition =
      _positionMap(upperLayer);

  final lowerPosition =
      _positionMap(lowerLayer);

  final segmentsByUpper =
      <int, List<int>>{};

  for (final source
      in upperLayer) {
    final sourcePosition =
        upperPosition[source]!;

    final children =
        graph.children[source] ??
            const [];

    for (final target
        in children) {
      final targetPosition =
          lowerPosition[target];

      if (targetPosition == null) {
        continue;
      }

      segmentsByUpper
          .putIfAbsent(
            sourcePosition,
            () => <int>[],
          )
          .add(
            targetPosition,
          );
    }
  }

  if (segmentsByUpper.isEmpty) {
    return 0;
  }

  final fenwick =
      _FenwickTree(
    lowerLayer.length,
  );

  var seen = 0;
  var crossings = 0;

  final upperPositions =
      segmentsByUpper.keys.toList()
        ..sort();

  for (final upperPositionValue
      in upperPositions) {
    final targets =
        segmentsByUpper[
            upperPositionValue]!;

    // Primeiro consulta todas.
    // Depois adiciona todas.
    //
    // Assim, arestas que partem do mesmo nó nunca contam
    // como cruzamento entre si.
    for (final targetPosition
        in targets) {
      final before =
          fenwick.query(
        targetPosition,
      );

      crossings +=
          seen - before;
    }

    for (final targetPosition
        in targets) {
      fenwick.add(
        targetPosition,
        1,
      );

      seen++;
    }
  }

  return crossings;
}


/// ============================================================================
/// UTILITÁRIOS
/// ============================================================================

Map<String, int> _positionMap(
  List<String> nodes,
) {
  return <String, int>{
    for (var i = 0;
        i < nodes.length;
        i++)
      nodes[i]: i,
  };
}


int _maxLayer(
  Map<int, List<String>> nodesByLayer,
) {
  if (nodesByLayer.isEmpty) {
    return 0;
  }

  return nodesByLayer.keys.reduce(
    math.max,
  );
}


Map<int, List<String>> _cloneLayers(
  Map<int, List<String>> source,
) {
  return <int, List<String>>{
    for (final entry
        in source.entries)
      entry.key:
          List<String>.from(
        entry.value,
      ),
  };
}


/// ============================================================================
/// NORMALIZAÇÃO
/// ============================================================================

void _normalizeCoordinates(
  Map<String, Offset> positions,
) {
  if (positions.isEmpty) {
    return;
  }

  var minimumX =
      double.infinity;

  var minimumY =
      double.infinity;

  for (final position
      in positions.values) {
    minimumX =
        math.min(
      minimumX,
      position.dx,
    );

    minimumY =
        math.min(
      minimumY,
      position.dy,
    );
  }

  final shiftX =
      minimumX.isFinite &&
              minimumX < 0
          ? -minimumX
          : 0.0;

  final shiftY =
      minimumY.isFinite &&
              minimumY < 0
          ? -minimumY
          : 0.0;

  if (shiftX == 0 &&
      shiftY == 0) {
    return;
  }

  for (final nodeId
      in positions.keys.toList()) {
    final position =
        positions[nodeId]!;

    positions[nodeId] =
        Offset(
      position.dx + shiftX,
      position.dy + shiftY,
    );
  }
}

/////// Ver simples

// import 'dart:math';

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:noema/core/database/database.dart';
// import 'package:noema/core/database/database_provider.dart';
// import 'package:noema/feature/graph/data/graph_node_dao.dart';
// import 'package:noema/feature/graph/provider/graph_provider.dart';

// // OBS.: Gerei com IA
// /// ---------------------------------------------------------------------------
// /// Representação interna de um nó do algoritmo.
// /// ---------------------------------------------------------------------------
// ///
// /// Os nós reais têm [isDummy] = false.
// /// Os nós criados para "quebrar" arestas longas têm [isDummy] = true.
// ///
// /// Dummy nodes NÃO são salvos no banco.
// class _LayoutNode {
//   final String id;
//   final bool isDummy;

//   /// ID do nó real associado.
//   ///
//   /// Para nós reais:
//   ///   realNodeId == id
//   ///
//   /// Para dummy:
//   ///   realNodeId == null
//   final String? realNodeId;

//   _LayoutNode({required this.id, required this.isDummy, this.realNodeId});
// }

// /// Aresta interna usada pelo algoritmo.
// ///
// /// Diferente da aresta do banco, esta estrutura pode conectar dummy nodes.
// class _LayoutEdge {
//   final String source;
//   final String target;

//   _LayoutEdge({required this.source, required this.target});
// }

// /// Resultado do layout.
// class _SugiyamaResult {
//   final Map<String, Offset> positions;
//   final Map<String, int> layers;

//   _SugiyamaResult({required this.positions, required this.layers});
// }

// Future<void> sugiyama(String graphId, WidgetRef ref) async {
//   final db = ref.read(appDatabaseProvider);

//   final graphNodeDao = GraphNodeDao(db);

//   final nodes = await ref.read(nodesProvider(graphId).future);
//   final edges = await ref.read(edgesProvider(graphId).future);

//   if (nodes.isEmpty) {
//     return;
//   }

//   // =========================================================================
//   // 1. Configuração visual
//   // =========================================================================

//   const horizontalSpacing = 220.0;
//   const verticalSpacing = 180.0;

//   // Quantidade de iterações da heurística de crossing minimization.
//   const iterations = 8;

//   // =========================================================================
//   // 2. Nós reais
//   // =========================================================================

//   final nodeById = <String, GraphNodeData>{
//     for (final node in nodes) node.id: node,
//   };

//   final layoutNodes = <String, _LayoutNode>{
//     for (final node in nodes)
//       node.id: _LayoutNode(id: node.id, isDummy: false, realNodeId: node.id),
//   };

//   // =========================================================================
//   // 3. Construir grafo básico
//   // =========================================================================

//   final inDegree = <String, int>{for (final node in nodes) node.id: 0};

//   final children = <String, List<String>>{
//     for (final node in nodes) node.id: [],
//   };

//   final parents = <String, List<String>>{for (final node in nodes) node.id: []};

//   //
//   // Guardamos primeiro as arestas reais.
//   //
//   final originalEdges = <_LayoutEdge>[];

//   for (final edge in edges) {
//     final source = edge.sourceNodeId;
//     final target = edge.targetNodeId;

//     // Ignora arestas inválidas.
//     if (!nodeById.containsKey(source) || !nodeById.containsKey(target)) {
//       continue;
//     }

//     // Evita self-loop.
//     if (source == target) {
//       continue;
//     }

//     originalEdges.add(_LayoutEdge(source: source, target: target));

//     children[source]!.add(target);
//     parents[target]!.add(source);

//     inDegree[target] = inDegree[target]! + 1;
//   }

//   // =========================================================================
//   // 4. Ordenação topológica + cálculo inicial das camadas
//   // =========================================================================
//   //
//   // A camada é determinada pela maior distância até uma raiz.
//   //
//   // Exemplo:
//   //
//   // A -> B -> D
//   // A -> C -> D
//   //
//   // A = 0
//   // B = 1
//   // C = 1
//   // D = 2
//   //
//   // =========================================================================

//   final queue = <String>[];

//   for (final entry in inDegree.entries) {
//     if (entry.value == 0) {
//       queue.add(entry.key);
//     }
//   }

//   final layers = <String, int>{for (final node in nodes) node.id: 0};

//   // Usar índice em vez de removeAt(0).
//   var queueIndex = 0;
//   var processed = 0;

//   while (queueIndex < queue.length) {
//     final current = queue[queueIndex++];
//     processed++;

//     final currentLayer = layers[current]!;

//     for (final child in children[current]!) {
//       layers[child] = max(layers[child] ?? 0, currentLayer + 1);

//       inDegree[child] = inDegree[child]! - 1;

//       if (inDegree[child] == 0) {
//         queue.add(child);
//       }
//     }
//   }

//   // =========================================================================
//   // 5. Detectar ciclo
//   // =========================================================================

//   if (processed != nodes.length) {
//     throw StateError(
//       'Não foi possível organizar o grafo porque ele contém '
//       'um ciclo. O algoritmo de Sugiyama trabalha sobre DAGs.',
//     );
//   }

//   // =========================================================================
//   // 6. Criar dummy nodes
//   // =========================================================================
//   //
//   // Uma aresta:
//   //
//   // A(layer 0) -----------------> D(layer 3)
//   //
//   // será transformada em:
//   //
//   // A -> dummy1 -> dummy2 -> D
//   //
//   // Isso permite que a heurística de crossing minimization enxergue
//   // corretamente a aresta passando pelas camadas intermediárias.
//   // =========================================================================

//   final layoutEdges = <_LayoutEdge>[];

//   var dummyCounter = 0;

//   for (final edge in originalEdges) {
//     final sourceLayer = layers[edge.source]!;
//     final targetLayer = layers[edge.target]!;

//     final distance = targetLayer - sourceLayer;

//     // Aresta normal: camadas consecutivas.
//     if (distance <= 1) {
//       layoutEdges.add(edge);
//       continue;
//     }

//     var previousNode = edge.source;

//     for (var layer = sourceLayer + 1; layer < targetLayer; layer++) {
//       final dummyId = '__dummy_${dummyCounter++}';

//       layoutNodes[dummyId] = _LayoutNode(id: dummyId, isDummy: true);

//       layers[dummyId] = layer;

//       layoutEdges.add(_LayoutEdge(source: previousNode, target: dummyId));

//       previousNode = dummyId;
//     }

//     layoutEdges.add(_LayoutEdge(source: previousNode, target: edge.target));
//   }

//   // =========================================================================
//   // 7. Construir estrutura de vizinhança usando os dummy nodes
//   // =========================================================================

//   final layoutParents = <String, List<String>>{
//     for (final nodeId in layoutNodes.keys) nodeId: [],
//   };

//   final layoutChildren = <String, List<String>>{
//     for (final nodeId in layoutNodes.keys) nodeId: [],
//   };

//   for (final edge in layoutEdges) {
//     layoutChildren[edge.source]!.add(edge.target);
//     layoutParents[edge.target]!.add(edge.source);
//   }

//   // =========================================================================
//   // 8. Agrupar nós por camada
//   // =========================================================================

//   final nodesByLayer = <int, List<String>>{};

//   for (final entry in layers.entries) {
//     nodesByLayer.putIfAbsent(entry.value, () => []);
//     nodesByLayer[entry.value]!.add(entry.key);
//   }

//   final maxLayer = nodesByLayer.keys.isEmpty
//       ? 0
//       : nodesByLayer.keys.reduce(max);

//   // =========================================================================
//   // 9. Ordem inicial
//   // =========================================================================
//   //
//   // Inicialmente mantemos a ordem original dos nós.
//   //
//   // Dummy nodes recebem a posição em que aparecem.
//   // =========================================================================

//   for (final layerNodes in nodesByLayer.values) {
//     layerNodes.sort((a, b) {
//       final aDummy = layoutNodes[a]!.isDummy;
//       final bDummy = layoutNodes[b]!.isDummy;

//       if (aDummy == bDummy) {
//         return a.compareTo(b);
//       }

//       return aDummy ? 1 : -1;
//     });
//   }

//   // =========================================================================
//   // 10. Função auxiliar para calcular barycenter
//   // =========================================================================
//   //
//   // O barycenter é a média das posições dos vizinhos na camada adjacente.
//   //
//   // Exemplo:
//   //
//   // camada acima:
//   //
//   // A   B   C
//   //
//   //             X
//   //
//   // se X estiver ligado a A e C:
//   //
//   // barycenter(X) = (0 + 2) / 2 = 1
//   //
//   // =========================================================================

//   double barycenter(String nodeId, List<String> adjacentNodes) {
//     if (adjacentNodes.isEmpty) {
//       return double.infinity;
//     }

//     var sum = 0.0;
//     var count = 0;

//     for (final neighbor in adjacentNodes) {
//       final position = adjacentNodes.indexOf(neighbor);

//       if (position >= 0) {
//         sum += position;
//         count++;
//       }
//     }

//     if (count == 0) {
//       return double.infinity;
//     }

//     return sum / count;
//   }

//   // =========================================================================
//   // 11. Melhor barycenter
//   // =========================================================================
//   //
//   // A função acima precisa conhecer a ordem da camada.
//   //
//   // Portanto usamos esta implementação real abaixo.
//   // =========================================================================

//   double calculateBarycenter({
//     required String nodeId,
//     required List<String> adjacent,
//     required List<String> adjacentLayer,
//   }) {
//     if (adjacent.isEmpty) {
//       return double.infinity;
//     }

//     final positionById = <String, int>{
//       for (var i = 0; i < adjacentLayer.length; i++) adjacentLayer[i]: i,
//     };

//     var sum = 0.0;
//     var count = 0;

//     for (final neighbor in adjacent) {
//       final position = positionById[neighbor];

//       if (position == null) {
//         continue;
//       }

//       sum += position;
//       count++;
//     }

//     if (count == 0) {
//       return double.infinity;
//     }

//     return sum / count;
//   }

//   // =========================================================================
//   // 12. Crossing minimization
//   // =========================================================================
//   //
//   // Fazemos várias passagens:
//   //
//   // cima -> baixo
//   // baixo -> cima
//   //
//   // Isso tende a encontrar uma ordem significativamente melhor do que
//   // simplesmente ordenar pelo ID dos nós.
//   // =========================================================================

//   for (var iteration = 0; iteration < iterations; iteration++) {
//     // -----------------------------------------------------------------------
//     // 12.1. Downward sweep
//     // -----------------------------------------------------------------------
//     //
//     // Ordena uma camada olhando para os nós da camada acima.
//     //
//     // -----------------------------------------------------------------------

//     for (var layer = 1; layer <= maxLayer; layer++) {
//       final currentLayer = nodesByLayer[layer];

//       if (currentLayer == null || currentLayer.length <= 1) {
//         continue;
//       }

//       final upperLayer = nodesByLayer[layer - 1] ?? [];

//       final upperPosition = <String, int>{
//         for (var i = 0; i < upperLayer.length; i++) upperLayer[i]: i,
//       };

//       currentLayer.sort((a, b) {
//         double barycenterOf(String nodeId) {
//           final parentIds = layoutParents[nodeId] ?? [];

//           if (parentIds.isEmpty) {
//             return double.infinity;
//           }

//           var sum = 0.0;
//           var count = 0;

//           for (final parentId in parentIds) {
//             final position = upperPosition[parentId];

//             if (position == null) {
//               continue;
//             }

//             sum += position;
//             count++;
//           }

//           if (count == 0) {
//             return double.infinity;
//           }

//           return sum / count;
//         }

//         final baryA = barycenterOf(a);
//         final baryB = barycenterOf(b);

//         if (baryA == baryB) {
//           return currentLayer.indexOf(a).compareTo(currentLayer.indexOf(b));
//         }

//         return baryA.compareTo(baryB);
//       });
//     }

//     // -----------------------------------------------------------------------
//     // 12.2. Upward sweep
//     // -----------------------------------------------------------------------

//     for (var layer = maxLayer - 1; layer >= 0; layer--) {
//       final currentLayer = nodesByLayer[layer];

//       if (currentLayer == null || currentLayer.length <= 1) {
//         continue;
//       }

//       final lowerLayer = nodesByLayer[layer + 1] ?? [];

//       final lowerPosition = <String, int>{
//         for (var i = 0; i < lowerLayer.length; i++) lowerLayer[i]: i,
//       };

//       currentLayer.sort((a, b) {
//         double barycenterOf(String nodeId) {
//           final childIds = layoutChildren[nodeId] ?? [];

//           if (childIds.isEmpty) {
//             return double.infinity;
//           }

//           var sum = 0.0;
//           var count = 0;

//           for (final childId in childIds) {
//             final position = lowerPosition[childId];

//             if (position == null) {
//               continue;
//             }

//             sum += position;
//             count++;
//           }

//           if (count == 0) {
//             return double.infinity;
//           }

//           return sum / count;
//         }

//         final baryA = barycenterOf(a);
//         final baryB = barycenterOf(b);

//         if (baryA == baryB) {
//           return currentLayer.indexOf(a).compareTo(currentLayer.indexOf(b));
//         }

//         return baryA.compareTo(baryB);
//       });
//     }
//   }

//   // =========================================================================
//   // 13. Calcular posições X/Y
//   // =========================================================================
//   //
//   // Primeiro calculamos X dentro da camada.
//   //
//   // Depois centralizamos cada camada para evitar que:
//   //
//   // camada 0 = 0..1000
//   // camada 1 = 0..400
//   //
//   // fique visualmente torto.
//   // =========================================================================

//   final positions = <String, Offset>{};

//   final layerWidths = <int, double>{};

//   for (final entry in nodesByLayer.entries) {
//     final layer = entry.key;
//     final layerNodes = entry.value;

//     if (layerNodes.isEmpty) {
//       layerWidths[layer] = 0;
//       continue;
//     }

//     final width = (layerNodes.length - 1) * horizontalSpacing;

//     layerWidths[layer] = width;
//   }

//   // Largura máxima do grafo.
//   final graphWidth = layerWidths.values.isEmpty
//       ? 0.0
//       : layerWidths.values.reduce(max);

//   for (final entry in nodesByLayer.entries) {
//     final layer = entry.key;
//     final layerNodes = entry.value;

//     final layerWidth = layerWidths[layer] ?? 0;

//     // Centraliza a camada em relação à maior camada.
//     final offsetX = (graphWidth - layerWidth) / 2;

//     for (var i = 0; i < layerNodes.length; i++) {
//       final nodeId = layerNodes[i];

//       final x = offsetX + i * horizontalSpacing;
//       final y = layer * verticalSpacing;

//       positions[nodeId] = Offset(x, y);
//     }
//   }

//   // =========================================================================
//   // 14. Resultado
//   // =========================================================================

//   final result = _SugiyamaResult(positions: positions, layers: layers);

//   // =========================================================================
//   // 15. Salvar somente os nós reais
//   // =========================================================================

//   for (final node in nodes) {
//     final position = result.positions[node.id];

//     if (position == null) {
//       continue;
//     }

//     await graphNodeDao.updateGraphNode(
//       id: node.id,
//       positionX: position.dx,
//       positionY: position.dy,
//     );

//     final layer = result.layers[node.id] ?? 0;

//     print(
//       'Node: ${node.title}\n'
//       'Layer: $layer\n'
//       'X: ${position.dx}\n'
//       'Y: ${position.dy}\n',
//     );
//   }
// }
