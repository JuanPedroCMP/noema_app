import 'package:flutter_test/flutter_test.dart';
import 'package:noema/feature/ai/services/ai_background_task_runner.dart';

void main() {
  test('applies bounded exponential delays before the final failure', () {
    expect(aiBackgroundRetryDelay(1), const Duration(seconds: 15));
    expect(aiBackgroundRetryDelay(2), const Duration(seconds: 45));
    expect(aiBackgroundRetryDelay(3), isNull);
    expect(maximumAiBackgroundAttempts, 3);
  });
}
