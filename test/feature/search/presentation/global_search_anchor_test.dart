import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noema/core/design/theme/app_theme.dart';
import 'package:noema/core/design/theme/theme_defaults.dart';
import 'package:noema/feature/search/presentation/global_search_anchor.dart';

void main() {
  testWidgets('desktop search stays compact and within its responsive width', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1200, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: AppTheme.create(
            seedColor: AppThemeDefaults.seedColor,
            brightness: Brightness.light,
            displayWidth: 1200,
          ),
          home: Scaffold(
            appBar: AppBar(
              actions: [
                GlobalSearchAnchor(isDesktop: true, onNavigate: (_) {}),
              ],
            ),
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    final searchBar = find.byType(SearchBar);
    expect(tester.getSize(searchBar).width, 300);
    expect(tester.getSize(searchBar).height, 48);
  });

  testWidgets('mobile search uses an accessible compact action', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: AppTheme.create(
            seedColor: AppThemeDefaults.seedColor,
            brightness: Brightness.light,
            displayWidth: 360,
          ),
          home: Scaffold(
            appBar: AppBar(
              actions: [
                GlobalSearchAnchor(isDesktop: false, onNavigate: (_) {}),
              ],
            ),
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(find.byTooltip('Buscar no Noema'), findsOneWidget);
  });
}
