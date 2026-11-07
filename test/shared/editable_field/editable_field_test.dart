import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noema/core/design/theme/app_theme.dart';
import 'package:noema/shared/editable_field/editable_field.dart';

void main() {
  testWidgets('long display values fit within a narrow profile layout', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(436, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.create(
          seedColor: Colors.blue.toARGB32(),
          brightness: Brightness.light,
          displayWidth: 436,
        ),
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 436,
              child: EditableField(
                displayLabel: const Text('Email:'),
                display: const Text(
                  'a.very.long.google.account.address@example-domain.com',
                ),
                inputLabel: 'Email',
                onChanged: (_) {},
                onConfirm: () {},
                onCancel: () {},
              ),
            ),
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(find.text('Editar'), findsOneWidget);

    await tester.tap(find.text('Editar'));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('Salvar'), findsOneWidget);
    expect(find.text('Cancelar'), findsOneWidget);
  });
}
