import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:noema/core/design/theme/theme_tokens.dart';
import 'package:noema/core/router/page_chrome.dart';

enum DisplaySize { mobile, tablet, desktop }

const _navigationItems = <(String, String, IconData, IconData)>[
  ('/', 'Início', Icons.home_outlined, Icons.home_rounded),
  ('/notes', 'Notas', Icons.notes_outlined, Icons.notes_rounded),
  (
    '/graphs',
    'Grafos',
    Icons.account_tree_outlined,
    Icons.account_tree_rounded,
  ),
  ('/flashcards', 'Flashcards', Icons.style_outlined, Icons.style_rounded),
  (
    '/study-sessions',
    'Sessões',
    Icons.playlist_add_check_circle_outlined,
    Icons.playlist_add_check_circle,
  ),
  ('/config', 'Configuração', Icons.settings_outlined, Icons.settings_rounded),
];

List<String> buildCumulativePaths(BuildContext context) {
  final segments = GoRouterState.of(context).uri.pathSegments;
  final paths = <String>['/'];
  if (segments.isEmpty) return paths;

  const topLevelRoutes = {
    'notes',
    'config',
    'test',
    'graphs',
    'flashcards',
    'study-sessions',
  };
  if (!topLevelRoutes.contains(segments.first)) return paths;
  paths.add('/${segments.first}');

  if (segments.first == 'study-sessions') {
    if (segments.length >= 2 && segments[1] == 'create') {
      paths.add('/study-sessions/create');
    } else if (segments.length >= 2) {
      paths.add('/study-sessions/${segments[1]}');
    }
    if (segments.length >= 3 && const {'edit', 'run'}.contains(segments[2])) {
      paths.add('/study-sessions/${segments[1]}/${segments[2]}');
    }
    return paths;
  }

  if (segments.first != 'graphs' || segments.length < 2) return paths;
  paths.add('/graphs/${segments[1]}');

  if (segments.length >= 4 && segments[2] == 'flashcards') {
    paths.add('/graphs/${segments[1]}/flashcards/${segments[3]}');
    return paths;
  }

  if (segments.length < 4 || segments[2] != 'exercises') return paths;
  final exercisesPath = '/graphs/${segments[1]}/exercises/${segments[3]}';
  paths.add(exercisesPath);

  final suffix = segments.skip(4).toList();
  if (suffix.isEmpty) return paths;
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
  if (suffix.length == 1 && suffix[0] == 'responses') {
    paths.add('$exercisesPath/responses');
  } else if (isOpenEndedRoute || isMultipleChoiceRoute) {
    paths.add('$exercisesPath/${suffix.join('/')}');
  }
  return paths;
}

String breadcrumbLabel(String path) {
  if (path == '/') return 'Início';
  final segments = Uri.parse(path).pathSegments;
  final segment = segments.last;

  if (segments.first == 'study-sessions') {
    if (segment == 'study-sessions') return 'Sessões de estudo';
    if (segment == 'create') return 'Criar sessão';
    if (segment == 'edit') return 'Editar sessão';
    if (segment == 'run') return 'Sessão em andamento';
    return 'Sessão de estudo';
  }

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
      if (segments.length >= 2 &&
          segments[segments.length - 2] == 'flashcards') {
        return 'Flashcards do nó';
      }
      return Uri.decodeComponent(segment);
  }
}

class AppShell extends StatelessWidget {
  const AppShell({
    super.key,
    required this.navigationShell,
    required this.currentPath,
  });

  final StatefulNavigationShell navigationShell;
  final String currentPath;

  static DisplaySize spacingFor(double width) {
    if (width >= 900) return DisplaySize.desktop;
    if (width >= 600) return DisplaySize.tablet;
    return DisplaySize.mobile;
  }

  @override
  Widget build(BuildContext context) {
    final chrome = chromeForPath(currentPath);
    final width = MediaQuery.sizeOf(context).width;
    final displaySize = spacingFor(width);
    final paths = buildCumulativePaths(context);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: displaySize == DisplaySize.mobile ? 64 : 72,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              chrome.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.textTheme.titleMedium,
            ),
            if (displaySize != DisplaySize.mobile && paths.length > 1)
              _Breadcrumbs(paths: paths, currentPath: currentPath),
          ],
        ),
        actions: chrome.actions,
      ),
      bottomNavigationBar: displaySize == DisplaySize.mobile
          ? NavigationBar(
              selectedIndex: navigationShell.currentIndex,
              onDestinationSelected: _goBranch,
              labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
              destinations: [
                for (final item in _navigationItems)
                  NavigationDestination(
                    icon: Icon(item.$3),
                    selectedIcon: Icon(item.$4),
                    label: item.$2,
                  ),
              ],
            )
          : null,
      body: displaySize == DisplaySize.mobile
          ? navigationShell
          : Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                NavigationRail(
                  selectedIndex: navigationShell.currentIndex,
                  onDestinationSelected: _goBranch,
                  extended: displaySize == DisplaySize.desktop && width >= 1200,
                  labelType:
                      displaySize == DisplaySize.desktop && width >= 1200
                      ? NavigationRailLabelType.none
                      : NavigationRailLabelType.all,
                  destinations: [
                    for (final item in _navigationItems)
                      NavigationRailDestination(
                        icon: Icon(item.$3),
                        selectedIcon: Icon(item.$4),
                        label: Text(item.$2),
                      ),
                  ],
                ),
                const VerticalDivider(width: 1),
                Expanded(child: navigationShell),
              ],
            ),
    );
  }

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}

class _Breadcrumbs extends StatelessWidget {
  const _Breadcrumbs({required this.paths, required this.currentPath});

  final List<String> paths;
  final String currentPath;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var index = 0; index < paths.length; index++) ...[
            if (index > 0)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Icon(
                  Icons.chevron_right,
                  size: 16,
                  color: context.colors.outline,
                ),
              ),
            _BreadcrumbButton(path: paths[index], currentPath: currentPath),
          ],
        ],
      ),
    );
  }
}

class _BreadcrumbButton extends StatelessWidget {
  const _BreadcrumbButton({required this.path, required this.currentPath});

  final String path;
  final String currentPath;

  @override
  Widget build(BuildContext context) {
    final isCurrent = Uri.parse(path).path == Uri.parse(currentPath).path;
    final label = breadcrumbLabel(path);
    return Semantics(
      button: !isCurrent,
      selected: isCurrent,
      label: isCurrent ? 'Localização atual: $label' : 'Navegar para $label',
      child: TextButton(
        onPressed: isCurrent ? null : () => context.go(path),
        style: TextButton.styleFrom(
          minimumSize: const Size(32, 28),
          padding: const EdgeInsets.symmetric(horizontal: 4),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: context.textTheme.labelMedium?.copyWith(
            color: isCurrent ? context.colors.onSurface : context.colors.primary,
            fontWeight: isCurrent ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
