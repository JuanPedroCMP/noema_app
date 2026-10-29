import 'package:flutter_test/flutter_test.dart';
import 'package:fsrs/fsrs.dart' as fsrs;
import 'package:noema/feature/review/data/domain_mastery_service.dart';

void main() {
  test('uses performance evidence for a new concept', () {
    final update = DomainMasteryUpdate.calculate(
      previousScore: null,
      previousReviewCount: 0,
      rating: fsrs.Rating.good,
      assessmentScore: 0.8,
    );

    expect(update.scoreBefore, 0.5);
    expect(update.scoreAfter, closeTo(0.79, 0.0001));
    expect(update.levelBefore, isNull);
    expect(update.levelAfter, 'ADEQUATE');
  });

  test('considers elapsed retention and experience frequency', () {
    final recent = DomainMasteryUpdate.calculate(
      previousScore: 0.9,
      previousReviewCount: 0,
      rating: fsrs.Rating.again,
      retrievability: 1,
    );
    final frequent = DomainMasteryUpdate.calculate(
      previousScore: 0.9,
      previousReviewCount: 4,
      rating: fsrs.Rating.again,
      retrievability: 1,
    );
    final forgotten = DomainMasteryUpdate.calculate(
      previousScore: 0.9,
      previousReviewCount: 4,
      rating: fsrs.Rating.again,
      retrievability: 0.2,
    );

    expect(recent.scoreAfter, lessThan(0.9));
    expect(frequent.scoreAfter, greaterThan(recent.scoreAfter));
    expect(forgotten.scoreAfter, lessThan(frequent.scoreAfter));
    expect(forgotten.scoreAfter, inInclusiveRange(0, 1));
  });

  test('maps mastery levels at deterministic boundaries', () {
    expect(DomainMasteryUpdate.levelForScore(0.39), 'WEAK');
    expect(DomainMasteryUpdate.levelForScore(0.4), 'PARTIAL');
    expect(DomainMasteryUpdate.levelForScore(0.6), 'ADEQUATE');
    expect(DomainMasteryUpdate.levelForScore(0.8), 'STRONG');
  });
}
