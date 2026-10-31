import 'package:flutter_test/flutter_test.dart';
import 'package:noema/core/router/app_shell.dart';

void main() {
  group('cumulativePathsFor', () {
    test('keeps top-level destinations at the home level', () {
      expect(cumulativePathsFor('/notes'), ['/', '/notes']);
      expect(parentNavigationPath(cumulativePathsFor('/notes')), isNull);
    });

    test(
      'resolves graph flashcard ancestry for contextual back navigation',
      () {
        final paths = cumulativePathsFor('/graphs/graph-1/flashcards/node-1');

        expect(paths, [
          '/',
          '/graphs',
          '/graphs/graph-1',
          '/graphs/graph-1/flashcards/node-1',
        ]);
        expect(parentNavigationPath(paths), '/graphs/graph-1');
      },
    );

    test('resolves study-session ancestry for nested routes', () {
      final paths = cumulativePathsFor('/study-sessions/session-1/run');

      expect(paths, [
        '/',
        '/study-sessions',
        '/study-sessions/session-1',
        '/study-sessions/session-1/run',
      ]);
      expect(parentNavigationPath(paths), '/study-sessions/session-1');
    });
  });
}
