import 'package:flutter_test/flutter_test.dart';
import 'package:noema/feature/graph/service/learning_path.dart';

LearningPathNode _node(
  String id,
  String title, {
  double? score,
  String? type,
  bool reviewDue = false,
}) => LearningPathNode(
  id: id,
  title: title,
  masteryScore: score,
  type: type,
  reviewDue: reviewDue,
);

LearningPathRelation _edge(
  String source,
  String target, {
  String type = 'PREREQUISITE',
  double? weight,
}) => LearningPathRelation(
  sourceId: source,
  targetId: target,
  type: type,
  weight: weight,
);

void main() {
  test(
    'SUBTOPIC does not gate a node and containers aggregate leaf scores',
    () {
      final path = LearningPath.analyze(
        nodes: [
          _node('container', 'Tópico', score: 0.99, type: 'TOPIC'),
          _node('mastered', 'Folha dominada', score: 0.8),
          _node('unknown', 'Folha desconhecida'),
        ],
        relations: [
          _edge('mastered', 'container', type: 'SUBTOPIC'),
          _edge('unknown', 'container', type: 'SUBTOPIC'),
        ],
      );

      expect(path.progressByNodeId['container']!.masteryScore, 0.4);
      expect(
        path.progressByNodeId['container']!.status,
        LearningProgressStatus.ready,
      );
      expect(path.progressByNodeId['container']!.subtopicIds, [
        'mastered',
        'unknown',
      ]);
      expect(
        path.progressByNodeId['unknown']!.status,
        LearningProgressStatus.ready,
      );
      expect(path.recommendedNodeIds, ['unknown']);
    },
  );

  test('AREA/TOPIC containers are not recommended even without children', () {
    final path = LearningPath.analyze(
      nodes: [
        _node('area', 'Área', score: 0.95, type: 'AREA'),
        _node('topic', 'Tópico', score: 0.95, type: 'TOPIC'),
      ],
      relations: const [],
    );

    expect(path.progressByNodeId['area']!.masteryScore, 0);
    expect(path.progressByNodeId['topic']!.masteryScore, 0);
    expect(path.recommendedNodeIds, isEmpty);
  });

  test('essential prerequisites use weight and ready thresholds', () {
    final belowReady = LearningPath.analyze(
      nodes: [
        _node('foundation', 'Base', score: 0.59),
        _node('target', 'Alvo'),
      ],
      relations: [_edge('foundation', 'target', weight: 1.0)],
    );
    expect(
      belowReady.progressByNodeId['target']!.status,
      LearningProgressStatus.availableWithGaps,
    );
    expect(belowReady.recommendedNodeIds, ['foundation']);

    final atReadyThreshold = LearningPath.analyze(
      nodes: [_node('foundation', 'Base', score: 0.6), _node('target', 'Alvo')],
      relations: [_edge('foundation', 'target', weight: 0.7)],
    );
    expect(
      atReadyThreshold.progressByNodeId['target']!.status,
      LearningProgressStatus.ready,
    );
    expect(atReadyThreshold.recommendedNodeIds, ['foundation', 'target']);
  });

  test('weak prerequisites are suggestions and do not gate recommendation', () {
    final path = LearningPath.analyze(
      nodes: [_node('foundation', 'Base', score: 0.2), _node('target', 'Alvo')],
      relations: [_edge('foundation', 'target', weight: 0.69)],
    );

    expect(
      path.progressByNodeId['target']!.status,
      LearningProgressStatus.ready,
    );
    expect(path.progressByNodeId['target']!.unmetPrerequisiteIds, isEmpty);
    expect(path.progressByNodeId['target']!.suggestedPrerequisiteIds, [
      'foundation',
    ]);
    expect(path.recommendedNodeIds, containsAll(['foundation', 'target']));
  });

  test(
    'an ancestor gap does not invalidate a mastered prerequisite subtree',
    () {
      final path = LearningPath.analyze(
        nodes: [
          _node('foundation', 'Base', score: 0.2),
          _node('middle', 'Intermediário', score: 0.8),
          _node('advanced', 'Avançado'),
        ],
        relations: [
          _edge('foundation', 'middle', weight: 0.5),
          _edge('middle', 'advanced', weight: 1),
        ],
      );

      expect(
        path.progressByNodeId['middle']!.status,
        LearningProgressStatus.mastered,
      );
      expect(
        path.progressByNodeId['advanced']!.status,
        LearningProgressStatus.ready,
      );
      expect(path.recommendedNodeIds, contains('advanced'));
    },
  );

  test('builds an ordered path through all unmet essential prerequisites', () {
    final path = LearningPath.analyze(
      nodes: [
        _node('foundation', 'Fundamento', score: 0.2),
        _node('middle', 'Intermediário', score: 0.3),
        _node('target', 'Alvo'),
      ],
      relations: [_edge('foundation', 'middle'), _edge('middle', 'target')],
    );

    final target = path.progressByNodeId['target']!;
    expect(target.unmetPrerequisiteIds, ['middle']);
    expect(target.prerequisitePathNodeIds, ['foundation', 'middle']);

    final foundationReady = LearningPath.analyze(
      nodes: [
        _node('foundation', 'Fundamento', score: 0.6),
        _node('middle', 'Intermediário', score: 0.3),
        _node('target', 'Alvo'),
      ],
      relations: [_edge('foundation', 'middle'), _edge('middle', 'target')],
    );
    expect(
      foundationReady.progressByNodeId['target']!.prerequisitePathNodeIds,
      ['middle'],
    );
  });

  test('keeps all foundation steps ahead of deeper route layers', () {
    final path = LearningPath.analyze(
      nodes: [
        _node('broad', 'Base compartilhada'),
        _node('second', 'Outra base'),
        _node('middle-a', 'Intermediário A'),
        _node('middle-b', 'Intermediário B'),
        _node('target', 'Alvo'),
      ],
      relations: [
        _edge('broad', 'middle-a'),
        _edge('broad', 'middle-b'),
        _edge('middle-a', 'target'),
        _edge('middle-b', 'target'),
        _edge('second', 'target'),
      ],
    );

    expect(path.progressByNodeId['target']!.prerequisitePathNodeIds, [
      'broad',
      'second',
      'middle-a',
      'middle-b',
    ]);
  });

  test(
    'recommendations sort by due review, layer, downstream impact, title, id',
    () {
      final path = LearningPath.analyze(
        nodes: [
          _node('root-z', 'Z base', score: 0.6),
          _node('root-a', 'A base', score: 0.6),
          _node('second', 'Segundo nível'),
          _node(
            'due-mastered',
            'Revisão dominada vencida',
            score: 0.9,
            reviewDue: true,
          ),
          _node('due', 'Revisão vencida', reviewDue: true),
          _node('child-a', 'Mesmo título'),
          _node('child-b', 'Mesmo título'),
        ],
        relations: [
          _edge('root-z', 'second'),
          _edge('root-z', 'child-a'),
          _edge('root-z', 'child-b'),
          _edge('root-a', 'second'),
        ],
      );

      expect(path.recommendedNodeIds.first, 'due-mastered');
      expect(path.recommendedNodeIds[1], 'due');
      expect(path.recommendedNodeIds[2], 'root-z');
      expect(
        path.recommendedNodeIds.indexOf('root-a'),
        lessThan(path.recommendedNodeIds.indexOf('second')),
      );
      expect(
        path.recommendedNodeIds.indexOf('child-a'),
        lessThan(path.recommendedNodeIds.indexOf('child-b')),
      );
    },
  );

  test(
    'first recommendation identifies the highest-impact valid starting point',
    () {
      final path = LearningPath.analyze(
        nodes: [
          _node('transferable', 'Fundamento transferível'),
          _node('narrow', 'Fundamento específico'),
          _node('middle-a', 'Conceito intermediário A'),
          _node('middle-b', 'Conceito intermediário B'),
          _node('target', 'Objetivo final'),
        ],
        relations: [
          _edge('transferable', 'middle-a'),
          _edge('transferable', 'middle-b'),
          _edge('middle-a', 'target'),
          _edge('middle-b', 'target'),
          _edge('narrow', 'target'),
        ],
      );

      expect(path.recommendedNodeIds.first, 'transferable');
    },
  );

  test(
    'thresholds are named and unmet cycle prerequisites stay unavailable',
    () {
      expect(LearningPath.masteryThreshold, 0.8);
      expect(LearningPath.readyThreshold, 0.6);
      expect(LearningPath.essentialWeight, 0.7);

      final path = LearningPath.analyze(
        nodes: [
          _node('first', 'Primeiro', score: 0.1),
          _node('second', 'Segundo', score: 0.1),
        ],
        relations: [_edge('first', 'second'), _edge('second', 'first')],
      );
      expect(path.masteredCount, 0);
      expect(path.recommendedNodeIds, isEmpty);
      expect(path.hasUnresolvedNodes, isTrue);
      expect(path.progressByNodeId['first']!.prerequisitePathNodeIds, isEmpty);
    },
  );
}
