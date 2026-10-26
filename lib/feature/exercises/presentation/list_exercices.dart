import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:noema/core/database/database.dart' hide OpenEnded;
import 'package:noema/core/database/database_provider.dart';
import 'package:noema/core/design/theme/theme_tokens.dart';
import 'package:noema/feature/exercises/multiple_choice/data/multiple_choice_dao.dart';
import 'package:noema/feature/exercises/open_ended/data/open_ended_dao.dart';

enum _ExerciseFilter { all, openEnded, multipleChoice }

class ExercicesList extends ConsumerStatefulWidget {
  const ExercicesList({super.key, required this.nodeId});

  final String nodeId;

  @override
  ConsumerState<ExercicesList> createState() => _ExercicesList();
}

class _ExercicesList extends ConsumerState<ExercicesList> {
  List<OpenEndedData> _openEndeds = [];
  List<MultipleChoiceData> _multipleChoices = [];
  bool _isLoading = true;
  String? _error;
  String _search = '';
  _ExerciseFilter _filter = _ExerciseFilter.all;

  @override
  void initState() {
    super.initState();
    carregar();
  }

  Future<void> carregar() async {
    if (mounted) setState(() => _isLoading = true);

    try {
      final db = ref.read(appDatabaseProvider);
      final results = await Future.wait([
        OpenEndedDao(db).getOpenEndedsByNode(nodeId: widget.nodeId),
        MultipleChoiceDao(db).getMultipleChoicesByNode(nodeId: widget.nodeId),
      ]);
      if (!mounted) return;

      setState(() {
        _openEndeds = results[0] as List<OpenEndedData>;
        _multipleChoices = results[1] as List<MultipleChoiceData>;
        _isLoading = false;
        _error = null;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _error = 'Não foi possível carregar as questões.';
      });
    }
  }

  Future<void> _navigate(String path) async {
    await context.push(path);
    if (mounted) await carregar();
  }

  Future<void> _deleteExercise({
    required String id,
    required String title,
    required bool isOpenEnded,
  }) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir questão?'),
        content: Text('“$title” será removida desta lista.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    try {
      final db = ref.read(appDatabaseProvider);
      if (isOpenEnded) {
        await OpenEndedDao(db).deleteOpenEnded(id: id);
      } else {
        await MultipleChoiceDao(db).deleteMultipleChoice(id: id);
      }
      if (mounted) await carregar();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível excluir a questão.')),
      );
    }
  }

  Widget _exerciseCard({
    required String id,
    required String title,
    required String statement,
    required bool isOpenEnded,
    required String currentUri,
  }) {
    final typeLabel = isOpenEnded ? 'Questão aberta' : 'Múltipla escolha';
    final route = isOpenEnded ? 'open-ended' : 'multiple-choice';

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: context.textTheme.titleMedium,
                  ),
                ),
                PopupMenuButton<String>(
                  tooltip: 'Mais opções',
                  onSelected: (action) {
                    if (action == 'edit') {
                      _navigate('$currentUri/$route/$id/edit');
                    } else if (action == 'delete') {
                      _deleteExercise(
                        id: id,
                        title: title,
                        isOpenEnded: isOpenEnded,
                      );
                    }
                  },
                  itemBuilder: (context) => const [
                    PopupMenuItem(value: 'edit', child: Text('Editar')),
                    PopupMenuItem(value: 'delete', child: Text('Excluir')),
                  ],
                ),
              ],
            ),
            Chip(
              avatar: Icon(
                isOpenEnded ? Icons.edit_note_rounded : Icons.checklist_rounded,
                size: 18,
              ),
              label: Text(typeLabel),
              visualDensity: VisualDensity.compact,
            ),
            const SizedBox(height: 8),
            Text(
              statement,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: context.textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                OutlinedButton.icon(
                  onPressed: () => _navigate('$currentUri/$route/$id/view'),
                  icon: const Icon(Icons.visibility_outlined),
                  label: const Text('Visualizar'),
                ),
                FilledButton.tonalIcon(
                  onPressed: () => _navigate('$currentUri/$route/$id/answer'),
                  icon: const Icon(Icons.play_arrow_rounded),
                  label: const Text('Responder'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off_outlined, size: 40),
            const SizedBox(height: 12),
            Text(_error!, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: carregar,
              icon: const Icon(Icons.refresh),
              label: const Text('Tentar novamente'),
            ),
          ],
        ),
      );
    }

    final currentUri = GoRouterState.of(context).uri.path;
    final query = _search.trim().toLowerCase();
    final openEnded = _openEndeds.where((exercise) {
      return _filter != _ExerciseFilter.multipleChoice &&
          '${exercise.title} ${exercise.statement}'.toLowerCase().contains(
            query,
          );
    }).toList();
    final multipleChoice = _multipleChoices.where((exercise) {
      return _filter != _ExerciseFilter.openEnded &&
          '${exercise.title} ${exercise.statement}'.toLowerCase().contains(
            query,
          );
    }).toList();
    final total = _openEndeds.length + _multipleChoices.length;
    final hasResults = openEnded.isNotEmpty || multipleChoice.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Questões', style: context.textTheme.headlineSmall),
                    const SizedBox(height: 4),
                    Text(
                      '$total ${total == 1 ? 'questão cadastrada' : 'questões cadastradas'}',
                      style: context.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Atualizar lista',
                onPressed: carregar,
                icon: const Icon(Icons.refresh),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FilledButton.icon(
                onPressed: () => _navigate('$currentUri/open-ended/create'),
                icon: const Icon(Icons.edit_note_rounded),
                label: const Text('Questão aberta'),
              ),
              OutlinedButton.icon(
                onPressed: () =>
                    _navigate('$currentUri/multiple-choice/create'),
                icon: const Icon(Icons.checklist_rounded),
                label: const Text('Múltipla escolha'),
              ),
              OutlinedButton.icon(
                onPressed: () => _navigate('$currentUri/responses'),
                icon: const Icon(Icons.history_rounded),
                label: const Text('Histórico'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            onChanged: (value) => setState(() => _search = value),
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Buscar por título ou enunciado',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: [
              for (final (filter, label) in [
                (_ExerciseFilter.all, 'Todas'),
                (_ExerciseFilter.openEnded, 'Abertas'),
                (_ExerciseFilter.multipleChoice, 'Múltipla escolha'),
              ])
                ChoiceChip(
                  label: Text(label),
                  selected: _filter == filter,
                  onSelected: (_) => setState(() => _filter = filter),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: RefreshIndicator(
              onRefresh: carregar,
              child: hasResults
                  ? ListView(
                      children: [
                        for (final exercise in openEnded)
                          _exerciseCard(
                            id: exercise.id,
                            title: exercise.title,
                            statement: exercise.statement,
                            isOpenEnded: true,
                            currentUri: currentUri,
                          ),
                        for (final exercise in multipleChoice)
                          _exerciseCard(
                            id: exercise.id,
                            title: exercise.title,
                            statement: exercise.statement,
                            isOpenEnded: false,
                            currentUri: currentUri,
                          ),
                      ],
                    )
                  : ListView(
                      children: [
                        const SizedBox(height: 36),
                        Icon(
                          total == 0 ? Icons.quiz_outlined : Icons.search_off,
                          size: 48,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          total == 0
                              ? 'Nenhuma questão por aqui ainda'
                              : 'Nenhuma questão encontrada',
                          textAlign: TextAlign.center,
                          style: context.textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          total == 0
                              ? 'Crie uma questão para começar a estudar este tópico.'
                              : 'Tente outro termo ou altere o filtro.',
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
