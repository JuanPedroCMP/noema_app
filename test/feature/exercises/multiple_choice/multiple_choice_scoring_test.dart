import 'package:flutter_test/flutter_test.dart';
import 'package:noema/feature/exercises/multiple_choice/data/multiple_choice_scoring.dart';

void main() {
  const choices = [
    WeightedChoice(id: 'correct', isCorrect: true, weight: 3),
    WeightedChoice(id: 'incorrect', isCorrect: false, weight: 2),
  ];

  test('adds correct weight and subtracts selected incorrect weight', () {
    final score = calculateMultipleChoiceScore(
      choices: choices,
      selectedChoiceIds: {'correct', 'incorrect'},
    );

    expect(score.points, 1);
    expect(score.maximumPoints, 3);
    expect(score.normalizedScore, closeTo(1 / 3, 0.0001));
  });

  test('penalizes an incorrect-only answer and defaults zero weights to one', () {
    final wrongAnswer = calculateMultipleChoiceScore(
      choices: choices,
      selectedChoiceIds: {'incorrect'},
    );
    final defaultWeights = calculateMultipleChoiceScore(
      choices: const [
        WeightedChoice(id: 'correct', isCorrect: true, weight: 0),
        WeightedChoice(id: 'incorrect', isCorrect: false, weight: null),
      ],
      selectedChoiceIds: {'correct'},
    );

    expect(wrongAnswer.points, -2);
    expect(wrongAnswer.normalizedScore, 0);
    expect(defaultWeights.points, 1);
    expect(defaultWeights.normalizedScore, 1);
  });
}
