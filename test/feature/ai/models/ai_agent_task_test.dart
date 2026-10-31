import 'package:flutter_test/flutter_test.dart';
import 'package:noema/feature/ai/models/ai_agent_task.dart';
import 'package:noema/feature/ai/services/ai_content_generation_service.dart';

void main() {
  test('all configured agent task wire names are recognized', () {
    for (final task in AiAgentTask.values) {
      expect(AiAgentTask.fromWireName(task.wireName), task);
    }
  });

  test('study assistant agent uses its backend task identifier', () {
    expect(
      AiAgentTask.fromWireName('study_assistant'),
      AiAgentTask.studyAssistant,
    );
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

  test('generation prompt stays unchanged when context is omitted', () {
    expect(
      AiContentGenerationService.buildUserPrompt(prompt: '  tema  '),
      'tema',
    );
  });

  test('generation prompt includes only explicitly supplied context', () {
    expect(
      AiContentGenerationService.buildUserPrompt(
        prompt: 'Crie um exercício.',
        context: const {
          'node': {'title': 'Fotossíntese', 'description': 'Processo vegetal'},
        },
      ),
      'Crie um exercício.\n\nContexto relevante (JSON):\n'
      '{"node":{"title":"Fotossíntese","description":"Processo vegetal"}}',
    );
  });
}
