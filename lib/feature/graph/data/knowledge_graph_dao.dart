import 'package:drift/drift.dart';
import 'package:noema/core/database/database.dart';
import 'package:uuid/uuid.dart';

part 'knowledge_graph_dao.g.dart';

@DriftAccessor(tables: [KnowledgeGraph])
class KnowledgeGraphDao extends DatabaseAccessor<AppDatabase> with _$KnowledgeGraphDaoMixin {
  KnowledgeGraphDao(super.db);

  Future<int> insertKnowledgeGraph({
    required String userId,
    required String title,
    String? description,
    bool? isArchived,
    bool? synced,
  }) {
    return into(attachedDatabase.knowledgeGraph).insert(
      KnowledgeGraphCompanion.insert(
        id: Uuid().v4(),
        userId: userId,
        title: title,
        description: Value(description),
        isArchived: isArchived == null ? const Value.absent() : Value(isArchived),
        synced: synced == null ? const Value.absent() : Value(synced),
      ),
    );
  }

  Future<int> updateKnowledgeGraph({
    required String id,
    String? userId,
    String? title,
    String? description,
    bool? isArchived,
    bool? synced,
  }) {
    return (update(
      attachedDatabase.knowledgeGraph,
    )..where((tbl) => tbl.id.equals(id))).write(
      KnowledgeGraphCompanion(
        userId: userId == null ? const Value.absent() : Value(userId),
        title: title == null ? const Value.absent() : Value(title),
        description: description == null ? const Value.absent() : Value(description),
        isArchived: isArchived == null ? const Value.absent() : Value(isArchived),
        synced: synced == null ? const Value.absent() : Value(synced),
      ),
    );
  }

  Future<KnowledgeGraphData?> getKnowledgeGraph({required String id}) {
    return (select(attachedDatabase.knowledgeGraph)..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();
  }

  Future<List<KnowledgeGraphData>> getKnowledgeGraphsByUser({required String userId}) {
    return (select(attachedDatabase.knowledgeGraph)
          ..where((tbl) => tbl.userId.equals(userId))
          ..where((tbl) => tbl.softDeleted.equals(false)))
        .get();
  }

  Future<int> deleteKnowledgeGraph({required String id}) {
    return (update(
      attachedDatabase.knowledgeGraph,
    )..where((tbl) => tbl.id.equals(id))).write(
      KnowledgeGraphCompanion(
        softDeleted: const Value(true),
        softDeletedAt: Value(DateTime.now().millisecondsSinceEpoch,),
      ),
    );
  }
}
