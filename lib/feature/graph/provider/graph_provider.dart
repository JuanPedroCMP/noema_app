import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noema/core/database/database.dart';
import 'package:noema/core/database/database_provider.dart';
import 'package:noema/feature/graph/data/graph_edge_dao.dart';
import 'package:noema/feature/graph/data/graph_node_dao.dart';
import 'package:noema/feature/graph/data/knowledge_graph_dao.dart';

final nodesProvider = FutureProvider.family<List<GraphNodeData>, String>((ref, graphId) async {
    final db = ref.read(appDatabaseProvider);
    final dao = GraphNodeDao(db);

    return await dao.getGraphNodesByGraph(graphId: graphId);
  
});

final edgesProvider = FutureProvider.family<List<GraphEdgeData>, String>((ref, graphId) async {
    final db = ref.read(appDatabaseProvider);
    final dao = GraphEdgeDao(db);

    return await dao.getGraphEdgesByGraph(graphId: graphId);
  
});