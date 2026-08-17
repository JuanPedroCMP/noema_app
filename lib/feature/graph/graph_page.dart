import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noema/core/database/database.dart';
import 'package:noema/core/database/database_provider.dart';
import 'package:noema/feature/graph/data/graph_node_dao.dart';
import 'package:noema/feature/graph/graph.dart';
import 'package:noema/feature/graph/provider/edge_type_provider.dart';
import 'package:noema/feature/graph/provider/graph_provider.dart';
import 'package:noema/feature/graph/provider/path_provider.dart';
import 'package:noema/feature/graph/provider/selected_provider.dart';
import 'package:noema/feature/graph/service/calculate_paths.dart';
import 'package:noema/feature/graph/service/gestureActions.dart';
import 'package:noema/feature/graph/service/sugiyama.dart';

class GraphPage extends ConsumerWidget {
  const GraphPage({super.key, required this.graphId});

  final String graphId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nodesAsync = ref.watch(nodesProvider(graphId));
    final edgesAsync = ref.watch(edgesProvider(graphId));
    final selected = ref.watch(selectedProvider);
    final selectedNotifier = ref.watch(selectedProvider.notifier);
    final edgeType = ref.watch(edgeTypeProvider);
    final edgeTypeNotifier = ref.watch(edgeTypeProvider.notifier);

    return nodesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Text('Erro: $error'),
      data: (nodes) {
        return edgesAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Text('Erro: $error'),
          data: (edges) {
            final paths = calculatePaths(nodes, edges, edgeType);
            return InteractiveViewer(
              child: GestureDetector(
                onTapDown: (details) {
                  final result = getTapTarget(
                    details.localPosition,
                    nodes,
                    edges,
                    paths,
                    selectedNotifier,
                  );

                  if (result.$3) {
                    if (result.$2) {
                      print('Node id ${result.$1}');
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
                  child: const SizedBox.expand(),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
