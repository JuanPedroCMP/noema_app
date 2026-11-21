import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noema/feature/splash/presentation/splash_page.dart';
import 'package:noema/shared/widgets/noema_logo.dart';

void main() {
  testWidgets('splash shows a minimal logo animation without overflow', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(360, 640);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        home: MediaQuery(
          data: const MediaQueryData(disableAnimations: true),
          child: const Scaffold(body: SplashPage()),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.byType(NoemaLogo), findsOneWidget);
    expect(find.byType(LinearProgressIndicator), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('splash transitions between the logo and a graph in a loop', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(360, 640);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: SplashPage())),
    );
    expect(tester.getCenter(find.byType(NoemaLogo)).dx, closeTo(180, 1));
    await tester.pump(const Duration(milliseconds: 1500));
    expect(tester.takeException(), isNull);

    await tester.pump(const Duration(milliseconds: 1500));
    expect(tester.takeException(), isNull);
    expect(find.byType(NoemaLogo), findsOneWidget);
  });
}
