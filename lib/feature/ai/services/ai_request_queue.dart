import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AiRequestPriority { user, background }

class AiRequestQueue {
  final List<_QueuedAiRequest<Object?>> _backgroundRequests = [];
  int _activeBackgroundRequests = 0;
  int _backgroundConcurrencyLimit = 1;

  int get activeBackgroundRequests => _activeBackgroundRequests;
  int get pendingBackgroundRequests => _backgroundRequests.length;

  Future<T> run<T>({
    required AiRequestPriority priority,
    required Future<T> Function() action,
    int backgroundConcurrencyLimit = 1,
  }) {
    if (priority == AiRequestPriority.user) {
      return Future<T>.sync(action);
    }
    if (backgroundConcurrencyLimit < 1 || backgroundConcurrencyLimit > 8) {
      throw ArgumentError.value(
        backgroundConcurrencyLimit,
        'backgroundConcurrencyLimit',
        'must be between 1 and 8',
      );
    }

    _backgroundConcurrencyLimit = backgroundConcurrencyLimit;
    final request = _QueuedAiRequest<T>(action);
    _backgroundRequests.add(request);
    _pumpBackgroundRequests();
    return request.result.future;
  }

  void _pumpBackgroundRequests() {
    while (_activeBackgroundRequests < _backgroundConcurrencyLimit &&
        _backgroundRequests.isNotEmpty) {
      final request = _backgroundRequests.removeAt(0);
      _activeBackgroundRequests++;
      request
          .run()
          .then<void>(
            request.complete,
            onError: request.completeError,
          )
          .whenComplete(() {
            _activeBackgroundRequests--;
            _pumpBackgroundRequests();
          });
    }
  }
}

class _QueuedAiRequest<T> {
  _QueuedAiRequest(this._action);

  final Future<T> Function() _action;
  final Completer<T> result = Completer<T>();

  Future<T> run() => Future<T>.sync(_action);

  void complete(T value) => result.complete(value);

  void completeError(Object error, StackTrace stackTrace) {
    result.completeError(error, stackTrace);
  }
}

final aiRequestQueueProvider = Provider<AiRequestQueue>(
  (ref) => AiRequestQueue(),
);
