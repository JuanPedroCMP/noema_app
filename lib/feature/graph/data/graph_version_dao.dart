import 'package:drift/drift.dart';
import 'package:noema/core/database/database.dart';
import 'package:uuid/uuid.dart';

part 'graph_version_dao.g.dart';

@DriftAccessor(tables: [GraphVersion])
class GraphVersionDao extends DatabaseAccessor<AppDatabase> with _$GraphVersionDaoMixin {
  GraphVersionDao(super.db);

  Future<int> insertGraphVersion({
    required String graphId,
    required int versionNumber,
    required String snapshotJson,
    String? changeSummary,
  }) {
    return into(attachedDatabase.graphVersion).insert(
      GraphVersionCompanion.insert(
        id: Uuid().v4(),
        graphId: graphId,
        versionNumber: versionNumber,
        snapshotJson: snapshotJson,
        changeSummary: Value(changeSummary),
      ),
    );
  }

  Future<int> updateGraphVersion({
    required String id,
    String? graphId,
    int? versionNumber,
    String? snapshotJson,
    String? changeSummary,
  }) {
    return (update(
      attachedDatabase.graphVersion,
    )..where((tbl) => tbl.id.equals(id))).write(
      GraphVersionCompanion(
        graphId: graphId == null ? const Value.absent() : Value(graphId),
        versionNumber: versionNumber == null ? const Value.absent() : Value(versionNumber),
        snapshotJson: snapshotJson == null ? const Value.absent() : Value(snapshotJson),
        changeSummary: changeSummary == null ? const Value.absent() : Value(changeSummary),
      ),
    );
  }

  Future<GraphVersionData?> getGraphVersion({required String id}) {
    return (select(attachedDatabase.graphVersion)..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();
  }

  Future<List<GraphVersionData>> getGraphVersionsByGraph({required String graphId}) {
    return (select(attachedDatabase.graphVersion)
          ..where((tbl) => tbl.graphId.equals(graphId))
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.versionNumber)]))
        .get();
  }

  Future<int> deleteGraphVersion({required String id}) {
    return (delete(attachedDatabase.graphVersion)
          ..where((tbl) => tbl.id.equals(id)))
        .go();
  }
}
