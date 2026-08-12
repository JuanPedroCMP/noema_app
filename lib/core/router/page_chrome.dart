import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noema/feature/config/data/enums.dart';
import 'package:noema/feature/config/providers/section_navigator_provider.dart';
import 'package:noema/shared/chrome_navigation_tile/chrome_navigation_tile.dart';

class PageChrome {
  final String title;
  final List<Widget> actions;
  final List<Widget> pageItens;

  const PageChrome({
    required this.title,
    required this.actions,
    required this.pageItens,
  });
}

PageChrome chromeForPath(String path, BuildContext context , WidgetRef ref) {
  final configProvider = ref.watch(sectionNavigatorProvider.notifier);

  if (path.startsWith('/notes')) {
    return PageChrome(
      title: "Notes",
      actions: [Text("Teste, Actionm")],
      pageItens: [Text("Test, item drawer")],
    );
  }

  if (path.startsWith('/config')) {
    return PageChrome(
      title: "Config",
      actions: [Text("Teste, Actionm")],
      pageItens: [
        ChromeNavigationTile(
          onTap: () {
            configProvider.changeCurrentSection(ConfigSections.profile);
          },
          title: Text("Profile"),
       
        ),
         ChromeNavigationTile(
          onTap: () {
            configProvider.changeCurrentSection(ConfigSections.preferences);
          },
          title: Text("Preferences"),

        ),
         ChromeNavigationTile(
          onTap: () {
            configProvider.changeCurrentSection(ConfigSections.colorTheme);
          },
          title: Text("Color Theme"),
         
        ),
      ],
    );
  }

  return PageChrome(
    title: "Home",
    actions: [Text("home Action")],
    pageItens: [Text("home drawer")],
  );
}
