import 'dart:collection';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:noema/core/database/database_provider.dart';
import 'package:noema/feature/graph/data/graph_node_dao.dart';
import 'package:noema/feature/graph/provider/graph_provider.dart';

// OBS.: Gerei com IA
//
// OBS. 2: Revisado para nunca lançar exceções durante o auto-layout e para
// preservar uma hierarquia visual clara.
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
//   - O posicionamento horizontal segue uma floresta de hierarquias: cada nó
//     recebe um pai principal, seus filhos ocupam posições contíguas e o pai
//     fica no ponto médio entre o primeiro e o último filho. Relações extras
//     de um DAG continuam presentes no grafo, mas não conseguem desfazer essa
//     estrutura visual.

/// ============================================================================
/// CONFIGURAÇÃO
/// ============================================================================

enum SugiyamaOrientation { topToBottom, bottomToTop }

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

  /// Direção principal do grafo. Por padrão, as raízes ficam no topo.
  final SugiyamaOrientation orientation;

  const SugiyamaConfig({
    this.horizontalSpacing = 260.0,
    this.verticalSpacing = 220.0,
    this.minimumHorizontalGap = 250.0,
    this.crossingIterations = 12,
    this.transposeIterations = 4,
    this.coordinateIterations = 6,
    this.preservePreviousOrder = true,
    this.compact = true,
    this.mode = SugiyamaLayoutMode.balanced,
    this.orientation = SugiyamaOrientation.topToBottom,
  });
}

/// Uma relação dirigida do pai para o filho usada pelo cálculo puro do layout.
class SugiyamaLayoutEdge {
  final String sourceNodeId;
  final String targetNodeId;

  const SugiyamaLayoutEdge({
    required this.sourceNodeId,
    required this.targetNodeId,
  });
}

/// Resultado do cálculo puro do layout, sem leitura ou escrita no banco.
class SugiyamaComputedLayout {
  final Map<String, Offset> positions;
  final Map<String, int> layers;
  final int cyclesBrokenCount;

  const SugiyamaComputedLayout({
    required this.positions,
    required this.layers,
    required this.cyclesBrokenCount,
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

class _TreeTraversalFrame {
  final String nodeId;
  final bool childrenPositioned;

  const _TreeTraversalFrame({
    required this.nodeId,
    required this.childrenPositioned,
  });
}

class _LayoutNode {
  final String id;

  const _LayoutNode({required this.id});
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

      if (x.isFinite) {
        previousX[node.id] = x;
      }
    }
  }

  // --------------------------------------------------------------------------
  // Converte as arestas do banco para o modelo interno.
  // --------------------------------------------------------------------------

  final inputEdges = <SugiyamaLayoutEdge>[
    for (final edge in edges)
      SugiyamaLayoutEdge(
        sourceNodeId: edge.type == 'SUBTOPIC'
            ? edge.targetNodeId
            : edge.sourceNodeId,
        targetNodeId: edge.type == 'SUBTOPIC'
            ? edge.sourceNodeId
            : edge.targetNodeId,
      ),
  ];

  // --------------------------------------------------------------------------
  // Executa o algoritmo puro.
  // --------------------------------------------------------------------------

  final result = computeSugiyamaLayout(
    nodeIds: nodes.map((node) => node.id),
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
    horizontalSpacing: safeSpacing(config.horizontalSpacing, 260.0),
    verticalSpacing: safeSpacing(config.verticalSpacing, 220.0),
    minimumHorizontalGap: safeSpacing(config.minimumHorizontalGap, 250.0),
    crossingIterations: safeIterations(config.crossingIterations),
    transposeIterations: safeIterations(config.transposeIterations),
    coordinateIterations: safeIterations(config.coordinateIterations),
    preservePreviousOrder: config.preservePreviousOrder,
    compact: config.compact,
    mode: config.mode,
    orientation: config.orientation,
  );
}

/// Produz uma disposição de árvore dentro das camadas já calculadas.
///
/// Em um DAG um nó pode ter mais de um pai, mas não há como deixá-lo
/// centralizado abaixo de todos eles ao mesmo tempo. Para preservar a leitura
/// hierárquica, escolhemos como pai principal o pai na camada mais próxima e
/// usamos as demais arestas apenas como relações adicionais. Isso mantém uma
/// árvore visual estável, sem alterar as relações persistidas no grafo.
Map<String, Offset> _buildHierarchicalPositions({
  required List<String> nodeIds,
  required _GraphModel graph,
  required Map<String, int> layers,
  required Map<String, double> previousX,
  required SugiyamaConfig config,
}) {
  if (nodeIds.isEmpty) return const {};
  final nodeOrder = <String, int>{
    for (var index = 0; index < nodeIds.length; index++) nodeIds[index]: index,
  };

  // Ambos os limites fazem parte do contrato de configuração. Usar o maior
  // deles garante que irmãos e subárvores nunca se sobreponham.
  final horizontalGap = math.max(
    config.horizontalSpacing,
    config.minimumHorizontalGap,
  );

  double stableX(String nodeId) {
    return previousX[nodeId] ?? (nodeOrder[nodeId] ?? 0) * horizontalGap;
  }

  int compareStableOrder(String left, String right) {
    final comparison = stableX(left).compareTo(stableX(right));
    if (comparison != 0) return comparison;

    final originalOrder = (nodeOrder[left] ?? 0).compareTo(
      nodeOrder[right] ?? 0,
    );
    if (originalOrder != 0) return originalOrder;

    return left.compareTo(right);
  }

  // Uma relação secundária pode vir de uma camada bem acima. Escolher o pai
  // mais profundo possível mantém o filho o mais próximo possível de seu pai
  // visual e deixa a geração principal diretamente abaixo dele quando o DAG
  // representa uma árvore comum.
  final primaryParentByNode = <String, String>{};
  for (final nodeId in nodeIds) {
    final nodeLayer = layers[nodeId] ?? 0;
    final candidates = <String>[
      for (final parentId in graph.parents[nodeId] ?? const <String>[])
        if ((layers[parentId] ?? nodeLayer) < nodeLayer) parentId,
    ];
    if (candidates.isEmpty) continue;

    candidates.sort((left, right) {
      final byLayer = (layers[right] ?? 0).compareTo(layers[left] ?? 0);
      return byLayer != 0 ? byLayer : compareStableOrder(left, right);
    });
    primaryParentByNode[nodeId] = candidates.first;
  }

  final primaryChildrenByNode = <String, List<String>>{
    for (final nodeId in nodeIds) nodeId: <String>[],
  };
  for (final entry in primaryParentByNode.entries) {
    primaryChildrenByNode[entry.value]!.add(entry.key);
  }
  for (final children in primaryChildrenByNode.values) {
    children.sort(compareStableOrder);
  }

  final rootIds = <String>[
    for (final nodeId in nodeIds)
      if (!primaryParentByNode.containsKey(nodeId)) nodeId,
  ]..sort(compareStableOrder);

  final xByNode = <String, double>{};
  var nextLeafX = 0.0;

  void positionSubtree(String rootId) {
    final stack = <_TreeTraversalFrame>[
      _TreeTraversalFrame(nodeId: rootId, childrenPositioned: false),
    ];

    while (stack.isNotEmpty) {
      final frame = stack.removeLast();
      final nodeId = frame.nodeId;
      final children = primaryChildrenByNode[nodeId] ?? const <String>[];

      if (!frame.childrenPositioned) {
        stack.add(
          _TreeTraversalFrame(nodeId: nodeId, childrenPositioned: true),
        );
        for (var index = children.length - 1; index >= 0; index--) {
          stack.add(
            _TreeTraversalFrame(
              nodeId: children[index],
              childrenPositioned: false,
            ),
          );
        }
        continue;
      }

      if (children.isEmpty) {
        xByNode[nodeId] = nextLeafX;
        nextLeafX += horizontalGap;
        continue;
      }

      // Os filhos são contíguos porque cada subárvore recebe folhas em uma
      // faixa exclusiva. Logo, este ponto médio mantém o pai centralizado no
      // conjunto dos filhos sem violar a distância mínima em nenhuma camada.
      xByNode[nodeId] =
          (xByNode[children.first]! + xByNode[children.last]!) / 2;
    }
  }

  for (final rootId in rootIds) {
    positionSubtree(rootId);
  }

  // A seleção do pai principal forma uma floresta em um DAG. Este fallback
  // protege o layout caso uma entrada inesperada viole essa premissa.
  for (final nodeId in nodeIds) {
    if (!xByNode.containsKey(nodeId)) positionSubtree(nodeId);
  }

  return <String, Offset>{
    for (final nodeId in nodeIds)
      nodeId: Offset(
        xByNode[nodeId] ?? 0,
        (layers[nodeId] ?? 0) * config.verticalSpacing,
      ),
  };
}

/// ============================================================================
/// PIPELINE
/// ============================================================================

SugiyamaComputedLayout computeSugiyamaLayout({
  required Iterable<String> nodeIds,
  required Iterable<SugiyamaLayoutEdge> edges,
  required Map<String, double> previousX,
  SugiyamaConfig config = const SugiyamaConfig(),
}) {
  final safeConfig = _sanitizeConfig(config);
  final orderedNodeIds = <String>{...nodeIds}.toList();

  // ==========================================================================
  // 1. Construir o grafo (já livre de ciclos, ver `_buildGraph`)
  // ==========================================================================

  final graph = _buildGraph(
    nodeIds: orderedNodeIds,
    edges: [
      for (final edge in edges)
        _InputEdge(source: edge.sourceNodeId, target: edge.targetNodeId),
    ],
  );

  // ==========================================================================
  // 2. Atribuir camadas
  // ==========================================================================

  final layers = _assignLayers(graph: graph);

  // ==========================================================================
  // 3. Coordenadas hierárquicas tipo árvore
  // ==========================================================================

  final calculatedPositions = _buildHierarchicalPositions(
    nodeIds: orderedNodeIds,
    graph: graph,
    layers: layers,
    previousX: previousX,
    config: safeConfig,
  );

  final maxY = calculatedPositions.values.isEmpty
      ? 0.0
      : calculatedPositions.values
            .map((position) => position.dy)
            .reduce(math.max);

  final positions = <String, Offset>{};
  for (final entry in calculatedPositions.entries) {
    final base = entry.value;
    positions[entry.key] = switch (safeConfig.orientation) {
      SugiyamaOrientation.topToBottom => base,
      SugiyamaOrientation.bottomToTop => Offset(base.dx, maxY - base.dy),
    };
  }

  return SugiyamaComputedLayout(
    positions: positions,
    layers: layers,
    cyclesBrokenCount: graph.cyclesBrokenCount,
  );
}

/// ============================================================================
/// CONSTRUIR GRAFO
/// ============================================================================

_GraphModel _buildGraph({
  required List<String> nodeIds,
  required List<_InputEdge> edges,
}) {
  final layoutNodes = <String, _LayoutNode>{
    for (final nodeId in nodeIds) nodeId: _LayoutNode(id: nodeId),
  };

  final knownNodeIds = layoutNodes.keys.toSet();

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

    if (!knownNodeIds.contains(source) || !knownNodeIds.contains(target)) {
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

  final cycleResult = _breakCycles(
    nodeIds: knownNodeIds,
    edges: candidateEdges,
  );

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
    for (final nodeId in layoutNodes.keys) nodeId: <String>[],
  };

  final children = <String, List<String>>{
    for (final nodeId in layoutNodes.keys) nodeId: <String>[],
  };

  final indegree = <String, int>{
    for (final nodeId in layoutNodes.keys) nodeId: 0,
  };

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
