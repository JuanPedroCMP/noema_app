class WeightedChoice {
  const WeightedChoice({
    required this.id,
    required this.isCorrect,
    required this.weight,
  });

  final String id;
  final bool isCorrect;
  final int? weight;
}

class MultipleChoiceScore {
  const MultipleChoiceScore({
    required this.points,
    required this.maximumPoints,
    required this.normalizedScore,
  });

  final int points;
  final int maximumPoints;
  final double normalizedScore;
}

MultipleChoiceScore calculateMultipleChoiceScore({
  required Iterable<WeightedChoice> choices,
  required Set<String> selectedChoiceIds,
}) {
  var maximumPoints = 0;
  var points = 0;

  for (final choice in choices) {
    final weight = choice.weight ?? 1;
    if (weight < 0) {
      throw ArgumentError.value(
        weight,
        'weight',
        'Alternative weights must not be negative.',
      );
    }

    final effectiveWeight = weight == 0 ? 1 : weight;
    if (choice.isCorrect) maximumPoints += effectiveWeight;
    if (selectedChoiceIds.contains(choice.id)) {
      points += choice.isCorrect ? effectiveWeight : -effectiveWeight;
    }
  }

  if (maximumPoints == 0) {
    throw ArgumentError('At least one correct answer is required.');
  }

  return MultipleChoiceScore(
    points: points,
    maximumPoints: maximumPoints,
    normalizedScore: (points / maximumPoints).clamp(0.0, 1.0),
  );
}
