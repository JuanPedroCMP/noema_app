import 'package:flutter_test/flutter_test.dart';
import 'package:noema/feature/study_assistant/models/study_assistant_action.dart';
import 'package:noema/feature/study_assistant/models/study_assistant_state.dart';

void main() {
  test(
    'parses supported actions and accepts snake-case resource identifiers',
    () {
      final action = StudyAssistantAction.fromJson({
        'type': 'create_exercise',
        'title': 'Praticar',
        'prompt': 'Foque em aplicações.',
        'exercise_type': 'open_ended',
        'graph_id': 'graph-1',
        'node_id': 'node-1',
      });

      expect(action?.type, StudyAssistantActionType.createExercise);
      expect(action?.exerciseType, 'open_ended');
      expect(action?.graphId, 'graph-1');
      expect(action?.nodeId, 'node-1');
    },
  );

  test('rejects unknown actions and limits untrusted text lengths', () {
    expect(
      StudyAssistantAction.fromJson({'type': 'delete_everything'}),
      isNull,
    );

    final action = StudyAssistantAction.fromJson({
      'type': 'create_graph',
      'title': List.filled(100, 't').join(),
      'prompt': List.filled(1500, 'p').join(),
    });

    expect(action?.title, hasLength(80));
    expect(action?.prompt, hasLength(1000));
  });

  test('automatic action generation is disabled by default', () {
    expect(const StudyAssistantSettings().autoGenerateActions, isFalse);
  });
}
