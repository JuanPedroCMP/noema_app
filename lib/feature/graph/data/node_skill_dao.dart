import 'package:drift/drift.dart';
import 'package:noema/core/database/database.dart';
import 'package:uuid/uuid.dart';

part 'node_skill_dao.g.dart';

@DriftAccessor(tables: [NodeSkill])
class NodeSkillDao extends DatabaseAccessor<AppDatabase>
    with _$NodeSkillDaoMixin {
  NodeSkillDao(super.db);

  Future<String> insertSkill({
    required String nodeId,
    required String description,
    required String type,
    required int displayOrder,
  }) async {
    final id = const Uuid().v4();
    await into(attachedDatabase.nodeSkill).insert(
      NodeSkillCompanion.insert(
        id: id,
        nodeId: nodeId,
        description: description.trim(),
        type: type,
        displayOrder: displayOrder,
        userEdited: const Value(true),
      ),
    );
    return id;
  }

  Future<int> nextDisplayOrder(String nodeId) async {
    final skills = await getByNode(nodeId);
    if (skills.isEmpty) return 0;
    return skills
            .map((skill) => skill.displayOrder)
            .reduce((a, b) => a > b ? a : b) +
        1;
  }

  Future<List<NodeSkillData>> getByNode(String nodeId) {
    return (select(attachedDatabase.nodeSkill)
          ..where((tbl) => tbl.nodeId.equals(nodeId))
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.displayOrder)]))
        .get();
  }

  Stream<List<NodeSkillData>> watchByNode(String nodeId) {
    return (select(attachedDatabase.nodeSkill)
          ..where((tbl) => tbl.nodeId.equals(nodeId))
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.displayOrder)]))
        .watch();
  }

  Future<int> deleteSkill({required String id}) {
    return (delete(
      attachedDatabase.nodeSkill,
    )..where((tbl) => tbl.id.equals(id))).go();
  }
}
