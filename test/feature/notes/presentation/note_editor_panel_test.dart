import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noema/core/database/database.dart';
import 'package:noema/core/database/database_provider.dart';
import 'package:noema/feature/notes/data/note_dao.dart';
import 'package:noema/feature/notes/presentation/note_editor_panel.dart';

void main() {
  late AppDatabase database;
  late NoteData note;

  setUp(() async {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    await database
        .into(database.appUser)
        .insert(
          AppUserCompanion.insert(
            id: 'user-1',
            remoteId: 'remote-user-1',
            userName: 'student',
            displayName: 'Student',
            primaryEmail: 'student@example.com',
            lastSeenAt: 0,
          ),
        );
    note = await NoteDao(database).create(
      userId: 'user-1',
      title: 'Biologia',
      contentQuillJson: '[{"insert":"Célula\\n"}]',
    );
  });

  tearDown(() async {
    await database.close();
  });

  testWidgets('opens a note editor without layout or semantics errors', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final semantics = tester.ensureSemantics();
    try {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [appDatabaseProvider.overrideWithValue(database)],
          child: MaterialApp(
            localizationsDelegates: const [
              FlutterQuillLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [Locale('en'), Locale('pt')],
            home: Scaffold(
              body: NoteEditorPanel(
                noteId: note.id,
                userId: 'user-1',
                onDirtyChanged: (_) {},
                onBack: () {},
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(QuillEditor), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.tap(find.byTooltip('Mais opções de formatação'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    } finally {
      semantics.dispose();
    }
  });

  testWidgets('font selection applies an available font to selected text', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [appDatabaseProvider.overrideWithValue(database)],
        child: MaterialApp(
          localizationsDelegates: const [
            FlutterQuillLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en'), Locale('pt')],
          home: Scaffold(
            body: NoteEditorPanel(
              noteId: note.id,
              userId: 'user-1',
              onDirtyChanged: (_) {},
              onBack: () {},
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final controller = tester
        .widget<QuillEditor>(find.byType(QuillEditor))
        .controller;
    controller.updateSelection(
      const TextSelection(baseOffset: 0, extentOffset: 6),
      ChangeSource.local,
    );
    await tester.pump();
    final fontButton = find.byWidgetPredicate(
      (widget) =>
          widget.runtimeType.toString() == 'QuillToolbarFontFamilyButton',
    );
    expect(fontButton, findsOneWidget);
    await tester.tap(fontButton);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Serifada'));
    await tester.pumpAndSettle();

    expect(
      controller.getSelectionStyle().attributes[Attribute.font.key]?.value,
      'serif',
    );
    await tester.tap(find.text('Salvar'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('autosaves edits after ten seconds, not immediately', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [appDatabaseProvider.overrideWithValue(database)],
        child: MaterialApp(
          localizationsDelegates: const [
            FlutterQuillLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en'), Locale('pt')],
          home: Scaffold(
            body: NoteEditorPanel(
              noteId: note.id,
              userId: 'user-1',
              onDirtyChanged: (_) {},
              onBack: () {},
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final controller = tester
        .widget<QuillEditor>(find.byType(QuillEditor))
        .controller;
    controller.document.insert(0, 'Novo ');
    await tester.pump();
    await tester.pump(const Duration(seconds: 9));

    var persisted = await NoteDao(
      database,
    ).getNote(noteId: note.id, userId: 'user-1');
    expect(persisted?.note.contentQuillJson, note.contentQuillJson);

    controller.document.insert(0, 'Mais ');
    await tester.pump();
    await tester.pump(const Duration(seconds: 9));
    persisted = await NoteDao(
      database,
    ).getNote(noteId: note.id, userId: 'user-1');
    expect(persisted?.note.contentQuillJson, note.contentQuillJson);

    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();
    persisted = await NoteDao(
      database,
    ).getNote(noteId: note.id, userId: 'user-1');
    expect(persisted?.note.contentQuillJson, contains('Novo '));
    expect(persisted?.note.contentQuillJson, contains('Mais '));
  });

  testWidgets('saves pending edits when the app is backgrounded', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [appDatabaseProvider.overrideWithValue(database)],
        child: MaterialApp(
          localizationsDelegates: const [
            FlutterQuillLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en'), Locale('pt')],
          home: Scaffold(
            body: NoteEditorPanel(
              noteId: note.id,
              userId: 'user-1',
              onDirtyChanged: (_) {},
              onBack: () {},
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final controller = tester
        .widget<QuillEditor>(find.byType(QuillEditor))
        .controller;
    controller.document.insert(0, 'Antes de sair ');
    await tester.pump();
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
    await tester.pumpAndSettle();

    final persisted = await NoteDao(
      database,
    ).getNote(noteId: note.id, userId: 'user-1');
    expect(persisted?.note.contentQuillJson, contains('Antes de sair '));
  });
}
