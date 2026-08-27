import 'package:drift/drift.dart';
import 'package:noema/core/database/database.dart';
import 'package:uuid/uuid.dart';

part 'graph_edge_dao.g.dart';

@DriftAccessor(tables: [GraphEdge])
class GraphEdgeDao extends DatabaseAccessor<AppDatabase>
    with _$GraphEdgeDaoMixin {
  GraphEdgeDao(super.db);

  Future<int> insertGraphEdge({
    required String graphId,
    required String sourceNodeId,
    required String targetNodeId,
    required String type,
    bool? isBidirectional,
    double? weight,
    bool? synced,
  }) {
    return into(attachedDatabase.graphEdge).insert(
      GraphEdgeCompanion.insert(
        id: Uuid().v4(),
        graphId: graphId,
        sourceNodeId: sourceNodeId,
        targetNodeId: targetNodeId,
        type: type,
        weight: Value(weight),
      ),
    );
  }

  Future<int> updateGraphEdge({
    required String id,
    String? graphId,
    String? sourceNodeId,
    String? targetNodeId,
    String? type,
    bool? isBidirectional,
    double? weight,
    bool? synced,
  }) {
    return (update(
      attachedDatabase.graphEdge,
    )..where((tbl) => tbl.id.equals(id))).write(
      GraphEdgeCompanion(
        graphId: graphId == null ? const Value.absent() : Value(graphId),
        sourceNodeId: sourceNodeId == null
            ? const Value.absent()
            : Value(sourceNodeId),
        targetNodeId: targetNodeId == null
            ? const Value.absent()
            : Value(targetNodeId),
        type: type == null ? const Value.absent() : Value(type),

        weight: weight == null ? const Value.absent() : Value(weight),
      ),
    );
  }

  Future<GraphEdgeData?> getGraphEdge({required String id}) {
    return (select(
      attachedDatabase.graphEdge,
    )..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  Future<List<GraphEdgeData>> getGraphEdgesByGraph({required String graphId}) {
    return (select(
      attachedDatabase.graphEdge,
    )..where((tbl) => tbl.graphId.equals(graphId))).get();
  }

  Future<int> deleteGraphEdge({required String id}) {
    return (delete(
      attachedDatabase.graphEdge,
    )..where((tbl) => tbl.id.equals(id))).go();
  }
}
