import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noema/shared/localization/runtime_localization.dart';
import 'package:noema/core/design/theme/theme_tokens.dart';
import 'package:noema/core/design/tokens/layout.dart';
import 'package:noema/core/network/connetction_checker.dart';
import 'package:noema/feature/config/data/enums.dart';
import 'package:noema/feature/config/presentation/api_keys_section.dart';
import 'package:noema/feature/config/presentation/color_theme_section.dart';
import 'package:noema/feature/config/presentation/config_section_catalog.dart';
import 'package:noema/feature/config/presentation/google_account_section.dart';
import 'package:noema/feature/config/presentation/manual_backup_section.dart';
import 'package:noema/feature/config/presentation/personal_ai_configuration_section.dart';
import 'package:noema/feature/config/presentation/preferences_section.dart';
import 'package:noema/feature/config/presentation/profile_section.dart';
import 'package:noema/feature/config/presentation/typography_theme_section.dart';
import 'package:noema/feature/config/presentation/widgets/config_connection_banner.dart';
import 'package:noema/feature/config/presentation/widgets/config_navigation_sidebar.dart';
import 'package:noema/feature/config/providers/config_refresh_provider.dart';
import 'package:noema/feature/config/providers/section_navigator_provider.dart';
import 'package:noema/shared/widgets/app_card.dart';
import 'package:noema/shared/widgets/app_section.dart';
import 'package:noema/shared/widgets/responsive_content.dart';

class ConfigPage extends ConsumerStatefulWidget {
  const ConfigPage({super.key});

  @override
  ConsumerState<ConfigPage> createState() => _ConfigPageState();
}

class _ConfigPageState extends ConsumerState<ConfigPage> {
  static const _refreshInterval = Duration(minutes: 5);

  final _searchController = TextEditingController();
  final _contentScrollController = ScrollController();
  final _sidebarScrollController = ScrollController();
  Timer? _refreshTimer;
  ConfigSections _activeSection = ConfigSections.profile;
  String _searchQuery = '';

  void _scrollTo(ConfigSections section) {
    setState(() => _activeSection = section);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_contentScrollController.hasClients) {
        _contentScrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _selectSection(ConfigSections section) {
    if (_searchQuery.isNotEmpty) {
      _searchController.clear();
      setState(() => _searchQuery = '');
    }
    _scrollTo(section);
  }

  void _updateSearch(String query) {
    setState(() {
      _searchQuery = query;
      final matches = configSectionCatalog
          .where((item) => item.matchesQuery(query))
          .toList();
      if (matches.isNotEmpty &&
          !matches.any((item) => item.section == _activeSection)) {
        _activeSection = matches.first.section;
      }
    });
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() => _searchQuery = '');
  }

  Widget _buildSectionContent(ConfigSections section) {
    switch (section) {
      case ConfigSections.profile:
        return const ProfileSection();
      case ConfigSections.colorTheme:
        return const ColorThemeSection();
      case ConfigSections.typographyTheme:
        return const TypographyThemeSection();
      case ConfigSections.aiConfiguration:
        return const PersonalAiConfigurationSection();
      case ConfigSections.apiKeys:
        return const ApiKeysSection();
      case ConfigSections.googleAccount:
        return const GoogleAccountSection();
      case ConfigSections.manualBackup:
        return const ManualBackupSection();
      case ConfigSections.preferences:
        return const PreferencesSection();
    }
  }

  @override
  void initState() {
    super.initState();

    ref.listenManual(sectionNavigatorProvider, (previous, next) {
      _scrollTo(next.currentSection);
    });
    _refreshTimer = Timer.periodic(_refreshInterval, (_) {
      if (ref.read(serverConnectionChecker).value == true) {
        ref.read(configRefreshProvider.notifier).refresh();
      }
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    _searchController.dispose();
    _contentScrollController.dispose();
    _sidebarScrollController.dispose();
    super.dispose();
  }

  void _handleRefresh() {
    ref.read(configRefreshProvider.notifier).refresh();
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: RuntimeLocalizedText('Atualizando informações do servidor…'),
        ),
      );
  }

  Widget _buildSelectedSection(
    List<ConfigSectionMetadata> sections,
    ThemeData theme,
  ) {
    final metadata = sections
        .where((item) => item.section == _activeSection)
        .firstOrNull;
    if (metadata == null) {
      return const SizedBox.shrink();
    }
    return AppSection(
      key: ValueKey(metadata.section),
      title: metadata.title,
      description: metadata.description,
      trailing: Icon(metadata.icon, color: theme.colorScheme.onSurfaceVariant),
      child: _buildSectionContent(metadata.section),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isConnected = ref.watch(serverConnectionChecker).value ?? false;
    final theme = Theme.of(context);
    final spacing = context.spacing;

    final filteredSections = configSectionCatalog
        .where((item) => item.matchesQuery(_searchQuery))
        .toList();

    return LayoutBuilder(
      builder: (context, constraints) {
        final showSidebar =
            constraints.maxWidth >= AppLayoutTokens.compactBreakpoint;

        final header = Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: spacing.md,
          children: [
            _ConfigHeader(
              searchController: _searchController,
              searchQuery: _searchQuery,
              onSearchChanged: _updateSearch,
              onClearSearch: _clearSearch,
            ),
            ConfigConnectionBanner(
              isConnected: isConnected,
              onRefresh: _handleRefresh,
            ),
          ],
        );

        final sectionsList = filteredSections.isEmpty
            ? _EmptySearchState(query: _searchQuery, onClear: _clearSearch)
            : _buildSelectedSection(filteredSections, theme);

        if (showSidebar && filteredSections.isNotEmpty) {
          return SizedBox(
            height: constraints.maxHeight,
            child: AppResponsiveContent(
              maxWidth: AppLayoutTokens.widePageContentWidth,
              padding: const EdgeInsets.only(
                left: 4,
                right: AppLayoutTokens.pageHorizontalPaddingCompact,
                top: AppLayoutTokens.pageVerticalPaddingRegular,
                bottom: AppLayoutTokens.pageVerticalPaddingRegular,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    width: 240,
                    child: Scrollbar(
                      controller: _sidebarScrollController,
                      thumbVisibility: true,
                      trackVisibility: true,
                      interactive: true,
                      thickness: 6,
                      child: SingleChildScrollView(
                        controller: _sidebarScrollController,
                        child: ConfigNavigationSidebar(
                          sections: filteredSections,
                          activeSection: _activeSection,
                          onSelectSection: _scrollTo,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: spacing.md),
                  Expanded(
                    child: Scrollbar(
                      controller: _contentScrollController,
                      thumbVisibility: true,
                      trackVisibility: true,
                      interactive: true,
                      thickness: 6,
                      child: SingleChildScrollView(
                        controller: _contentScrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          spacing: spacing.md,
                          children: [header, sectionsList],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return SizedBox(
          height: constraints.maxHeight,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(
                  AppLayoutTokens.pageHorizontalPaddingCompact,
                  spacing.sm,
                  AppLayoutTokens.pageHorizontalPaddingCompact,
                  spacing.xs,
                ),
                child: DropdownButtonFormField<ConfigSections>(
                  initialValue: _activeSection,
                  decoration: const InputDecoration(
                    labelText: 'Seção de configuração',
                    prefixIcon: Icon(Icons.tune),
                  ),
                  items: [
                    for (final section in configSectionCatalog)
                      DropdownMenuItem(
                        value: section.section,
                        child: Text(section.title),
                      ),
                  ],
                  onChanged: (section) {
                    if (section != null) _selectSection(section);
                  },
                ),
              ),
              Expanded(
                child: Scrollbar(
                  controller: _contentScrollController,
                  thumbVisibility: true,
                  trackVisibility: true,
                  interactive: true,
                  thickness: 6,
                  child: SingleChildScrollView(
                    controller: _contentScrollController,
                    child: AppResponsiveContent(
                      maxWidth: AppLayoutTokens.widePageContentWidth,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        spacing: spacing.md,
                        children: [header, sectionsList],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ConfigHeader extends StatelessWidget {
  const _ConfigHeader({
    required this.searchController,
    required this.searchQuery,
    required this.onSearchChanged,
    required this.onClearSearch,
  });

  final TextEditingController searchController;
  final String searchQuery;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onClearSearch;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;

    final titleBlock = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RuntimeLocalizedText(
          'Configurações',
          style: theme.textTheme.headlineSmall,
        ),
        SizedBox(height: spacing.xs / 2),
        Text(
          'Gerencie sua conta, aparência, provedores de IA, backups e preferências.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );

    final searchField = ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 320),
      child: TextField(
        controller: searchController,
        onChanged: onSearchChanged,
        decoration: InputDecoration(
          hintText: 'Filtrar configurações…',
          prefixIcon: const Icon(Icons.search, size: 20),
          suffixIcon: searchQuery.isNotEmpty
              ? IconButton(
                  tooltip: 'Limpar filtro',
                  icon: const Icon(Icons.close, size: 18),
                  onPressed: onClearSearch,
                )
              : null,
          isDense: true,
        ),
      ),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < AppLayoutTokens.compactHeaderBreakpoint) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              titleBlock,
              SizedBox(height: spacing.md),
              searchField,
            ],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(child: titleBlock),
            SizedBox(width: spacing.md),
            searchField,
          ],
        );
      },
    );
  }
}

class _EmptySearchState extends StatelessWidget {
  const _EmptySearchState({required this.query, required this.onClear});

  final String query;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;

    return AppCard(
      padding: EdgeInsets.all(spacing.xl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.search_off_outlined,
            size: 40,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          SizedBox(height: spacing.sm),
          Text(
            'Nenhuma seção encontrada para "$query"',
            style: theme.textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: spacing.xs),
          Text(
            'Tente outro termo ou limpe o filtro para ver todas as configurações.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: spacing.md),
          OutlinedButton.icon(
            onPressed: onClear,
            icon: const Icon(Icons.clear_all),
            label: const RuntimeLocalizedText('Limpar filtro'),
          ),
        ],
      ),
    );
  }
}
