import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noema/core/network/connetction_checker.dart';
import 'package:noema/core/design/tokens/layout.dart';
import 'package:noema/core/design/theme/theme_tokens.dart';
import 'package:noema/feature/config/data/enums.dart';
import 'package:noema/feature/config/presentation/color_theme_section.dart';
import 'package:noema/feature/config/presentation/api_keys_section.dart';
import 'package:noema/feature/config/presentation/google_account_section.dart';
import 'package:noema/feature/config/presentation/profile_section.dart';
import 'package:noema/feature/config/presentation/preferences_section.dart';
import 'package:noema/feature/config/presentation/typography_theme_section.dart';
import 'package:noema/feature/config/providers/section_navigator_provider.dart';
import 'package:noema/feature/config/providers/config_refresh_provider.dart';
import 'package:noema/shared/widgets/app_card.dart';
import 'package:noema/shared/widgets/app_section.dart';
import 'package:noema/shared/widgets/responsive_content.dart';

class ConfigPage extends ConsumerStatefulWidget {
  const ConfigPage({super.key});

  @override
  ConsumerState<ConfigPage> createState() => _ConfigPage();
}

class _ConfigPage extends ConsumerState<ConfigPage> {
  static const _refreshInterval = Duration(minutes: 5);

  final keys = {
    for (final section in ConfigSections.values) section: GlobalKey(),
  };
  Timer? _refreshTimer;

  void scrollTo(ConfigSections section) {
    final context = keys[section]?.currentContext;

    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void initState() {
    super.initState();

    ref.listenManual(sectionNavigatorProvider, ((previous, next) {
      scrollTo(next.currentSection);
    }));
    _refreshTimer = Timer.periodic(_refreshInterval, (_) {
      if (ref.read(serverConnectionChecker).value == true) {
        ref.read(configRefreshProvider.notifier).refresh();
      }
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isConnected = ref.watch(serverConnectionChecker).value ?? false;
    return SingleChildScrollView(
      child: AppResponsiveContent(
        maxWidth: AppLayoutTokens.widePageContentWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: context.spacing.md,
          children: [
            _ConnectionBanner(
              isConnected: isConnected,
              onRefresh: () {
                ref.read(configRefreshProvider.notifier).refresh();
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    const SnackBar(
                      content: Text('Atualizando informações do servidor…'),
                    ),
                  );
              },
            ),
            AppSection(
              title: "Perfil",
              description: "Gerencie seus dados e preferências de conta.",
              key: keys[ConfigSections.profile],
              child: ProfileSection(),
            ),

            AppSection(
              title: "Tema de cores",
              description:
                  "Personalização local deste dispositivo: escolha paleta e modo claro ou escuro.",
              key: keys[ConfigSections.colorTheme],
              child: ColorThemeSection(),
            ),
            AppSection(
              title: "Tipografia",
              description:
                  "Personalização local deste dispositivo: escolha fontes e escala de leitura.",
              key: keys[ConfigSections.typographyTheme],
              child: const TypographyThemeSection(),
            ),
            AppSection(
              title: "Chaves de API",
              description:
                  "Gerencie chaves dos provedores de inteligência artificial.",
              key: keys[ConfigSections.apiKeys],
              child: const ApiKeysSection(),
            ),
            AppSection(
              title: "Conta Google",
              description:
                  "Vincule ou remova a conta Google usada pelas integrações.",
              key: keys[ConfigSections.googleAccount],
              child: const GoogleAccountSection(),
            ),
            AppSection(
              title: "Preferências",
              description:
                  "Escolha o que sincronizar com sua conta e o que manter apenas neste dispositivo.",
              key: keys[ConfigSections.preferences],
              child: const PreferencesSection(),
            ),
          ],
        ),
      ),
    );
  }
}

class _ConnectionBanner extends StatelessWidget {
  const _ConnectionBanner({required this.isConnected, required this.onRefresh});

  final bool isConnected;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final message = Text(
      isConnected
          ? 'As informações do servidor são atualizadas ao abrir esta tela e a cada 5 minutos.'
          : 'Sem conexão com o servidor. As informações serão atualizadas quando a conexão voltar.',
      style: theme.textTheme.bodyMedium,
    );
    final refreshButton = OutlinedButton.icon(
      onPressed: isConnected ? onRefresh : null,
      icon: const Icon(Icons.refresh),
      label: const Text('Atualizar'),
    );

    return AppCard(
      padding: EdgeInsets.all(spacing.md),
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < AppLayoutTokens.compactHeaderBreakpoint) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                message,
                SizedBox(height: spacing.sm),
                refreshButton,
              ],
            );
          }
          return Row(
            children: [
              Expanded(child: message),
              SizedBox(width: spacing.sm),
              refreshButton,
            ],
          );
        },
      ),
    );
  }
}
