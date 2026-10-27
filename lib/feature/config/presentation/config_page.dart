import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noema/core/network/connetction_checker.dart';
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
        maxWidth: 1200,
        child: Column(
          spacing: context.spacing.md,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        isConnected
                            ? 'As informações do servidor são atualizadas ao '
                                  'abrir esta tela e a cada 5 minutos.'
                            : 'Sem conexão com o servidor. As informações '
                                  'serão atualizadas quando a conexão voltar.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    const SizedBox(width: 12),
                    OutlinedButton.icon(
                      onPressed: isConnected
                          ? () {
                              ref
                                  .read(configRefreshProvider.notifier)
                                  .refresh();
                              ScaffoldMessenger.of(context)
                                ..hideCurrentSnackBar()
                                ..showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Atualizando informações do servidor…',
                                    ),
                                  ),
                                );
                            }
                          : null,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Atualizar'),
                    ),
                  ],
                ),
              ),
            ),
            AppSection(
              title: "Perfil",
              description: "Gerencie seus dados e preferências de conta.",
              key: keys[ConfigSections.profile],
              child: ProfileSection(),
            ),

            AppSection(
              title: "Tema de cores",
              description: "Escolha uma paleta para personalizar o aplicativo.",
              key: keys[ConfigSections.colorTheme],
              child: ColorThemeSection(),
            ),
            AppSection(
              title: "Tipografia",
              description: "Defina fontes e escala para melhorar a leitura.",
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
              description: "Idioma e outras preferências deste dispositivo.",
              key: keys[ConfigSections.preferences],
              child: const PreferencesSection(),
            ),
          ],
        ),
      ),
    );
  }
}
