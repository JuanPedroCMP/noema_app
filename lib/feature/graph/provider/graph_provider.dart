import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noema/core/database/database.dart';
import 'package:noema/core/database/database_provider.dart';
import 'package:noema/feature/config/providers/user_provider.dart';
import 'package:noema/feature/graph/data/knowledge_graph_dao.dart';

final knowledgeGraphsProvider = StreamProvider<List<KnowledgeGraphData>>((
  ref,
) async* {
  final db = ref.watch(appDatabaseProvider);
  final user = await ref.watch(userProvider.future);

  yield* (db.select(db.knowledgeGraph)
        ..where((graph) => graph.userId.equals(user.id))
        ..where((graph) => graph.softDeleted.equals(false)))
      .watch();
});

final nodesProvider = StreamProvider.family<List<GraphNodeData>, String>((
  ref,
  graphId,
) async* {
  final db = ref.watch(appDatabaseProvider);
  final user = await ref.watch(userProvider.future);
  final graph = await KnowledgeGraphDao(db).getKnowledgeGraph(id: graphId);
  if (graph == null || graph.softDeleted || graph.userId != user.id) {
    yield const [];
    return;
  }

  yield* (db.select(db.graphNode)
        ..where((node) => node.graphId.equals(graphId))
        ..where((node) => node.softDeleted.equals(false)))
      .watch();
});

final edgesProvider = StreamProvider.family<List<GraphEdgeData>, String>((
  ref,
  graphId,
) async* {
  final db = ref.watch(appDatabaseProvider);
  final user = await ref.watch(userProvider.future);
  final graph = await KnowledgeGraphDao(db).getKnowledgeGraph(id: graphId);
  if (graph == null || graph.softDeleted || graph.userId != user.id) {
    yield const [];
    return;
  }

  yield* (db.select(
    db.graphEdge,
  )..where((edge) => edge.graphId.equals(graphId))).watch();
});
