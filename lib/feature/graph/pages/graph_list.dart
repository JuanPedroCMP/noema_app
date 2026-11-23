import 'package:flutter/material.dart';
import 'package:noema/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:noema/shared/localization/runtime_localization.dart';
import 'package:noema/core/database/database.dart';
import 'package:noema/core/database/database_provider.dart';
import 'package:noema/core/design/tokens/layout.dart';
import 'package:noema/core/design/theme/theme_tokens.dart';
import 'package:noema/core/router/route_paths.dart';
import 'package:noema/feature/config/providers/user_provider.dart';
import 'package:noema/feature/graph/data/knowledge_graph_dao.dart';
import 'package:noema/feature/graph/pages/create_blank_graph.dart';
import 'package:noema/feature/graph/pages/create_graph_with_ai.dart';
import 'package:noema/feature/graph/provider/graph_provider.dart';
import 'package:noema/feature/graph/service/graph_transfer_service.dart';
import 'package:noema/shared/widgets/async_state_view.dart';
import 'package:noema/feature/study_assistant/models/study_assistant_action.dart';
import 'package:noema/feature/study_assistant/providers/study_assistant_provider.dart';

class GraphList extends ConsumerStatefulWidget {
  const GraphList({super.key, this.initialHandoff});

  final StudyAssistantHandoff? initialHandoff;

  @override
  ConsumerState<GraphList> createState() => _GraphListState();
}

class _GraphListState extends ConsumerState<GraphList> {
  AppUserData? _user;
  KnowledgeGraphDao? _dao;
  int _creationMode = 0;
  String _initialPrompt = '';
  bool _autoGenerate = false;
  bool _showActionNotice = false;
  String? _deletingGraphId;

  @override
  void initState() {
    super.initState();
    _applyHandoff(widget.initialHandoff);
    _loadUser();
  }

  @override
  void didUpdateWidget(covariant GraphList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialHandoff != widget.initialHandoff) {
      _applyHandoff(widget.initialHandoff);
    }
  }

  void _applyHandoff(StudyAssistantHandoff? handoff) {
    if (handoff?.type == StudyAssistantActionType.createGraph) {
      _creationMode = 3;
      _initialPrompt = handoff!.prompt;
      _autoGenerate = handoff.autoGenerate;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          ref.read(studyAssistantProvider.notifier).consumeHandoff();
        }
      });
    } else if (handoff?.type == StudyAssistantActionType.createExercise &&
        (handoff?.graphId == null || handoff?.nodeId == null)) {
      _showActionNotice = true;
    } else {
      _showActionNotice = false;
    }
  }

  Future<void> _loadUser() async {
    final user = await ref.read(userProvider.notifier).getUser();
    if (!mounted) return;
    setState(() {
      _user = user;
      _dao = KnowledgeGraphDao(ref.read(appDatabaseProvider));
    });
  }

  void _toggleCreation(int mode) {
    setState(() => _creationMode = _creationMode == mode ? 0 : mode);
  }

  Future<void> _importGraphFile() async {
    if (_dao == null || _user == null) return;
    try {
      final id = await GraphTransferService.importGraph(
        db: ref.read(appDatabaseProvider),
        userId: _user!.id,
      );
      if (id == null) return;
      ref.invalidate(knowledgeGraphsProvider);
      if (mounted) context.go(RoutePaths.graph(id));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: RuntimeLocalizedText(
            'O arquivo não pôde ser importado. Verifique o JSON.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final graphsAsync = ref.watch(knowledgeGraphsProvider);
    if (_user == null || _dao == null) {
      return AppLoadingView(label: 'Carregando seus grafos...');
    }

    return graphsAsync.when(
      loading: () => AppLoadingView(label: 'Carregando seus grafos...'),
      error: (error, _) => AppErrorView(
        message: 'Não foi possível carregar seus grafos.',
        onRetry: () => ref.invalidate(knowledgeGraphsProvider),
      ),
      data: (graphs) => LayoutBuilder(
        builder: (context, constraints) {
          final compact =
              constraints.maxWidth < AppLayoutTokens.graphGridBreakpoint;
          final horizontalPadding = compact
              ? AppLayoutTokens.pageHorizontalPaddingCompact
              : AppLayoutTokens.pageHorizontalPaddingRegular;
          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(knowledgeGraphsProvider),
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    context.spacing.lg,
                    horizontalPadding,
                    context.spacing.sm + context.spacing.xs,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: _Header(
                      graphCount: graphs.length,
                      compact: compact,
                      onCreateWithAi: () => _toggleCreation(3),
                      onCreateBlank: () => _toggleCreation(2),
                      onImport: _importGraphFile,
                    ),
                  ),
                ),
                if (_showActionNotice)
                  SliverPadding(
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                    ),
                    sliver: SliverToBoxAdapter(
                      child: Card(
                        child: ListTile(
                          leading: const Icon(Icons.quiz_outlined),
                          title: RuntimeLocalizedText(
                            'Escolha onde criar o exercício',
                          ),
                          subtitle: Text(
                            '${widget.initialHandoff?.prompt}\n'
                            'Abra um grafo e escolha o nó que deseja praticar.',
                          ),
                          trailing: IconButton(
                            tooltip: AppLocalizations.of(context)!.dismiss,
                            onPressed: () =>
                                setState(() => _showActionNotice = false),
                            icon: const Icon(Icons.close),
                          ),
                        ),
                      ),
                    ),
                  ),
                if (_creationMode != 0)
                  SliverPadding(
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                    ),
                    sliver: SliverToBoxAdapter(
                      child: _CreationPanel(
                        mode: _creationMode,
                        compact: compact,
                        onSelect: _toggleCreation,
                        initialPrompt: _initialPrompt,
                        autoGenerate: _autoGenerate,
                      ),
                    ),
                  ),
                if (graphs.isEmpty && _creationMode == 0)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: AppEmptyView(
                      icon: Icons.account_tree_outlined,
                      title: 'Seu primeiro grafo começa aqui',
                      message:
                          'Crie um mapa vazio e adicione nós aos poucos, ou use a IA para gerar uma estrutura inicial.',
                      action: Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          FilledButton.icon(
                            onPressed: () => _toggleCreation(3),
                            icon: const Icon(Icons.auto_awesome_rounded),
                            label: const RuntimeLocalizedText('Gerar com IA'),
                          ),
                          OutlinedButton.icon(
                            onPressed: () => _toggleCreation(2),
                            icon: const Icon(Icons.add),
                            label: const RuntimeLocalizedText('Criar vazio'),
                          ),
                        ],
                      ),
                    ),
                  )
                else if (graphs.isNotEmpty)
                  SliverPadding(
                    padding: EdgeInsets.fromLTRB(
                      horizontalPadding,
                      context.spacing.sm,
                      horizontalPadding,
                      context.spacing.xl,
                    ),
                    sliver: SliverGrid(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => _GraphCard(
                          graph: graphs[index],
                          deleting: _deletingGraphId == graphs[index].id,
                          onOpen: () =>
                              context.push(RoutePaths.graph(graphs[index].id)),
                          onDelete: () => _deleteGraph(graphs[index]),
                        ),
                        childCount: graphs.length,
                      ),
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: compact
                            ? AppLayoutTokens.graphCardCompactMaxWidth
                            : AppLayoutTokens.graphCardMaxWidth,
                        mainAxisExtent: AppLayoutTokens.graphCardHeight,
                        crossAxisSpacing: AppLayoutTokens.gridGap,
                        mainAxisSpacing: AppLayoutTokens.gridGap,
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _deleteGraph(KnowledgeGraphData graph) async {
    if (_deletingGraphId != null) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        icon: const Icon(Icons.delete_outline),
        title: const RuntimeLocalizedText('Excluir grafo?'),
        content: Text(
          '“${graph.title}” será removido da sua lista. Essa ação não pode ser desfeita.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const RuntimeLocalizedText('Cancelar'),
          ),
          FilledButton.tonal(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const RuntimeLocalizedText('Excluir'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    setState(() => _deletingGraphId = graph.id);
    final messenger = ScaffoldMessenger.of(context);
    try {
      final deleted = await _dao!.deleteKnowledgeGraph(id: graph.id);
      if (!mounted) return;
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              deleted ? 'Grafo excluído.' : 'O grafo não foi encontrado.',
            ),
          ),
        );
    } catch (_) {
      if (!mounted) return;
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: RuntimeLocalizedText('Não foi possível excluir o grafo.'),
          ),
        );
    } finally {
      if (mounted) setState(() => _deletingGraphId = null);
    }
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.graphCount,
    required this.compact,
    required this.onCreateWithAi,
    required this.onCreateBlank,
    required this.onImport,
  });

  final int graphCount;
  final bool compact;
  final VoidCallback onCreateWithAi;
  final VoidCallback onCreateBlank;
  final VoidCallback onImport;

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Meus grafos',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  SizedBox(height: spacing.xs + 2),
                  Text(
                    graphCount == 0
                        ? 'Organize seus estudos em um mapa de conhecimento.'
                        : '$graphCount ${graphCount == 1 ? 'grafo disponível' : 'grafos disponíveis'}',
                  ),
                ],
              ),
            ),
            if (!compact) ...[
              OutlinedButton.icon(
                onPressed: onImport,
                icon: const Icon(Icons.upload_file),
                label: const RuntimeLocalizedText('Importar'),
              ),
              SizedBox(width: spacing.sm),
              OutlinedButton.icon(
                onPressed: onCreateBlank,
                icon: const Icon(Icons.add),
                label: const RuntimeLocalizedText('Criar vazio'),
              ),
              SizedBox(width: spacing.sm),
              FilledButton.icon(
                onPressed: onCreateWithAi,
                icon: const Icon(Icons.auto_awesome_rounded),
                label: const RuntimeLocalizedText('Gerar com IA'),
              ),
            ],
          ],
        ),
        if (compact) ...[
          SizedBox(height: spacing.md),
          SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FilledButton.icon(
                  onPressed: onCreateWithAi,
                  icon: const Icon(Icons.auto_awesome_rounded),
                  label: const RuntimeLocalizedText('Gerar com IA'),
                ),
                SizedBox(height: spacing.sm),
                OutlinedButton.icon(
                  onPressed: onCreateBlank,
                  icon: const Icon(Icons.add),
                  label: const RuntimeLocalizedText('Criar vazio'),
                ),
                SizedBox(height: spacing.sm),
                OutlinedButton.icon(
                  onPressed: onImport,
                  icon: const Icon(Icons.upload_file),
                  label: const RuntimeLocalizedText('Importar arquivo JSON'),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _CreationPanel extends StatelessWidget {
  const _CreationPanel({
    required this.mode,
    required this.compact,
    required this.onSelect,
    required this.initialPrompt,
    required this.autoGenerate,
  });

  final int mode;
  final bool compact;
  final ValueChanged<int> onSelect;
  final String initialPrompt;
  final bool autoGenerate;

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: EdgeInsets.all(
          compact ? spacing.md : AppLayoutTokens.sectionPadding,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    mode == 3 ? 'Gerar grafo com IA' : 'Criar grafo vazio',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
                IconButton(
                  tooltip: AppLocalizations.of(context)!.close,
                  onPressed: () => onSelect(0),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            SizedBox(height: spacing.xs),
            const Text(
              'Gere um mapa a partir de um tema ou comece com uma estrutura vazia.',
            ),
            SizedBox(height: spacing.md),
            SegmentedButton<int>(
              segments: const [
                ButtonSegment(
                  value: 2,
                  icon: Icon(Icons.edit_note),
                  label: RuntimeLocalizedText('Começar vazio'),
                ),
                ButtonSegment(
                  value: 3,
                  icon: Icon(Icons.auto_awesome),
                  label: RuntimeLocalizedText('Gerar com IA'),
                ),
              ],
              selected: {mode == 3 ? 3 : 2},
              onSelectionChanged: (value) => onSelect(value.first),
            ),
            SizedBox(height: spacing.lg - spacing.xs),
            if (mode == 2) const CreateBlankGraph(),
            if (mode == 3)
              CreateGraphWithAi(
                key: ValueKey((initialPrompt, autoGenerate)),
                initialPrompt: initialPrompt,
                autoGenerate: autoGenerate,
              ),
          ],
        ),
      ),
    );
  }
}

class _GraphCard extends StatelessWidget {
  const _GraphCard({
    required this.graph,
    required this.deleting,
    required this.onOpen,
    required this.onDelete,
  });

  final KnowledgeGraphData graph;
  final bool deleting;
  final VoidCallback onOpen;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: deleting ? null : onOpen,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    child: Icon(
                      Icons.account_tree_outlined,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const Spacer(),
                  PopupMenuButton<String>(
                    tooltip: AppLocalizations.of(context)!.graphActions,
                    onSelected: (value) {
                      if (value == 'open') onOpen();
                      if (value == 'delete') onDelete();
                    },
                    itemBuilder: (context) => const [
                      PopupMenuItem(
                        value: 'open',
                        child: RuntimeLocalizedText('Abrir grafo'),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: RuntimeLocalizedText('Excluir grafo'),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                graph.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Text(
                  graph.description?.trim().isNotEmpty == true
                      ? graph.description!
                      : 'Sem descrição. Adicione uma para identificar melhor este grafo.',
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: FilledButton.tonalIcon(
                  onPressed: deleting ? null : onOpen,
                  icon: deleting
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.open_in_new),
                  label: Text(deleting ? 'Excluindo...' : 'Abrir grafo'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
