import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noema/core/database/database.dart';
import 'package:noema/core/database/database_provider.dart';
import 'package:noema/feature/graph/data/graph_node_dao.dart';
import 'package:noema/feature/graph/provider/graph_states_provider.dart';
import 'package:noema/feature/graph/widgets/create_edge.dart';
import 'package:noema/feature/graph/widgets/create_node.dart';
import 'package:noema/feature/graph/widgets/graph.dart';
import 'package:noema/feature/graph/widgets/graph_utils_layer.dart';
import 'package:noema/feature/graph/provider/edge_type_provider.dart';
import 'package:noema/feature/graph/provider/graph_provider.dart';
import 'package:noema/feature/graph/provider/path_provider.dart';
import 'package:noema/feature/graph/provider/selected_provider.dart';
import 'package:noema/feature/graph/provider/transformation_controller_provider.dart';
import 'package:noema/feature/graph/service/calculate_paths.dart';
import 'package:noema/feature/graph/service/gestureActions.dart';
import 'package:noema/feature/graph/service/sugiyama.dart';
import 'package:noema/feature/graph/widgets/node_card.dart';
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

      final size = MediaQuery.sizeOf(context);

      final controllerNotifier = ref.read(
        transformationControllerProvider.notifier,
      );

      sugiyama(widget.graphId, ref);
      final seed = sugiyama(widget.graphId, ref);

      controllerNotifier.goToPoint(await seed, 0.8, size);
    });
  }

  @override
  Widget build(BuildContext context) {
    final nodesAsync = ref.watch(nodesProvider(widget.graphId));
    final edgesAsync = ref.watch(edgesProvider(widget.graphId));
    final selected = ref.watch(selectedProvider);
    final selectedNotifier = ref.watch(selectedProvider.notifier);
    final edgeType = ref.watch(edgeTypeProvider);
    final edgeTypeNotifier = ref.watch(edgeTypeProvider.notifier);
    final graphStatesNotifier = ref.watch(graphStatesProvider.notifier);
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

            if (nodes.isEmpty) {
              return const SizedBox.expand();
            }

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

            if (!minX.isFinite ||
                !maxX.isFinite ||
                !minY.isFinite ||
                !maxY.isFinite) {
              return const SizedBox.expand();
            }

            final graphWidth = max(1.0, maxX * 2);

            final graphHeight = max(1.0, maxY * 2);

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
                          details.localPosition,
                          nodes,
                          edges,
                          paths,
                          selectedNotifier,
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
                              Offset(node.positionX, node.positionY),
                              1.0,
                              size,
                            );
                            print('Node id ${result.$1}');
                            selectedNotifier.selectedChanged(result.$1);

                            // controller.toScene(
                            //   Offset(node.positionX, node.positionY),
                            // );
                          } else {
                            print('Edge id ${result.$1}');
                          }
                        }

                        if (edgeType >= 3) {
                          edgeTypeNotifier.edgeTypeChanged(0);
                        } else {
                          edgeTypeNotifier.edgeTypeChanged(edgeType + 1);
                        }
                      },
                      child: CustomPaint(
                        painter: GraphPainter(
                          context: context,
                          nodes: nodes,
                          edges: edges,
                          selected: selected,
                          option: edgeType,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(top: 10, left: 10, child: GraphUtilsLayer()),
                nodesById[selected] == null
                    ? SizedBox()
                    : SizedBox(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: NodeDetails(node: nodesById[selected]!),
                        ),
                      ),
                !graphStates
                        .isCreatingNode // Concertar os erros cabulosos causador pelos dois widgets a
                    ? SizedBox()
                    : SizedBox(
                        child: Align(
                          alignment: Alignment.center,
                          child: FloatingCard(
                            width: 800,
                            child: CreateNode(graphId: widget.graphId),
                          ),
                        ),
                      ),
                !graphStates.isCreatingEdge
                    ? SizedBox()
                    : Align(
                        alignment: Alignment.center,
                        child: FloatingCard(
                          width: 800,
                          child: CreateEdge(graphId: widget.graphId),
                        ),
                      ),
              ],
            );
          },
        );
      },
    );
  }
}
