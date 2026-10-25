import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noema/core/design/theme/theme_tokens.dart';
import 'package:noema/feature/config/data/enums.dart';
import 'package:noema/feature/config/presentation/color_theme_section.dart';
import 'package:noema/feature/config/presentation/profile_section.dart';
import 'package:noema/feature/config/presentation/typography_theme_section.dart';
import 'package:noema/feature/config/providers/section_navigator_provider.dart';
import 'package:noema/shared/widgets/app_section.dart';
import 'package:noema/shared/widgets/responsive_content.dart';

class ConfigPage extends ConsumerStatefulWidget {
  const ConfigPage({super.key});

  @override
  ConsumerState<ConfigPage> createState() => _ConfigPage();
}

class _ConfigPage extends ConsumerState<ConfigPage> {
  final keys = {
    for (final section in ConfigSections.values) section: GlobalKey(),
  };

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
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: AppResponsiveContent(
        maxWidth: 1200,
        child: Column(
          spacing: context.spacing.md,
          children: [
              AppSection(
                title: "Perfil",
                description: "Gerencie seus dados e preferências de conta.",
                key: keys[ConfigSections.profile],
                child: ProfileSection(),
              ),

              AppSection(
                title: "Tema de cores",
                description:
                    "Escolha uma paleta para personalizar o aplicativo.",
                key: keys[ConfigSections.colorTheme],
                child: ColorThemeSection(),
              ),
              AppSection(
                title: "Tipografia",
                description: "Defina fontes e escala para melhorar a leitura.",
                key: keys[ConfigSections.typographyTheme],
                child: const TypographyThemeSection(),
              ),
          ],
        ),
      ),
    );
  }
}
