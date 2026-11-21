import 'package:flutter_test/flutter_test.dart';
import 'package:noema/feature/exercises/data/study_pack_service.dart';

void main() {
  test('validates per-type limits and requires at least one item', () {
    expect(() => const StudyPackCounts().validate(), throwsArgumentError);
    expect(
      () => const StudyPackCounts(multipleChoice: 21).validate(),
      throwsArgumentError,
    );
    expect(
      () => const StudyPackCounts(essay: 2, flashcards: 3).validate(),
      returnsNormally,
    );
  });

  test('round-trips an offline-ready request payload', () {
    const request = StudyPackRequest(
      counts: StudyPackCounts(multipleChoice: 2, essay: 1, flashcards: 3),
      instructions: 'Foque nos conceitos principais.',
    );

    final restored = StudyPackRequest.fromJson(request.toJson());

    expect(restored.counts.multipleChoice, 2);
    expect(restored.counts.essay, 1);
    expect(restored.counts.flashcards, 3);
    expect(restored.instructions, request.instructions);
  });
}
