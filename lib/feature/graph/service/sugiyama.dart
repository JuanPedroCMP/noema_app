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
// OBS. 2: Revisado para nunca lançar exceções durante o auto-layout, e para
// suportar dois modos de organização horizontal (`SugiyamaLayoutMode`).
//
//   - Ciclos no grafo (ex.: A pré-requisito de B e B pré-requisito de A,
//     algo que uma IA gerando o grafo pode produzir por engano) são
//     detectados e quebrados automaticamente em `_breakCycles`, em vez de
//     travar o layout.
//   - `_assignLayers` mantém uma rede de segurança extra: se por algum
//     motivo inesperado ainda sobrar um nó não processado, ele recebe uma
//     camada de fallback em vez de lançar exceção.
//   - `sugiyama()` (ponto de entrada público) envolve o pipeline inteiro em
//     try/catch: qualquer erro inesperado é registrado via `debugPrint` e
//     engolido, para nunca derrubar a tela do usuário. Em vez de não
//     retornar nada, ela devolve um `SugiyamaRunResult` com o que
//     aconteceu (quantos nós foram salvos, quantos falharam, quantos
//     ciclos foram quebrados e o retângulo que envolve o grafo).
//   - A persistência no banco é feita nó a nó, cada um com seu próprio
//     try/catch, então a falha ao salvar um nó não impede os demais de
//     serem salvos.
//   - Valores de configuração inválidos (negativos, zero ou não finitos)
//     são normalizados para os padrões seguros em `_sanitizeConfig`.
//   - `SugiyamaLayoutMode.balanced` (padrão) posiciona cada nó na média
//     dos vizinhos; `SugiyamaLayoutMode.centered` centraliza cada nó
//     exatamente entre o vizinho mais à esquerda e o mais à direita,
//     dando um visual de organograma/árvore genealógica.
//   - `_projectLayerPositions` usa regressão isotônica (PAVA) em vez de
//     só empurrar nós para a direita. Isso é o que garante que irmãos
//     com a mesma posição desejada (ex.: filhos de um mesmo pai) fiquem
//     distribuídos simetricamente ao redor dela, e não "grudados" à
//     esquerda — ao custo de usar um pouco mais de espaço quando preciso.

/// ============================================================================
/// CONFIGURAÇÃO
/// ============================================================================

enum SugiyamaLayoutMode {
  /// Cada nó tenta se aproximar da média de todos os seus vizinhos (pais e
  /// filhos). Bom modo geral: minimiza o deslocamento total das arestas e
  /// tende a se comportar bem mesmo em grafos com muitas conexões
  /// cruzadas entre si.
  balanced,

  /// Cada nó é centralizado exatamente entre o vizinho mais à esquerda e
  /// o mais à direita (pais na passagem para frente, filhos na passagem
  /// para trás). Na prática isso centraliza cada pai bem em cima do
  /// intervalo ocupado pelos seus filhos — e cada filho único fica
  /// exatamente embaixo do seu pai — resultando num visual mais
  /// simétrico e "arrumado", parecido com organograma ou árvore
  /// genealógica. É o modo recomendado quando o grafo é predominantemente
  /// hierárquico (poucos nós com múltiplos pais).
  centered,
}

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

  /// Estratégia usada para posicionar horizontalmente os nós dentro de
  /// cada camada. Veja `SugiyamaLayoutMode`.
  final SugiyamaLayoutMode mode;

  const SugiyamaConfig({
    this.horizontalSpacing = 220.0,
    this.verticalSpacing = 180.0,
    this.minimumHorizontalGap = 220.0,
    this.crossingIterations = 12,
    this.transposeIterations = 4,
    this.coordinateIterations = 6,
    this.preservePreviousOrder = true,
    this.compact = true,
    this.mode = SugiyamaLayoutMode.balanced,
  });
}

/// ============================================================================
/// TIPOS INTERNOS
/// ============================================================================

class _InputEdge {
  final String source;
  final String target;

  const _InputEdge({required this.source, required this.target});
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

  const _LayoutEdge({required this.source, required this.target});
}

class _GraphModel {
  final Map<String, _LayoutNode> nodes;
  final List<_LayoutEdge> edges;

  final Map<String, List<String>> parents;
  final Map<String, List<String>> children;

  final Map<String, int> indegree;

  /// Quantidade de arestas removidas automaticamente por `_breakCycles`
  /// para tornar o grafo acíclico. Só é preenchido no grafo original
  /// (antes da inserção de dummy nodes); no grafo expandido fica 0.
  final int cyclesBrokenCount;

  const _GraphModel({
    required this.nodes,
    required this.edges,
    required this.parents,
    required this.children,
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

class _SugiyamaResult {
  final Map<String, Offset> positions;
  final Map<String, int> layers;
  final int cyclesBrokenCount;

  const _SugiyamaResult({
    required this.positions,
    required this.layers,
    required this.cyclesBrokenCount,
  });
}

/// ============================================================================
/// RESULTADO DE UMA EXECUÇÃO
/// ============================================================================
///
/// Retornado por `sugiyama()` para que quem chamou saiba o que aconteceu
/// sem precisar consultar o banco de novo — por exemplo, para mostrar um
/// aviso ("2 nós não puderam ser salvos") ou para centralizar a
/// câmera/viewport no grafo usando `bounds`.

class SugiyamaRunResult {
  /// Quantidade de nós reais que tiveram a posição salva com sucesso.
  final int nodesUpdated;

  /// Quantidade de nós reais que falharam ao salvar a nova posição.
  /// Detalhes de cada falha vão para `debugPrint`.
  final int nodesFailed;

  /// Quantidade de arestas removidas automaticamente para quebrar
  /// ciclos no grafo (ver `_breakCycles`). Zero na grande maioria dos
  /// grafos.
  final int cyclesBroken;

  /// Retângulo que envolve todas as posições calculadas. Útil para
  /// centralizar a câmera/viewport no grafo depois do auto-layout.
  ///
  /// `null` quando nada foi processado (grafo vazio ou falha antes de
  /// calcular qualquer posição).
  final Rect? bounds;

  const SugiyamaRunResult({
    required this.nodesUpdated,
    required this.nodesFailed,
    required this.cyclesBroken,
    required this.bounds,
  });

  /// Resultado neutro, usado quando o grafo está vazio ou quando o
  /// auto-layout falha antes de processar qualquer nó.
  static const empty = SugiyamaRunResult(
    nodesUpdated: 0,
    nodesFailed: 0,
    cyclesBroken: 0,
    bounds: null,
  );
}

/// ============================================================================
/// ERRO ESPECÍFICO
/// ============================================================================
///
/// Mantida apenas por compatibilidade com código externo que já capture
/// esse tipo, por exemplo:
///
///     catch (e) { if (e is SugiyamaLayoutException) ... }
///
/// O algoritmo não lança mais essa exceção: ciclos no grafo agora são
/// detectados e quebrados automaticamente (ver `_breakCycles`), então o
/// layout nunca falha por causa de um ciclo.

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

  int queryRange(int left, int right) {
    if (right < left) {
      return 0;
    }

    return query(right) - (left == 0 ? 0 : query(left - 1));
  }
}

/// ============================================================================
/// API PRINCIPAL
/// ============================================================================
///
/// Ponto de entrada público. Nunca lança exceções: qualquer falha em
/// qualquer etapa (carregar dados, calcular o layout, persistir) é
/// capturada e registrada via `debugPrint`, e a função retorna
/// `SugiyamaRunResult.empty` sem alterar o que já estava salvo.
///

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
    // --------------------------------------------------------------------------
    // Última rede de segurança: um erro no auto-layout nunca deve travar a
    // tela do usuário. As posições anteriores dos nós permanecem intactas.
    // --------------------------------------------------------------------------
    debugPrint(
      'Sugiyama: falha inesperada no auto-layout do grafo "$graphId". '
      'As posições anteriores foram preservadas. Erro: $error',
    );
    debugPrint('$stackTrace');

    return SugiyamaRunResult.empty;
  }
}

/// Carrega os dados, roda o algoritmo puro e persiste o resultado.
///
/// Separado de `sugiyama()` só para que o try/catch externo cubra o
/// pipeline inteiro (carregamento incluso) em um único lugar.
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

  final inputEdges = <_InputEdge>[
    for (final edge in edges)
      _InputEdge(source: edge.sourceNodeId, target: edge.targetNodeId),
  ];

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
  //
  // Cada nó é salvo com seu próprio try/catch: se um nó falhar (ex.: erro
  // transitório de banco), os demais continuam sendo salvos normalmente.
  // Também acumulamos o retângulo que envolve todas as posições, para
  // devolver em `SugiyamaRunResult.bounds`.
  // --------------------------------------------------------------------------

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

      debugPrint(
        'Sugiyama\n'
        'Node: ${node.title}\n'
        'Layer: ${result.layers[node.id]}\n'
        'X: ${position.dx.toStringAsFixed(1)}\n'
        'Y: ${position.dy.toStringAsFixed(1)}',
      );
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

  final bounds =
      (minX != null && minY != null && maxX != null && maxY != null)
      ? Rect.fromLTRB(minX, minY, maxX, maxY)
      : null;

  return SugiyamaRunResult(
    nodesUpdated: succeeded,
    nodesFailed: failed,
    cyclesBroken: result.cyclesBrokenCount,
    bounds: bounds,
  );
}

/// ============================================================================
/// SANITIZAÇÃO DE CONFIGURAÇÃO
/// ============================================================================
///
/// Garante que a configuração usada internamente seja sempre segura, mesmo
/// que valores inválidos (negativos, zero ou não finitos) sejam passados
/// por engano — evita espaçamentos degenerados ou loops configurados para
/// nunca convergir.
///

SugiyamaConfig _sanitizeConfig(SugiyamaConfig config) {
  double safeSpacing(double value, double fallback) {
    if (!value.isFinite || value <= 0) {
      return fallback;
    }

    return value;
  }

  int safeIterations(int value) {
    if (value < 0) {
      return 0;
    }

    return value;
  }

  return SugiyamaConfig(
    horizontalSpacing: safeSpacing(config.horizontalSpacing, 220.0),
    verticalSpacing: safeSpacing(config.verticalSpacing, 180.0),
    minimumHorizontalGap: safeSpacing(config.minimumHorizontalGap, 220.0),
    crossingIterations: safeIterations(config.crossingIterations),
    transposeIterations: safeIterations(config.transposeIterations),
    coordinateIterations: safeIterations(config.coordinateIterations),
    preservePreviousOrder: config.preservePreviousOrder,
    compact: config.compact,
    mode: config.mode,
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
  // 1. Construir o grafo (já livre de ciclos, ver `_buildGraph`)
  // ==========================================================================

  final graph = _buildGraph(nodes: nodes, edges: edges);

  // ==========================================================================
  // 2. Atribuir camadas
  // ==========================================================================

  final layers = _assignLayers(graph: graph);

  // ==========================================================================
  // 3. Inserir dummy nodes
  // ==========================================================================

  final expanded = _insertDummyNodes(graph: graph, layers: layers);

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
  // 6. Coordenadas (respeita `config.mode`: balanced ou centered)
  // ==========================================================================

  final positions = _assignCoordinates(
    graph: expanded.graph,
    nodesByLayer: crossingResult.nodesByLayer,
    config: config,
  );

  return _SugiyamaResult(
    positions: positions,
    layers: expanded.layers,
    cyclesBrokenCount: graph.cyclesBrokenCount,
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
      node.id: _LayoutNode(id: node.id, isDummy: false, realNodeId: node.id),
  };

  final nodeIds = layoutNodes.keys.toSet();

  // --------------------------------------------------------------------------
  // Primeiro filtro: descarta arestas inválidas.
  //
  //   - apontando para um nó inexistente
  //   - self-loop (nó apontando para si mesmo)
  //   - duplicata
  // --------------------------------------------------------------------------

  final candidateEdges = <_InputEdge>[];
  final seenEdges = <String>{};

  for (final edge in edges) {
    final source = edge.source;
    final target = edge.target;

    if (!nodeIds.contains(source) || !nodeIds.contains(target)) {
      continue;
    }

    if (source == target) {
      continue;
    }

    final edgeKey = '$source::$target';

    if (!seenEdges.add(edgeKey)) {
      continue;
    }

    candidateEdges.add(edge);
  }

  // --------------------------------------------------------------------------
  // Segundo filtro: quebra ciclos automaticamente.
  //
  // Um grafo de conhecimento gerado por IA pode ocasionalmente conter
  // relações contraditórias (ex.: A é pré-requisito de B e B é
  // pré-requisito de A). Em vez de deixar o algoritmo de camadas travar
  // com uma exceção, removemos o menor conjunto de arestas necessário
  // para tornar o grafo acíclico.
  // --------------------------------------------------------------------------

  final cycleResult = _breakCycles(nodeIds: nodeIds, edges: candidateEdges);

  if (cycleResult.removedEdges.isNotEmpty) {
    final removedDescription = cycleResult.removedEdges
        .map((edge) => '${edge.source}->${edge.target}')
        .join(', ');

    debugPrint(
      'Sugiyama: ${cycleResult.removedEdges.length} aresta(s) '
      'removida(s) automaticamente para quebrar ciclo(s) no grafo: '
      '$removedDescription',
    );
  }

  // --------------------------------------------------------------------------
  // Constrói as estruturas finais a partir do grafo já acíclico.
  // --------------------------------------------------------------------------

  final parents = <String, List<String>>{
    for (final node in nodes) node.id: <String>[],
  };

  final children = <String, List<String>>{
    for (final node in nodes) node.id: <String>[],
  };

  final indegree = <String, int>{for (final node in nodes) node.id: 0};

  final layoutEdges = <_LayoutEdge>[];

  for (final edge in cycleResult.acyclicEdges) {
    final source = edge.source;
    final target = edge.target;

    layoutEdges.add(_LayoutEdge(source: source, target: target));

    children[source]?.add(target);
    parents[target]?.add(source);

    indegree[target] = (indegree[target] ?? 0) + 1;
  }

  return _GraphModel(
    nodes: layoutNodes,
    edges: layoutEdges,
    parents: parents,
    children: children,
    indegree: indegree,
    cyclesBrokenCount: cycleResult.removedEdges.length,
  );
}

/// ============================================================================
/// REMOÇÃO AUTOMÁTICA DE CICLOS
/// ============================================================================
///
/// DFS iterativo (sem recursão, para não estourar a pilha em grafos
/// grandes/profundos) com coloração clássica de três cores:
///
///   - branco: ainda não visitado
///   - cinza:  em andamento (é um ancestral do nó atual na busca)
///   - preto:  totalmente processado
///
/// Uma aresta que aponta para um nó cinza é uma "back edge": ela fecha um
/// ciclo. Essas arestas são removidas do resultado. Todas as outras
/// (arestas de árvore, forward e cross) são mantidas, garantindo que o
/// grafo resultante seja sempre um DAG.
///

class _CycleBreakResult {
  final List<_InputEdge> acyclicEdges;
  final List<_InputEdge> removedEdges;

  const _CycleBreakResult({
    required this.acyclicEdges,
    required this.removedEdges,
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

  for (final edge in edges) {
    adjacency[edge.source]?.add(edge);
  }

  final color = <String, int>{for (final id in nodeIds) id: _dfsWhite};

  final acyclicEdges = <_InputEdge>[];
  final removedEdges = <_InputEdge>[];

  for (final startId in nodeIds) {
    if (color[startId] != _dfsWhite) {
      continue;
    }

    // Pilha explícita: cada frame guarda o nó atual e até onde já
    // percorremos a lista de vizinhos dele.
    final nodeStack = <String>[startId];
    final edgeIndexStack = <int>[0];

    color[startId] = _dfsGray;

    while (nodeStack.isNotEmpty) {
      final currentId = nodeStack.last;
      final neighbors = adjacency[currentId] ?? const [];
      final edgeIndex = edgeIndexStack.last;

      if (edgeIndex >= neighbors.length) {
        // Todos os vizinhos foram explorados: finaliza o nó.
        color[currentId] = _dfsBlack;

        nodeStack.removeLast();
        edgeIndexStack.removeLast();

        continue;
      }

      // Avança o ponteiro deste frame antes de processar a aresta, para
      // que, ao voltarmos a este nó, continuemos do próximo vizinho.
      edgeIndexStack[edgeIndexStack.length - 1] = edgeIndex + 1;

      final edge = neighbors[edgeIndex];
      final targetColor = color[edge.target] ?? _dfsBlack;

      if (targetColor == _dfsGray) {
        // Back edge: o alvo é um ancestral do nó atual -> fecha um ciclo.
        removedEdges.add(edge);
        continue;
      }

      acyclicEdges.add(edge);

      if (targetColor == _dfsWhite) {
        color[edge.target] = _dfsGray;

        nodeStack.add(edge.target);
        edgeIndexStack.add(0);
      }

      // Se o alvo já está preto (forward/cross edge), a aresta é mantida
      // sem empilhar nada: ela não pode fechar um ciclo.
    }
  }

  return _CycleBreakResult(
    acyclicEdges: acyclicEdges,
    removedEdges: removedEdges,
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
/// Como `_buildGraph` já garante que o grafo é acíclico, o ordenamento
/// topológico abaixo sempre termina processando todos os nós. Ainda assim,
/// mantemos uma rede de segurança: se, por algum motivo inesperado, algum
/// nó ficar sem processar, ele recebe uma camada de fallback em vez de
/// lançar uma exceção.
///

Map<String, int> _assignLayers({required _GraphModel graph}) {
  final indegree = <String, int>{...graph.indegree};

  final layers = <String, int>{
    for (final nodeId in graph.nodes.keys) nodeId: 0,
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

    final currentLayer = layers[current] ?? 0;

    for (final child in graph.children[current] ?? const []) {
      layers[child] = math.max(layers[child] ?? 0, currentLayer + 1);

      indegree[child] = (indegree[child] ?? 0) - 1;

      if (indegree[child] == 0) {
        queue.add(child);
      }
    }
  }

  // --------------------------------------------------------------------------
  // Rede de segurança: isso não deveria mais acontecer, já que o grafo
  // chega aqui sem ciclos. Mas se algo inesperado deixar nós sem
  // processar, não travamos o layout — atribuímos uma camada de fallback
  // (logo após a maior camada já calculada) e seguimos em frente.
  // --------------------------------------------------------------------------

  if (processed != graph.nodes.length) {
    final unprocessed = indegree.entries
        .where((entry) => entry.value > 0)
        .map((entry) => entry.key)
        .toList();

    debugPrint(
      'Sugiyama: ${unprocessed.length} nó(s) não foram processados pela '
      'ordenação topológica (ciclo residual inesperado). Usando camada '
      'de fallback para: $unprocessed',
    );

    final fallbackLayer =
        (layers.values.isEmpty ? 0 : layers.values.reduce(math.max)) + 1;

    for (final nodeId in unprocessed) {
      layers[nodeId] = fallbackLayer;
    }
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
  final expandedNodes = <String, _LayoutNode>{...graph.nodes};

  final expandedEdges = <_LayoutEdge>[];

  final expandedLayers = <String, int>{...layers};

  var dummyCounter = 0;

  for (final edge in graph.edges) {
    final sourceLayer = layers[edge.source] ?? 0;
    final targetLayer = layers[edge.target] ?? 0;

    final distance = targetLayer - sourceLayer;

    // ------------------------------------------------------------------------
    // Aresta entre camadas consecutivas (ou, no pior caso de fallback,
    // uma aresta que não avança camadas). Nunca criamos uma cadeia de
    // dummies para uma distância <= 1, então isso é sempre seguro.
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

    for (var layer = sourceLayer + 1; layer < targetLayer; layer++) {
      final dummyId = '__dummy__$dummyCounter';

      dummyCounter++;

      expandedNodes[dummyId] = _LayoutNode(
        id: dummyId,
        isDummy: true,
        realNodeId: null,
      );

      expandedLayers[dummyId] = layer;

      expandedEdges.add(_LayoutEdge(source: previousNode, target: dummyId));

      previousNode = dummyId;
    }

    expandedEdges.add(_LayoutEdge(source: previousNode, target: edge.target));
  }

  final parents = <String, List<String>>{
    for (final nodeId in expandedNodes.keys) nodeId: <String>[],
  };

  final children = <String, List<String>>{
    for (final nodeId in expandedNodes.keys) nodeId: <String>[],
  };

  final indegree = <String, int>{
    for (final nodeId in expandedNodes.keys) nodeId: 0,
  };

  for (final edge in expandedEdges) {
    children[edge.source]?.add(edge.target);
    parents[edge.target]?.add(edge.source);

    indegree[edge.target] = (indegree[edge.target] ?? 0) + 1;
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
    result.putIfAbsent(entry.value, () => <String>[]).add(entry.key);
  }

  for (final layerNodes in result.values) {
    final originalOrder = _positionMap(layerNodes);

    layerNodes.sort((a, b) {
      final xA = previousX[a];
      final xB = previousX[b];

      // --------------------------------------------------------------------
      // Ambos possuem posição anterior.
      // --------------------------------------------------------------------

      if (xA != null && xB != null) {
        final comparison = xA.compareTo(xB);

        if (comparison != 0) {
          return comparison;
        }

        return originalOrder[a]!.compareTo(originalOrder[b]!);
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

/// ============================================================================
/// MINIMIZAÇÃO DE CRUZAMENTOS
/// ============================================================================

_LayerOrderResult _minimizeCrossings({
  required _GraphModel graph,
  required Map<int, List<String>> initialLayers,
  required SugiyamaConfig config,
}) {
  var current = _cloneLayers(initialLayers);

  var currentCrossings = _countAllCrossings(
    graph: graph,
    nodesByLayer: current,
  );

  var best = _cloneLayers(current);

  var bestCrossings = currentCrossings;

  for (
    var iteration = 0;
    iteration < config.crossingIterations;
    iteration++
  ) {
    // ========================================================================
    // Downward sweep
    // ========================================================================

    final downward = _downwardSweep(graph: graph, nodesByLayer: current);

    final downwardCrossings = _countAllCrossings(
      graph: graph,
      nodesByLayer: downward,
    );

    current = downward;
    currentCrossings = downwardCrossings;

    if (currentCrossings < bestCrossings) {
      best = _cloneLayers(current);

      bestCrossings = currentCrossings;
    }

    // ========================================================================
    // Upward sweep
    // ========================================================================

    final upward = _upwardSweep(graph: graph, nodesByLayer: current);

    final upwardCrossings = _countAllCrossings(
      graph: graph,
      nodesByLayer: upward,
    );

    current = upward;
    currentCrossings = upwardCrossings;

    if (currentCrossings < bestCrossings) {
      best = _cloneLayers(current);

      bestCrossings = currentCrossings;
    }

    // ========================================================================
    // Adjacent transpose
    //
    // Tenta trocar pares vizinhos quando isso reduz cruzamentos.
    // ========================================================================

    final transposed = _transposeLayers(
      graph: graph,
      nodesByLayer: current,
      maxIterations: config.transposeIterations,
    );

    final transposedCrossings = _countAllCrossings(
      graph: graph,
      nodesByLayer: transposed,
    );

    current = transposed;
    currentCrossings = transposedCrossings;

    if (currentCrossings < bestCrossings) {
      best = _cloneLayers(current);

      bestCrossings = currentCrossings;
    }

    // ========================================================================
    // Convergência.
    // ========================================================================

    if (bestCrossings == 0) {
      break;
    }
  }

  return _LayerOrderResult(nodesByLayer: best, crossingCount: bestCrossings);
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
  final result = _cloneLayers(nodesByLayer);

  final maxLayer = _maxLayer(result);

  for (var layer = 1; layer <= maxLayer; layer++) {
    final currentLayer = result[layer];

    if (currentLayer == null || currentLayer.length <= 1) {
      continue;
    }

    final upperLayer = result[layer - 1] ?? const [];

    final upperPosition = _positionMap(upperLayer);

    final oldPosition = _positionMap(currentLayer);

    final score = <String, double>{};

    for (final nodeId in currentLayer) {
      score[nodeId] = _barycenter(
        neighbors: graph.parents[nodeId] ?? const [],
        position: upperPosition,
      );
    }

    currentLayer.sort((a, b) {
      final comparison = _compareScores(score[a]!, score[b]!);

      if (comparison != 0) {
        return comparison;
      }

      // Mantém estabilidade.
      return oldPosition[a]!.compareTo(oldPosition[b]!);
    });
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
  final result = _cloneLayers(nodesByLayer);

  final maxLayer = _maxLayer(result);

  for (var layer = maxLayer - 1; layer >= 0; layer--) {
    final currentLayer = result[layer];

    if (currentLayer == null || currentLayer.length <= 1) {
      continue;
    }

    final lowerLayer = result[layer + 1] ?? const [];

    final lowerPosition = _positionMap(lowerLayer);

    final oldPosition = _positionMap(currentLayer);

    final score = <String, double>{};

    for (final nodeId in currentLayer) {
      score[nodeId] = _barycenter(
        neighbors: graph.children[nodeId] ?? const [],
        position: lowerPosition,
      );
    }

    currentLayer.sort((a, b) {
      final comparison = _compareScores(score[a]!, score[b]!);

      if (comparison != 0) {
        return comparison;
      }

      return oldPosition[a]!.compareTo(oldPosition[b]!);
    });
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

  for (final neighbor in neighbors) {
    final index = position[neighbor];

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

int _compareScores(double a, double b) {
  if (a.isInfinite && b.isInfinite) {
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
  final result = _cloneLayers(nodesByLayer);

  if (maxIterations <= 0) {
    return result;
  }

  for (var iteration = 0; iteration < maxIterations; iteration++) {
    var changed = false;

    final maxLayer = _maxLayer(result);

    // ------------------------------------------------------------------------
    // Alternamos a direção para evitar viés.
    // ------------------------------------------------------------------------

    final forward = iteration.isEven;

    final start = forward ? 0 : maxLayer;

    final end = forward ? maxLayer : 0;

    final step = forward ? 1 : -1;

    for (
      var layer = start;
      forward ? layer <= end : layer >= end;
      layer += step
    ) {
      final nodes = result[layer];

      if (nodes == null || nodes.length <= 1) {
        continue;
      }

      var i = forward ? 0 : nodes.length - 2;

      while (forward ? i < nodes.length - 1 : i >= 0) {
        if (i < 0 || i + 1 >= nodes.length) {
          break;
        }

        final before = _localCrossingsForNodeLayer(
          graph: graph,
          nodesByLayer: result,
          layer: layer,
        );

        final temp = nodes[i];

        nodes[i] = nodes[i + 1];
        nodes[i + 1] = temp;

        final after = _localCrossingsForNodeLayer(
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
          final rollback = nodes[i];

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

  final upper = nodesByLayer[layer - 1];

  final current = nodesByLayer[layer];

  final lower = nodesByLayer[layer + 1];

  if (upper != null && current != null) {
    result += _countLayerCrossings(
      graph: graph,
      upperLayer: upper,
      lowerLayer: current,
    );
  }

  if (current != null && lower != null) {
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
/// Depois, a cada iteração (alternando passagem para frente/trás):
///
///     x -> `_computeDesiredX` dos vizinhos (média, no modo `balanced`;
///          ponto médio entre extremos, no modo `centered`)
///
/// Finalmente:
///
///     projeção sobre as restrições de distância mínima, e (opcional)
///     compactação.
///

Map<String, Offset> _assignCoordinates({
  required _GraphModel graph,
  required Map<int, List<String>> nodesByLayer,
  required SugiyamaConfig config,
}) {
  final positions = <String, Offset>{};

  if (nodesByLayer.isEmpty) {
    return positions;
  }

  // ==========================================================================
  // 1. Posição inicial
  // ==========================================================================

  for (final entry in nodesByLayer.entries) {
    final layer = entry.key;

    final nodes = entry.value;

    for (var i = 0; i < nodes.length; i++) {
      positions[nodes[i]] = Offset(
        i * config.horizontalSpacing,
        layer * config.verticalSpacing,
      );
    }
  }

  // ==========================================================================
  // 2. Ajuste iterativo
  // ==========================================================================

  for (
    var iteration = 0;
    iteration < config.coordinateIterations;
    iteration++
  ) {
    final forward = iteration.isEven;

    if (forward) {
      _coordinateForwardPass(
        graph: graph,
        nodesByLayer: nodesByLayer,
        positions: positions,
        mode: config.mode,
      );
    } else {
      _coordinateBackwardPass(
        graph: graph,
        nodesByLayer: nodesByLayer,
        positions: positions,
        mode: config.mode,
      );
    }

    _projectLayerPositions(
      nodesByLayer: nodesByLayer,
      positions: positions,
      minimumGap: config.minimumHorizontalGap,
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
      minimumGap: config.minimumHorizontalGap,
      mode: config.mode,
    );
  }

  // ==========================================================================
  // 4. Garantir coordenadas positivas
  // ==========================================================================

  _normalizeCoordinates(positions);

  return positions;
}

/// ============================================================================
/// PASSAGEM PARA FRENTE
/// ============================================================================
///
/// Aproxima cada nó dos seus pais (já posicionados nas camadas
/// anteriores, processadas antes na mesma varredura).

void _coordinateForwardPass({
  required _GraphModel graph,
  required Map<int, List<String>> nodesByLayer,
  required Map<String, Offset> positions,
  required SugiyamaLayoutMode mode,
}) {
  final maxLayer = _maxLayer(nodesByLayer);

  for (var layer = 1; layer <= maxLayer; layer++) {
    final current = nodesByLayer[layer];

    if (current == null) {
      continue;
    }

    for (final nodeId in current) {
      final neighbors = graph.parents[nodeId] ?? const [];

      final desired = _computeDesiredX(
        neighbors: neighbors,
        positions: positions,
        mode: mode,
      );

      if (desired == null) {
        continue;
      }

      final position = positions[nodeId]!;

      positions[nodeId] = Offset(desired, position.dy);
    }
  }
}

/// ============================================================================
/// PASSAGEM PARA TRÁS
/// ============================================================================
///
/// Aproxima cada nó dos seus filhos (já posicionados nas camadas
/// seguintes, processadas antes nesta varredura de baixo para cima).

void _coordinateBackwardPass({
  required _GraphModel graph,
  required Map<int, List<String>> nodesByLayer,
  required Map<String, Offset> positions,
  required SugiyamaLayoutMode mode,
}) {
  final maxLayer = _maxLayer(nodesByLayer);

  for (var layer = maxLayer - 1; layer >= 0; layer--) {
    final current = nodesByLayer[layer];

    if (current == null) {
      continue;
    }

    for (final nodeId in current) {
      final neighbors = graph.children[nodeId] ?? const [];

      final desired = _computeDesiredX(
        neighbors: neighbors,
        positions: positions,
        mode: mode,
      );

      if (desired == null) {
        continue;
      }

      final position = positions[nodeId]!;

      positions[nodeId] = Offset(desired, position.dy);
    }
  }
}

/// ============================================================================
/// X DESEJADO
/// ============================================================================
///
/// Calcula a posição X que um nó "gostaria" de ter, dada a posição atual
/// de um conjunto de vizinhos (pais, na passagem para frente; filhos, na
/// passagem para trás; pais + filhos, na compactação).
///
///   - `SugiyamaLayoutMode.balanced`: média de todos os vizinhos.
///   - `SugiyamaLayoutMode.centered`: ponto médio entre o vizinho mais à
///     esquerda e o mais à direita — centraliza o nó exatamente sobre o
///     intervalo ocupado pelos vizinhos, como numa árvore genealógica.
///

double? _computeDesiredX({
  required List<String> neighbors,
  required Map<String, Offset> positions,
  required SugiyamaLayoutMode mode,
}) {
  var sum = 0.0;
  var count = 0;

  double? minX;
  double? maxX;

  for (final neighbor in neighbors) {
    final position = positions[neighbor];

    if (position == null) {
      continue;
    }

    sum += position.dx;
    count++;

    minX = (minX == null) ? position.dx : math.min(minX, position.dx);
    maxX = (maxX == null) ? position.dx : math.max(maxX, position.dx);
  }

  if (count == 0) {
    return null;
  }

  if (mode == SugiyamaLayoutMode.centered && minX != null && maxX != null) {
    return (minX + maxX) / 2;
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
/// sem alterar a ordem da camada — e o faz da forma matematicamente ótima:
/// minimizando a soma dos deslocamentos ao quadrado em relação às posições
/// desejadas (as posições que `_computeDesiredX` acabou de calcular).
///
/// Isso importa especialmente no modo `centered`: quando vários irmãos têm
/// o mesmo pai, todos calculam a mesma posição desejada (a do próprio
/// pai). Uma projeção ingênua que só empurra para a direita a partir do
/// nó mais à esquerda deixaria os irmãos "grudados" à esquerda do pai, em
/// vez de centralizados embaixo dele. A projeção abaixo (regressão
/// isotônica via PAVA — Pool Adjacent Violators Algorithm) resolve esse
/// tipo de empate distribuindo os nós SIMETRICAMENTE ao redor da posição
/// desejada compartilhada, ao custo de ocupar um pouco mais de espaço
/// quando necessário.
///

void _projectLayerPositions({
  required Map<int, List<String>> nodesByLayer,
  required Map<String, Offset> positions,
  required double minimumGap,
}) {
  for (final nodes in nodesByLayer.values) {
    if (nodes.length <= 1) {
      continue;
    }

    final desired = <double>[
      for (final nodeId in nodes) positions[nodeId]!.dx,
    ];

    final projected = _isotonicProject(desired, minimumGap);

    for (var i = 0; i < nodes.length; i++) {
      final nodeId = nodes[i];
      final current = positions[nodeId]!;

      positions[nodeId] = Offset(projected[i], current.dy);
    }
  }
}

/// ============================================================================
/// REGRESSÃO ISOTÔNICA (PAVA)
/// ============================================================================
///
/// Dada uma lista de posições desejadas, na ordem em que os nós aparecem
/// na camada, devolve a lista de posições finais que:
///
///   1. respeita a ordem: `x[i + 1] >= x[i] + minimumGap`;
///   2. entre todas as listas que respeitam (1), é a que minimiza a soma
///      dos quadrados dos deslocamentos em relação às posições desejadas.
///
/// Ideia: substituindo `y[i] = desired[i] - i * minimumGap`, a restrição
/// vira simplesmente `y[i + 1] >= y[i]` — uma regressão isotônica comum,
/// resolvida em O(n) com o algoritmo clássico "Pool Adjacent Violators":
/// percorremos os pontos da esquerda para a direita mantendo uma pilha de
/// blocos; sempre que um bloco novo violaria a ordem em relação ao
/// anterior, fundimos os dois na média ponderada, repetindo até a pilha
/// voltar a ficar em ordem. No fim, cada ponto recebe a média do seu
/// bloco — por isso o resultado é sempre simétrico quando várias posições
/// desejadas coincidem (ex.: vários irmãos querendo a posição do pai),
/// em vez de tendencioso para um lado.
///
/// Sempre termina (o laço interno só reduz o tamanho da pilha, nunca
/// aumenta o trabalho total), então não há risco de loop sem fim.
///

List<double> _isotonicProject(
  List<double> desired,
  double minimumGap,
) {
  final n = desired.length;

  if (n == 0) {
    return const [];
  }

  if (n == 1) {
    return [desired[0]];
  }

  final y = <double>[
    for (var i = 0; i < n; i++) desired[i] - i * minimumGap,
  ];

  // Pilha de blocos: para cada bloco guardamos a soma dos valores, o
  // peso (quantidade de pontos) e o tamanho (quantos índices ele cobre).
  final blockSum = <double>[];
  final blockWeight = <int>[];
  final blockSize = <int>[];

  for (var i = 0; i < n; i++) {
    blockSum.add(y[i]);
    blockWeight.add(1);
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
    final size = blockSize[block];

    for (var k = 0; k < size; k++) {
      result[index] = average + index * minimumGap;
      index++;
    }
  }

  return result;
}

/// ============================================================================
/// COMPACTAÇÃO
/// ============================================================================
///
/// Remove espaço horizontal desnecessário sem destruir a ordem.
///
/// O algoritmo encontra o menor deslocamento global possível para cada
/// camada enquanto respeita as restrições dos vizinhos (usando a mesma
/// lógica de `_computeDesiredX`, para ficar consistente com o modo
/// escolhido).
///

void _compactGraph({
  required _GraphModel graph,
  required Map<int, List<String>> nodesByLayer,
  required Map<String, Offset> positions,
  required double minimumGap,
  required SugiyamaLayoutMode mode,
}) {
  final maxLayer = _maxLayer(nodesByLayer);

  for (var layer = 0; layer <= maxLayer; layer++) {
    final current = nodesByLayer[layer];

    if (current == null || current.isEmpty) {
      continue;
    }

    // ------------------------------------------------------------------------
    // Deslocamento médio recomendado pelos vizinhos.
    // ------------------------------------------------------------------------

    var totalDesiredShift = 0.0;
    var desiredCount = 0;

    for (final nodeId in current) {
      final nodePosition = positions[nodeId]!;

      final neighbors = <String>[
        ...graph.parents[nodeId] ?? const [],
        ...graph.children[nodeId] ?? const [],
      ];

      if (neighbors.isEmpty) {
        continue;
      }

      final desiredX = _computeDesiredX(
        neighbors: neighbors,
        positions: positions,
        mode: mode,
      );

      if (desiredX == null) {
        continue;
      }

      totalDesiredShift += desiredX - nodePosition.dx;

      desiredCount++;
    }

    if (desiredCount == 0) {
      continue;
    }

    final shift = totalDesiredShift / desiredCount;

    // Limita a compactação para não destruir uma estrutura boa.
    final clampedShift = shift.clamp(-minimumGap, minimumGap);

    for (final nodeId in current) {
      final position = positions[nodeId]!;

      positions[nodeId] = Offset(position.dx + clampedShift, position.dy);
    }

    _projectLayerPositions(
      nodesByLayer: nodesByLayer,
      positions: positions,
      minimumGap: minimumGap,
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

  final maxLayer = _maxLayer(nodesByLayer);

  for (var layer = 0; layer < maxLayer; layer++) {
    total += _countLayerCrossings(
      graph: graph,
      upperLayer: nodesByLayer[layer] ?? const [],
      lowerLayer: nodesByLayer[layer + 1] ?? const [],
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
  if (upperLayer.isEmpty || lowerLayer.isEmpty) {
    return 0;
  }

  final upperPosition = _positionMap(upperLayer);

  final lowerPosition = _positionMap(lowerLayer);

  final segmentsByUpper = <int, List<int>>{};

  for (final source in upperLayer) {
    final sourcePosition = upperPosition[source]!;

    final children = graph.children[source] ?? const [];

    for (final target in children) {
      final targetPosition = lowerPosition[target];

      if (targetPosition == null) {
        continue;
      }

      segmentsByUpper
          .putIfAbsent(sourcePosition, () => <int>[])
          .add(targetPosition);
    }
  }

  if (segmentsByUpper.isEmpty) {
    return 0;
  }

  final fenwick = _FenwickTree(lowerLayer.length);

  var seen = 0;
  var crossings = 0;

  final upperPositions = segmentsByUpper.keys.toList()..sort();

  for (final upperPositionValue in upperPositions) {
    final targets = segmentsByUpper[upperPositionValue]!;

    // Primeiro consulta todas.
    // Depois adiciona todas.
    //
    // Assim, arestas que partem do mesmo nó nunca contam
    // como cruzamento entre si.
    for (final targetPosition in targets) {
      final before = fenwick.query(targetPosition);

      crossings += seen - before;
    }

    for (final targetPosition in targets) {
      fenwick.add(targetPosition, 1);

      seen++;
    }
  }

  return crossings;
}

/// ============================================================================
/// UTILITÁRIOS
/// ============================================================================

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

/// ============================================================================
/// NORMALIZAÇÃO
/// ============================================================================

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

  final shiftX = minimumX.isFinite && minimumX < 0 ? -minimumX : 0.0;

  final shiftY = minimumY.isFinite && minimumY < 0 ? -minimumY : 0.0;

  if (shiftX == 0 && shiftY == 0) {
    return;
  }

  for (final nodeId in positions.keys.toList()) {
    final position = positions[nodeId]!;

    positions[nodeId] = Offset(position.dx + shiftX, position.dy + shiftY);
  }
}