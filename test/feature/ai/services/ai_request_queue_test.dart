import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:noema/feature/ai/services/ai_request_queue.dart';

void main() {
  test(
    'runs automatic requests sequentially when concurrency is one',
    () async {
      final queue = AiRequestQueue();
      final firstGate = Completer<void>();
      final secondStarted = Completer<void>();
      var startedRequests = 0;

      final first = queue.run<void>(
        priority: AiRequestPriority.background,
        backgroundConcurrencyLimit: 1,
        action: () async {
          startedRequests++;
          await firstGate.future;
        },
      );
      final second = queue.run<void>(
        priority: AiRequestPriority.background,
        backgroundConcurrencyLimit: 1,
        action: () async {
          startedRequests++;
          secondStarted.complete();
        },
      );

      expect(startedRequests, 1);
      expect(queue.pendingBackgroundRequests, 1);
      firstGate.complete();
      await first;
      await secondStarted.future;
      await second;
      expect(startedRequests, 2);
      expect(queue.activeBackgroundRequests, 0);
      expect(queue.pendingBackgroundRequests, 0);
    },
  );

  test(
    'runs automatic requests up to the configured concurrency limit',
    () async {
      final queue = AiRequestQueue();
      final firstGate = Completer<void>();
      final thirdStarted = Completer<void>();
      var startedRequests = 0;
      Future<void> startRequest({bool notifyThird = false}) async {
        startedRequests++;
        if (notifyThird) thirdStarted.complete();
        if (startedRequests <= 2) await firstGate.future;
      }

      final requests = List.generate(
        3,
        (index) => queue.run<void>(
          priority: AiRequestPriority.background,
          backgroundConcurrencyLimit: 2,
          action: () => startRequest(notifyThird: index == 2),
        ),
      );

      expect(startedRequests, 2);
      firstGate.complete();
      await thirdStarted.future;
      await Future.wait(requests);
      expect(startedRequests, 3);
      expect(queue.activeBackgroundRequests, 0);
    },
  );

  test('user requests bypass active and queued background work', () async {
    final queue = AiRequestQueue();
    final backgroundGate = Completer<void>();
    var automaticCompleted = false;

    final activeBackground = queue.run<void>(
      priority: AiRequestPriority.background,
      backgroundConcurrencyLimit: 1,
      action: () async => backgroundGate.future,
    );
    final queuedBackground = queue.run<void>(
      priority: AiRequestPriority.background,
      backgroundConcurrencyLimit: 1,
      action: () async {
        automaticCompleted = true;
      },
    );

    var userCompleted = false;
    await queue.run<void>(
      priority: AiRequestPriority.user,
      action: () async {
        userCompleted = true;
      },
    );

    expect(userCompleted, isTrue);
    expect(automaticCompleted, isFalse);
    backgroundGate.complete();
    await Future.wait([activeBackground, queuedBackground]);
    expect(automaticCompleted, isTrue);
  });

  test('rejects concurrency outside the supported schema range', () {
    final queue = AiRequestQueue();

    expect(
      () => queue.run<void>(
        priority: AiRequestPriority.background,
        backgroundConcurrencyLimit: 9,
        action: () async {},
      ),
      throwsArgumentError,
    );
  });
}
