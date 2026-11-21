import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:noema/shared/localization/runtime_localization.dart';
import 'package:noema/core/design/tokens/layout.dart';
import 'package:noema/core/design/theme/color_theme_provider.dart'
    show brightnessProvider, colorProvider;
import 'package:noema/core/design/theme/theme_tokens.dart';
import 'package:noema/core/router/page_chrome.dart';
import 'package:noema/core/router/route_paths.dart';
import 'package:noema/feature/ai/services/ai_background_task_runner.dart';
import 'package:noema/feature/ai/data/ai_background_task_dao.dart';
import 'package:noema/feature/ai/providers/ai_background_task_provider.dart';
import 'package:noema/feature/auth/providers/account_state.dart';
import 'package:noema/feature/auth/providers/profile_avatar_provider.dart';
import 'package:noema/feature/config/data/enums.dart';
import 'package:noema/feature/config/providers/section_navigator_provider.dart';
import 'package:noema/feature/config/providers/user_provider.dart';
import 'package:noema/feature/notes/presentation/notes_page.dart';
import 'package:noema/feature/search/presentation/global_search_anchor.dart';
import 'package:noema/feature/study_assistant/presentation/study_assistant_panel.dart';
import 'package:noema/feature/study_assistant/providers/study_assistant_preferences_provider.dart';
import 'package:noema/feature/study_assistant/providers/study_assistant_provider.dart';
import 'package:noema/shared/widgets/noema_logo.dart';

enum DisplaySize { mobile, tablet, desktop }

class _NavigationItem {
  const _NavigationItem(
    this.label,
    this.icon,
    this.selectedIcon, {
    this.branchIndex,
    this.routePath,
  });

  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final int? branchIndex;
  final String? routePath;
}

class _NavigationGroup {
  const _NavigationGroup(this.label, this.items);

  final String label;
  final List<_NavigationItem> items;
}

const _primaryNavigationItems = <_NavigationItem>[
  _NavigationItem(
    'Início',
    Icons.home_outlined,
    Icons.home_rounded,
    branchIndex: 0,
  ),
  _NavigationItem(
    'Painel',
    Icons.dashboard_outlined,
    Icons.dashboard_rounded,
    routePath: RoutePaths.dashboard,
  ),
  _NavigationItem(
    'Notas',
    Icons.notes_outlined,
    Icons.notes_rounded,
    branchIndex: 1,
  ),
  _NavigationItem(
    'Grafos',
    Icons.account_tree_outlined,
    Icons.account_tree_rounded,
    branchIndex: 2,
  ),
];

const _moreNavigationGroups = <_NavigationGroup>[
  _NavigationGroup('Estudo', [
    _NavigationItem(
      'Flashcards',
      Icons.style_outlined,
      Icons.style_rounded,
      branchIndex: 3,
    ),
    _NavigationItem(
      'Sessões',
      Icons.playlist_add_check_circle_outlined,
      Icons.playlist_add_check_circle,
      branchIndex: 4,
    ),
  ]),
  _NavigationGroup('Sistema', [
    _NavigationItem(
      'Configurações',
      Icons.settings_outlined,
      Icons.settings_rounded,
      branchIndex: 5,
    ),
    _NavigationItem(
      'Fila de IA',
      Icons.queue_outlined,
      Icons.queue_rounded,
      branchIndex: 6,
    ),
  ]),
];

final _navigationItems = [
  ..._primaryNavigationItems,
  for (final group in _moreNavigationGroups) ...group.items,
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
    final extendedNavigation =
        displaySize == DisplaySize.desktop &&
        width >= AppLayoutTokens.extendedNavigationRailBreakpoint &&
        !showPinnedAssistant;

    return _AiTaskCompletionListener(
      child: Scaffold(
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
                        color: context.colors.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: NoemaLogo(
                        markSize: 30,
                        wordmark: false,
                        inkColor: context.colors.onSurface,
                        accentColor: context.colors.primary,
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
            GlobalSearchAnchor(
              isDesktop: displaySize == DisplaySize.desktop,
              onNavigate: (path) => _navigate(context, path),
            ),
            if (displaySize == DisplaySize.desktop)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: SizedBox(
                  height: 32,
                  child: VerticalDivider(
                    width: 1,
                    color: context.colors.outlineVariant,
                  ),
                ),
              )
            else
              const SizedBox(width: 8),
            if (displaySize == DisplaySize.mobile)
              _ProfileMenuButton(
                onNavigate: (path) => _navigate(context, path),
              ),
            if (displaySize == DisplaySize.desktop)
              Tooltip(
                message: assistant.isOpen
                    ? 'Fechar o painel do assistente de estudos'
                    : 'Tire dúvidas sobre seu conteúdo e gere atividades',
                child: assistant.isOpen
                    ? FilledButton.tonalIcon(
                        onPressed: () =>
                            ref.read(studyAssistantProvider.notifier).close(),
                        icon: const Icon(Icons.close_rounded),
                        label: const RuntimeLocalizedText('Fechar assistente'),
                      )
                    : OutlinedButton.icon(
                        onPressed: () =>
                            ref.read(studyAssistantProvider.notifier).open(),
                        icon: const Icon(Icons.auto_awesome_rounded),
                        label: const RuntimeLocalizedText('Assistente'),
                      ),
              )
            else
              IconButton(
                tooltip: assistant.isOpen
                    ? 'Fechar assistente de estudos'
                    : 'Abrir assistente: tire dúvidas e crie atividades',
                onPressed: () => assistant.isOpen
                    ? ref.read(studyAssistantProvider.notifier).close()
                    : ref.read(studyAssistantProvider.notifier).open(),
                isSelected: assistant.isOpen,
                selectedIcon: const Icon(Icons.close_rounded),
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
                labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
                selectedIndex:
                    _selectedNavigationIndex(currentPath) <
                        _primaryNavigationItems.length
                    ? _selectedNavigationIndex(currentPath)
                    : _primaryNavigationItems.length,
                onDestinationSelected: (index) {
                  if (index == _primaryNavigationItems.length) {
                    _showMoreNavigation(context);
                  } else {
                    _activateNavigationItem(
                      context,
                      _primaryNavigationItems[index],
                    );
                  }
                },
                destinations: [
                  for (final item in _primaryNavigationItems)
                    NavigationDestination(
                      icon: Icon(item.icon),
                      selectedIcon: Icon(item.selectedIcon),
                      label: item.label,
                    ),
                  NavigationDestination(
                    icon: Icon(
                      _selectedNavigationIndex(currentPath) >=
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
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth: extendedNavigation
                                    ? AppLayoutTokens
                                          .extendedNavigationRailWidth
                                    : AppLayoutTokens
                                          .compactNavigationRailWidth,
                              ),
                              child: NavigationRail(
                                trailingAtBottom: true,
                                trailing: _ProfileMenuButton(
                                  extended: extendedNavigation,
                                  onNavigate: (path) =>
                                      _navigate(context, path),
                                ),
                                selectedIndex: _selectedNavigationIndex(
                                  currentPath,
                                ),
                                onDestinationSelected: (index) =>
                                    _activateNavigationItem(
                                      context,
                                      _navigationItems[index],
                                    ),
                                extended: extendedNavigation,
                                labelType: extendedNavigation
                                    ? NavigationRailLabelType.none
                                    : NavigationRailLabelType.selected,
                                destinations: [
                                  for (final item in _navigationItems)
                                    NavigationRailDestination(
                                      icon: Tooltip(
                                        message: item.label,
                                        child: Icon(item.icon),
                                      ),
                                      selectedIcon: Tooltip(
                                        message: item.label,
                                        child: Icon(item.selectedIcon),
                                      ),
                                      label: Text(item.label),
                                    ),
                                ],
                              ),
                            ),
                            const VerticalDivider(width: 1),
                            Expanded(child: navigationShell),
                          ],
                        );
                  final assistantWidth =
                      (constraints.maxWidth -
                              AppLayoutTokens.floatingPanelInset)
                          .clamp(0, AppLayoutTokens.assistantPanelWidth)
                          .toDouble();
                  final assistantHeight =
                      (constraints.maxHeight -
                              AppLayoutTokens.floatingPanelInset)
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
              SizedBox(
                width: AppLayoutTokens.pinnedAssistantWidth,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: context.colors.surfaceContainerLow,
                    border: Border(
                      left: BorderSide(
                        color: context.colors.outlineVariant.withValues(
                          alpha: 0.65,
                        ),
                      ),
                    ),
                  ),
                  child: const StudyAssistantPanel(isDocked: true),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _showMoreNavigation(BuildContext context) async {
    Widget buildMoreNavigationItem(BuildContext context, _NavigationItem item) {
      final index = _navigationItems.indexOf(item);
      final isSelected = _selectedNavigationIndex(currentPath) == index;
      return Semantics(
        selected: isSelected,
        child: ListTile(
          leading: Icon(isSelected ? item.selectedIcon : item.icon),
          title: Text(item.label),
          selected: isSelected,
          trailing: isSelected ? const Icon(Icons.check_circle_outline) : null,
          minTileHeight: AppLayoutTokens.minimumControlHeight,
          onTap: () => Navigator.pop(context, index),
        ),
      );
    }

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
              child: RuntimeLocalizedText(
                'Mais áreas',
                style: context.textTheme.titleMedium,
              ),
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
                  group.label,
                  style: context.textTheme.labelLarge?.copyWith(
                    color: context.colors.onSurfaceVariant,
                  ),
                ),
              ),
              for (final item in group.items)
                buildMoreNavigationItem(context, item),
            ],
          ],
        ),
      ),
    );
    if (selectedIndex != null && context.mounted) {
      await _activateNavigationItem(context, _navigationItems[selectedIndex]);
    }
  }

  int _selectedNavigationIndex(String path) {
    final routeIndex = _navigationItems.indexWhere((item) {
      final routePath = item.routePath;
      return routePath != null &&
          (path == routePath || path.startsWith('$routePath/'));
    });
    if (routeIndex >= 0) return routeIndex;
    final branchIndex = _navigationItems.indexWhere(
      (item) => item.branchIndex == navigationShell.currentIndex,
    );
    return branchIndex < 0 ? 0 : branchIndex;
  }

  Future<void> _activateNavigationItem(
    BuildContext context,
    _NavigationItem item,
  ) async {
    final routePath = item.routePath;
    if (routePath != null) {
      await _navigate(context, routePath);
      return;
    }
    final branchIndex = item.branchIndex;
    if (branchIndex != null) await _goBranch(context, branchIndex);
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

class _AiTaskCompletionListener extends ConsumerStatefulWidget {
  const _AiTaskCompletionListener({required this.child});

  final Widget child;

  @override
  ConsumerState<_AiTaskCompletionListener> createState() =>
      _AiTaskCompletionListenerState();
}

class _AiTaskCompletionListenerState
    extends ConsumerState<_AiTaskCompletionListener> {
  final _notifiedTaskIds = <String>{};
  bool _hasInitialSnapshot = false;

  @override
  Widget build(BuildContext context) {
    ref.listen(aiBackgroundTaskItemsProvider, (previous, next) {
      final items = next.asData?.value;
      if (items == null) return;
      final completed = items
          .where((item) => item.task.status == aiTaskCompleted)
          .toList(growable: false);
      final newItems = completed
          .where((item) => _notifiedTaskIds.add(item.task.id))
          .toList(growable: false);
      if (!_hasInitialSnapshot) {
        _hasInitialSnapshot = true;
        return;
      }
      for (final item in newItems) {
        final message = switch (item.task.taskType) {
          aiNodeDescriptionTaskType =>
            'Descrição gerada para "${item.node.title}".',
          aiOpenEndedCorrectionTaskType || aiMultipleChoiceCorrectionTaskType =>
            'Correção concluída para "${item.node.title}".',
          aiStudyPackTaskType =>
            'Pacote de estudo pronto para "${item.node.title}".',
          _ => null,
        };
        if (message != null && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              duration: const Duration(seconds: 5),
            ),
          );
        }
      }
    });
    return widget.child;
  }
}

enum _ProfileMenuAction { profile, preferences, toggleBrightness, logout }

class _ProfileMenuButton extends ConsumerWidget {
  const _ProfileMenuButton({required this.onNavigate, this.extended = false});

  final ValueChanged<String> onNavigate;
  final bool extended;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(userProvider);
    final profile = profileState.asData?.value;
    final avatarUrl = ref.watch(profileAvatarUrlProvider).asData?.value;
    final brightness = ref.watch(brightnessProvider);
    final displayName = profile == null
        ? profileState.isLoading
              ? 'Carregando perfil…'
              : 'Minha conta'
        : profile.displayName.trim().isEmpty
        ? profile.userName
        : profile.displayName;
    final email = profile?.primaryEmail.trim() ?? '';

    return PopupMenuButton<_ProfileMenuAction>(
      tooltip: 'Abrir menu de $displayName',
      position: PopupMenuPosition.under,
      menuPadding: EdgeInsets.zero,
      constraints: const BoxConstraints(minWidth: 260, maxWidth: 300),
      color: context.colors.surfaceContainerHigh,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: context.colors.outlineVariant),
      ),
      onSelected: (action) async {
        switch (action) {
          case _ProfileMenuAction.profile:
            _openConfigSection(ref, ConfigSections.profile);
            break;
          case _ProfileMenuAction.preferences:
            _openConfigSection(ref, ConfigSections.preferences);
            break;
          case _ProfileMenuAction.toggleBrightness:
            await _toggleBrightness(context, ref, brightness);
            break;
          case _ProfileMenuAction.logout:
            await _logout(context, ref);
            break;
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem<_ProfileMenuAction>(
          enabled: false,
          height: 76,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                displayName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.textTheme.titleSmall,
              ),
              const SizedBox(height: 3),
              Text(
                email.isEmpty ? 'E-mail não informado' : email,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.textTheme.bodySmall?.copyWith(
                  color: context.colors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        PopupMenuDivider(height: 1, color: context.colors.outlineVariant),
        PopupMenuItem(
          value: _ProfileMenuAction.profile,
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: const _ProfileMenuEntry(
            icon: Icons.person_outline_rounded,
            label: 'Perfil',
          ),
        ),
        PopupMenuItem(
          value: _ProfileMenuAction.preferences,
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: const _ProfileMenuEntry(
            icon: Icons.settings_outlined,
            label: 'Preferências',
          ),
        ),
        PopupMenuItem(
          value: _ProfileMenuAction.toggleBrightness,
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: _ProfileMenuEntry(
            icon: brightness == Brightness.dark
                ? Icons.light_mode_outlined
                : Icons.dark_mode_outlined,
            label: brightness == Brightness.dark
                ? 'Usar tema claro'
                : 'Usar tema escuro',
          ),
        ),
        PopupMenuDivider(height: 1, color: context.colors.outlineVariant),
        PopupMenuItem(
          value: _ProfileMenuAction.logout,
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: _ProfileMenuEntry(
            icon: Icons.logout_rounded,
            label: 'Sair',
            color: context.colors.error,
          ),
        ),
      ],
      child: Semantics(
        button: true,
        label: 'Abrir menu do perfil de $displayName',
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: extended
              ? SizedBox(
                  width: AppLayoutTokens.extendedNavigationRailWidth - 16,
                  child: Row(
                    children: [
                      _buildProfileAvatar(
                        context,
                        imageUrl: avatarUrl,
                        name: displayName,
                        radius: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Tooltip(
                          message: displayName,
                          child: Text(
                            displayName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: context.textTheme.labelLarge,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : _buildProfileAvatar(
                  context,
                  imageUrl: avatarUrl,
                  name: displayName,
                  radius: 20,
                ),
        ),
      ),
    );
  }

  void _openConfigSection(WidgetRef ref, ConfigSections section) {
    ref.read(sectionNavigatorProvider.notifier).changeCurrentSection(section);
    onNavigate(RoutePaths.config);
  }

  Future<void> _logout(BuildContext context, WidgetRef ref) async {
    try {
      final localCleanupError = await endAccountSession(ref);
      if (!context.mounted) return;
      context.go(RoutePaths.login);
      if (localCleanupError != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'A sessão foi encerrada, mas o estado local '
              'não pôde ser atualizado: $localCleanupError',
            ),
          ),
        );
      }
    } catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: RuntimeLocalizedText('Não foi possível sair: $error'),
        ),
      );
    }
  }

  Future<void> _toggleBrightness(
    BuildContext context,
    WidgetRef ref,
    Brightness currentBrightness,
  ) async {
    try {
      await ref
          .read(colorProvider.notifier)
          .setBrightness(
            brightness: currentBrightness == Brightness.dark
                ? Brightness.light
                : Brightness.dark,
          );
    } catch (error, stackTrace) {
      debugPrint('Não foi possível alternar o tema: $error');
      debugPrintStack(stackTrace: stackTrace);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: RuntimeLocalizedText(
              'Não foi possível alterar o tema. Tente novamente.',
            ),
          ),
        );
      }
    }
  }

  Widget _buildProfileAvatar(
    BuildContext context, {
    required String? imageUrl,
    required String name,
    required double radius,
  }) {
    final initial = name.trim().isEmpty
        ? 'N'
        : name.trim().substring(0, 1).toUpperCase();
    Widget fallback() => Center(
      child: Text(
        initial,
        style: TextStyle(
          color: context.colors.onPrimaryContainer,
          fontWeight: FontWeight.w700,
        ),
      ),
    );

    return CircleAvatar(
      radius: radius,
      backgroundColor: context.colors.primaryContainer,
      child: ClipOval(
        child: SizedBox(
          width: radius * 2,
          height: radius * 2,
          child: imageUrl == null
              ? fallback()
              : Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, progress) =>
                      progress == null ? child : fallback(),
                  errorBuilder: (context, error, stackTrace) => fallback(),
                ),
        ),
      ),
    );
  }
}

class _ProfileMenuEntry extends StatelessWidget {
  const _ProfileMenuEntry({
    required this.icon,
    required this.label,
    this.color,
  });

  final IconData icon;
  final String label;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final foreground = color ?? context.colors.onSurface;
    return Row(
      children: [
        Icon(icon, size: 22, color: foreground),
        const SizedBox(width: 14),
        Expanded(
          child: Text(
            label,
            style: context.textTheme.bodyLarge?.copyWith(color: foreground),
          ),
        ),
      ],
    );
  }
}

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
