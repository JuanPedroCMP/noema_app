import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noema/core/design/theme/app_theme.dart';
import 'package:noema/core/design/theme/theme_defaults.dart';
import 'package:noema/shared/widgets/app_section.dart';

void main() {
  testWidgets('shows section details from the discreet info button', (
    tester,
  ) async {
    const description = 'Ajuste a fonte e o tamanho do texto.';
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.create(
          seedColor: AppThemeDefaults.seedColor,
          brightness: Brightness.light,
          displayWidth: 800,
        ),
        home: const Scaffold(
          body: AppSection(
            title: 'Tipografia',
            description: description,
            child: SizedBox(),
          ),
        ),
      ),
    );

    expect(find.text(description), findsNothing);
    await tester.tap(find.byTooltip('Mais informações'));
    await tester.pumpAndSettle();

    expect(find.text(description), findsOneWidget);
    expect(find.text('Entendi'), findsOneWidget);
  });
}
