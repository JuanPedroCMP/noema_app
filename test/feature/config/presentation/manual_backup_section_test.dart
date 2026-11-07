import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noema/core/database/database.dart';
import 'package:noema/core/database/database_provider.dart';
import 'package:noema/core/design/theme/app_theme.dart';
import 'package:noema/feature/config/presentation/manual_backup_section.dart';

void main() {
  testWidgets('shows manual export, import, encryption, and history controls', (
    tester,
  ) async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [appDatabaseProvider.overrideWithValue(database)],
        child: MaterialApp(
          theme: AppTheme.create(
            seedColor: 0xFF6750A4,
            brightness: Brightness.dark,
            displayWidth: 484,
          ),
          home: const Scaffold(
            body: SingleChildScrollView(child: ManualBackupSection()),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Exportar backup'), findsOneWidget);
    expect(find.text('Importar backup'), findsOneWidget);
    expect(find.text('Criptografar o arquivo'), findsOneWidget);
    expect(find.text('Histórico de operações'), findsOneWidget);
    expect(
      find.text('Ainda não há exportações ou importações manuais.'),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });
}
