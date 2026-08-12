import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noema/core/design/theme/app_theme.dart' show AppTheme;
import 'package:noema/core/design/theme/color_theme_provider.dart'
    show colorProvider, brightnessProvider;
import 'package:noema/core/design/theme/display_width_provider.dart';
import 'package:noema/core/router/router.dart';
import 'package:noema/l10n/app_localizations.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorApp = ref.watch(colorProvider);
    final brightnessApp = ref.watch(brightnessProvider);

    final width = MediaQuery.sizeOf(context).width;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(displayWidthProvider.notifier).update(width);
    });

    final displayWidth = ref.watch(displayWidthProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,

      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('pt', ''), // Português
        const Locale('en', ''), // Inglês
        // const Locale.fromSubtags(languageCode: 'zh'),
      ],

      routerConfig: ref.watch(goRouterProvider),

      theme: AppTheme.create(
        seedColor: colorApp,
        brightness: brightnessApp,
        displayWidth: displayWidth,
      ),
    );
  }
}
