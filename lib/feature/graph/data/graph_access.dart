import 'package:noema/core/database/database.dart';
import 'package:noema/feature/graph/data/graph_node_dao.dart';
import 'package:noema/feature/graph/data/knowledge_graph_dao.dart';

Future<GraphNodeData> getGraphNodeForUser({
  required AppDatabase db,
  required String nodeId,
  required String userId,
}) async {
  final node = await GraphNodeDao(db).getGraphNode(id: nodeId);
  if (node == null || node.softDeleted) {
    throw StateError('O conteúdo solicitado não está disponível.');
  }
  final graph = await KnowledgeGraphDao(db).getKnowledgeGraph(id: node.graphId);
  if (graph == null || graph.softDeleted || graph.userId != userId) {
    throw StateError('O conteúdo solicitado não está disponível.');
  }
  return node;
}
