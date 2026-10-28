import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noema/core/database/database.dart';
import 'package:noema/core/database/database_provider.dart';
import 'package:noema/core/design/theme/theme_tokens.dart';
import 'package:noema/feature/graph/data/graph_edge_dao.dart';
import 'package:noema/feature/graph/data/graph_node_dao.dart';
import 'package:noema/feature/graph/provider/edge_type_provider.dart';
import 'package:noema/feature/graph/provider/graph_provider.dart';
import 'package:noema/feature/graph/provider/graph_states_provider.dart';
import 'package:noema/feature/graph/provider/selected_provider.dart';
import 'package:noema/feature/graph/provider/transformation_controller_provider.dart';
import 'package:noema/feature/graph/service/calculate_paths.dart';
import 'package:noema/feature/graph/service/gesture_actions.dart';
import 'package:noema/feature/graph/service/sugiyama.dart';
import 'package:noema/feature/graph/widgets/graph.dart';
import 'package:noema/feature/graph/widgets/graph_utils_layer.dart';
import 'package:noema/feature/graph/widgets/node_details.dart';

class GraphPage extends ConsumerStatefulWidget {
  const GraphPage({super.key, required this.graphId});

  final String graphId;

  @override
  ConsumerState<GraphPage> createState() => _GraphPageState();
}

class _GraphPageState extends ConsumerState<GraphPage> {
  bool _initialFitScheduled = false;
  bool _isOrganizing = false;
  String? _edgeSourceNodeId;
  String? _edgeTargetNodeId;
  String? _edgePickEndpoint;
  Size _lastViewport = Size.zero;
  final ScrollController _toolbarScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(selectedProvider.notifier).clear();
      ref.read(graphStatesProvider.notifier).closeDialogs();
      ref.read(transformationControllerProvider).value = Matrix4.identity();
    });
  }

  @override
  void dispose() {
    _toolbarScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final nodesAsync = ref.watch(nodesProvider(widget.graphId));
    final edgesAsync = ref.watch(edgesProvider(widget.graphId));
    final graphsAsync = ref.watch(knowledgeGraphsProvider);
    final selected = ref.watch(selectedProvider);
    final selectedNotifier = ref.watch(selectedProvider.notifier);
    final edgeType = ref.watch(edgeTypeProvider);
    final graphStates = ref.watch(graphStatesProvider);
    final controller = ref.watch(transformationControllerProvider);
    final controllerNotifier = ref.watch(
      transformationControllerProvider.notifier,
    );

    final graphs = graphsAsync is AsyncData<List<KnowledgeGraphData>>
        ? graphsAsync.value
        : const <KnowledgeGraphData>[];
    KnowledgeGraphData? graph;
    for (final item in graphs) {
      if (item.id == widget.graphId) {
        graph = item;
        break;
      }
    }

    return nodesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => _GraphLoadError(error: error),
      data: (nodes) => edgesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => _GraphLoadError(error: error),
        data: (edges) => _buildGraph(
          context,
          graph: graph,
          nodes: nodes,
          edges: edges,
          selected: selected,
          selectedNotifier: selectedNotifier,
          isCreatingEdge: graphStates.isCreatingEdge,
          edgeType: edgeType,
          controller: controller,
          controllerNotifier: controllerNotifier,
        ),
      ),
    );
  }

  Widget _buildGraph(
    BuildContext context, {
    required KnowledgeGraphData? graph,
    required List<GraphNodeData> nodes,
    required List<GraphEdgeData> edges,
    required String selected,
    required SelectedNotifier selectedNotifier,
    required bool isCreatingEdge,
    required int edgeType,
    required TransformationController controller,
    required TransformationControllerNotifier controllerNotifier,
  }) {
    final nodesById = {for (final node in nodes) node.id: node};
    final edgesById = {for (final edge in edges) edge.id: edge};
    final selectedNode = nodesById[selected];
    final selectedEdge = edgesById[selected];

    return Padding(
      padding: EdgeInsets.fromLTRB(
        context.spacing.sm,
        context.spacing.xs,
        context.spacing.sm,
        context.spacing.xs,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _GraphHeader(
            title: graph?.title ?? 'Grafo de conhecimento',
            description: graph?.description,
            nodeCount: nodes.length,
            edgeCount: edges.length,
          ),
          const SizedBox(height: 4),
          Scrollbar(
            controller: _toolbarScrollController,
            thumbVisibility: true,
            thickness: 3,
            child: SingleChildScrollView(
              controller: _toolbarScrollController,
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  GraphUtilsLayer(
                    onOrganize: () async {
                      await _organizeGraph();
                    },
                    onCreateNode: _toggleNodeCreation,
                    onCreateEdge: _toggleEdgeCreation,
                    canOrganize: nodes.isNotEmpty,
                    isOrganizing: _isOrganizing,
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    tooltip: 'Buscar conceito',
                    onPressed: nodes.isEmpty
                        ? null
                        : () => _showNodeSearch(context, nodes),
                    icon: const Icon(Icons.search_rounded),
                    visualDensity: VisualDensity.compact,
                  ),
                  PopupMenuButton<int>(
                    tooltip: 'Estilo das relações',
                    initialValue: edgeType,
                    onSelected: ref
                        .read(edgeTypeProvider.notifier)
                        .edgeTypeChanged,
                    itemBuilder: (context) => const [
                      PopupMenuItem(value: 0, child: Text('Relações curvas')),
                      PopupMenuItem(value: 1, child: Text('Relações diretas')),
                      PopupMenuItem(value: 2, child: Text('Ângulos retos')),
                      PopupMenuItem(value: 3, child: Text('Um vértice')),
                    ],
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Icon(
                        Icons.route_outlined,
                        color: context.colors.onSurfaceVariant,
                        size: 22,
                      ),
                    ),
                  ),
                  AnimatedBuilder(
                    animation: controller,
                    builder: (context, _) => _CanvasControls(
                      scale: controller.value.getMaxScaleOnAxis(),
                      onZoomIn: () => _zoomAtCenter(
                        controller,
                        controllerNotifier,
                        _lastViewport,
                        1.25,
                      ),
                      onZoomOut: () => _zoomAtCenter(
                        controller,
                        controllerNotifier,
                        _lastViewport,
                        0.8,
                      ),
                      onFit: () => _fitGraph(
                        nodes,
                        _currentOrigin(nodes),
                        _lastViewport,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (selectedEdge != null) ...[
            const SizedBox(height: 4),
            _EdgeInfoCard(
              edge: selectedEdge,
              nodesById: nodesById,
              onClose: selectedNotifier.clear,
            ),
          ],
          const SizedBox(height: 4),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final showDockedDetails =
                    selectedNode != null && constraints.maxWidth >= 900;
                final detailsWidth = showDockedDetails
                    ? math.min(360.0, constraints.maxWidth * 0.34)
                    : 0.0;
                final viewport = Size(
                  constraints.maxWidth -
                      detailsWidth -
                      (showDockedDetails ? 8 : 0),
                  constraints.maxHeight,
                );
                _lastViewport = viewport;
                const nodeWidth = 200.0;
                const nodeHeight = 80.0;
                const canvasPadding = 120.0;

                var minX = double.infinity;
                var maxX = double.negativeInfinity;
                var minY = double.infinity;
                var maxY = double.negativeInfinity;
                for (final node in nodes) {
                  if (!node.positionX.isFinite || !node.positionY.isFinite) {
                    continue;
                  }
                  minX = math.min(minX, node.positionX);
                  maxX = math.max(maxX, node.positionX);
                  minY = math.min(minY, node.positionY);
                  maxY = math.max(maxY, node.positionY);
                }

                final hasFiniteBounds =
                    minX.isFinite &&
                    maxX.isFinite &&
                    minY.isFinite &&
                    maxY.isFinite;
                final origin = hasFiniteBounds
                    ? Offset(canvasPadding - minX, canvasPadding - minY)
                    : const Offset(canvasPadding, canvasPadding);
                final graphWidth = math.max(
                  600.0,
                  hasFiniteBounds
                      ? maxX - minX + nodeWidth + canvasPadding * 2
                      : canvasPadding * 2 + nodeWidth,
                );
                final graphHeight = math.max(
                  400.0,
                  hasFiniteBounds
                      ? maxY - minY + nodeHeight + canvasPadding * 2
                      : canvasPadding * 2 + nodeHeight,
                );

                if (!_initialFitScheduled && nodes.isNotEmpty) {
                  _initialFitScheduled = true;
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted) _fitGraph(nodes, origin, viewport);
                  });
                }

                final paths = calculatePaths(nodes, edges, edgeType);
                final canvas = ClipRRect(
                  borderRadius: BorderRadius.circular(context.radius.card),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      ColoredBox(
                        color: context.colors.surfaceContainerLowest,
                        child: InteractiveViewer(
                          boundaryMargin: const EdgeInsets.all(500),
                          transformationController: controller,
                          constrained: false,
                          minScale: 0.1,
                          maxScale: 4,
                          child: SizedBox(
                            width: graphWidth,
                            height: graphHeight,
                            child: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTapUp: (details) {
                                final result = getTapTarget(
                                  details.localPosition - origin,
                                  nodes,
                                  paths,
                                  context,
                                );
                                if (isCreatingEdge) {
                                  if (!result.$3 || !result.$2) {
                                    _showMessage(
                                      'Toque em um nó para selecioná-lo como '
                                      '${_edgePickEndpoint == 'source' ? 'origem' : 'destino'}.',
                                    );
                                    return;
                                  }
                                  final node = nodesById[result.$1];
                                  if (node != null) {
                                    _handleEdgeNodeTap(node, selectedNotifier);
                                  }
                                  return;
                                }
                                if (!result.$3) {
                                  selectedNotifier.clear();
                                  return;
                                }
                                if (result.$2) {
                                  final node = nodesById[result.$1];
                                  if (node != null) {
                                    final selectionViewport =
                                        constraints.maxWidth >= 900
                                        ? Size(
                                            constraints.maxWidth -
                                                math.min(
                                                  360.0,
                                                  constraints.maxWidth * 0.34,
                                                ) -
                                                8,
                                            constraints.maxHeight,
                                          )
                                        : viewport;
                                    _selectNode(
                                      context,
                                      node,
                                      origin,
                                      selectionViewport,
                                      controllerNotifier,
                                      selectedNotifier,
                                      showSheet: constraints.maxWidth < 900,
                                    );
                                  }
                                } else {
                                  selectedNotifier.selectedChanged(result.$1);
                                }
                              },
                              child: CustomPaint(
                                painter: GraphPainter(
                                  context: context,
                                  nodes: nodes,
                                  edges: edges,
                                  selected: selected,
                                  option: edgeType,
                                  origin: origin,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (nodes.isEmpty && !isCreatingEdge)
                        _EmptyGraphState(onEdit: _toggleNodeCreation),
                      if (isCreatingEdge)
                        Positioned(
                          top: 12,
                          left: 12,
                          right: 12,
                          child: _CanvasCreationPrompt(
                            message: _edgePickEndpoint == 'source'
                                ? 'Toque no nó que será a origem da relação.'
                                : 'Toque no nó que será o destino da relação.',
                            onCancel: _cancelCreation,
                          ),
                        ),
                    ],
                  ),
                );
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(child: canvas),
                    if (showDockedDetails) ...[
                      const SizedBox(width: 8),
                      SizedBox(
                        width: detailsWidth,
                        child: NodeDetails(
                          key: ValueKey(selectedNode.id),
                          node: selectedNode,
                          onClose: selectedNotifier.clear,
                        ),
                      ),
                    ],
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Offset _currentOrigin(List<GraphNodeData> nodes) {
    final bounds = _nodeBounds(nodes);
    if (bounds == null) return const Offset(120, 120);
    return Offset(120 - bounds.left, 120 - bounds.top);
  }

  Future<bool> _organizeGraph({bool showSuccess = true}) async {
    if (_isOrganizing) return false;
    setState(() => _isOrganizing = true);
    try {
      final result = await sugiyama(
        widget.graphId,
        ref,
        config: const SugiyamaConfig(mode: SugiyamaLayoutMode.centered),
      );
      if (!mounted) return false;
      ref.invalidate(nodesProvider(widget.graphId));
      final nodes = await ref.read(nodesProvider(widget.graphId).future);
      if (!mounted) return false;
      if (nodes.isNotEmpty) {
        final bounds = _nodeBounds(nodes);
        if (bounds != null) {
          final origin = Offset(120 - bounds.left, 120 - bounds.top);
          _fitGraph(nodes, origin, _lastViewport);
        }
      }
      if (result.nodesFailed > 0) {
        if (showSuccess) {
          _showMessage(
            'O grafo foi organizado, mas ${result.nodesFailed} posição(ões) '
            'não puderam ser salvas.',
          );
        }
        return false;
      } else {
        if (showSuccess) _showMessage('Grafo organizado.');
        return true;
      }
    } catch (error) {
      if (mounted) _showMessage('Não foi possível organizar o grafo: $error');
      return false;
    } finally {
      if (mounted) setState(() => _isOrganizing = false);
    }
  }

  Rect? _nodeBounds(List<GraphNodeData> nodes) {
    final validNodes = nodes
        .where((node) => node.positionX.isFinite && node.positionY.isFinite)
        .toList();
    if (validNodes.isEmpty) return null;
    final xs = validNodes.map((node) => node.positionX);
    final ys = validNodes.map((node) => node.positionY);
    return Rect.fromLTRB(
      xs.reduce(math.min),
      ys.reduce(math.min),
      xs.reduce(math.max),
      ys.reduce(math.max),
    );
  }

  void _fitGraph(List<GraphNodeData> nodes, Offset origin, Size viewport) {
    final bounds = _nodeBounds(nodes);
    if (bounds == null || viewport.width <= 0 || viewport.height <= 0) return;

    const nodeWidth = 200.0;
    const nodeHeight = 80.0;
    const viewportPadding = 72.0;
    final contentWidth = bounds.width + nodeWidth;
    final contentHeight = bounds.height + nodeHeight;
    final scale = math
        .min(
          (viewport.width - viewportPadding) / contentWidth,
          (viewport.height - viewportPadding) / contentHeight,
        )
        .clamp(0.1, 1.25);
    final sceneCenter = bounds.center + origin;
    ref
        .read(transformationControllerProvider.notifier)
        .goToPoint(sceneCenter, scale, viewport);
  }

  void _zoomAtCenter(
    TransformationController controller,
    TransformationControllerNotifier notifier,
    Size viewport,
    double multiplier,
  ) {
    final center = viewport.center(Offset.zero);
    final sceneCenter = controller.toScene(center);
    final scale = (controller.value.getMaxScaleOnAxis() * multiplier).clamp(
      0.1,
      4.0,
    );
    notifier.goToPoint(sceneCenter, scale, viewport);
  }

  void _toggleNodeCreation() {
    _cancelCreation();
    ref.read(selectedProvider.notifier).clear();
    _showCreateNodeDialog(context);
  }

  void _toggleEdgeCreation() {
    _cancelCreation();
    ref.read(selectedProvider.notifier).clear();
    _showCreateEdgeDialog();
  }

  void _cancelCreation() {
    setState(() {
      _edgeSourceNodeId = null;
      _edgeTargetNodeId = null;
      _edgePickEndpoint = null;
    });
    ref.read(graphStatesProvider.notifier).isEditingChanged(true);
    ref.read(selectedProvider.notifier).clear();
  }

  Future<void> _showCreateNodeDialog(BuildContext context) async {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    var nodeType = 'CONCEPT';
    var isSaving = false;
    String? errorMessage;

    bool? created;
    try {
      created = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => StatefulBuilder(
          builder: (context, setDialogState) => AlertDialog(
            title: const Text('Adicionar nó'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DropdownButtonFormField<String>(
                    initialValue: nodeType,
                    decoration: const InputDecoration(labelText: 'Tipo'),
                    items: const [
                      DropdownMenuItem(value: 'AREA', child: Text('Área')),
                      DropdownMenuItem(value: 'TOPIC', child: Text('Tópico')),
                      DropdownMenuItem(
                        value: 'CONCEPT',
                        child: Text('Conceito'),
                      ),
                      DropdownMenuItem(
                        value: 'SUBCONCEPT',
                        child: Text('Subconceito'),
                      ),
                    ],
                    onChanged: isSaving
                        ? null
                        : (value) {
                            if (value != null) {
                              setDialogState(() => nodeType = value);
                            }
                          },
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: titleController,
                    autofocus: true,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: const InputDecoration(
                      labelText: 'Título',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: descriptionController,
                    minLines: 2,
                    maxLines: 4,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: const InputDecoration(
                      labelText: 'Descrição (opcional)',
                      border: OutlineInputBorder(),
                      alignLabelWithHint: true,
                    ),
                  ),
                  if (errorMessage != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      errorMessage!,
                      style: TextStyle(color: context.colors.error),
                    ),
                  ],
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: isSaving
                    ? null
                    : () => Navigator.pop(dialogContext, false),
                child: const Text('Cancelar'),
              ),
              FilledButton.icon(
                onPressed: isSaving
                    ? null
                    : () async {
                        final title = titleController.text.trim();
                        if (title.isEmpty) {
                          setDialogState(
                            () => errorMessage = 'Informe o título do nó.',
                          );
                          return;
                        }
                        setDialogState(() {
                          isSaving = true;
                          errorMessage = null;
                        });
                        try {
                          await GraphNodeDao(
                            ref.read(appDatabaseProvider),
                          ).insertGraphNode(
                            graphId: widget.graphId,
                            type: nodeType,
                            title: title,
                            description:
                                descriptionController.text.trim().isEmpty
                                ? null
                                : descriptionController.text.trim(),
                            positionX: 0,
                            positionY: 0,
                          );
                          if (dialogContext.mounted) {
                            Navigator.pop(dialogContext, true);
                          }
                        } catch (error) {
                          if (dialogContext.mounted) {
                            setDialogState(() {
                              isSaving = false;
                              errorMessage =
                                  'Não foi possível adicionar o nó: $error';
                            });
                          }
                        }
                      },
                icon: isSaving
                    ? const SizedBox.square(
                        dimension: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.add),
                label: Text(isSaving ? 'Salvando…' : 'Adicionar nó'),
              ),
            ],
          ),
        ),
      );
    } finally {
      titleController.dispose();
      descriptionController.dispose();
    }

    if (!mounted) return;
    ref.read(graphStatesProvider.notifier).isCreatingNodeChanged(false);
    if (created == true) {
      ref.invalidate(nodesProvider(widget.graphId));
      try {
        await ref.read(nodesProvider(widget.graphId).future);
      } catch (error) {
        if (mounted) {
          _showMessage(
            'Nó adicionado, mas não foi possível recarregar o grafo: $error',
          );
        }
        return;
      }
      final organized = await _organizeGraph(showSuccess: false);
      if (mounted) {
        _showMessage(
          organized
              ? 'Nó adicionado e grafo organizado.'
              : 'Nó adicionado, mas não foi possível organizar o grafo.',
        );
      }
    }
  }

  void _handleEdgeNodeTap(
    GraphNodeData node,
    SelectedNotifier selectedNotifier,
  ) {
    final endpoint = _edgePickEndpoint;
    if (endpoint == null) {
      _showMessage('Escolha origem ou destino no formulário primeiro.');
      return;
    }
    final otherEndpointId = endpoint == 'source'
        ? _edgeTargetNodeId
        : _edgeSourceNodeId;
    if (node.id == otherEndpointId) {
      _showMessage('Origem e destino precisam ser nós diferentes.');
      return;
    }
    setState(() {
      if (endpoint == 'source') {
        _edgeSourceNodeId = node.id;
      } else {
        _edgeTargetNodeId = node.id;
      }
      _edgePickEndpoint = null;
    });
    ref.read(graphStatesProvider.notifier).isCreatingEdgeChanged(false);
    selectedNotifier.clear();
    _showCreateEdgeDialog(
      sourceNodeId: _edgeSourceNodeId,
      targetNodeId: _edgeTargetNodeId,
    );
  }

  Future<void> _showCreateEdgeDialog({
    String? sourceNodeId,
    String? targetNodeId,
  }) async {
    late final List<GraphNodeData> nodes;
    try {
      nodes = await ref.read(nodesProvider(widget.graphId).future);
    } catch (error) {
      if (mounted) {
        _cancelCreation();
        _showMessage('Não foi possível carregar os nós do grafo: $error');
      }
      return;
    }
    if (!mounted) return;
    if (nodes.length < 2) {
      _cancelCreation();
      _showMessage('Adicione ao menos dois nós antes de criar uma relação.');
      return;
    }

    var selectedSourceId = nodes.any((node) => node.id == sourceNodeId)
        ? sourceNodeId
        : null;
    var selectedTargetId = nodes.any((node) => node.id == targetNodeId)
        ? targetNodeId
        : null;
    String? relationType = 'PREREQUISITE';
    var weightValue = '';
    String? errorMessage;
    final dialogResult = await showDialog<_EdgeDialogResult>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) {
          final availableTargets = nodes
              .where((node) => node.id != selectedSourceId)
              .toList();
          final availableSources = nodes
              .where((node) => node.id != selectedTargetId)
              .toList();
          return AlertDialog(
            title: const Text('Criar relação'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DropdownButtonFormField<String>(
                    initialValue: selectedSourceId,
                    isExpanded: true,
                    decoration: const InputDecoration(labelText: 'Origem'),
                    items: [
                      for (final node in availableSources)
                        DropdownMenuItem(
                          value: node.id,
                          child: Text(
                            node.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                    onChanged: (value) =>
                        setDialogState(() => selectedSourceId = value),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      onPressed: () => Navigator.pop(
                        dialogContext,
                        _EdgeDialogResult.pickSource(
                          selectedSourceId,
                          selectedTargetId,
                        ),
                      ),
                      icon: const Icon(Icons.touch_app_outlined),
                      label: const Text('Escolher origem clicando no nó'),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: Icon(Icons.south_rounded),
                  ),
                  DropdownButtonFormField<String>(
                    initialValue: selectedTargetId,
                    isExpanded: true,
                    decoration: const InputDecoration(labelText: 'Destino'),
                    items: [
                      for (final node in availableTargets)
                        DropdownMenuItem(
                          value: node.id,
                          child: Text(
                            node.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                    onChanged: (value) =>
                        setDialogState(() => selectedTargetId = value),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      onPressed: () => Navigator.pop(
                        dialogContext,
                        _EdgeDialogResult.pickTarget(
                          selectedSourceId,
                          selectedTargetId,
                        ),
                      ),
                      icon: const Icon(Icons.touch_app_outlined),
                      label: const Text('Escolher destino clicando no nó'),
                    ),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    initialValue: relationType,
                    decoration: const InputDecoration(
                      labelText: 'Tipo de relação',
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'PREREQUISITE',
                        child: Text('Pré-requisito'),
                      ),
                      DropdownMenuItem(
                        value: 'SUBTOPIC',
                        child: Text('Subtópico'),
                      ),
                    ],
                    onChanged: (value) =>
                        setDialogState(() => relationType = value),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                      signed: true,
                    ),
                    onChanged: (value) => weightValue = value.trim(),
                    decoration: const InputDecoration(
                      labelText: 'Peso (opcional)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  if (errorMessage != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      errorMessage!,
                      style: TextStyle(color: context.colors.error),
                    ),
                  ],
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('Cancelar'),
              ),
              FilledButton.icon(
                onPressed: () {
                  final type = relationType;
                  final sourceId = selectedSourceId;
                  final targetId = selectedTargetId;
                  final weightText = weightValue;
                  final weight = weightText.isEmpty
                      ? null
                      : double.tryParse(weightText.replaceAll(',', '.'));
                  if (sourceId == null || targetId == null) {
                    setDialogState(
                      () => errorMessage =
                          'Selecione os nós de origem e destino.',
                    );
                    return;
                  }
                  if (sourceId == targetId) {
                    setDialogState(
                      () => errorMessage =
                          'Origem e destino devem ser diferentes.',
                    );
                    return;
                  }
                  if (type == null) {
                    setDialogState(
                      () => errorMessage = 'Selecione o tipo de relação.',
                    );
                    return;
                  }
                  if (weightText.isNotEmpty &&
                      (weight == null || !weight.isFinite)) {
                    setDialogState(
                      () => errorMessage = 'Informe um peso numérico válido.',
                    );
                    return;
                  }
                  Navigator.pop(
                    dialogContext,
                    _EdgeDialogResult.create(
                      sourceId: sourceId,
                      targetId: targetId,
                      type: type,
                      weight: weight,
                    ),
                  );
                },
                icon: const Icon(Icons.add_link_rounded),
                label: const Text('Criar relação'),
              ),
            ],
          );
        },
      ),
    );
    if (!mounted || dialogResult == null) {
      _cancelCreation();
      return;
    }
    if (dialogResult.pickEndpoint != null) {
      setState(() {
        _edgeSourceNodeId = dialogResult.sourceNodeId;
        _edgeTargetNodeId = dialogResult.targetNodeId;
        _edgePickEndpoint = dialogResult.pickEndpoint;
      });
      ref.read(graphStatesProvider.notifier).isCreatingEdgeChanged(true);
      return;
    }

    setState(() {
      _edgeSourceNodeId = null;
      _edgeTargetNodeId = null;
      _edgePickEndpoint = null;
    });
    ref.read(graphStatesProvider.notifier).isCreatingEdgeChanged(false);
    try {
      await GraphEdgeDao(ref.read(appDatabaseProvider)).insertGraphEdge(
        graphId: widget.graphId,
        sourceNodeId: dialogResult.sourceNodeId!,
        targetNodeId: dialogResult.targetNodeId!,
        type: dialogResult.type!,
        weight: dialogResult.weight,
      );
      if (mounted) _showMessage('Relação adicionada ao grafo.');
    } catch (error) {
      if (mounted) _showMessage('Não foi possível criar a relação: $error');
    }
  }

  void _selectNode(
    BuildContext context,
    GraphNodeData node,
    Offset origin,
    Size viewport,
    TransformationControllerNotifier controllerNotifier,
    SelectedNotifier selectedNotifier, {
    required bool showSheet,
  }) {
    selectedNotifier.selectedChanged(node.id);
    controllerNotifier.goToPoint(
      Offset(node.positionX + origin.dx, node.positionY + origin.dy),
      1,
      viewport,
    );
    if (showSheet) _showNodeSheet(context, node);
  }

  Future<void> _showNodeSearch(
    BuildContext context,
    List<GraphNodeData> nodes,
  ) async {
    final controller = TextEditingController();
    try {
      final node = await showDialog<GraphNodeData>(
        context: context,
        builder: (dialogContext) => StatefulBuilder(
          builder: (context, setDialogState) {
            final query = controller.text.trim().toLowerCase();
            final matches = nodes
                .where(
                  (node) =>
                      node.title.toLowerCase().contains(query) ||
                      (node.description?.toLowerCase().contains(query) ??
                          false),
                )
                .take(30)
                .toList();
            return AlertDialog(
              title: const Text('Buscar conceito'),
              content: SizedBox(
                width: 460,
                height: 420,
                child: Column(
                  children: [
                    TextField(
                      controller: controller,
                      autofocus: true,
                      onChanged: (_) => setDialogState(() {}),
                      decoration: const InputDecoration(
                        hintText: 'Digite o nome de um conceito',
                        prefixIcon: Icon(Icons.search_rounded),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: matches.isEmpty
                          ? const Center(
                              child: Text('Nenhum conceito encontrado.'),
                            )
                          : ListView.builder(
                              itemCount: matches.length,
                              itemBuilder: (context, index) {
                                final match = matches[index];
                                return ListTile(
                                  leading: const Icon(
                                    Icons.lightbulb_outline_rounded,
                                  ),
                                  title: Text(match.title),
                                  subtitle: Text(_nodeTypeLabel(match.type)),
                                  onTap: () =>
                                      Navigator.pop(dialogContext, match),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Fechar'),
                ),
              ],
            );
          },
        ),
      );
      if (node == null || !mounted || !context.mounted) return;

      final nodesById = {for (final item in nodes) item.id: item};
      final bounds = _nodeBounds(nodes);
      if (bounds == null) return;
      const padding = 120.0;
      final origin = Offset(padding - bounds.left, padding - bounds.top);
      final viewport = _lastViewport.width > 0 && _lastViewport.height > 0
          ? _lastViewport
          : MediaQuery.sizeOf(context);
      final isWideLayout = MediaQuery.sizeOf(context).width >= 900;
      final currentSelection = ref.read(selectedProvider);
      final selectionViewport =
          isWideLayout && !nodesById.containsKey(currentSelection)
          ? Size(
              viewport.width - math.min(360.0, viewport.width * 0.34) - 8,
              viewport.height,
            )
          : viewport;
      final controllerNotifier = ref.read(
        transformationControllerProvider.notifier,
      );
      _selectNode(
        context,
        nodesById[node.id]!,
        origin,
        selectionViewport,
        controllerNotifier,
        ref.read(selectedProvider.notifier),
        showSheet: !isWideLayout,
      );
    } finally {
      controller.dispose();
    }
  }

  void _showNodeSheet(BuildContext context, GraphNodeData node) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.58,
        minChildSize: 0.32,
        maxChildSize: 0.9,
        builder: (context, scrollController) => Padding(
          padding: EdgeInsets.fromLTRB(
            12,
            0,
            12,
            MediaQuery.viewInsetsOf(context).bottom + 12,
          ),
          child: NodeDetails(
            key: ValueKey(node.id),
            node: node,
            scrollController: scrollController,
            onClose: () {
              ref.read(selectedProvider.notifier).clear();
              Navigator.of(sheetContext).pop();
            },
          ),
        ),
      ),
    );
  }

  String _nodeTypeLabel(String type) {
    switch (type.toUpperCase()) {
      case 'AREA':
        return 'Área';
      case 'TOPIC':
        return 'Tópico';
      case 'SUBCONCEPT':
        return 'Subconceito';
      default:
        return 'Conceito';
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}

class _CanvasCreationPrompt extends StatelessWidget {
  const _CanvasCreationPrompt({required this.message, required this.onCancel});

  final String message;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Card(
        color: context.colors.primaryContainer,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.touch_app_outlined,
                size: 18,
                color: context.colors.onPrimaryContainer,
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  message,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.colors.onPrimaryContainer,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              IconButton(
                tooltip: 'Cancelar criação',
                visualDensity: VisualDensity.compact,
                onPressed: onCancel,
                icon: Icon(
                  Icons.close_rounded,
                  size: 18,
                  color: context.colors.onPrimaryContainer,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EdgeDialogResult {
  const _EdgeDialogResult({
    this.sourceNodeId,
    this.targetNodeId,
    this.type,
    this.weight,
    this.pickEndpoint,
  });

  final String? sourceNodeId;
  final String? targetNodeId;
  final String? type;
  final double? weight;
  final String? pickEndpoint;

  factory _EdgeDialogResult.pickSource(
    String? sourceNodeId,
    String? targetNodeId,
  ) {
    return _EdgeDialogResult(
      sourceNodeId: sourceNodeId,
      targetNodeId: targetNodeId,
      pickEndpoint: 'source',
    );
  }

  factory _EdgeDialogResult.pickTarget(
    String? sourceNodeId,
    String? targetNodeId,
  ) {
    return _EdgeDialogResult(
      sourceNodeId: sourceNodeId,
      targetNodeId: targetNodeId,
      pickEndpoint: 'target',
    );
  }

  factory _EdgeDialogResult.create({
    required String sourceId,
    required String targetId,
    required String type,
    required double? weight,
  }) {
    return _EdgeDialogResult(
      sourceNodeId: sourceId,
      targetNodeId: targetId,
      type: type,
      weight: weight,
    );
  }
}

class _GraphHeader extends StatelessWidget {
  const _GraphHeader({
    required this.title,
    required this.description,
    required this.nodeCount,
    required this.edgeCount,
  });

  final String title;
  final String? description;
  final int nodeCount;
  final int edgeCount;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final colors = context.colors;
    final descriptionText = description?.trim();

    return Row(
      children: [
        Icon(Icons.account_tree_rounded, color: colors.primary, size: 22),
        const SizedBox(width: 8),
        Expanded(
          child: Tooltip(
            message: descriptionText?.isNotEmpty == true
                ? '$title\n\n$descriptionText'
                : title,
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Tooltip(
          message: '$nodeCount conceitos',
          child: _CountBadge(
            icon: Icons.lightbulb_outline_rounded,
            label: '$nodeCount',
          ),
        ),
        const SizedBox(width: 4),
        Tooltip(
          message: '$edgeCount relações',
          child: _CountBadge(icon: Icons.hub_outlined, label: '$edgeCount'),
        ),
      ],
    );
  }
}

class _CountBadge extends StatelessWidget {
  const _CountBadge({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(icon, size: 18),
      label: Text(label),
      visualDensity: VisualDensity.compact,
      padding: EdgeInsets.zero,
      labelPadding: const EdgeInsets.symmetric(horizontal: 2),
      side: BorderSide.none,
      backgroundColor: Colors.transparent,
    );
  }
}

class _CanvasControls extends StatelessWidget {
  const _CanvasControls({
    required this.scale,
    required this.onZoomIn,
    required this.onZoomOut,
    required this.onFit,
  });

  final double scale;
  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;
  final VoidCallback onFit;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '${(scale * 100).round()}%',
          style: context.textTheme.labelSmall?.copyWith(
            color: context.colors.onSurfaceVariant,
          ),
        ),
        PopupMenuButton<String>(
          tooltip: 'Zoom e enquadramento',
          onSelected: (action) {
            switch (action) {
              case 'in':
                onZoomIn();
              case 'out':
                onZoomOut();
              case 'fit':
                onFit();
            }
          },
          itemBuilder: (context) => const [
            PopupMenuItem(
              value: 'in',
              child: ListTile(
                leading: Icon(Icons.add_rounded),
                title: Text('Aumentar zoom'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
            PopupMenuItem(
              value: 'out',
              child: ListTile(
                leading: Icon(Icons.remove_rounded),
                title: Text('Diminuir zoom'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
            PopupMenuItem(
              value: 'fit',
              child: ListTile(
                leading: Icon(Icons.fit_screen_rounded),
                title: Text('Enquadrar grafo'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ],
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Icon(
              Icons.zoom_out_map_rounded,
              size: 21,
              color: context.colors.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }
}

class _EdgeInfoCard extends StatelessWidget {
  const _EdgeInfoCard({
    required this.edge,
    required this.nodesById,
    required this.onClose,
  });

  final GraphEdgeData edge;
  final Map<String, GraphNodeData> nodesById;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final source = nodesById[edge.sourceNodeId];
    final target = nodesById[edge.targetNodeId];
    return Card(
      child: Padding(
        padding: const EdgeInsets.only(left: 14, top: 4, bottom: 4, right: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.arrow_downward_rounded, size: 18),
            const SizedBox(width: 8),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 280),
              child: Text(
                '${source?.title ?? "Conceito"} → ${target?.title ?? "Conceito"}'
                '\n${_edgeTypeLabel(edge.type)}',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: context.textTheme.labelMedium,
              ),
            ),
            IconButton(
              tooltip: 'Fechar detalhes da relação',
              onPressed: onClose,
              icon: const Icon(Icons.close_rounded),
            ),
          ],
        ),
      ),
    );
  }

  String _edgeTypeLabel(String type) {
    switch (type.toUpperCase()) {
      case 'PREREQUISITE':
        return 'Pré-requisito';
      case 'SUBTOPIC':
        return 'Subtópico';
      default:
        return type;
    }
  }
}

class _EmptyGraphState extends StatelessWidget {
  const _EmptyGraphState({required this.onEdit});

  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.account_tree_outlined,
                size: 44,
                color: context.colors.primary,
              ),
              const SizedBox(height: 12),
              Text(
                'Seu grafo começa com uma ideia',
                style: context.textTheme.titleMedium,
              ),
              const SizedBox(height: 6),
              const Text(
                'Adicione conceitos e conecte-os para criar seu mapa de conhecimento.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: onEdit,
                icon: const Icon(Icons.add_rounded),
                label: const Text('Adicionar primeiro conceito'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GraphLoadError extends StatelessWidget {
  const _GraphLoadError({required this.error});

  final Object error;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.cloud_off_outlined,
              color: context.colors.error,
              size: 40,
            ),
            const SizedBox(height: 12),
            Text('Não foi possível carregar o grafo.'),
            const SizedBox(height: 4),
            Text(
              '$error',
              textAlign: TextAlign.center,
              style: context.textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
