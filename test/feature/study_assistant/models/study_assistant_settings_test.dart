import 'package:flutter_test/flutter_test.dart';
import 'package:noema/feature/study_assistant/models/study_assistant_state.dart';

void main() {
  group('StudyAssistantSettings', () {
    test('uses safe defaults for pinning, response detail, and Enter', () {
      const settings = StudyAssistantSettings();

      expect(settings.pinPanel, isFalse);
      expect(settings.responseStyle, StudyAssistantResponseStyle.balanced);
      expect(settings.sendOnEnter, isFalse);
      expect(settings.autoGenerateActions, isFalse);
    });

    test('copyWith updates one preference without resetting others', () {
      const settings = StudyAssistantSettings(
        pinPanel: true,
        responseStyle: StudyAssistantResponseStyle.detailed,
        sendOnEnter: true,
      );

      final updated = settings.copyWith(sendOnEnter: false);

      expect(updated.pinPanel, isTrue);
      expect(updated.responseStyle, StudyAssistantResponseStyle.detailed);
      expect(updated.sendOnEnter, isFalse);
    });
  });

  group('StudyAssistantResponseStyle', () {
    test('reads supported values and defaults unknown values to balanced', () {
      expect(
        StudyAssistantResponseStyle.fromPreference('concise'),
        StudyAssistantResponseStyle.concise,
      );
      expect(
        StudyAssistantResponseStyle.fromPreference('detailed'),
        StudyAssistantResponseStyle.detailed,
      );
      expect(
        StudyAssistantResponseStyle.fromPreference('invalid'),
        StudyAssistantResponseStyle.balanced,
      );
    });
  });
}
