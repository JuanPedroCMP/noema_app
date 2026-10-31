import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:noema/core/design/tokens/layout.dart';
import 'package:noema/core/design/theme/theme_tokens.dart';
import 'package:noema/core/router/page_chrome.dart';
import 'package:noema/core/router/route_paths.dart';
import 'package:noema/feature/ai/services/ai_background_task_runner.dart';
import 'package:noema/feature/notes/presentation/notes_page.dart';
import 'package:noema/feature/study_assistant/presentation/study_assistant_panel.dart';
import 'package:noema/feature/study_assistant/providers/study_assistant_preferences_provider.dart';
import 'package:noema/feature/study_assistant/providers/study_assistant_provider.dart';

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
  ('/config', 'Configurações', Icons.settings_outlined, Icons.settings_rounded),
  ('/ai-queue', 'Fila de IA', Icons.queue_outlined, Icons.queue_rounded),
];

List<String> buildCumulativePaths(BuildContext context) {
  return cumulativePathsFor(GoRouterState.of(context).uri.path);
}

List<String> cumulativePathsFor(String path) {
  final segments = Uri.parse(path).pathSegments;
  final paths = <String>['/'];
  if (segments.isEmpty) return paths;

  const topLevelRoutes = {
    'notes',
    'config',
    'ai-queue',
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

String? parentNavigationPath(List<String> paths) =>
    paths.length > 2 ? paths[paths.length - 2] : null;

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
    case 'ai-queue':
      return 'Fila de IA';
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

class AppShell extends ConsumerWidget {
  const AppShell({
    super.key,
    required this.navigationShell,
    required this.currentPath,
  });

  final StatefulNavigationShell navigationShell;
  final String currentPath;

  static DisplaySize spacingFor(double width) {
    if (width >= AppLayoutTokens.desktopBreakpoint) return DisplaySize.desktop;
    if (width >= AppLayoutTokens.compactBreakpoint) return DisplaySize.tablet;
    return DisplaySize.mobile;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(aiBackgroundTaskRunnerProvider);
    final chrome = chromeForPath(currentPath);
    final width = MediaQuery.sizeOf(context).width;
    final displaySize = spacingFor(width);
    final paths = buildCumulativePaths(context);
    final parentPath = parentNavigationPath(paths);
    final assistant = ref.watch(studyAssistantProvider);
    final assistantSettings = ref
        .watch(studyAssistantSettingsProvider)
        .asData
        ?.value;
    final showPinnedAssistant =
        assistant.isOpen &&
        (assistantSettings?.pinPanel ?? false) &&
        width >= AppLayoutTokens.pinnedAssistantBreakpoint;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: displaySize == DisplaySize.mobile
            ? AppLayoutTokens.appBarHeightCompact
            : AppLayoutTokens.appBarHeightRegular,
        backgroundColor: context.colors.surfaceContainerLow,
        scrolledUnderElevation: 0,
        leadingWidth: 64,
        leading: parentPath != null
            ? IconButton(
                tooltip: 'Voltar para ${breadcrumbLabel(parentPath)}',
                onPressed: () => _navigate(context, parentPath),
                icon: const Icon(Icons.arrow_back_rounded),
              )
            : Padding(
                padding: const EdgeInsets.only(left: 14),
                child: Center(
                  child: Container(
                    width: AppLayoutTokens.appBarBrandMarkSize,
                    height: AppLayoutTokens.appBarBrandMarkSize,
                    decoration: BoxDecoration(
                      color: context.colors.primaryContainer,
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Icon(
                      Icons.school_rounded,
                      color: context.colors.onPrimaryContainer,
                      size: 22,
                    ),
                  ),
                ),
              ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              chrome.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: displaySize == DisplaySize.mobile
                  ? context.textTheme.titleMedium
                  : context.textTheme.titleLarge,
            ),
            if (displaySize != DisplaySize.mobile && paths.length > 2)
              _Breadcrumbs(
                paths: paths,
                currentPath: currentPath,
                onNavigate: (path) => _navigate(context, path),
              )
            else if (displaySize != DisplaySize.mobile &&
                chrome.subtitle != null)
              Text(
                chrome.subtitle!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.textTheme.bodySmall?.copyWith(
                  color: context.colors.onSurfaceVariant,
                ),
              ),
          ],
        ),
        actions: [
          ...chrome.actions,
          if (displaySize == DisplaySize.desktop)
            TextButton.icon(
              onPressed: () => _navigate(context, RoutePaths.config),
              icon: const Icon(Icons.settings_outlined),
              label: const Text('Configurações'),
            )
          else
            IconButton(
              tooltip: 'Configurações',
              onPressed: () => _navigate(context, RoutePaths.config),
              style: currentPath.startsWith(RoutePaths.config)
                  ? IconButton.styleFrom(
                      foregroundColor: context.colors.primary,
                      backgroundColor: context.colors.primaryContainer,
                    )
                  : null,
              icon: const Icon(Icons.settings_outlined),
            ),
          if (displaySize == DisplaySize.desktop)
            assistant.isOpen
                ? FilledButton.tonalIcon(
                    onPressed: () =>
                        ref.read(studyAssistantProvider.notifier).close(),
                    icon: const Icon(Icons.auto_awesome),
                    label: const Text('Assistente'),
                  )
                : TextButton.icon(
                    onPressed: () =>
                        ref.read(studyAssistantProvider.notifier).open(),
                    icon: const Icon(Icons.auto_awesome_outlined),
                    label: const Text('Assistente'),
                  )
          else
            IconButton(
              tooltip: assistant.isOpen
                  ? 'Fechar assistente de estudos'
                  : 'Abrir assistente de estudos',
              onPressed: () => assistant.isOpen
                  ? ref.read(studyAssistantProvider.notifier).close()
                  : ref.read(studyAssistantProvider.notifier).open(),
              style: assistant.isOpen
                  ? IconButton.styleFrom(
                      foregroundColor: context.colors.primary,
                      backgroundColor: context.colors.primaryContainer,
                    )
                  : null,
              icon: Icon(
                assistant.isOpen
                    ? Icons.auto_awesome
                    : Icons.auto_awesome_outlined,
              ),
            ),
          const SizedBox(width: 8),
        ],
      ),
      bottomNavigationBar: displaySize == DisplaySize.mobile
          ? NavigationBar(
              height: AppLayoutTokens.navigationBarHeight,
              selectedIndex:
                  navigationShell.currentIndex < _primaryNavigationItems.length
                  ? navigationShell.currentIndex
                  : _primaryNavigationItems.length,
              onDestinationSelected: (index) {
                if (index == _primaryNavigationItems.length) {
                  _showMoreNavigation(context);
                } else {
                  _goBranch(context, index);
                }
              },
              destinations: [
                for (final item in _primaryNavigationItems)
                  NavigationDestination(
                    icon: Icon(item.$3),
                    selectedIcon: Icon(item.$4),
                    label: item.$2,
                  ),
                NavigationDestination(
                  icon: Icon(
                    navigationShell.currentIndex >=
                            _primaryNavigationItems.length
                        ? Icons.more_horiz
                        : Icons.more_horiz_outlined,
                  ),
                  selectedIcon: const Icon(Icons.more_horiz),
                  label: 'Mais',
                ),
              ],
            )
          : null,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final page = displaySize == DisplaySize.mobile
                    ? navigationShell
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          NavigationRail(
                            selectedIndex: navigationShell.currentIndex,
                            onDestinationSelected: (index) =>
                                _goBranch(context, index),
                            extended:
                                displaySize == DisplaySize.desktop &&
                                width >=
                                    AppLayoutTokens
                                        .extendedNavigationRailBreakpoint,
                            labelType:
                                displaySize == DisplaySize.desktop &&
                                    width >=
                                        AppLayoutTokens
                                            .extendedNavigationRailBreakpoint
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
                      );
                final assistantWidth =
                    (constraints.maxWidth - AppLayoutTokens.floatingPanelInset)
                        .clamp(0, AppLayoutTokens.assistantPanelWidth)
                        .toDouble();
                final assistantHeight =
                    (constraints.maxHeight - AppLayoutTokens.floatingPanelInset)
                        .clamp(0, AppLayoutTokens.assistantPanelMaxHeight)
                        .toDouble();
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    page,
                    if (assistant.isOpen && !showPinnedAssistant)
                      Positioned(
                        right: AppLayoutTokens.floatingPanelOffset,
                        bottom: AppLayoutTokens.floatingPanelOffset,
                        width: assistantWidth,
                        height: assistantHeight,
                        child: const StudyAssistantPanel(),
                      ),
                  ],
                );
              },
            ),
          ),
          if (showPinnedAssistant)
            const SizedBox(
              width: AppLayoutTokens.pinnedAssistantWidth,
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  0,
                  AppLayoutTokens.assistantDockPadding,
                  AppLayoutTokens.assistantDockPadding,
                  AppLayoutTokens.assistantDockPadding,
                ),
                child: StudyAssistantPanel(),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _showMoreNavigation(BuildContext context) async {
    final selectedIndex = await showModalBottomSheet<int>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(bottom: context.spacing.md),
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                context.spacing.lg,
                0,
                context.spacing.lg,
                context.spacing.sm,
              ),
              child: Text('Mais áreas', style: context.textTheme.titleMedium),
            ),
            for (final group in _moreNavigationGroups) ...[
              Padding(
                padding: EdgeInsets.fromLTRB(
                  context.spacing.lg,
                  context.spacing.sm,
                  context.spacing.lg,
                  context.spacing.xs,
                ),
                child: Text(
                  group.$1,
                  style: context.textTheme.labelLarge?.copyWith(
                    color: context.colors.onSurfaceVariant,
                  ),
                ),
              ),
              for (final index in group.$2)
                Semantics(
                  selected: navigationShell.currentIndex == index,
                  child: ListTile(
                    leading: Icon(
                      navigationShell.currentIndex == index
                          ? _navigationItems[index].$4
                          : _navigationItems[index].$3,
                    ),
                    title: Text(_navigationItems[index].$2),
                    selected: navigationShell.currentIndex == index,
                    trailing: navigationShell.currentIndex == index
                        ? const Icon(Icons.check_circle_outline)
                        : const Icon(Icons.chevron_right),
                    onTap: () => Navigator.pop(context, index),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
    if (selectedIndex != null && context.mounted) {
      await _goBranch(context, selectedIndex);
    }
  }

  Future<void> _goBranch(BuildContext context, int index) async {
    if (index != navigationShell.currentIndex &&
        navigationShell.currentIndex == 1 &&
        !await _saveActiveNote(context)) {
      return;
    }
    if (!context.mounted) return;
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  Future<void> _navigate(BuildContext context, String path) async {
    if (navigationShell.currentIndex == 1 &&
        !path.startsWith('/notes') &&
        !await _saveActiveNote(context)) {
      return;
    }
    if (context.mounted) context.go(path);
  }

  Future<bool> _saveActiveNote(BuildContext context) async {
    final saved = await notesPageKey.currentState?.saveActiveNote() ?? true;
    if (!saved && context.mounted) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text(
              'Não foi possível salvar. Verifique a anotação e tente novamente.',
            ),
          ),
        );
    }
    return saved;
  }
}

final _primaryNavigationItems = [
  _navigationItems[0],
  _navigationItems[1],
  _navigationItems[2],
  _navigationItems[3],
].toList(growable: false);

const _moreNavigationGroups = <(String, List<int>)>[
  ('Estudo', [4]),
  ('Sistema', [5, 6]),
];

class _Breadcrumbs extends StatelessWidget {
  const _Breadcrumbs({
    required this.paths,
    required this.currentPath,
    required this.onNavigate,
  });

  final List<String> paths;
  final String currentPath;
  final ValueChanged<String> onNavigate;

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
            _BreadcrumbButton(
              path: paths[index],
              currentPath: currentPath,
              onNavigate: onNavigate,
            ),
          ],
        ],
      ),
    );
  }
}

class _BreadcrumbButton extends StatelessWidget {
  const _BreadcrumbButton({
    required this.path,
    required this.currentPath,
    required this.onNavigate,
  });

  final String path;
  final String currentPath;
  final ValueChanged<String> onNavigate;

  @override
  Widget build(BuildContext context) {
    final isCurrent = Uri.parse(path).path == Uri.parse(currentPath).path;
    final label = breadcrumbLabel(path);
    return Semantics(
      button: !isCurrent,
      selected: isCurrent,
      label: isCurrent ? 'Localização atual: $label' : 'Navegar para $label',
      child: TextButton(
        onPressed: isCurrent ? null : () => onNavigate(path),
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
            color: isCurrent
                ? context.colors.onSurface
                : context.colors.primary,
            fontWeight: isCurrent ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
