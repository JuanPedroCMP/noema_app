import 'package:flutter_test/flutter_test.dart';
import 'package:noema/feature/graph/service/learning_path.dart';

void main() {
  const foundations = LearningPathNode(
    id: 'foundations',
    title: 'Fundamentos',
    masteryScore: 0.2,
  );
  const advanced = LearningPathNode(
    id: 'advanced',
    title: 'Tópico avançado',
    masteryScore: null,
  );
  const subtopic = LearningPathNode(
    id: 'subtopic',
    title: 'Subtópico',
    masteryScore: null,
  );

  test('recommends an unmet prerequisite before its advanced topic', () {
    final path = LearningPath.analyze(
      nodes: [foundations, advanced],
      relations: const [
        LearningPathRelation(
          sourceId: 'foundations',
          targetId: 'advanced',
          type: 'PREREQUISITE',
        ),
      ],
    );

    expect(path.recommendedNodeIds, ['foundations']);
    expect(path.progressByNodeId['advanced']!.unmetPrerequisiteIds, [
      'foundations',
    ]);
    expect(
      path.progressByNodeId['advanced']!.status,
      LearningProgressStatus.blocked,
    );
  });

  test('unlocks and recommends a child after its parent is mastered', () {
    final masteredParent = const LearningPathNode(
      id: 'parent',
      title: 'Tópico superior',
      masteryScore: 0.8,
    );
    final path = LearningPath.analyze(
      nodes: [masteredParent, subtopic],
      relations: const [
        LearningPathRelation(
          sourceId: 'subtopic',
          targetId: 'parent',
          type: 'SUBTOPIC',
        ),
      ],
    );

    expect(path.recommendedNodeIds, ['subtopic']);
    expect(path.progressByNodeId['parent']!.subtopicIds, ['subtopic']);
    expect(
      path.progressByNodeId['subtopic']!.status,
      LearningProgressStatus.ready,
    );
  });

  test('keeps a subtopic blocked while its superior topic is not mastered', () {
    final path = LearningPath.analyze(
      nodes: [
        const LearningPathNode(
          id: 'parent',
          title: 'Tópico superior',
          masteryScore: 0.79,
        ),
        subtopic,
      ],
      relations: const [
        LearningPathRelation(
          sourceId: 'subtopic',
          targetId: 'parent',
          type: 'SUBTOPIC',
        ),
      ],
    );

    expect(path.recommendedNodeIds, ['parent']);
    expect(
      path.progressByNodeId['subtopic']!.unmetPrerequisiteIds,
      ['parent'],
    );
    expect(
      path.progressByNodeId['subtopic']!.parentTopicIds,
      ['parent'],
    );
  });

  test('uses the parent as a prerequisite for its subtopic', () {
    final path = LearningPath.analyze(
      nodes: [
        const LearningPathNode(
          id: 'parent',
          title: 'Tópico superior',
          masteryScore: 0.9,
        ),
        const LearningPathNode(
          id: 'child',
          title: 'Subtópico',
          masteryScore: null,
        ),
        const LearningPathNode(
          id: 'child-foundation',
          title: 'Fundamento do subtópico',
          masteryScore: 0.4,
        ),
      ],
      relations: const [
        LearningPathRelation(
          sourceId: 'child',
          targetId: 'parent',
          type: 'SUBTOPIC',
        ),
        LearningPathRelation(
          sourceId: 'child-foundation',
          targetId: 'child',
          type: 'PREREQUISITE',
        ),
      ],
    );

    expect(path.progressByNodeId['parent']!.subtopicIds, ['child']);
    expect(path.recommendedNodeIds, ['child-foundation']);
    expect(
      path.progressByNodeId['child']!.status,
      LearningProgressStatus.blocked,
    );
  });

  test('requires every prerequisite to be strongly mastered', () {
    final path = LearningPath.analyze(
      nodes: [
        const LearningPathNode(
          id: 'first',
          title: 'Primeiro',
          masteryScore: 0.8,
        ),
        const LearningPathNode(
          id: 'second',
          title: 'Segundo',
          masteryScore: 0.79,
        ),
        advanced,
      ],
      relations: const [
        LearningPathRelation(
          sourceId: 'first',
          targetId: 'advanced',
          type: 'PREREQUISITE',
        ),
        LearningPathRelation(
          sourceId: 'second',
          targetId: 'advanced',
          type: 'PREREQUISITE',
        ),
      ],
    );

    expect(path.recommendedNodeIds, ['second']);
    expect(path.progressByNodeId['advanced']!.unmetPrerequisiteIds, ['second']);
  });

  test('does not skip an unmet prerequisite further up the learning chain', () {
    final path = LearningPath.analyze(
      nodes: [
        const LearningPathNode(
          id: 'foundation',
          title: 'Fundamento',
          masteryScore: 0.4,
        ),
        const LearningPathNode(
          id: 'middle',
          title: 'Tópico intermediário',
          masteryScore: 0.95,
        ),
        const LearningPathNode(
          id: 'advanced',
          title: 'Tópico avançado',
          masteryScore: 0.95,
        ),
      ],
      relations: const [
        LearningPathRelation(
          sourceId: 'foundation',
          targetId: 'middle',
          type: 'PREREQUISITE',
        ),
        LearningPathRelation(
          sourceId: 'middle',
          targetId: 'advanced',
          type: 'PREREQUISITE',
        ),
      ],
    );

    expect(path.recommendedNodeIds, ['foundation']);
    expect(path.masteredCount, 0);
    expect(path.progressByNodeId['advanced']!.unmetPrerequisiteIds, ['middle']);
    expect(path.progressByNodeId['middle']!.unmetPrerequisiteIds, [
      'foundation',
    ]);
  });

  test('does not make a circular prerequisite chain appear mastered', () {
    final path = LearningPath.analyze(
      nodes: [
        const LearningPathNode(
          id: 'first',
          title: 'Primeiro',
          masteryScore: 0.95,
        ),
        const LearningPathNode(
          id: 'second',
          title: 'Segundo',
          masteryScore: 0.95,
        ),
      ],
      relations: const [
        LearningPathRelation(
          sourceId: 'first',
          targetId: 'second',
          type: 'PREREQUISITE',
        ),
        LearningPathRelation(
          sourceId: 'second',
          targetId: 'first',
          type: 'PREREQUISITE',
        ),
      ],
    );

    expect(path.masteredCount, 0);
    expect(path.recommendedNodeIds, isEmpty);
    expect(path.hasUnresolvedNodes, isTrue);
  });
}
