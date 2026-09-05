import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noema/core/database/database.dart';
import 'package:noema/core/database/database_provider.dart';
import 'package:noema/feature/config/providers/user_provider.dart';

final knowledgeGraphsProvider = StreamProvider<List<KnowledgeGraphData>>((
  ref,
) async* {
  final db = ref.watch(appDatabaseProvider);
  final userNotifier = ref.read(userProvider.notifier);

  final user = await userNotifier.getUser();

  yield* (db.select(
    db.knowledgeGraph,
  )..where((graph) => graph.userId.equals(user.id))).watch();
});

final nodesProvider = StreamProvider.family<List<GraphNodeData>, String>((
  ref,
  graphId,
) {
  final db = ref.watch(appDatabaseProvider);

  return (db.select(
    db.graphNode,
  )..where((node) => node.graphId.equals(graphId))).watch();
});

final edgesProvider = StreamProvider.family<List<GraphEdgeData>, String>((
  ref,
  graphId,
) {
  final db = ref.watch(appDatabaseProvider);

  return (db.select(
    db.graphEdge,
  )..where((edge) => edge.graphId.equals(graphId))).watch();
});
