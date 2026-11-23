import 'package:flutter_test/flutter_test.dart';
import 'package:noema/feature/graph/providers/recommended_study_content_provider.dart';

void main() {
  test('automatic study generation is disabled unless explicitly enabled', () {
    final settings = RecommendedStudyContentSettings.fromPreference(null);

    expect(settings.enabled, isFalse);
    expect(settings.counts.multipleChoice, 2);
    expect(settings.counts.essay, 1);
    expect(settings.counts.feynman, 1);
    expect(settings.counts.flashcards, 3);
  });

  test('loads and preserves configured exercise quantities', () {
    final settings = RecommendedStudyContentSettings.fromPreference({
      'enabled': true,
      'multiple_choice': 4,
      'essay': 2,
      'feynman': 0,
      'flashcards': 5,
    });

    expect(settings.enabled, isTrue);
    expect(settings.counts.multipleChoice, 4);
    expect(settings.counts.essay, 2);
    expect(settings.counts.feynman, 0);
    expect(settings.counts.flashcards, 5);
  });

  test('uses the disabled default for invalid saved counts', () {
    final settings = RecommendedStudyContentSettings.fromPreference({
      'enabled': true,
      'multiple_choice': -1,
      'essay': 1,
      'feynman': 1,
      'flashcards': 3,
    });

    expect(settings.enabled, isFalse);
  });
}
