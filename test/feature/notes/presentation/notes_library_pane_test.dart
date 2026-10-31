import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noema/feature/notes/presentation/notes_page.dart';

void main() {
  testWidgets(
    'fills available width on compact layouts without infinite width',
    (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  NotesLibraryPane(
                    compact: true,
                    child: ColoredBox(
                      key: ValueKey('notes-library'),
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        tester.getSize(find.byKey(const ValueKey('notes-library'))).width,
        358,
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('keeps the fixed library width on wide layouts', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Row(
            children: [
              NotesLibraryPane(
                compact: false,
                child: ColoredBox(
                  key: ValueKey('notes-library'),
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      tester.getSize(find.byKey(const ValueKey('notes-library'))).width,
      320,
    );
    expect(tester.takeException(), isNull);
  });
}
