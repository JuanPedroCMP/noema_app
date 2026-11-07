class LearningPathNode {
  const LearningPathNode({
    required this.id,
    required this.title,
    required this.masteryScore,
  });

  final String id;
  final String title;
  final double? masteryScore;
}

class LearningPathRelation {
  const LearningPathRelation({
    required this.sourceId,
    required this.targetId,
    required this.type,
  });

  final String sourceId;
  final String targetId;
  final String type;

  bool get gatesProgress =>
      type == 'PREREQUISITE' || type == 'SUBTOPIC';
}

enum LearningProgressStatus { mastered, ready, blocked }

class LearningNodeProgress {
  const LearningNodeProgress({
    required this.status,
    required this.unmetPrerequisiteIds,
    required this.subtopicIds,
    required this.parentTopicIds,
  });

  final LearningProgressStatus status;
  final List<String> unmetPrerequisiteIds;
  final List<String> subtopicIds;
  final List<String> parentTopicIds;
}

class LearningPath {
  LearningPath._({
    required this.progressByNodeId,
    required this.recommendedNodeIds,
    required this.masteredCount,
    required this.hasUnresolvedNodes,
  });

  static const masteryThreshold = 0.8;

  final Map<String, LearningNodeProgress> progressByNodeId;
  final List<String> recommendedNodeIds;
  final int masteredCount;
  final bool hasUnresolvedNodes;

  factory LearningPath.analyze({
    required List<LearningPathNode> nodes,
    required List<LearningPathRelation> relations,
  }) {
    final nodesById = {for (final node in nodes) node.id: node};
    final incoming = <String, List<LearningPathRelation>>{};
    final subtopicsByParent = <String, List<String>>{};
    final parentBySubtopic = <String, List<String>>{};
    final gatingRelations = <LearningPathRelation>[];
    for (final relation in relations) {
      if (!nodesById.containsKey(relation.sourceId) ||
          !nodesById.containsKey(relation.targetId)) {
        continue;
      }
      if (relation.type == 'PREREQUISITE') {
        gatingRelations.add(relation);
      }
      if (relation.type == 'SUBTOPIC') {
        gatingRelations.add(
          LearningPathRelation(
            sourceId: relation.targetId,
            targetId: relation.sourceId,
            type: relation.type,
          ),
        );
        subtopicsByParent
            .putIfAbsent(relation.targetId, () => [])
            .add(relation.sourceId);
        parentBySubtopic
            .putIfAbsent(relation.sourceId, () => [])
            .add(relation.targetId);
      }
    }
    for (final relation in gatingRelations) {
      incoming.putIfAbsent(relation.targetId, () => []).add(relation);
    }

    final masteryCache = <String, bool>{};
    bool isEffectivelyMastered(String nodeId, Set<String> visiting) {
      final cached = masteryCache[nodeId];
      if (cached != null) return cached;
      final node = nodesById[nodeId];
      if (node == null ||
          node.masteryScore == null ||
          !node.masteryScore!.isFinite ||
          node.masteryScore! < masteryThreshold ||
          !visiting.add(nodeId)) {
        return false;
      }

      final mastered = (incoming[nodeId] ?? const <LearningPathRelation>[])
          .every(
            (relation) => isEffectivelyMastered(
              relation.sourceId,
              {...visiting},
            ),
          );
      visiting.remove(nodeId);
      masteryCache[nodeId] = mastered;
      return mastered;
    }

    for (final node in nodes) {
      isEffectivelyMastered(node.id, <String>{});
    }

    final progressByNodeId = <String, LearningNodeProgress>{};
    final readyIds = <String>[];
    var masteredCount = 0;
    for (final node in nodes) {
      final unmet = (incoming[node.id] ?? const <LearningPathRelation>[])
          .where(
            (relation) =>
                !isEffectivelyMastered(relation.sourceId, <String>{}),
          )
          .map((relation) => relation.sourceId)
          .toSet()
          .toList();
      final mastered = isEffectivelyMastered(node.id, <String>{});
      final status = mastered
          ? LearningProgressStatus.mastered
          : unmet.isEmpty
          ? LearningProgressStatus.ready
          : LearningProgressStatus.blocked;
      if (mastered) masteredCount++;
      if (status == LearningProgressStatus.ready) readyIds.add(node.id);

      progressByNodeId[node.id] = LearningNodeProgress(
        status: status,
        unmetPrerequisiteIds: unmet,
        parentTopicIds: parentBySubtopic[node.id] ?? const <String>[],
        subtopicIds: mastered
            ? (subtopicsByParent[node.id] ?? const <String>[])
                  .where(
                    (id) => !isEffectivelyMastered(id, <String>{}),
                  )
                  .toSet()
                  .toList()
            : const [],
      );
    }

    int downstreamImpact(String nodeId) {
      final visited = <String>{nodeId};
      final pending = <String>[nodeId];
      while (pending.isNotEmpty) {
        final current = pending.removeLast();
        for (final relation in gatingRelations) {
          if (relation.sourceId != current ||
              !relation.gatesProgress ||
              !nodesById.containsKey(relation.targetId)) {
            continue;
          }
          if (visited.add(relation.targetId)) {
            pending.add(relation.targetId);
          }
        }
      }
      return visited
          .where(
            (id) =>
                id != nodeId &&
                progressByNodeId[id]?.status !=
                    LearningProgressStatus.mastered,
          )
          .length;
    }

    readyIds.sort((firstId, secondId) {
      final impact = downstreamImpact(secondId).compareTo(
        downstreamImpact(firstId),
      );
      if (impact != 0) return impact;
      return nodesById[firstId]!.title.toLowerCase().compareTo(
        nodesById[secondId]!.title.toLowerCase(),
      );
    });

    return LearningPath._(
      progressByNodeId: progressByNodeId,
      recommendedNodeIds: readyIds,
      masteredCount: masteredCount,
      hasUnresolvedNodes: masteredCount < nodes.length,
    );
  }
}
