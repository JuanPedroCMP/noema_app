import 'package:flutter_test/flutter_test.dart';
import 'package:noema/feature/config/data/google_drive/automatic_backup_scheduler.dart';

void main() {
  group('backupFrequencyDuration', () {
    test('maps never and legacy preferences without scheduling work', () {
      expect(backupFrequencyDuration('never', 1), isNull);
      expect(backupFrequencyDuration('manual', 1), isNull);
      expect(backupFrequencyDuration('weekly', 1), const Duration(days: 7));
    });

    test('supports daily and custom day/hour intervals', () {
      expect(backupFrequencyDuration('daily', 1), const Duration(days: 1));
      expect(backupFrequencyDuration('every_days', 3), const Duration(days: 3));
      expect(
        backupFrequencyDuration('every_hours', 4),
        const Duration(hours: 4),
      );
    });

    test('rejects intervals outside the supported ranges', () {
      expect(
        () => backupFrequencyDuration('every_hours', 25),
        throwsRangeError,
      );
      expect(() => backupFrequencyDuration('every_days', 0), throwsRangeError);
    });
  });

  group('backupScheduleDuration', () {
    test('uses the new schedule while preserving legacy preferences', () {
      expect(
        backupScheduleDuration({'unit': 'days', 'interval': 5}, 'manual'),
        const Duration(days: 5),
      );
      expect(backupScheduleDuration({'unit': 'never'}, 'daily'), isNull);
      expect(backupScheduleDuration(null, 'weekly'), const Duration(days: 7));
    });

    test('rejects malformed custom schedules', () {
      expect(
        () => backupScheduleDuration({'unit': 'hours', 'interval': 25}, null),
        throwsFormatException,
      );
      expect(
        () => backupScheduleDuration('hours', null),
        throwsFormatException,
      );
    });
  });
}
