import 'package:drift/drift.dart';
import 'package:noema/core/database/database.dart';
import 'package:uuid/uuid.dart';

part 'graph_node_dao.g.dart';

@DriftAccessor(tables: [GraphNode])
class GraphNodeDao extends DatabaseAccessor<AppDatabase>
    with _$GraphNodeDaoMixin {
  GraphNodeDao(super.db);

  Future<int> insertGraphNode({
    required String graphId,
    String? parentId,
    required String type,
    required String title,
    String? description,
    double? masteryScore,
    bool? isSkipped,
    required double positionX,
    required double positionY,
    String? aiSynthesis,
    bool? synthesisEdited,
    int? fsrsRating,
  }) {
    return into(attachedDatabase.graphNode).insert(
      GraphNodeCompanion.insert(
        id: Uuid().v4(),
        graphId: graphId,
        type: type,
        title: title,
        description: Value(description),
        masteryScore: Value(masteryScore),
        isSkipped: isSkipped == null ? const Value.absent() : Value(isSkipped),
        positionX: positionX,
        positionY: positionY,
        fsrsRating: Value(fsrsRating),
      ),
    );
  }

  Future<int> updateGraphNode({
    required String id,
    String? graphId,
    String? parentId,
    String? type,
    String? title,
    String? description,
    double? masteryScore,
    bool? isSkipped,
    double? positionX,
    double? positionY,
    String? aiSynthesis,
    bool? synthesisEdited,
    int? fsrsRating,
  }) {
    return (update(
      attachedDatabase.graphNode,
    )..where((tbl) => tbl.id.equals(id))).write(
      GraphNodeCompanion(
        graphId: graphId == null ? const Value.absent() : Value(graphId),
        type: type == null ? const Value.absent() : Value(type),
        title: title == null ? const Value.absent() : Value(title),
        description: description == null
            ? const Value.absent()
            : Value(description),
        masteryScore: masteryScore == null
            ? const Value.absent()
            : Value(masteryScore),
        isSkipped: isSkipped == null ? const Value.absent() : Value(isSkipped),
        positionX: positionX == null ? const Value.absent() : Value(positionX),
        positionY: positionY == null ? const Value.absent() : Value(positionY),
        fsrsRating: fsrsRating == null
            ? const Value.absent()
            : Value(fsrsRating),
      ),
    );
  }

  Future<GraphNodeData?> getGraphNode({required String id}) {
    return (select(
      attachedDatabase.graphNode,
    )..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  Future<List<GraphNodeData>> getGraphNodesByGraph({required String graphId}) {
    return (select(attachedDatabase.graphNode)
          ..where((tbl) => tbl.graphId.equals(graphId))
          ..where((tbl) => tbl.softDeleted.equals(false)))
        .get();
  }

  Future<int> deleteGraphNode({required String id}) {
    return (update(
      attachedDatabase.graphNode,
    )..where((tbl) => tbl.id.equals(id))).write(
      GraphNodeCompanion(
        softDeleted: const Value(true),
        softDeletedAt: Value(DateTime.now().millisecondsSinceEpoch),
      ),
    );
  }
}
