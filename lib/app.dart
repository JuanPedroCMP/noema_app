import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noema/core/theme/color_theme.dart' show ColorTheme;
import 'package:noema/core/theme/color_theme_provider.dart' show colorProvider, brightnessProvider;
import 'package:noema/core/router/router.dart';


class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final colorApp = ref.watch(colorProvider);
    final brightnessApp = ref.watch(brightnessProvider);

     return MaterialApp.router(
      debugShowCheckedModeBanner: false,

      routerConfig: ref.watch(goRouterProvider),

      theme: ColorTheme.create(
        seedColor: colorApp,
        brightness: brightnessApp,
      ),

    );
  }
}
