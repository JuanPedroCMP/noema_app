import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noema/core/design/theme/theme_tokens.dart';
import 'package:noema/feature/config/data/enums.dart';
import 'package:noema/feature/config/presentation/color_theme_section.dart';
import 'package:noema/feature/config/presentation/color_selector.dart';
import 'package:noema/feature/config/presentation/profile_section.dart';
import 'package:noema/feature/config/providers/section_navigator_provider.dart';
import 'package:noema/feature/config/widgets/section.dart';
import 'package:noema/shared/floating_card/floating_card.dart';

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

  bool isOpended = false;

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
      child: Stack(
        children: [
          Column(
            spacing: context.spacing.md,
            children: [
              Section(
                section: ProfileSection(),
                key: keys[ConfigSections.profile],
                sectionTitle: "Profile",
              ),

              Section(
                section: ColorThemeSection(),
                key: keys[ConfigSections.colorTheme],
                sectionTitle: "Color Theme",
              ),
            ],
          ),
          if (isOpended)
            Align(
              alignment: Alignment.center,
              child: FloatingCard(
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            isOpended = !isOpended;
                          });
                        },
                        icon: Icon(Icons.close_rounded),
                      ),
                    ),
                    Text(
                      "Selecione a cor principal",
                      style: context.textTheme.titleMedium,
                    ),
                    Divider(),
                    ColorSelector(),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
