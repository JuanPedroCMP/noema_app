import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:noema/core/database/database.dart';
import 'package:noema/core/database/database_provider.dart';
import 'package:noema/core/router/route_paths.dart';
import 'package:noema/feature/config/providers/user_provider.dart';
import 'package:noema/feature/graph/data/knowledge_graph_dao.dart';
import 'package:noema/feature/graph/pages/create_blank_graph.dart';
import 'package:noema/feature/graph/pages/create_graph_with_ai.dart';
import 'package:noema/feature/graph/provider/graph_provider.dart';
import 'package:noema/shared/widgets/async_state_view.dart';

class GraphList extends ConsumerStatefulWidget {
  const GraphList({super.key});

  @override
  ConsumerState<GraphList> createState() => _GraphListState();
}

class _GraphListState extends ConsumerState<GraphList> {
  AppUserData? _user;
  KnowledgeGraphDao? _dao;
  int _creationMode = 0;
  String? _deletingGraphId;

  @override
  void initState() {
    super.initState();
    _loadUser();
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

  @override
  Widget build(BuildContext context) {
    final graphsAsync = ref.watch(knowledgeGraphsProvider);
    if (_user == null || _dao == null) {
      return const AppLoadingView(label: 'Carregando seus grafos...');
    }

    return graphsAsync.when(
      loading: () => const AppLoadingView(label: 'Carregando seus grafos...'),
      error: (error, _) => AppErrorView(
        message: 'Não foi possível carregar seus grafos.',
        onRetry: () => ref.invalidate(knowledgeGraphsProvider),
      ),
      data: (graphs) => LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 700;
          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(knowledgeGraphsProvider),
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(
                    compact ? 16 : 32,
                    24,
                    compact ? 16 : 32,
                    12,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: _Header(
                      graphCount: graphs.length,
                      compact: compact,
                      onCreate: () => _toggleCreation(1),
                    ),
                  ),
                ),
                if (_creationMode != 0)
                  SliverPadding(
                    padding: EdgeInsets.symmetric(
                      horizontal: compact ? 16 : 32,
                    ),
                    sliver: SliverToBoxAdapter(
                      child: _CreationPanel(
                        mode: _creationMode,
                        compact: compact,
                        onSelect: _toggleCreation,
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
                      action: FilledButton.icon(
                        onPressed: () => _toggleCreation(1),
                        icon: const Icon(Icons.add),
                        label: const Text('Criar grafo'),
                      ),
                    ),
                  )
                else if (graphs.isNotEmpty)
                  SliverPadding(
                    padding: EdgeInsets.fromLTRB(
                      compact ? 16 : 32,
                      8,
                      compact ? 16 : 32,
                      32,
                    ),
                    sliver: SliverGrid(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => _GraphCard(
                          graph: graphs[index],
                          deleting: _deletingGraphId == graphs[index].id,
                          onOpen: () => context.push(
                            RoutePaths.graph(graphs[index].id),
                          ),
                          onDelete: () => _deleteGraph(graphs[index]),
                        ),
                        childCount: graphs.length,
                      ),
                      gridDelegate:
                          SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: compact ? 500 : 430,
                        mainAxisExtent: 245,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
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
        title: const Text('Excluir grafo?'),
        content: Text(
          '“${graph.title}” será removido da sua lista. Essa ação não pode ser desfeita.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancelar'),
          ),
          FilledButton.tonal(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Excluir'),
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
          const SnackBar(content: Text('Não foi possível excluir o grafo.')),
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
    required this.onCreate,
  });

  final int graphCount;
  final bool compact;
  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
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
                  Text('Meus grafos', style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 6),
                  Text(
                    graphCount == 0
                        ? 'Organize seus estudos em um mapa de conhecimento.'
                        : '$graphCount ${graphCount == 1 ? 'grafo disponível' : 'grafos disponíveis'}',
                  ),
                ],
              ),
            ),
            if (!compact)
              FilledButton.icon(
                onPressed: onCreate,
                icon: const Icon(Icons.add),
                label: const Text('Novo grafo'),
              ),
          ],
        ),
        if (compact) ...[
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: onCreate,
              icon: const Icon(Icons.add),
              label: const Text('Novo grafo'),
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
  });

  final int mode;
  final bool compact;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: EdgeInsets.all(compact ? 16 : 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Como você quer começar?',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
                IconButton(
                  tooltip: 'Fechar',
                  onPressed: () => onSelect(0),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 4),
            const Text('Escolha uma opção para criar seu próximo mapa.'),
            const SizedBox(height: 16),
            SegmentedButton<int>(
              segments: const [
                ButtonSegment(
                  value: 2,
                  icon: Icon(Icons.edit_note),
                  label: Text('Começar vazio'),
                ),
                ButtonSegment(
                  value: 3,
                  icon: Icon(Icons.auto_awesome),
                  label: Text('Gerar com IA'),
                ),
              ],
              selected: {mode == 3 ? 3 : 2},
              onSelectionChanged: (value) => onSelect(value.first),
            ),
            const SizedBox(height: 20),
            if (mode == 2) const CreateBlankGraph(),
            if (mode == 3) const CreateGraphWithAi(),
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
                    child: Icon(Icons.account_tree_outlined,
                        color: theme.colorScheme.primary),
                  ),
                  const Spacer(),
                  PopupMenuButton<String>(
                    tooltip: 'Ações do grafo',
                    onSelected: (value) {
                      if (value == 'open') onOpen();
                      if (value == 'delete') onDelete();
                    },
                    itemBuilder: (context) => const [
                      PopupMenuItem(value: 'open', child: Text('Abrir grafo')),
                      PopupMenuItem(
                        value: 'delete',
                        child: Text('Excluir grafo'),
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
