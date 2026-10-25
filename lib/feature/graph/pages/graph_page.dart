import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noema/feature/graph/provider/graph_states_provider.dart';
import 'package:noema/feature/graph/widgets/create_edge.dart';
import 'package:noema/feature/graph/widgets/create_node.dart';
import 'package:noema/feature/graph/widgets/graph.dart';
import 'package:noema/feature/graph/widgets/graph_utils_layer.dart';
import 'package:noema/feature/graph/provider/edge_type_provider.dart';
import 'package:noema/feature/graph/provider/graph_provider.dart';
import 'package:noema/feature/graph/provider/selected_provider.dart';
import 'package:noema/feature/graph/provider/transformation_controller_provider.dart';
import 'package:noema/feature/graph/service/calculate_paths.dart';
import 'package:noema/feature/graph/service/gestureActions.dart';
import 'package:noema/feature/graph/service/sugiyama.dart';
import 'package:noema/feature/graph/widgets/node_details.dart';
import 'package:noema/shared/floating_card/floating_card.dart';

class GraphPage extends ConsumerStatefulWidget {
  const GraphPage({super.key, required this.graphId});

  final String graphId;

  @override
  ConsumerState<GraphPage> createState() => _GraphPage();
}

class _GraphPage extends ConsumerState<GraphPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;

      // These providers are shared with the graph toolbar. Updating them
      // during initState can coincide with the first provider build and
      // trigger Riverpod's "modify a provider while the widget tree was
      // building" assertion.
      ref.read(selectedProvider.notifier).clear();
      ref.read(graphStatesProvider.notifier).closeDialogs();

      final size = MediaQuery.sizeOf(context);

      final controllerNotifier = ref.read(
        transformationControllerProvider.notifier,
      );

      final seed = await loadGraph();

      final bounds = seed.bounds;
      if (bounds != null && bounds.isFinite) {
        controllerNotifier.goToPoint(bounds.center, 0.8, size);
      }
    });
  }

  Future<SugiyamaRunResult> loadGraph() async {
    return sugiyama(
      widget.graphId,
      ref,
      config: const SugiyamaConfig(mode: SugiyamaLayoutMode.centered),
    );
  }

  @override
  Widget build(BuildContext context) {
    final nodesAsync = ref.watch(nodesProvider(widget.graphId));
    final edgesAsync = ref.watch(edgesProvider(widget.graphId));
    final selected = ref.watch(selectedProvider);
    final selectedNotifier = ref.watch(selectedProvider.notifier);
    final edgeType = ref.watch(edgeTypeProvider);
    final graphStates = ref.watch(graphStatesProvider);
    final controller = ref.watch(transformationControllerProvider);
    final controllerNotifier = ref.watch(
      transformationControllerProvider.notifier,
    );

    return nodesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Text('Erro: $error'),
      data: (nodes) {
        return edgesAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Text('Erro: $error'),
          data: (edges) {
            final paths = calculatePaths(nodes, edges, edgeType);

            final nodesById = {for (final node in nodes) node.id: node};

            double minX = double.infinity;
            double maxX = double.negativeInfinity;
            double minY = double.infinity;
            double maxY = double.negativeInfinity;

            for (final node in nodes) {
              if (!node.positionX.isFinite || !node.positionY.isFinite) {
                continue;
              }

              minX = min(minX, node.positionX);
              maxX = max(maxX, node.positionX);

              minY = min(minY, node.positionY);
              maxY = max(maxY, node.positionY);
            }

            const nodeWidth = 200.0;
            const nodeHeight = 80.0;
            const canvasPadding = 120.0;
            final hasFiniteBounds =
                minX.isFinite &&
                maxX.isFinite &&
                minY.isFinite &&
                maxY.isFinite;
            final origin = hasFiniteBounds
                ? Offset(canvasPadding - minX, canvasPadding - minY)
                : const Offset(canvasPadding, canvasPadding);
            final graphWidth = max(
              600.0,
              hasFiniteBounds
                  ? maxX - minX + nodeWidth + canvasPadding * 2
                  : canvasPadding * 2 + nodeWidth,
            );
            final graphHeight = max(
              400.0,
              hasFiniteBounds
                  ? maxY - minY + nodeHeight + canvasPadding * 2
                  : canvasPadding * 2 + nodeHeight,
            );

            return Stack(
              fit: StackFit.loose,
              children: [
                InteractiveViewer(
                  boundaryMargin: EdgeInsets.all(500),
                  transformationController: controller,
                  constrained: false,
                  minScale: 0.1,
                  maxScale: 5,
                  child: SizedBox(
                    width: graphWidth,
                    height: graphHeight,
                    child: GestureDetector(
                      onTapDown: (details) {
                        final result = getTapTarget(
                          details.localPosition - origin,
                          nodes,
                          paths,
                          context,
                        );

                        if (result.$3) {
                          if (result.$2) {
                            final size = MediaQuery.of(context).size;
                            final node = nodesById[result.$1];
                            if (node == null) {
                              return;
                            }
                            controllerNotifier.goToPoint(
                              Offset(
                                node.positionX + origin.dx,
                                node.positionY + origin.dy,
                              ),
                              1.0,
                              size,
                            );
                            debugPrint('Node id ${result.$1}');
                            selectedNotifier.selectedChanged(result.$1);

                            // controller.toScene(
                            //   Offset(node.positionX, node.positionY),
                            // );
                          } else {
                            debugPrint('Edge id ${result.$1}');
                            selectedNotifier.selectedChanged(result.$1);
                          }
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
                if (nodes.isEmpty)
                  const Center(
                    child: Text(
                      'Este grafo está vazio.\nEntre no modo de edição para adicionar um nó.',
                      textAlign: TextAlign.center,
                    ),
                  ),
                Positioned(
                  top: 10,
                  left: 10,
                  right: 10,
                  child: GraphUtilsLayer(graphId: widget.graphId),
                ),
                nodesById[selected] == null
                    ? const SizedBox.shrink()
                    : SizedBox(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: NodeDetails(node: nodesById[selected]!),
                        ),
                      ),
                if (graphStates.isCreatingNode)
                  _buildEditorPanel(
                    context,
                    CreateNode(graphId: widget.graphId),
                  ),
                if (graphStates.isCreatingEdge)
                  _buildEditorPanel(
                    context,
                    CreateEdge(graphId: widget.graphId),
                  ),
              ],
            );
          },
        );
      },
    );
  }
}

Widget _buildEditorPanel(BuildContext context, Widget child) {
  final viewport = MediaQuery.sizeOf(context);
  final width = min(800.0, max(280.0, viewport.width - 32));
  final height = min(620.0, max(260.0, viewport.height - 120));

  return Positioned.fill(
    child: SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: FloatingCard(
            width: width,
            height: height,
            padding: 20,
            child: child,
          ),
        ),
      ),
    ),
  );
}
