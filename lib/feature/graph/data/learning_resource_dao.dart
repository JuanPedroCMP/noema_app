import 'package:drift/drift.dart';
import 'package:noema/core/database/database.dart';
import 'package:uuid/uuid.dart';

part 'learning_resource_dao.g.dart';

@DriftAccessor(tables: [LearningResource])
class LearningResourceDao extends DatabaseAccessor<AppDatabase> with _$LearningResourceDaoMixin {
  LearningResourceDao(super.db);

  Future<int> insertLearningResource({
    required String nodeId,
    required String category,
    required String title,
    String? author,
    String? url,
    required String tier,
    required String rationale,
    required double relevanceScore,
    required double reputationScore,
    bool? isAiGenerated,
    bool? userEdited,
  }) {
    return into(attachedDatabase.learningResource).insert(
      LearningResourceCompanion.insert(
        id: Uuid().v4(),
        nodeId: nodeId,
        category: category,
        title: title,
        author: Value(author),
        url: Value(url),
        tier: tier,
        rationale: rationale,
        relevanceScore: relevanceScore,
        reputationScore: reputationScore,
        isAiGenerated: isAiGenerated == null ? const Value.absent() : Value(isAiGenerated),
        userEdited: userEdited == null ? const Value.absent() : Value(userEdited),
      ),
    );
  }

  Future<int> updateLearningResource({
    required String id,
    String? nodeId,
    String? category,
    String? title,
    String? author,
    String? url,
    String? tier,
    String? rationale,
    double? relevanceScore,
    double? reputationScore,
    bool? isAiGenerated,
    bool? userEdited,
  }) {
    return (update(
      attachedDatabase.learningResource,
    )..where((tbl) => tbl.id.equals(id))).write(
      LearningResourceCompanion(
        nodeId: nodeId == null ? const Value.absent() : Value(nodeId),
        category: category == null ? const Value.absent() : Value(category),
        title: title == null ? const Value.absent() : Value(title),
        author: author == null ? const Value.absent() : Value(author),
        url: url == null ? const Value.absent() : Value(url),
        tier: tier == null ? const Value.absent() : Value(tier),
        rationale: rationale == null ? const Value.absent() : Value(rationale),
        relevanceScore: relevanceScore == null ? const Value.absent() : Value(relevanceScore),
        reputationScore: reputationScore == null ? const Value.absent() : Value(reputationScore),
        isAiGenerated: isAiGenerated == null ? const Value.absent() : Value(isAiGenerated),
        userEdited: userEdited == null ? const Value.absent() : Value(userEdited),
      ),
    );
  }

  Future<LearningResourceData?> getLearningResource({required String id}) {
    return (select(attachedDatabase.learningResource)..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();
  }

  Future<List<LearningResourceData>> getLearningResourcesByNode({required String nodeId}) {
    return (select(attachedDatabase.learningResource)
          ..where((tbl) => tbl.nodeId.equals(nodeId))
          ..where((tbl) => tbl.softDeleted.equals(false)))
        .get();
  }

  Future<int> deleteLearningResource({required String id}) {
    return (update(
      attachedDatabase.learningResource,
    )..where((tbl) => tbl.id.equals(id))).write(
      LearningResourceCompanion(
        softDeleted: const Value(true),
        softDeletedAt: Value(DateTime.now().millisecondsSinceEpoch),
      ),
    );
  }
}
