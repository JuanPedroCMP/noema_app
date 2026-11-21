import 'dart:ui' as ui;

import 'package:file_picker/file_picker.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:noema/shared/localization/runtime_localization.dart';
import 'package:noema/core/database/database_provider.dart';
import 'package:noema/feature/config/data/config_dao.dart';
import 'package:noema/feature/config/providers/preference_storage_provider.dart';
import 'package:noema/feature/config/providers/user_provider.dart';
import 'package:noema/feature/review/data/dashboard_ai_usage_service.dart';
import 'package:noema/feature/review/data/dashboard_export_service.dart';
import 'package:noema/feature/review/data/domain_dashboard_service.dart';

final scopedDomainDashboardProvider =
    FutureProvider.family<DomainDashboardSummary, DomainDashboardQuery>((
      ref,
      query,
    ) async {
      final database = ref.watch(appDatabaseProvider);
      final user = await ref.watch(userProvider.future);
      return DomainDashboardService(
        database,
      ).load(userId: user.id, query: query);
    });

final dashboardSectionsPreferenceProvider = FutureProvider<List<String>?>((
  ref,
) async {
  final user = await ref.watch(userProvider.future);
  final config = await ConfigDao(
    ref.watch(appDatabaseProvider),
  ).getConfigByUser(userId: user.id);
  if (config == null) return null;
  final value = readConfigPreference(
    config.preferences,
    'superDashboardSections',
  );
  if (value is! List) return null;
  const availableSections = {
    'evolution',
    'reviews',
    'fsrs',
    'graphs',
    'nodes',
    'activity',
    'ai',
  };
  return [
    for (final section in value)
      if (section is String && availableSections.contains(section)) section,
  ];
});

enum _DashboardLayout { overview, rhythm, mastery, ai, custom }

class DomainDashboardPage extends ConsumerStatefulWidget {
  const DomainDashboardPage({
    super.key,
    this.initialGraphId,
    this.initialNodeId,
  });

  final String? initialGraphId;
  final String? initialNodeId;

  @override
  ConsumerState<DomainDashboardPage> createState() =>
      _DomainDashboardPageState();
}

class _DomainDashboardPageState extends ConsumerState<DomainDashboardPage> {
  final _shareCardKey = GlobalKey();
  final _exportService = const DashboardExportService();
  final _enabledSections = <String>{'evolution', 'reviews', 'fsrs', 'graphs'};
  _DashboardLayout _layout = _DashboardLayout.overview;
  bool _filtersExpanded = false;
  String _scopeType = 'global';
  String? _selectedGraphId;
  String? _selectedNodeId;
  String _periodKey = '30';
  DateTimeRange? _customRange;

  @override
  void initState() {
    super.initState();
    if (widget.initialNodeId != null) {
      _scopeType = 'node';
      _selectedGraphId = widget.initialGraphId;
      _selectedNodeId = widget.initialNodeId;
      _filtersExpanded = true;
    } else if (widget.initialGraphId != null) {
      _scopeType = 'graph';
      _selectedGraphId = widget.initialGraphId;
      _filtersExpanded = true;
    }
    _loadSavedSections();
  }

  @override
  Widget build(BuildContext context) {
    final query = _query;
    final summary = ref.watch(scopedDomainDashboardProvider(query));
    final aiUsage = ref.watch(dashboardAiUsageProvider(query));
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Painel de aprendizagem',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 4),
              Text(
                'Acompanhe sua evolução, revisões, retenção e uso de IA.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 18),
              summary.when(
                loading: () => const Card(
                  child: Padding(
                    padding: EdgeInsets.all(28),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                ),
                error: (error, _) => Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: RuntimeLocalizedText(
                      'Não foi possível carregar o painel: $error',
                    ),
                  ),
                ),
                data: (data) => _buildDashboard(context, data, aiUsage, query),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDashboard(
    BuildContext context,
    DomainDashboardSummary summary,
    AsyncValue<DashboardAiUsageSummary> aiUsage,
    DomainDashboardQuery query,
  ) {
    final theme = Theme.of(context);
    final currentAiUsage = aiUsage.asData?.value;
    final graphOptions = summary.availableGraphs;
    final nodeOptions = summary.availableNodes
        .where(
          (node) =>
              _selectedGraphId == null || node.graphId == _selectedGraphId,
        )
        .toList();
    final scopeName = _scopeName(summary);
    final periodName = _periodName;
    final metrics = _metricsForLayout(summary, currentAiUsage);
    final sections = <Widget>[
      if (_sectionIsVisible('evolution')) _ProgressPanel(summary: summary),
      if (_sectionIsVisible('reviews')) _ReviewPanel(summary: summary),
      if (_sectionIsVisible('fsrs')) _FsrsPanel(summary: summary),
      if (_sectionIsVisible('ai'))
        _AiUsagePanel(
          usage: aiUsage,
          hasScopedFilter: query.graphId != null,
          compact: _layout == _DashboardLayout.ai,
        ),
      if (_sectionIsVisible('graphs')) _GraphPanel(summary: summary),
      if (_sectionIsVisible('nodes')) _NodePanel(summary: summary),
      if (_sectionIsVisible('activity')) _ActivityPanel(summary: summary),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Card(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.filter_list_rounded),
                title: const RuntimeLocalizedText('Filtros'),
                subtitle: RuntimeLocalizedText('$scopeName · $periodName'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      tooltip: 'Personalizar layout',
                      onPressed: () => _showSectionPicker(context),
                      icon: const Icon(Icons.tune_rounded),
                    ),
                    PopupMenuButton<DashboardExportFormat>(
                      tooltip: 'Exportar painel',
                      onSelected: (format) => _export(
                        context,
                        format,
                        summary,
                        currentAiUsage,
                        scopeName,
                        periodName,
                      ),
                      itemBuilder: (context) => const [
                        PopupMenuItem(
                          value: DashboardExportFormat.csv,
                          child: ListTile(
                            leading: Icon(Icons.table_chart_outlined),
                            title: RuntimeLocalizedText('Planilha / CSV'),
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                        PopupMenuItem(
                          value: DashboardExportFormat.pdf,
                          child: ListTile(
                            leading: Icon(Icons.picture_as_pdf_outlined),
                            title: RuntimeLocalizedText('Relatório PDF'),
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                        PopupMenuItem(
                          value: DashboardExportFormat.png,
                          child: ListTile(
                            leading: Icon(Icons.image_outlined),
                            title: RuntimeLocalizedText('Imagem PNG'),
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      tooltip: _filtersExpanded
                          ? 'Recolher filtros'
                          : 'Mostrar filtros',
                      onPressed: () =>
                          setState(() => _filtersExpanded = !_filtersExpanded),
                      icon: Icon(
                        _filtersExpanded
                            ? Icons.expand_less_rounded
                            : Icons.expand_more_rounded,
                      ),
                    ),
                  ],
                ),
              ),
              if (_filtersExpanded)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      SizedBox(
                        width: 180,
                        child: _dropdownField<String>(
                          label: 'Escopo',
                          value: _scopeType,
                          items: const [
                            DropdownMenuItem(
                              value: 'global',
                              child: RuntimeLocalizedText('Global'),
                            ),
                            DropdownMenuItem(
                              value: 'graph',
                              child: RuntimeLocalizedText('Por grafo'),
                            ),
                            DropdownMenuItem(
                              value: 'node',
                              child: RuntimeLocalizedText('Por nó'),
                            ),
                          ],
                          onChanged: (value) {
                            if (value == null) return;
                            setState(() {
                              _scopeType = value;
                              if (value == 'global') {
                                _selectedGraphId = null;
                                _selectedNodeId = null;
                              } else if (value == 'graph') {
                                _selectedNodeId = null;
                              }
                            });
                          },
                        ),
                      ),
                      if (_scopeType != 'global')
                        SizedBox(
                          width: 260,
                          child: _dropdownField<String>(
                            label: 'Grafo',
                            value:
                                graphOptions.any(
                                  (graph) => graph.id == _selectedGraphId,
                                )
                                ? _selectedGraphId
                                : null,
                            hint: const RuntimeLocalizedText(
                              'Selecione um grafo',
                            ),
                            items: [
                              for (final graph in graphOptions)
                                DropdownMenuItem(
                                  value: graph.id,
                                  child: Text(
                                    '${graph.title} (${graph.nodeCount})',
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                            ],
                            onChanged: (value) => setState(() {
                              _selectedGraphId = value;
                              _selectedNodeId = null;
                            }),
                          ),
                        ),
                      if (_scopeType == 'node')
                        SizedBox(
                          width: 260,
                          child: DropdownMenu<String>(
                            key: ValueKey(_selectedNodeId),
                            label: const RuntimeLocalizedText('Nó'),
                            width: 260,
                            enableFilter: true,
                            enableSearch: true,
                            initialSelection:
                                nodeOptions.any(
                                  (node) => node.id == _selectedNodeId,
                                )
                                ? _selectedNodeId
                                : null,
                            dropdownMenuEntries: [
                              for (final node in nodeOptions)
                                DropdownMenuEntry(
                                  value: node.id,
                                  label: node.title,
                                ),
                            ],
                            onSelected: (value) {
                              final node = nodeOptions.where(
                                (item) => item.id == value,
                              );
                              setState(() {
                                _selectedNodeId = value;
                                if (node.isNotEmpty) {
                                  _selectedGraphId = node.first.graphId;
                                }
                              });
                            },
                          ),
                        ),
                      SizedBox(
                        width: 190,
                        child: _dropdownField<String>(
                          label: 'Período',
                          value: _periodKey,
                          items: const [
                            DropdownMenuItem(
                              value: '7',
                              child: RuntimeLocalizedText('Últimos 7 dias'),
                            ),
                            DropdownMenuItem(
                              value: '30',
                              child: RuntimeLocalizedText('Últimos 30 dias'),
                            ),
                            DropdownMenuItem(
                              value: '90',
                              child: RuntimeLocalizedText('Últimos 90 dias'),
                            ),
                            DropdownMenuItem(
                              value: '365',
                              child: RuntimeLocalizedText('Último ano'),
                            ),
                            DropdownMenuItem(
                              value: 'all',
                              child: RuntimeLocalizedText('Todo o período'),
                            ),
                            DropdownMenuItem(
                              value: 'custom',
                              child: RuntimeLocalizedText('Personalizado…'),
                            ),
                          ],
                          onChanged: (value) {
                            if (value == null) return;
                            if (value == 'custom') {
                              _pickCustomRange();
                            } else {
                              setState(() => _periodKey = value);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final (layout, label, icon) in const [
              (_DashboardLayout.overview, 'Resumo', Icons.dashboard_outlined),
              (_DashboardLayout.rhythm, 'Ritmo', Icons.calendar_month_outlined),
              (_DashboardLayout.mastery, 'Domínio', Icons.insights_outlined),
              (_DashboardLayout.ai, 'IA', Icons.auto_awesome_outlined),
              (_DashboardLayout.custom, 'Personalizado', Icons.tune_rounded),
            ])
              ChoiceChip(
                avatar: Icon(icon, size: 18),
                label: Text(label),
                selected: _layout == layout,
                onSelected: (_) => setState(() => _layout = layout),
              ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4, bottom: 8),
          child: Text(_layoutDescription, style: theme.textTheme.bodySmall),
        ),
        if (_selectedGraphId == null && _scopeType != 'global')
          const _EmptyHint(
            message: 'Selecione um grafo para ver os dados desse escopo.',
          )
        else ...[
          RepaintBoundary(
            key: _shareCardKey,
            child: _ShareSummaryCard(
              scope: scopeName,
              period: periodName,
              layout: _layoutName,
              metrics: metrics,
            ),
          ),
          const SizedBox(height: 16),
          if (sections.isNotEmpty)
            LayoutBuilder(
              builder: (context, constraints) {
                final useTwoColumns = constraints.maxWidth >= 840;
                final gap = 16.0;
                final columnWidth = (constraints.maxWidth - gap) / 2;
                return Wrap(
                  spacing: gap,
                  runSpacing: gap,
                  children: [
                    for (var index = 0; index < sections.length; index++)
                      SizedBox(
                        width:
                            !useTwoColumns ||
                                sections.length == 1 ||
                                (sections.length.isOdd &&
                                    index == sections.length - 1)
                            ? constraints.maxWidth
                            : columnWidth,
                        child: sections[index],
                      ),
                  ],
                );
              },
            )
          else if (_layout == _DashboardLayout.custom)
            const _EmptyHint(
              message:
                  'Seu layout está vazio. Use Personalizar layout para adicionar seções.',
            ),
        ],
        const SizedBox(height: 10),
        if (_layout == _DashboardLayout.ai)
          Text(
            'Tokens só aparecem quando fornecidos pela API; o painel não estima valores.',
            style: theme.textTheme.bodySmall,
          ),
      ],
    );
  }

  Widget _dropdownField<T>({
    required String label,
    required T? value,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
    Widget? hint,
  }) => InputDecorator(
    decoration: InputDecoration(
      labelText: label,
      border: const OutlineInputBorder(),
    ),
    child: DropdownButtonHideUnderline(
      child: DropdownButton<T>(
        value: value,
        hint: hint,
        isExpanded: true,
        items: items,
        onChanged: onChanged,
      ),
    ),
  );

  DomainDashboardQuery get _query {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    DateTime? start;
    DateTime? endBefore;
    var allTime = false;
    if (_periodKey == 'all') {
      allTime = true;
    } else if (_periodKey == 'custom' && _customRange != null) {
      start = DateTime(
        _customRange!.start.year,
        _customRange!.start.month,
        _customRange!.start.day,
      );
      endBefore = DateTime(
        _customRange!.end.year,
        _customRange!.end.month,
        _customRange!.end.day + 1,
      );
    } else {
      final days = int.tryParse(_periodKey) ?? 30;
      start = today.subtract(Duration(days: days - 1));
      endBefore = today.add(const Duration(days: 1));
    }

    return DomainDashboardQuery(
      graphId: _scopeType == 'global' ? null : _selectedGraphId,
      nodeId: _scopeType == 'node' ? _selectedNodeId : null,
      startAt: start,
      endBefore: endBefore,
      allTime: allTime,
    );
  }

  String get _periodName {
    if (_periodKey == 'all') return 'Todo o período';
    if (_periodKey == 'custom' && _customRange != null) {
      return '${DateFormat.yMMMd().format(_customRange!.start)} – '
          '${DateFormat.yMMMd().format(_customRange!.end)}';
    }
    return switch (_periodKey) {
      '7' => 'Últimos 7 dias',
      '90' => 'Últimos 90 dias',
      '365' => 'Último ano',
      _ => 'Últimos 30 dias',
    };
  }

  String _scopeName(DomainDashboardSummary summary) {
    if (_scopeType == 'global') return 'Todos os grafos';
    final graph = summary.availableGraphs.where(
      (item) => item.id == _selectedGraphId,
    );
    final graphName = graph.isEmpty ? 'Grafo' : graph.first.title;
    if (_scopeType == 'graph') return graphName;
    final node = summary.availableNodes.where(
      (item) => item.id == _selectedNodeId,
    );
    return node.isEmpty ? '$graphName · selecione um nó' : node.first.title;
  }

  String get _layoutName => switch (_layout) {
    _DashboardLayout.overview => 'Resumo',
    _DashboardLayout.rhythm => 'Ritmo de estudo',
    _DashboardLayout.mastery => 'Domínio e retenção',
    _DashboardLayout.ai => 'Uso de IA',
    _DashboardLayout.custom => 'Personalizado',
  };

  String get _layoutDescription => switch (_layout) {
    _DashboardLayout.overview =>
      'O essencial: domínio, acertos e sua atividade recente.',
    _DashboardLayout.rhythm =>
      'Veja quando você estuda e como mantém a frequência de revisão.',
    _DashboardLayout.mastery =>
      'Acompanhe a evolução do domínio e os sinais de retenção.',
    _DashboardLayout.ai =>
      'Chamadas e tokens registrados pela API, sem estimativas.',
    _DashboardLayout.custom => 'Mostrando apenas as seções que você escolheu.',
  };

  List<_Metric> _metricsForLayout(
    DomainDashboardSummary summary,
    DashboardAiUsageSummary? aiUsage,
  ) {
    final mastery = _formatPercent(summary.averageMastery);
    final accuracy = _formatPercent(summary.averageAccuracy);
    final retention = _formatPercent(summary.averageRetrievability);
    final calls = aiUsage == null ? '—' : '${aiUsage.calls}';
    final totalTokens = aiUsage == null || aiUsage.callsWithTotalTokenData == 0
        ? '—'
        : '${aiUsage.totalTokens}';
    final inputTokens = aiUsage == null || aiUsage.callsWithInputTokenData == 0
        ? '—'
        : '${aiUsage.inputTokens}';
    final outputTokens =
        aiUsage == null || aiUsage.callsWithOutputTokenData == 0
        ? '—'
        : '${aiUsage.outputTokens}';

    return switch (_layout) {
      _DashboardLayout.overview => [
        _Metric(
          'Conceitos dominados',
          '${summary.masteredConcepts}',
          Icons.check_circle_outline_rounded,
        ),
        _Metric(
          'Conceitos frágeis',
          '${summary.fragileConcepts}',
          Icons.warning_amber_outlined,
        ),
        _Metric(
          'Pré-requisitos críticos',
          '${summary.criticalPrerequisites}',
          Icons.account_tree_outlined,
        ),
        _Metric('Domínio médio', mastery, Icons.track_changes_outlined),
      ],
      _DashboardLayout.rhythm => [
        _Metric('Revisões', '${summary.reviewCount}', Icons.replay_rounded),
        _Metric(
          'Dias ativos',
          '${summary.activeReviewDays}',
          Icons.calendar_today_outlined,
        ),
        _Metric(
          'Tempo estudado',
          '${summary.sessionMinutes} min',
          Icons.timer_outlined,
        ),
        _Metric(
          'Sessões concluídas',
          '${summary.sessionCount}',
          Icons.event_available_outlined,
        ),
      ],
      _DashboardLayout.mastery => [
        _Metric('Domínio médio', mastery, Icons.track_changes_outlined),
        _Metric(
          'Nós dominados',
          '${summary.masteredConcepts}',
          Icons.check_circle_outline_rounded,
        ),
        _Metric(
          'Nós frágeis',
          '${summary.fragileConcepts}',
          Icons.warning_amber_outlined,
        ),
        _Metric('Retenção FSRS', retention, Icons.psychology_outlined),
      ],
      _DashboardLayout.ai => [
        _Metric('Chamadas', calls, Icons.auto_awesome_outlined),
        _Metric('Tokens totais', totalTokens, Icons.token_outlined),
        _Metric('Entrada', inputTokens, Icons.call_received_rounded),
        _Metric('Saída', outputTokens, Icons.call_made_rounded),
      ],
      _DashboardLayout.custom => [
        _Metric('Domínio', mastery, Icons.track_changes_outlined),
        _Metric('Acertos', accuracy, Icons.check_circle_outline),
        _Metric('Revisões', '${summary.reviewCount}', Icons.replay_rounded),
        _Metric('Retenção', retention, Icons.psychology_outlined),
      ],
    };
  }

  bool _sectionIsVisible(String section) {
    if (_layout == _DashboardLayout.custom) {
      return _enabledSections.contains(section);
    }
    return switch (_layout) {
      _DashboardLayout.overview =>
        section == 'evolution' || section == 'reviews' || section == 'graphs',
      _DashboardLayout.rhythm => section == 'reviews',
      _DashboardLayout.mastery =>
        section == 'evolution' || section == 'fsrs' || section == 'graphs',
      _DashboardLayout.ai => section == 'ai',
      _DashboardLayout.custom => false,
    };
  }

  Future<void> _pickCustomRange() async {
    final now = DateTime.now();
    final initial =
        _customRange ??
        DateTimeRange(
          start: DateTime(
            now.year,
            now.month,
            now.day,
          ).subtract(const Duration(days: 29)),
          end: DateTime(now.year, now.month, now.day),
        );
    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(now.year, now.month, now.day),
      initialDateRange: initial,
      helpText: 'Selecione o período do painel',
    );
    if (range != null && mounted) {
      setState(() {
        _customRange = range;
        _periodKey = 'custom';
      });
    }
  }

  Future<void> _showSectionPicker(BuildContext context) async {
    const labels = {
      'evolution': 'Evolução do domínio',
      'reviews': 'Frequência e acertos',
      'fsrs': 'Métricas FSRS',
      'ai': 'Uso de IA',
      'graphs': 'Desempenho por grafo',
      'nodes': 'Desempenho por nó',
      'activity': 'Atividade recente',
    };
    var saving = false;
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => SafeArea(
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            children: [
              Text(
                'Personalizar layout',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const Text(
                'Escolha quais seções aparecem no layout Personalizado.',
              ),
              Text(
                'Essa personalização fica salva neste dispositivo.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 8),
              for (final entry in labels.entries)
                CheckboxListTile(
                  value: _enabledSections.contains(entry.key),
                  title: Text(entry.value),
                  controlAffinity: ListTileControlAffinity.leading,
                  onChanged: (value) {
                    setState(() {
                      if (value ?? false) {
                        _enabledSections.add(entry.key);
                      } else {
                        _enabledSections.remove(entry.key);
                      }
                    });
                    setSheetState(() {});
                  },
                ),
              const SizedBox(height: 8),
              FilledButton.icon(
                onPressed: saving
                    ? null
                    : () async {
                        setSheetState(() => saving = true);
                        try {
                          await ref
                              .read(preferenceStorageServiceProvider)
                              .saveLocally(
                                key: 'superDashboardSections',
                                value: _enabledSections.toList(),
                              );
                          ref.invalidate(dashboardSectionsPreferenceProvider);
                          if (!mounted || !context.mounted) return;
                          setState(() => _layout = _DashboardLayout.custom);
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(this.context).showSnackBar(
                            const SnackBar(
                              content: RuntimeLocalizedText(
                                'Personalização salva.',
                              ),
                            ),
                          );
                        } on Object catch (error) {
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(this.context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Não foi possível salvar a personalização: $error',
                              ),
                            ),
                          );
                        } finally {
                          if (context.mounted) {
                            setSheetState(() => saving = false);
                          }
                        }
                      },
                icon: saving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.save_outlined),
                label: const RuntimeLocalizedText('Salvar personalização'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _loadSavedSections() async {
    try {
      final saved = await ref.read(dashboardSectionsPreferenceProvider.future);
      if (!mounted || saved == null) return;
      setState(() {
        _enabledSections
          ..clear()
          ..addAll(saved);
      });
    } on Object catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: RuntimeLocalizedText(
            'Não foi possível carregar a personalização: $error',
          ),
        ),
      );
    }
  }

  Future<void> _export(
    BuildContext context,
    DashboardExportFormat format,
    DomainDashboardSummary summary,
    DashboardAiUsageSummary? aiUsage,
    String scope,
    String period,
  ) async {
    final messenger = ScaffoldMessenger.maybeOf(context);
    try {
      final filename = 'noema-painel-${DateTime.now().millisecondsSinceEpoch}';
      switch (format) {
        case DashboardExportFormat.csv:
          final bytes = _exportService.toCsv(
            summary: summary,
            aiUsage: aiUsage,
            scope: scope,
            period: period,
            sections: _enabledSections,
          );
          final uri = await FilePicker.saveFile(
            fileName: '$filename.csv',
            bytes: bytes,
            mimeType: 'text/csv',
            dialogTitle: 'Exportar dados do painel',
          );
          if (uri == null) return;
          messenger?.showSnackBar(
            const SnackBar(
              content: RuntimeLocalizedText('Planilha CSV exportada.'),
            ),
          );
          break;
        case DashboardExportFormat.pdf:
          final bytes = await _exportService.toPdf(
            summary: summary,
            aiUsage: aiUsage,
            scope: scope,
            period: period,
            sections: _enabledSections,
          );
          final uri = await FilePicker.saveFile(
            fileName: '$filename.pdf',
            bytes: bytes,
            mimeType: 'application/pdf',
            dialogTitle: 'Exportar relatório do painel',
          );
          if (uri == null) return;
          messenger?.showSnackBar(
            const SnackBar(
              content: RuntimeLocalizedText('Relatório PDF exportado.'),
            ),
          );
          break;
        case DashboardExportFormat.png:
          final object = _shareCardKey.currentContext?.findRenderObject();
          if (object is! RenderRepaintBoundary) {
            throw StateError('O cartão compartilhável não está disponível.');
          }
          final image = await object.toImage(pixelRatio: 2);
          final data = await image.toByteData(format: ui.ImageByteFormat.png);
          image.dispose();
          if (data == null) {
            throw StateError('Não foi possível gerar a imagem PNG.');
          }
          final uri = await FilePicker.saveFile(
            fileName: '$filename.png',
            bytes: data.buffer.asUint8List(),
            mimeType: 'image/png',
            dialogTitle: 'Exportar imagem do painel',
          );
          if (uri == null) return;
          messenger?.showSnackBar(
            const SnackBar(
              content: RuntimeLocalizedText('Imagem PNG exportada.'),
            ),
          );
          break;
      }
    } on Object catch (error) {
      if (!mounted) return;
      messenger?.showSnackBar(
        SnackBar(
          content: RuntimeLocalizedText('Não foi possível exportar: $error'),
        ),
      );
    }
  }
}

class _Metric {
  const _Metric(this.label, this.value, this.icon);

  final String label;
  final String value;
  final IconData icon;
}

class _ShareSummaryCard extends StatelessWidget {
  const _ShareSummaryCard({
    required this.scope,
    required this.period,
    required this.layout,
    required this.metrics,
  });

  final String scope;
  final String period;
  final String layout;
  final List<_Metric> metrics;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: scheme.surfaceContainerLow,
          border: Border.all(color: scheme.outlineVariant),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.insights_outlined,
                  size: 16,
                  color: scheme.onSurfaceVariant,
                ),
                const SizedBox(width: 6),
                Text(
                  'NOEMA · MEU APRENDIZADO',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              scope,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: scheme.onSurface,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              period,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
            ),
            const SizedBox(height: 2),
            Text(
              layout,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
            ),
            const SizedBox(height: 18),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                for (final metric in metrics)
                  _ShareMetric(
                    label: metric.label,
                    value: metric.value,
                    icon: metric.icon,
                    color: scheme.primary,
                    labelColor: scheme.onSurfaceVariant,
                  ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              'Aprender um pouco, todos os dias.',
              style: Theme.of(
                context,
              ).textTheme.labelSmall?.copyWith(color: scheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}

class _ShareMetric extends StatelessWidget {
  const _ShareMetric({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.labelColor,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final Color labelColor;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final width = constraints.maxWidth >= 760
          ? (constraints.maxWidth - 36) / 4
          : constraints.maxWidth >= 480
          ? (constraints.maxWidth - 12) / 2
          : constraints.maxWidth;
      return SizedBox(
        width: width,
        child: Card(
          margin: EdgeInsets.zero,
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(height: 10),
                Text(
                  value,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: labelColor),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

class _ProgressPanel extends StatelessWidget {
  const _ProgressPanel({required this.summary});

  final DomainDashboardSummary summary;

  @override
  Widget build(BuildContext context) {
    final points = summary.recentProgress;
    final hasData = points.any((point) => point.averageScore != null);
    return _DashboardPanel(
      title: 'Evolução do domínio',
      subtitle: 'Média dos registros de domínio no período selecionado',
      icon: Icons.show_chart_rounded,
      child: SizedBox(
        height: 230,
        child: !hasData
            ? const _EmptyHint(
                message: 'Ainda não há registros de evolução neste período.',
              )
            : LineChart(
                LineChartData(
                  minY: 0,
                  maxY: 1,
                  minX: 0,
                  maxX: (points.length - 1).clamp(1, 100000).toDouble(),
                  gridData: const FlGridData(
                    show: true,
                    drawVerticalLine: false,
                  ),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 42,
                        getTitlesWidget: (value, meta) => SideTitleWidget(
                          meta: meta,
                          child: Text(
                            '${(value * 100).round()}%',
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        ),
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: (points.length / 6)
                            .ceilToDouble()
                            .clamp(1, 100000)
                            .toDouble(),
                        reservedSize: 26,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index < 0 || index >= points.length) {
                            return const SizedBox.shrink();
                          }
                          return SideTitleWidget(
                            meta: meta,
                            child: Text(
                              DateFormat(
                                points.length > 53 ? 'MM/yy' : 'dd/MM',
                              ).format(points[index].date),
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: [
                        for (var index = 0; index < points.length; index++)
                          if (points[index].averageScore case final score?)
                            FlSpot(index.toDouble(), score),
                      ],
                      isCurved: true,
                      barWidth: 3,
                      dotData: const FlDotData(show: false),
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

class _ReviewPanel extends StatelessWidget {
  const _ReviewPanel({required this.summary});

  final DomainDashboardSummary summary;

  @override
  Widget build(BuildContext context) {
    final points = summary.reviewFrequency;
    return _DashboardPanel(
      title: 'Ritmo e acertos',
      subtitle:
          '${summary.activeReviewDays} dia(s) com revisão · '
          '${summary.reviewCount} revisão(ões) no período',
      icon: Icons.calendar_month_outlined,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth >= 700
              ? (constraints.maxWidth - 16) / 2
              : constraints.maxWidth;
          return Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              SizedBox(
                width: width,
                child: _ReviewFrequencyChart(points: points),
              ),
              SizedBox(
                width: width,
                child: _AccuracyTrendChart(points: points),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ReviewFrequencyChart extends StatelessWidget {
  const _ReviewFrequencyChart({required this.points});

  final List<DashboardReviewPoint> points;

  @override
  Widget build(BuildContext context) {
    final maxCount = points
        .map((point) => point.reviewCount)
        .fold<int>(0, (a, b) => a > b ? a : b);
    if (maxCount == 0) {
      return const SizedBox(
        height: 205,
        child: _EmptyHint(message: 'Sem revisões neste período.'),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Revisões por período',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 180,
          child: BarChart(
            BarChartData(
              maxY: (maxCount * 1.2).clamp(1, 100000).toDouble(),
              gridData: const FlGridData(show: true, drawVerticalLine: false),
              borderData: FlBorderData(show: false),
              titlesData: _chartTitles(
                context,
                points.map((point) => point.date).toList(),
              ),
              barGroups: [
                for (var index = 0; index < points.length; index++)
                  BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: points[index].reviewCount.toDouble(),
                        color: Theme.of(context).colorScheme.secondary,
                        width: points.length > 90 ? 5 : 10,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _AccuracyTrendChart extends StatelessWidget {
  const _AccuracyTrendChart({required this.points});

  final List<DashboardReviewPoint> points;

  @override
  Widget build(BuildContext context) {
    final hasData = points.any((point) => point.averageAccuracy != null);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RuntimeLocalizedText(
          'Taxa de acertos',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 180,
          child: !hasData
              ? const _EmptyHint(
                  message: 'Ainda não há respostas avaliadas neste período.',
                )
              : LineChart(
                  LineChartData(
                    minY: 0,
                    maxY: 1,
                    minX: 0,
                    maxX: (points.length - 1).clamp(1, 100000).toDouble(),
                    gridData: const FlGridData(
                      show: true,
                      drawVerticalLine: false,
                    ),
                    borderData: FlBorderData(show: false),
                    titlesData: _chartTitles(
                      context,
                      points.map((point) => point.date).toList(),
                    ),
                    lineBarsData: [
                      LineChartBarData(
                        spots: [
                          for (var index = 0; index < points.length; index++)
                            if (points[index].averageAccuracy
                                case final accuracy?)
                              FlSpot(index.toDouble(), accuracy),
                        ],
                        isCurved: true,
                        barWidth: 3,
                        dotData: const FlDotData(show: false),
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                    ],
                  ),
                ),
        ),
      ],
    );
  }
}

FlTitlesData _chartTitles(
  BuildContext context,
  List<DateTime> dates, {
  bool percentAxis = false,
}) => FlTitlesData(
  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
  leftTitles: AxisTitles(
    sideTitles: SideTitles(
      showTitles: true,
      reservedSize: percentAxis ? 42 : 34,
      getTitlesWidget: (value, meta) => SideTitleWidget(
        meta: meta,
        child: Text(
          percentAxis ? '${(value * 100).round()}%' : '${value.toInt()}',
          style: Theme.of(context).textTheme.labelSmall,
        ),
      ),
    ),
  ),
  bottomTitles: AxisTitles(
    sideTitles: SideTitles(
      showTitles: true,
      interval: (dates.length / 5).ceilToDouble().clamp(1, 100000).toDouble(),
      reservedSize: 24,
      getTitlesWidget: (value, meta) {
        final index = value.toInt();
        if (index < 0 || index >= dates.length) return const SizedBox.shrink();
        return SideTitleWidget(
          meta: meta,
          child: Text(
            DateFormat(
              dates.length > 53 ? 'MM/yy' : 'dd/MM',
            ).format(dates[index]),
            style: Theme.of(context).textTheme.labelSmall,
          ),
        );
      },
    ),
  ),
);

class _FsrsPanel extends StatelessWidget {
  const _FsrsPanel({required this.summary});

  final DomainDashboardSummary summary;

  @override
  Widget build(BuildContext context) {
    const labels = ['Novamente', 'Difícil', 'Bom', 'Fácil'];
    return _DashboardPanel(
      title: 'Memória e FSRS',
      subtitle: 'Retenção, intervalos e distribuição das avaliações',
      icon: Icons.psychology_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _InlineMetric(
                label: 'Retenção média no momento da revisão',
                value: _formatPercent(summary.averageRetrievability),
              ),
              _InlineMetric(
                label: 'Intervalo agendado médio',
                value: summary.averageScheduledDays == null
                    ? '—'
                    : '${summary.averageScheduledDays!.toStringAsFixed(1)} dias',
              ),
            ],
          ),
          const SizedBox(height: 14),
          for (var rating = 1; rating <= 4; rating++)
            _RatingBar(
              label: labels[rating - 1],
              count: summary.ratingCounts[rating] ?? 0,
              total: summary.reviewCount,
            ),
        ],
      ),
    );
  }
}

class _AiUsagePanel extends StatelessWidget {
  const _AiUsagePanel({
    required this.usage,
    required this.hasScopedFilter,
    required this.compact,
  });

  final AsyncValue<DashboardAiUsageSummary> usage;
  final bool hasScopedFilter;
  final bool compact;

  @override
  Widget build(BuildContext context) => _DashboardPanel(
    title: 'Uso de IA',
    subtitle: hasScopedFilter
        ? 'Chamadas vinculadas ao escopo selecionado'
        : 'Telemetria registrada pela API',
    icon: Icons.auto_awesome_outlined,
    child: usage.when(
      loading: () => const _LoadingHint(message: 'Carregando telemetria…'),
      error: (error, _) => _EmptyHint(
        message: 'Não foi possível carregar os dados de IA: $error',
      ),
      data: (data) => data.calls == 0
          ? const _EmptyHint(
              message: 'Nenhuma chamada de IA registrada neste período.',
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (!compact)
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      _InlineMetric(label: 'Chamadas', value: '${data.calls}'),
                      _InlineMetric(
                        label: 'Tokens de entrada',
                        value: data.callsWithInputTokenData == 0
                            ? 'Indisponível'
                            : '${data.inputTokens}',
                      ),
                      _InlineMetric(
                        label: 'Tokens de saída',
                        value: data.callsWithOutputTokenData == 0
                            ? 'Indisponível'
                            : '${data.outputTokens}',
                      ),
                      _InlineMetric(
                        label: 'Tokens totais',
                        value: data.callsWithTotalTokenData == 0
                            ? 'Indisponível'
                            : '${data.totalTokens}',
                      ),
                    ],
                  ),
                if (data.callsWithTokenData > 0)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      'Tokens informados para ${data.callsWithTokenData} de '
                      '${data.calls} chamadas.',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                if (data.unattributedCalls > 0)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      '${data.unattributedCalls} chamada(s) sem identificação de grafo/nó '
                      'não foram incluídas neste escopo.',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                if (data.modelCalls.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(
                    'Chamadas por modelo (mais usados)',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  _ModelCallsChart(modelCalls: data.modelCalls),
                ],
                if (data.calls > 0 && data.callsWithTokenData == 0)
                  const Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text(
                      'A API registra chamadas, mas não forneceu contagem de tokens. '
                      'O painel não estima esse valor.',
                    ),
                  ),
              ],
            ),
    ),
  );
}

class _GraphPanel extends StatelessWidget {
  const _GraphPanel({required this.summary});

  final DomainDashboardSummary summary;

  @override
  Widget build(BuildContext context) => _DashboardPanel(
    title: 'Desempenho por grafo',
    subtitle: 'Domínio médio e quantidade de nós no escopo selecionado',
    icon: Icons.account_tree_outlined,
    child: summary.graphPerformance.isEmpty
        ? const _EmptyHint(message: 'Ainda não há grafos neste escopo.')
        : _GraphMasteryChart(graphs: summary.graphPerformance),
  );
}

String _formatPercent(double? value) =>
    value == null ? '—' : '${(value * 100).round()}%';

class _GraphMasteryChart extends StatelessWidget {
  const _GraphMasteryChart({required this.graphs});

  final List<DashboardGraphMetric> graphs;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      for (final graph in graphs)
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  graph.graphTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 3,
                child: LinearProgressIndicator(
                  value: graph.averageMastery?.clamp(0, 1),
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              SizedBox(
                width: 52,
                child: Text(
                  graph.averageMastery == null
                      ? '—'
                      : '${(graph.averageMastery! * 100).round()}%',
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
        ),
    ],
  );
}

class _NodePanel extends StatelessWidget {
  const _NodePanel({required this.summary});

  final DomainDashboardSummary summary;

  @override
  Widget build(BuildContext context) => _DashboardPanel(
    title: 'Desempenho por nó',
    subtitle: 'Domínio e taxa de acertos em cada conceito',
    icon: Icons.hub_outlined,
    child: summary.nodePerformance.isEmpty
        ? const _EmptyHint(message: 'Ainda não há nós neste escopo.')
        : Column(
            children: [
              for (final node in summary.nodePerformance.take(12))
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 7),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              node.nodeTitle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              '${node.graphTitle} · ${node.reviewCount} revisões',
                              style: Theme.of(context).textTheme.bodySmall,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 3,
                        child: LinearProgressIndicator(
                          value: node.masteryScore?.clamp(0, 1),
                          minHeight: 8,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      SizedBox(
                        width: 52,
                        child: Text(
                          node.masteryScore == null
                              ? '—'
                              : '${(node.masteryScore! * 100).round()}%',
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                ),
              if (summary.nodePerformance.length > 12)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    'Mostrando 12 de ${summary.nodePerformance.length}; '
                    'o CSV inclui todos.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
            ],
          ),
  );
}

class _ModelCallsChart extends StatelessWidget {
  const _ModelCallsChart({required this.modelCalls});

  final Map<String, int> modelCalls;

  @override
  Widget build(BuildContext context) {
    final entries = modelCalls.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final visibleEntries = entries.take(5);
    final maxCalls = visibleEntries.first.value;
    return Column(
      children: [
        for (final entry in visibleEntries)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 7),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    entry.key,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 3,
                  child: LinearProgressIndicator(
                    value: maxCalls == 0 ? 0 : entry.value / maxCalls,
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                SizedBox(
                  width: 44,
                  child: RuntimeLocalizedText(
                    '${entry.value}',
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
          ),
        if (entries.length > 5)
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Exibindo 5 de ${entries.length} modelos.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
      ],
    );
  }
}

class _ActivityPanel extends StatelessWidget {
  const _ActivityPanel({required this.summary});

  final DomainDashboardSummary summary;

  @override
  Widget build(BuildContext context) => _DashboardPanel(
    title: 'Atividade recente',
    subtitle: 'Últimas alterações de domínio no período',
    icon: Icons.history_rounded,
    child: summary.recentActivity.isEmpty
        ? const _EmptyHint(
            message: 'Suas atividades de estudo aparecerão aqui.',
          )
        : Column(
            children: [
              for (final activity in summary.recentActivity)
                ListTile(
                  leading: const Icon(Icons.history_rounded),
                  title: Text(activity.nodeTitle),
                  subtitle: Text(
                    '${activity.graphTitle} · '
                    '${DateFormat.yMd().add_Hm().format(activity.loggedAt)}',
                  ),
                  trailing: RuntimeLocalizedText(
                    '${(activity.score * 100).round()}%',
                  ),
                ),
            ],
          ),
  );
}

class _DashboardPanel extends StatelessWidget {
  const _DashboardPanel({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.child,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Widget child;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(icon, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 12),
          child,
        ],
      ),
    ),
  );
}

class _InlineMetric extends StatelessWidget {
  const _InlineMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 220,
    child: Card(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(value, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 4),
            Text(label, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    ),
  );
}

class _RatingBar extends StatelessWidget {
  const _RatingBar({
    required this.label,
    required this.count,
    required this.total,
  });

  final String label;
  final int count;
  final int total;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Row(
      children: [
        SizedBox(width: 90, child: Text(label)),
        Expanded(
          child: LinearProgressIndicator(
            value: total == 0 ? 0 : count / total,
            minHeight: 8,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        SizedBox(width: 44, child: Text('$count', textAlign: TextAlign.end)),
      ],
    ),
  );
}

class _EmptyHint extends StatelessWidget {
  const _EmptyHint({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
    child: Text(message, textAlign: TextAlign.center),
  );
}

class _LoadingHint extends StatelessWidget {
  const _LoadingHint({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      const SizedBox(
        width: 18,
        height: 18,
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
      const SizedBox(width: 12),
      Text(message),
    ],
  );
}
