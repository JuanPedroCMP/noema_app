class LearningPathNode {
  const LearningPathNode({
    required this.id,
    required this.title,
    required this.masteryScore,
    this.type,
    this.reviewDue = false,
  });

  final String id;
  final String title;
  final double? masteryScore;
  final String? type;
  final bool reviewDue;
}

class LearningPathRelation {
  const LearningPathRelation({
    required this.sourceId,
    required this.targetId,
    required this.type,
    this.weight = 1.0,
  });

  final String sourceId;
  final String targetId;
  final String type;
  final double? weight;

  bool get isEssential =>
      type == 'PREREQUISITE' &&
      (weight ?? 1.0) >= LearningPath.essentialWeight;
}

enum LearningProgressStatus { mastered, ready, availableWithGaps }

class LearningNodeProgress {
  const LearningNodeProgress({
    required this.status,
    required this.masteryScore,
    required this.unmetPrerequisiteIds,
    required this.suggestedPrerequisiteIds,
    required this.subtopicIds,
    required this.parentTopicIds,
    required this.isContainer,
  });

  final LearningProgressStatus status;
  final double? masteryScore;
  final List<String> unmetPrerequisiteIds;
  final List<String> suggestedPrerequisiteIds;
  final List<String> subtopicIds;
  final List<String> parentTopicIds;
  final bool isContainer;
}

class LearningPath {
  LearningPath._({
    required this.progressByNodeId,
    required this.recommendedNodeIds,
    required this.masteredCount,
    required this.hasUnresolvedNodes,
  });

  static const masteryThreshold = 0.8;
  static const readyThreshold = 0.6;
  static const essentialWeight = 0.7;

  final Map<String, LearningNodeProgress> progressByNodeId;
  final List<String> recommendedNodeIds;
  final int masteredCount;
  final bool hasUnresolvedNodes;

  factory LearningPath.analyze({
    required List<LearningPathNode> nodes,
    required List<LearningPathRelation> relations,
  }) {
    final nodesById = {for (final node in nodes) node.id: node};
    final subtopicsByParent = <String, List<String>>{};
    final parentBySubtopic = <String, List<String>>{};
    final prerequisitesByTarget = <String, List<LearningPathRelation>>{};

    for (final relation in relations) {
      if (!nodesById.containsKey(relation.sourceId) ||
          !nodesById.containsKey(relation.targetId)) {
        continue;
      }
      if (relation.type == 'SUBTOPIC') {
        subtopicsByParent
            .putIfAbsent(relation.targetId, () => [])
            .add(relation.sourceId);
        parentBySubtopic
            .putIfAbsent(relation.sourceId, () => [])
            .add(relation.targetId);
      } else if (relation.type == 'PREREQUISITE') {
        prerequisitesByTarget
            .putIfAbsent(relation.targetId, () => [])
            .add(relation);
      }
    }

    final containers = {
      ...subtopicsByParent.keys,
      for (final node in nodes)
        if (node.type?.toUpperCase() == 'AREA' ||
            node.type?.toUpperCase() == 'TOPIC')
          node.id,
    };
    final descendantsByContainer = <String, List<String>>{};
    List<String> leafDescendants(String id, Set<String> visiting) {
      if (!visiting.add(id)) return const [];
      final children = subtopicsByParent[id] ?? const <String>[];
      if (children.isEmpty) {
        return containers.contains(id) ? const [] : [id];
      }
      return [
        for (final child in children) ...leafDescendants(child, {...visiting}),
      ];
    }

    for (final containerId in containers) {
      descendantsByContainer[containerId] = leafDescendants(
        containerId,
        <String>{},
      );
    }

    double scoreFor(String id) {
      final descendants = descendantsByContainer[id];
      if (descendants != null) {
        if (descendants.isEmpty) return 0;
        return descendants
                .map((leafId) => _normalizedScore(nodesById[leafId]?.masteryScore))
                .fold<double>(0, (total, score) => total + score) /
            descendants.length;
      }
      return _normalizedScore(nodesById[id]?.masteryScore);
    }

    final progressByNodeId = <String, LearningNodeProgress>{};
    final essentialGapsByNodeId = <String, List<String>>{};
    var masteredCount = 0;

    for (final node in nodes) {
      final isContainer = containers.contains(node.id);
      final prerequisiteRelations = (prerequisitesByTarget[node.id] ??
              const <LearningPathRelation>[])
          .where(
            (relation) =>
                !containers.contains(relation.sourceId) &&
                !containers.contains(relation.targetId),
          )
          .toList();
      final gaps = prerequisiteRelations
          .where(
            (relation) =>
                relation.isEssential &&
                scoreFor(relation.sourceId) < readyThreshold,
          )
          .map((relation) => relation.sourceId)
          .toSet()
          .toList();
      final suggestedGaps = prerequisiteRelations
          .where(
            (relation) =>
                !relation.isEssential &&
                scoreFor(relation.sourceId) < readyThreshold,
          )
          .map((relation) => relation.sourceId)
          .toSet()
          .toList();
      essentialGapsByNodeId[node.id] = gaps;

      final score = scoreFor(node.id);
      final mastered = score >= masteryThreshold;
      final status = mastered
          ? LearningProgressStatus.mastered
          : gaps.isNotEmpty
          ? LearningProgressStatus.availableWithGaps
          : LearningProgressStatus.ready;
      if (mastered) masteredCount++;

      progressByNodeId[node.id] = LearningNodeProgress(
        status: status,
        masteryScore: isContainer
            ? score
            : _displayScore(nodesById[node.id]?.masteryScore),
        unmetPrerequisiteIds: gaps,
        suggestedPrerequisiteIds: suggestedGaps,
        parentTopicIds: parentBySubtopic[node.id] ?? const [],
        subtopicIds: subtopicsByParent[node.id] ?? const [],
        isContainer: isContainer,
      );
    }

    final essentialPrerequisites = <String, List<String>>{};
    for (final relation in relations) {
      if (relation.type != 'PREREQUISITE' ||
          !relation.isEssential ||
          !nodesById.containsKey(relation.sourceId) ||
          !nodesById.containsKey(relation.targetId) ||
          containers.contains(relation.sourceId) ||
          containers.contains(relation.targetId)) {
        continue;
      }
      essentialPrerequisites
          .putIfAbsent(relation.targetId, () => [])
          .add(relation.sourceId);
    }

    final depthByNodeId = <String, int>{};
    int depthFor(String id, Set<String> visiting) {
      final cached = depthByNodeId[id];
      if (cached != null) return cached;
      if (!visiting.add(id)) return 0;
      final prerequisites = essentialPrerequisites[id] ?? const <String>[];
      final depth = prerequisites.isEmpty
          ? 0
          : prerequisites
                    .map(
                      (prerequisiteId) =>
                          depthFor(prerequisiteId, {...visiting}) + 1,
                    )
                    .fold<int>(0, (maximum, value) => value > maximum ? value : maximum);
      depthByNodeId[id] = depth;
      return depth;
    }

    for (final node in nodes) {
      depthFor(node.id, <String>{});
    }

    int downstreamImpact(String nodeId) {
      final visited = <String>{nodeId};
      final pending = <String>[nodeId];
      while (pending.isNotEmpty) {
        final current = pending.removeLast();
        for (final targetId in essentialPrerequisites.keys) {
          if (!(essentialPrerequisites[targetId] ?? const []).contains(current) ||
              progressByNodeId[targetId]?.status ==
                  LearningProgressStatus.mastered) {
            continue;
          }
          if (visited.add(targetId)) pending.add(targetId);
        }
      }
      return visited.length - 1;
    }

    final recommendedIds = nodes
        .where(
          (node) =>
              !containers.contains(node.id) &&
              (progressByNodeId[node.id]?.status !=
                      LearningProgressStatus.mastered ||
                  node.reviewDue) &&
              (essentialGapsByNodeId[node.id]?.isEmpty ?? true),
        )
        .map((node) => node.id)
        .toList();
    recommendedIds.sort((firstId, secondId) {
      final first = nodesById[firstId]!;
      final second = nodesById[secondId]!;
      final byReview = (second.reviewDue ? 1 : 0).compareTo(
        first.reviewDue ? 1 : 0,
      );
      if (byReview != 0) return byReview;
      final byLayer = (depthByNodeId[firstId] ?? 0).compareTo(
        depthByNodeId[secondId] ?? 0,
      );
      if (byLayer != 0) return byLayer;
      final byImpact = downstreamImpact(secondId).compareTo(
        downstreamImpact(firstId),
      );
      if (byImpact != 0) return byImpact;
      final byTitle = first.title.toLowerCase().compareTo(
        second.title.toLowerCase(),
      );
      return byTitle != 0 ? byTitle : firstId.compareTo(secondId);
    });

    return LearningPath._(
      progressByNodeId: progressByNodeId,
      recommendedNodeIds: recommendedIds,
      masteredCount: masteredCount,
      hasUnresolvedNodes: masteredCount < nodes.length,
    );
  }
}

double _normalizedScore(double? score) =>
    score == null || !score.isFinite ? 0 : score.clamp(0, 1).toDouble();

double? _displayScore(double? score) =>
    score == null || !score.isFinite ? null : score.clamp(0, 1).toDouble();
