import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:noema/core/design/theme/app_theme.dart';
import 'package:noema/core/design/theme/theme_defaults.dart';
import 'package:noema/feature/auth/presentation/login_page.dart';
import 'package:noema/feature/auth/providers/auth_base_page.dart';
import 'package:noema/shared/widgets/noema_logo.dart';

void main() {
  testWidgets('login adapts between split desktop and compact mobile layouts', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1280, 900);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (_, _) => const AuthBasePage(child: LoginPage()),
        ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp.router(
          routerConfig: router,
          theme: AppTheme.create(
            seedColor: AppThemeDefaults.seedColor,
            brightness: Brightness.light,
            displayWidth: 1280,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Aprenda conectando ideias.'), findsOneWidget);
    expect(find.text('Cadastre-se'), findsOneWidget);
    expect(tester.takeException(), isNull);

    tester.view.physicalSize = const Size(390, 844);
    await tester.pumpAndSettle();

    expect(find.byType(NoemaLogo), findsOneWidget);
    expect(find.text('Ainda não tem uma conta? Cadastre-se'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
