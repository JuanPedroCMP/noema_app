import 'package:flutter_test/flutter_test.dart';
import 'package:noema/feature/ai/models/ai_agent_task.dart';
import 'package:noema/feature/exercises/data/ai_exercise_evaluation.dart';

void main() {
  test('normalizes multiple-choice explanation and the objective score', () {
    final result = normalizeAiExerciseEvaluation(
      task: AiAgentTask.evaluateMultipleChoiceQuestion,
      response: const {
        'explanation': 'A alternativa está correta.',
        'tips': 'Revise o conceito de fotossíntese.',
      },
      context: const {'objective_score': 0.75},
    );

    expect(
      result['feedback'],
      'A alternativa está correta.\n\nRevise o conceito de fotossíntese.',
    );
    expect(result['score'], 0.75);
    expect(result['mastery_demonstrated'], 'ADEQUATE');
  });

  test(
    'derives Feynman score from backend rubric and reverses gap severity',
    () {
      final result = normalizeAiExerciseEvaluation(
        task: AiAgentTask.evaluateFeynman,
        response: const {
          'feedback': 'A explicação está clara.',
          'conceptualRequisites': {
            'fidelity_to_question': 80,
            'teoric_precision': 60,
            'response_deep': 70,
          },
          'textCoerence': {
            'coerence': 90,
            'argument_struct': 80,
            'argument_clarity': 70,
          },
          'feynmanRequisites': {
            'explanation_acessibility': 80,
            'logic_progression': 60,
            'gaps': 20,
          },
        },
        context: const {},
      );

      expect(result['feedback'], 'A explicação está clara.');
      expect(result['score'], closeTo(0.744444, 0.00001));
      expect(result['mastery_demonstrated'], 'ADEQUATE');
    },
  );

  test('does not silently accept incomplete rubric responses', () {
    expect(
      () => normalizeAiExerciseEvaluation(
        task: AiAgentTask.evaluateEssayQuestion,
        response: const {
          'feedback': 'Feedback',
          'conceptualRequisites': {'fidelity_to_question': 80},
        },
        context: const {},
      ),
      throwsFormatException,
    );
  });

  test('interprets rubric values as percentages, including the value one', () {
    final result = normalizeAiExerciseEvaluation(
      task: AiAgentTask.evaluateEssayQuestion,
      response: const {
        'feedback': 'Feedback',
        'conceptualRequisites': {
          'fidelity_to_question': 1,
          'teoric_precision': 0,
          'response_deep': 0,
        },
        'textCoerence': {
          'coerence': 0,
          'argument_struct': 0,
          'argument_clarity': 0,
        },
      },
      context: const {},
    );

    expect(result['score'], closeTo(1 / 600, 0.000001));
    expect(result['mastery_demonstrated'], 'WEAK');
  });
}
