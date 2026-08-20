import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:noema/core/database/database.dart';
import 'package:noema/core/design/theme/display_width_provider.dart';
import 'package:noema/core/design/theme/theme_tokens.dart';
import 'package:noema/core/router/page_chrome.dart';
import 'package:noema/core/router/widgets/app_side_bar/app_side_bar.dart';
import 'package:noema/core/router/widgets/navigation_item/navigation_item.dart';
import 'package:noema/feature/config/providers/user_provider.dart';

enum DisplaySize { mobile, tablet, desktop }

class AppShell extends ConsumerWidget {
  final StatefulNavigationShell navigationShell;
  final String currentPath;

  const AppShell({
    super.key,
    required this.navigationShell,
    required this.currentPath,
  });

  static DisplaySize spacingFor(double width) {
    return DisplaySize.desktop; //TODO temp, tirar dps
    if (width >= 900) return DisplaySize.desktop;
    if (width >= 600) return DisplaySize.tablet;

    return DisplaySize.mobile;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chrome = chromeForPath(currentPath, context, ref);
    final user = ref.watch(userProvider);

    final width = MediaQuery.sizeOf(context).width;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(displayWidthProvider.notifier).update(width);
    });

    final displayWidth = ref.watch(displayWidthProvider);

    return Scaffold(
      appBar: AppBar(title: Text(chrome.title), actions: chrome.actions),

      drawer: (spacingFor(displayWidth) == DisplaySize.mobile)
          ? _buildDrawer(context, chrome, navigationShell, user)
          : null,

      body: (spacingFor(displayWidth) == DisplaySize.mobile)
          ? _buildBody(context, navigationShell)
          : Row(
              children: [
                AppSideBar(
                  navigationWidgets: [
                    NavigationItem(
                      index: 0,
                      label: "Home",
                      navigationShell: navigationShell,
                      icon: Icon(Icons.home_rounded),
                    ),
                    NavigationItem(
                      index: 1,
                      label: "notes",
                      navigationShell: navigationShell,
                      icon: Icon(Icons.notes),
                    ),
                    NavigationItem(
                      index: 2,
                      label: "Config",
                      navigationShell: navigationShell,
                      icon: Icon(Icons.settings_rounded),
                    ),
                    NavigationItem(
                      index: 3,
                      label: "Teste",
                      navigationShell: navigationShell,
                      icon: Icon(Icons.smart_button),
                    ),
                    NavigationItem(
                      index: 4,
                      label: "Graph",
                      navigationShell: navigationShell,
                      icon: Icon(Icons.graphic_eq_rounded),
                    ),
                    NavigationItem(
                      index: 5,
                      label: "Create Graph",
                      navigationShell: navigationShell,
                      icon: Icon(Icons.graphic_eq_rounded),
                    ),
                    NavigationItem(
                      index: 6,
                      label: "List Graph",
                      navigationShell: navigationShell,
                      icon: Icon(Icons.graphic_eq_rounded),
                    ),
                  ],
                  pageWidgets: chrome.pageItens,
                  bottonWidgets: [
                    Icon(Icons.more_vert_rounded),
                    SizedBox(height: context.spacing.md),
                    Icon(Icons.person),
                  ],
                ),

                const VerticalDivider(width: 1),
                Expanded(child: _buildBody(context, navigationShell)),
              ],
            ),
    );
  }
}

Widget _buildBody(
  BuildContext context,
  StatefulNavigationShell navigationShell,
) {
  return Container(
    child: navigationShell,
  );
}

Widget _buildDrawer(
  BuildContext context,
  PageChrome chrome,
  StatefulNavigationShell navigationShell,
  AsyncValue<AppUserData> user,
) {
  return Drawer(
    child: SafeArea(
      child: Column(
        children: [
          Flexible(
            fit: FlexFit.loose,
            child: Row(
              children: [
                Flexible(
                  fit: FlexFit.loose,
                  child: ListView(
                    children: [
                      ListTile(
                        onTap: () {
                          navigationShell.goBranch(0);
                        },
                        selected: (chrome.title == "Home"),
                        title: const Text("Home"),
                      ),

                      ListTile(
                        onTap: () {
                          navigationShell.goBranch(1);
                        },
                        selected: (chrome.title == "Notes"),
                        title: const Text("Notes"),
                      ),
                    ],
                  ),
                ),
                VerticalDivider(width: 1),
                Flexible(child: ListView(children: chrome.pageItens)),
              ],
            ),
          ),
          const Divider(height: 1),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            child: Row(
              spacing: 15,
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () {
                    navigationShell.goBranch(2);
                    context.go("/profile");
                  },
                  child: const Icon(Icons.person),
                ),
                user.when(
                  data: (user) => Text(user.displayName),
                  loading: () => const Text("Carregando..."),
                  error: (e, _) => const Text("Erro"),
                ),
                const Icon(Icons.settings),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
