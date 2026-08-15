import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noema/core/database/database.dart';
import 'package:noema/feature/graph/graph.dart';
import 'package:noema/feature/graph/provider/graph_provider.dart';

class GraphPage extends ConsumerWidget {
  const GraphPage({super.key, required this.graphId});

  final String graphId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nodesAsync = ref.watch(nodesProvider(graphId));
    final edgeAsync = ref.watch(edgesProvider(graphId));

    return nodesAsync.when(
      data: (nodesData) => edgeAsync.when(
        data: (edgesData) => CustomPaint(
          painter: GraphPainter(
            nodes: nodesData, 
            edges: edgesData), 
            child: const SizedBox.expand()), 
        error: ((error, stackTrace) => Text("Erro")), 
        loading: () => Text("Carregando")), 
      error: ((error, stackTrace) => Text("Erro")), 
      loading: () => Text("Carregando"));
  }
}
