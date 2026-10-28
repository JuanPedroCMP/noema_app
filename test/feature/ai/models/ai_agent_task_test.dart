import 'package:flutter_test/flutter_test.dart';
import 'package:noema/feature/ai/models/ai_agent_task.dart';

void main() {
  test('all configured agent task wire names are recognized', () {
    for (final task in AiAgentTask.values) {
      expect(AiAgentTask.fromWireName(task.wireName), task);
    }
  });

  test('legacy backend task spellings are normalized safely', () {
    expect(
      AiAgentTask.fromWireName('evaluate_feynman'),
      AiAgentTask.evaluateFeynman,
    );
    expect(
      AiAgentTask.fromWireName('create_flashcards'),
      AiAgentTask.createFlashcards,
    );
    expect(
      AiAgentTask.fromWireName('generate_node_description'),
      AiAgentTask.generateNodeDescription,
    );
  });

  test('unknown task names remain unsupported', () {
    expect(AiAgentTask.fromWireName('unknown_task'), isNull);
  });
}
