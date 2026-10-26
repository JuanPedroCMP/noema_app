import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:noema/core/database/database.dart';
import 'package:noema/core/design/theme/theme_tokens.dart';
import 'package:noema/core/router/page_chrome.dart';
import 'package:noema/core/router/route_paths.dart';
import 'package:noema/core/router/widgets/app_side_bar/app_side_bar.dart';
import 'package:noema/core/router/widgets/navigation_item/navigation_item.dart';
import 'package:noema/feature/config/providers/user_provider.dart';

List<String> buildCumulativePaths(BuildContext context) {
  final segments = GoRouterState.of(context).uri.pathSegments;
  final paths = <String>['/'];
  if (segments.isEmpty) return paths;

  const topLevelRoutes = {'notes', 'config', 'test', 'graphs', 'flashcards'};
  if (!topLevelRoutes.contains(segments.first)) {
    return paths;
  }
  paths.add('/${segments.first}');

  if (segments.first != 'graphs' || segments.length < 2) return paths;
  paths.add('/graphs/${segments[1]}');

  if (segments.length < 4 || segments[2] != 'exercises') return paths;
  final exercisesPath = '/graphs/${segments[1]}/exercises/${segments[3]}';
  paths.add(exercisesPath);

  final suffix = segments.skip(4).toList();
  if (suffix.isEmpty) return paths;
  if (suffix.length == 1 && suffix[0] == 'responses') {
    paths.add('$exercisesPath/responses');
    return paths;
  }

  final isOpenEndedRoute =
      (suffix.length == 2 &&
          suffix[0] == 'open-ended' &&
          suffix[1] == 'create') ||
      (suffix.length == 3 &&
          suffix[0] == 'open-ended' &&
          const {'edit', 'answer', 'view'}.contains(suffix[2]));
  final isMultipleChoiceRoute =
      (suffix.length == 2 &&
          suffix[0] == 'multiple-choice' &&
          suffix[1] == 'create') ||
      (suffix.length == 3 &&
          suffix[0] == 'multiple-choice' &&
          const {'edit', 'answer', 'view'}.contains(suffix[2]));

  if (isOpenEndedRoute || isMultipleChoiceRoute) {
    paths.add('$exercisesPath/${suffix.join('/')}');
  }
  return paths;
}

String breadcrumbLabel(String path) {
  if (path == '/') return 'Início';

  final segments = Uri.parse(path).pathSegments;
  final segment = segments.last;

  switch (segment) {
    case 'notes':
      return 'Notas';
    case 'config':
      return 'Configuração';
    case 'test':
      return 'Teste';
    case 'graphs':
      return 'Grafos';
    case 'flashcards':
      return 'Flashcards';
    case 'exercises':
      return 'Exercícios';
    case 'responses':
      return 'Histórico de respostas';
    case 'open-ended':
      return 'Questão aberta';
    case 'multiple-choice':
      return 'Múltipla escolha';
    case 'create':
      return 'Criar questão';
    case 'edit':
      return 'Editar questão';
    case 'answer':
      return 'Responder questão';
    case 'view':
      return 'Visualizar questão';
    default:
      if (segments.length >= 2 && segments[segments.length - 2] == 'graphs') {
        return 'Grafo';
      }
      if (segments.length >= 2 &&
          segments[segments.length - 2] == 'exercises') {
        return 'Questões';
      }
      if (segments.length >= 2 &&
          (segments[segments.length - 2] == 'open-ended' ||
              segments[segments.length - 2] == 'multiple-choice')) {
        return 'Questão';
      }
      return Uri.decodeComponent(segment);
  }
}

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
    if (width >= 900) return DisplaySize.desktop;
    if (width >= 600) return DisplaySize.tablet;

    return DisplaySize.mobile;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chrome = chromeForPath(currentPath);
    final user = ref.watch(userProvider);

    final width = MediaQuery.sizeOf(context).width;

    final displaySize = spacingFor(width);

    final paths = buildCumulativePaths(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Flexible(
              flex: 2,
              child: Text(chrome.title, overflow: TextOverflow.ellipsis),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (var index = 0; index < paths.length; index++) ...[
                      if (index > 0)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Icon(
                            Icons.chevron_right,
                            size: 18,
                            color: context.colors.outline,
                          ),
                        ),
                      Builder(
                        builder: (context) {
                          final path = paths[index];
                          final isCurrent = index == paths.length - 1;
                          final label = breadcrumbLabel(path);

                          return Semantics(
                            button: !isCurrent,
                            label: isCurrent
                                ? 'Localização atual: $label'
                                : 'Navegar para $label',
                            child: Tooltip(
                              message: isCurrent
                                  ? 'Localização atual'
                                  : 'Navegar para $label',
                              child: TextButton(
                                onPressed: isCurrent
                                    ? null
                                    : () => context.go(path),
                                style: TextButton.styleFrom(
                                  minimumSize: Size.zero,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 4,
                                    vertical: 6,
                                  ),
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: Text(
                                  label,
                                  overflow: TextOverflow.ellipsis,
                                  style: BuildContextThemeExtension(context)
                                      .textTheme
                                      .labelLarge
                                      ?.copyWith(
                                        color: isCurrent
                                            ? context.colors.onSurface
                                            : context.colors.primary,
                                        fontWeight: isCurrent
                                            ? FontWeight.w600
                                            : FontWeight.normal,
                                      ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
        actions: chrome.actions,
      ),

      drawer: displaySize == DisplaySize.mobile
          ? _buildDrawer(context, chrome, navigationShell, user)
          : null,

      bottomNavigationBar: displaySize == DisplaySize.mobile
          ? _buildBottomNavigationBar(navigationShell)
          : null,

      body: displaySize == DisplaySize.mobile
          ? _buildBody(context, navigationShell)
          : Row(
              children: [
                AppSideBar(
                  navigationWidgets: _navigationItems(navigationShell),
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

List<Widget> _navigationItems(StatefulNavigationShell navigationShell) {
  const items = [
    (0, 'Início', Icons.home_rounded),
    (1, 'Notas', Icons.notes_rounded),
    (2, 'Configuração', Icons.settings_rounded),
    (3, 'Teste', Icons.smart_button_rounded),
    (4, 'Grafos', Icons.account_tree_rounded),
    (5, 'Flashcards', Icons.style_rounded),
  ];

  return [
    for (final item in items)
      NavigationItem(
        index: item.$1,
        label: item.$2,
        navigationShell: navigationShell,
        icon: Icon(item.$3),
      ),
  ];
}

Widget _buildBottomNavigationBar(StatefulNavigationShell navigationShell) {
  return NavigationBar(
    selectedIndex: navigationShell.currentIndex,
    onDestinationSelected: navigationShell.goBranch,
    labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
    destinations: const [
      NavigationDestination(
        icon: Icon(Icons.home_outlined),
        selectedIcon: Icon(Icons.home_rounded),
        label: 'Início',
      ),
      NavigationDestination(
        icon: Icon(Icons.notes_outlined),
        selectedIcon: Icon(Icons.notes_rounded),
        label: 'Notas',
      ),
      NavigationDestination(
        icon: Icon(Icons.settings_outlined),
        selectedIcon: Icon(Icons.settings_rounded),
        label: 'Configuração',
      ),
      NavigationDestination(
        icon: Icon(Icons.smart_button_outlined),
        selectedIcon: Icon(Icons.smart_button_rounded),
        label: 'Teste',
      ),
      NavigationDestination(
        icon: Icon(Icons.account_tree_outlined),
        selectedIcon: Icon(Icons.account_tree_rounded),
        label: 'Grafos',
      ),
      NavigationDestination(
        icon: Icon(Icons.style_outlined),
        selectedIcon: Icon(Icons.style_rounded),
        label: 'Flashcards',
      ),
    ],
  );
}

Widget _buildBody(
  BuildContext context,
  StatefulNavigationShell navigationShell,
) {
  return Container(child: navigationShell);
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
                        selected: navigationShell.currentIndex == 0,
                        title: const Text("Início"),
                      ),

                      ListTile(
                        onTap: () {
                          navigationShell.goBranch(1);
                        },
                        selected: navigationShell.currentIndex == 1,
                        title: const Text("Notas"),
                      ),
                      ListTile(
                        onTap: () => navigationShell.goBranch(2),
                        selected: navigationShell.currentIndex == 2,
                        title: const Text("Configuração"),
                      ),
                      ListTile(
                        onTap: () => navigationShell.goBranch(3),
                        selected: navigationShell.currentIndex == 3,
                        title: const Text("Teste"),
                      ),
                      ListTile(
                        onTap: () => navigationShell.goBranch(4),
                        selected: navigationShell.currentIndex == 4,
                        title: const Text("Grafos"),
                      ),
                      ListTile(
                        onTap: () => navigationShell.goBranch(5),
                        selected: navigationShell.currentIndex == 5,
                        title: const Text("Flashcards"),
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
                    context.go(RoutePaths.config);
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
