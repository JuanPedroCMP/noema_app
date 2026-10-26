import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:noema/core/database/database.dart';
import 'package:noema/core/database/database_provider.dart';
import 'package:noema/core/router/route_paths.dart';
import 'package:noema/feature/config/providers/user_provider.dart';
import 'package:noema/feature/graph/data/graph_node_dao.dart';
import 'package:noema/feature/graph/data/knowledge_graph_dao.dart';
import 'package:noema/feature/study_session/data/study_session_dao.dart';
import 'package:noema/feature/study_session/data/study_session_question_dao.dart';
import 'package:uuid/uuid.dart';

class StudySessionCreatePage extends ConsumerStatefulWidget {
  const StudySessionCreatePage({super.key, this.sessionId});

  final String? sessionId;

  @override
  ConsumerState<StudySessionCreatePage> createState() =>
      _StudySessionCreatePageState();
}

class _StudySessionCreatePageState
    extends ConsumerState<StudySessionCreatePage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _durationController = TextEditingController(text: '25');
  final _searchController = TextEditingController();
  List<KnowledgeGraphData> _graphs = [];
  List<StudySessionQuestionCandidate> _questions = [];
  final Set<String> _selectedQuestionKeys = {};
  String? _graphId;
  String _search = '';
  StudySessionQuestionType? _typeFilter;
  bool _isLoading = true;
  bool _isSaving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadFormData();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _durationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadFormData() async {
    try {
      final db = ref.read(appDatabaseProvider);
      final user = await ref.read(userProvider.future);
      final graphs = await KnowledgeGraphDao(
        db,
      ).getKnowledgeGraphsByUser(userId: user.id);
      final sessionId = widget.sessionId;
      StudySessionData? session;
      List<StudySessionQuestionCandidate> existingQuestions = [];
      String? graphId;
      if (sessionId != null) {
        session = await StudySessionDao(db).getStudySession(id: sessionId);
        if (session == null ||
            session.softDeleted ||
            session.userId != user.id) {
          throw StateError('Esta sessão não existe ou foi arquivada.');
        }
        final activeLogs = await (db.select(
          db.studySessionLog,
        )..where(
          (log) =>
              log.studySessionId.equals(sessionId) &
              log.status.equals('IN_PROGRESS'),
        )).get();
        if (activeLogs.isNotEmpty) {
          throw StateError(
            'Interrompa a realização em andamento antes de editar a sessão.',
          );
        }
        existingQuestions = await StudySessionQuestionDao(
          db,
        ).getQuestionsBySession(studySessionId: sessionId);
        final graphLinks = await (db.select(
          db.studySessionUseKnowledgeGraph,
        )..where((link) => link.studySessionId.equals(sessionId))).get();
        graphId = graphLinks.firstOrNull?.graphId;
        if (graphId == null && existingQuestions.isNotEmpty) {
          graphId = (await GraphNodeDao(
            db,
          ).getGraphNode(id: existingQuestions.first.nodeId))?.graphId;
        }
      }
      if (!mounted) return;
      setState(() {
        _graphs = graphs;
        _graphId = graphId;
        if (session != null) {
          _titleController.text = session.title;
          _descriptionController.text = session.description ?? '';
          _durationController.text = session.targetDurationMin.toString();
          _selectedQuestionKeys.addAll(
            existingQuestions.map(_questionKey),
          );
        }
        _isLoading = false;
      });
      if (graphId != null) await _selectGraph(graphId, preserveSelection: true);
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _error = 'Não foi possível preparar o formulário: $error';
        _isLoading = false;
      });
    }
  }

  Future<void> _selectGraph(
    String? graphId, {
    bool preserveSelection = false,
  }) async {
    setState(() {
      _graphId = graphId;
      _questions = [];
      if (!preserveSelection) _selectedQuestionKeys.clear();
      _error = null;
      _isLoading = graphId != null;
    });
    if (graphId == null) return;

    try {
      final user = await ref.read(userProvider.future);
      final questions = await StudySessionQuestionDao(
        ref.read(appDatabaseProvider),
      ).getQuestionsByGraph(graphId: graphId, userId: user.id);
      if (!mounted) return;
      setState(() {
        _questions = questions;
        if (preserveSelection) {
          _selectedQuestionKeys.addAll(
            questions
                .where(
                  (question) =>
                      _selectedQuestionKeys.contains(_questionKey(question)),
                )
                .map(_questionKey),
          );
        }
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _error = 'Não foi possível carregar as questões: $error';
        _isLoading = false;
      });
    }
  }

  String _questionKey(StudySessionQuestionCandidate question) =>
      '${question.type.name}:${question.id}';

  void _moveSelectedQuestion(String key, int offset) {
    final orderedKeys = _selectedQuestionKeys.toList();
    final currentIndex = orderedKeys.indexOf(key);
    final nextIndex = currentIndex + offset;
    if (currentIndex < 0 ||
        nextIndex < 0 ||
        nextIndex >= orderedKeys.length) {
      return;
    }
    orderedKeys
      ..removeAt(currentIndex)
      ..insert(nextIndex, key);
    setState(() {
      _selectedQuestionKeys
        ..clear()
        ..addAll(orderedKeys);
    });
  }

  Future<void> _createExercise() async {
    final graphId = _graphId;
    if (graphId == null) return;
    List<GraphNodeData> nodes;
    try {
      nodes = await GraphNodeDao(
        ref.read(appDatabaseProvider),
      ).getGraphNodesByGraph(graphId: graphId);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Não foi possível carregar os nodes: $error')),
      );
      return;
    }
    if (!mounted) return;
    if (nodes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Este grafo ainda não tem nodes.')),
      );
      return;
    }
    final nodeId = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            const ListTile(
              title: Text('Escolha onde criar o exercício'),
              subtitle: Text('Selecione um node deste grafo.'),
            ),
            for (final node in nodes)
              ListTile(
                leading: const Icon(Icons.account_tree_outlined),
                title: Text(node.title),
                onTap: () => Navigator.pop(context, node.id),
              ),
          ],
        ),
      ),
    );
    if (nodeId == null || !mounted) return;
    final type = await showModalBottomSheet<StudySessionQuestionType>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const ListTile(
              title: Text('Que tipo de exercício deseja criar?'),
            ),
            ListTile(
              leading: const Icon(Icons.checklist_rounded),
              title: const Text('Múltipla escolha'),
              onTap: () => Navigator.pop(
                context,
                StudySessionQuestionType.multipleChoice,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.edit_note_rounded),
              title: const Text('Dissertativa'),
              onTap: () =>
                  Navigator.pop(context, StudySessionQuestionType.openEnded),
            ),
          ],
        ),
      ),
    );
    if (type == null || !mounted) return;
    final path = type == StudySessionQuestionType.multipleChoice
        ? RoutePaths.multipleChoiceCreate(graphId, nodeId)
        : RoutePaths.openEndedCreate(graphId, nodeId);
    await context.push(path);
    if (mounted && _graphId == graphId) {
      await _selectGraph(graphId, preserveSelection: true);
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate() || _isSaving) return;
    setState(() => _isSaving = true);
    try {
      final db = ref.read(appDatabaseProvider);
      final user = await ref.read(userProvider.future);
      final questionsByKey = {
        for (final question in _questions) _questionKey(question): question,
      };
      final selectedQuestions = _selectedQuestionKeys
          .map((key) => questionsByKey[key])
          .whereType<StudySessionQuestionCandidate>()
          .toList();
      final title = _titleController.text.trim();
      final description = _descriptionController.text.trim();
      final duration = int.parse(_durationController.text.trim());

      final sessionId = await db.transaction(() async {
        final existingId = widget.sessionId;
        late final String savedSessionId;
        if (existingId == null) {
          savedSessionId = await StudySessionDao(db).insertStudySession(
            userId: user.id,
            title: title,
            description: description.isEmpty ? null : description,
            status: 'CONFIGURING',
            targetDurationMin: duration,
            totalActivities: selectedQuestions.length,
          );
        } else {
          savedSessionId = existingId;
          await (db.update(
            db.studySession,
          )..where((session) => session.id.equals(existingId))).write(
            StudySessionCompanion(
              title: drift.Value(title),
              description: drift.Value(
                description.isEmpty ? null : description,
              ),
              targetDurationMin: drift.Value(duration),
              totalActivities: drift.Value(selectedQuestions.length),
              completedActivities: const drift.Value(0),
              actualDurationMin: const drift.Value(null),
              endedAt: const drift.Value(null),
              status: const drift.Value('CONFIGURING'),
              updatedAt: drift.Value(
                DateTime.now().millisecondsSinceEpoch ~/ 1000,
              ),
            ),
          );
          await (db.delete(
            db.studySessionUseKnowledgeGraph,
          )..where(
            (link) => link.studySessionId.equals(savedSessionId),
          )).go();
          await (db.delete(
            db.sessionNode,
          )..where((node) => node.studySessionId.equals(savedSessionId))).go();
          await StudySessionQuestionDao(db).replaceQuestions(
            studySessionId: savedSessionId,
            questions: selectedQuestions,
          );
        }

        if (selectedQuestions.isNotEmpty && _graphId != null) {
          await db.into(db.studySessionUseKnowledgeGraph).insert(
            StudySessionUseKnowledgeGraphCompanion.insert(
              id: const Uuid().v4(),
              graphId: _graphId!,
              studySessionId: savedSessionId,
            ),
          );
        }
        if (existingId == null) {
          await db.batch((batch) {
            batch.insertAll(db.studySessionQuestion, [
              for (var index = 0; index < selectedQuestions.length; index++)
                StudySessionQuestionCompanion.insert(
                  id: const Uuid().v4(),
                  studySessionId: savedSessionId,
                  multipleChoiceId: drift.Value(
                    selectedQuestions[index].type ==
                            StudySessionQuestionType.multipleChoice
                        ? selectedQuestions[index].id
                        : null,
                  ),
                  openEndedId: drift.Value(
                    selectedQuestions[index].type ==
                            StudySessionQuestionType.openEnded
                        ? selectedQuestions[index].id
                        : null,
                  ),
                  displayOrder: index,
                ),
            ]);
          });
        }
        final nodeIds = selectedQuestions
            .map((question) => question.nodeId)
            .toSet()
            .toList();
        await db.batch((batch) {
          batch.insertAll(db.sessionNode, [
            for (var index = 0; index < nodeIds.length; index++)
              SessionNodeCompanion.insert(
                id: const Uuid().v4(),
                studySessionId: savedSessionId,
                nodeId: nodeIds[index],
                displayOrder: index,
              ),
          ]);
        });
        return savedSessionId;
      });

      if (!mounted) return;
      context.pop(sessionId);
    } catch (error) {
      if (!mounted) return;
      setState(() => _error = 'Não foi possível salvar a sessão: $error');
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final visibleQuestionsByKey = {
      for (final question in _questions) _questionKey(question): question,
    };
    final visibleQuestions = _questions.where((question) {
      final search = _search.trim().toLowerCase();
      final matchesSearch =
          search.isEmpty ||
          question.title.toLowerCase().contains(search) ||
          question.nodeTitle.toLowerCase().contains(search);
      return matchesSearch &&
          (search.isEmpty ||
              question.statement.toLowerCase().contains(search)) &&
          (_typeFilter == null || question.type == _typeFilter);
    }).toList();
    final selectedCount = _selectedQuestionKeys.length;
    final graphName = _graphs
        .where((graph) => graph.id == _graphId)
        .map((graph) => graph.title)
        .firstOrNull;

    return Scaffold(
      body: _isLoading && _graphs.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                children: [
                  Text(
                    widget.sessionId == null
                        ? 'Monte uma sequência reutilizável. Você também pode '
                              'criar os exercícios sem sair deste fluxo.'
                        : 'Atualize os detalhes e a sequência de questões. '
                              'As realizações anteriores continuarão no histórico.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _titleController,
                    autofocus: widget.sessionId == null,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: const InputDecoration(
                      labelText: 'Título da sessão',
                      hintText: 'Ex.: Revisão de fisiologia',
                      prefixIcon: Icon(Icons.title),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => (value ?? '').trim().isEmpty
                        ? 'Informe um título para a sessão.'
                        : null,
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _descriptionController,
                    minLines: 2,
                    maxLines: 4,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: const InputDecoration(
                      labelText: 'Descrição (opcional)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _durationController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Duração planejada',
                      suffixText: 'min',
                      prefixIcon: Icon(Icons.timer_outlined),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      final minutes = int.tryParse((value ?? '').trim());
                      if (minutes == null || minutes < 1) {
                        return 'Informe uma duração de pelo menos 1 minuto.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Questões',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    selectedCount == 0
                        ? 'Sem questões por enquanto — você pode adicionar depois.'
                        : '$selectedCount questão(ões) na sequência',
                  ),
                  if (_selectedQuestionKeys.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Ordem de realização',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    Text(
                      'Use as setas para ajustar a sequência.',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Card(
                      child: Column(
                        children: [
                          for (var index = 0;
                              index < _selectedQuestionKeys.length;
                              index++)
                            if (visibleQuestionsByKey.containsKey(
                              _selectedQuestionKeys.elementAt(index),
                            ))
                              ListTile(
                                dense: true,
                                leading: CircleAvatar(
                                  radius: 15,
                                  child: Text('${index + 1}'),
                                ),
                                title: Text(
                                  visibleQuestionsByKey[
                                          _selectedQuestionKeys.elementAt(index)]!
                                      .title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle: Text(
                                  visibleQuestionsByKey[
                                          _selectedQuestionKeys.elementAt(index)]!
                                      .nodeTitle,
                                ),
                                trailing: Wrap(
                                  spacing: 0,
                                  children: [
                                    IconButton(
                                      tooltip: 'Mover para cima',
                                      visualDensity: VisualDensity.compact,
                                      onPressed: index == 0
                                          ? null
                                          : () => _moveSelectedQuestion(
                                              _selectedQuestionKeys.elementAt(
                                                index,
                                              ),
                                              -1,
                                            ),
                                      icon: const Icon(Icons.arrow_upward),
                                    ),
                                    IconButton(
                                      tooltip: 'Mover para baixo',
                                      visualDensity: VisualDensity.compact,
                                      onPressed:
                                          index ==
                                              _selectedQuestionKeys.length - 1
                                          ? null
                                          : () => _moveSelectedQuestion(
                                              _selectedQuestionKeys.elementAt(
                                                index,
                                              ),
                                              1,
                                            ),
                                      icon: const Icon(Icons.arrow_downward),
                                    ),
                                    IconButton(
                                      tooltip: 'Remover da sessão',
                                      visualDensity: VisualDensity.compact,
                                      onPressed: () => setState(
                                        () => _selectedQuestionKeys.remove(
                                          _selectedQuestionKeys.elementAt(
                                            index,
                                          ),
                                        ),
                                      ),
                                      icon: const Icon(
                                        Icons.remove_circle_outline,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String?>(
                    initialValue: _graphId,
                    decoration: const InputDecoration(
                      labelText: 'Grafo de origem (opcional)',
                      prefixIcon: Icon(Icons.account_tree_outlined),
                      border: OutlineInputBorder(),
                    ),
                    items: [
                      const DropdownMenuItem<String?>(
                        value: null,
                        child: Text('Não selecionar grafo'),
                      ),
                      for (final graph in _graphs)
                        DropdownMenuItem<String?>(
                          value: graph.id,
                          child: Text(
                            graph.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                    onChanged: _isSaving ? null : _selectGraph,
                  ),
                  if (_graphId != null) ...[
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: OutlinedButton.icon(
                        onPressed: _isSaving || _isLoading
                            ? null
                            : _createExercise,
                        icon: const Icon(Icons.add_rounded),
                        label: const Text('Criar exercício neste grafo'),
                      ),
                    ),
                    Wrap(
                      spacing: 8,
                      children: [
                        FilterChip(
                          label: const Text('Todos'),
                          selected: _typeFilter == null,
                          onSelected: (_) => setState(() => _typeFilter = null),
                        ),
                        FilterChip(
                          label: const Text('Múltipla escolha'),
                          selected:
                              _typeFilter ==
                              StudySessionQuestionType.multipleChoice,
                          onSelected: (_) => setState(
                            () => _typeFilter =
                                StudySessionQuestionType.multipleChoice,
                          ),
                        ),
                        FilterChip(
                          label: const Text('Dissertativas'),
                          selected:
                              _typeFilter ==
                              StudySessionQuestionType.openEnded,
                          onSelected: (_) => setState(
                            () => _typeFilter =
                                StudySessionQuestionType.openEnded,
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (graphName != null) ...[
                    const SizedBox(height: 12),
                    TextField(
                      controller: _searchController,
                      onChanged: (value) => setState(() => _search = value),
                      decoration: InputDecoration(
                        labelText: 'Buscar questões em $graphName',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: _search.isEmpty
                            ? null
                            : IconButton(
                                tooltip: 'Limpar busca',
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() => _search = '');
                                },
                                icon: const Icon(Icons.clear),
                              ),
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ],
                  if (_error != null) ...[
                    const SizedBox(height: 12),
                    Material(
                      color: Theme.of(context).colorScheme.errorContainer,
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(_error!),
                      ),
                    ),
                  ],
                  if (_graphId != null && _isLoading)
                    const Padding(
                      padding: EdgeInsets.all(24),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (_graphId != null &&
                      _questions.isEmpty &&
                      _error == null)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Text(
                        'Este grafo ainda não tem questões disponíveis.',
                        textAlign: TextAlign.center,
                      ),
                    )
                  else if (visibleQuestions.isEmpty &&
                      _questions.isNotEmpty &&
                      _graphId != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Text(
                        _search.isNotEmpty
                            ? 'Nenhuma questão corresponde à busca.'
                            : 'Nenhuma questão deste tipo neste grafo.',
                        textAlign: TextAlign.center,
                      ),
                    )
                  else if (visibleQuestions.isNotEmpty)
                    for (final question in visibleQuestions)
                      CheckboxListTile(
                        key: ValueKey(_questionKey(question)),
                        value: _selectedQuestionKeys.contains(
                          _questionKey(question),
                        ),
                        onChanged: _isSaving
                            ? null
                            : (selected) {
                                setState(() {
                                  if (selected == true) {
                                    _selectedQuestionKeys.add(
                                      _questionKey(question),
                                    );
                                  } else {
                                    _selectedQuestionKeys.remove(
                                      _questionKey(question),
                                    );
                                  }
                                });
                              },
                        title: Text(question.title),
                        subtitle: Text(
                          '${question.nodeTitle} · ${_questionTypeLabel(question.type)}\n'
                          '${question.statement}',
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        secondary: Icon(
                          question.type ==
                                  StudySessionQuestionType.multipleChoice
                              ? Icons.checklist_rounded
                              : Icons.edit_note_rounded,
                        ),
                        controlAffinity: ListTileControlAffinity.leading,
                        isThreeLine: true,
                      ),
                  const SizedBox(height: 20),
                  FilledButton.icon(
                    onPressed: _isSaving ? null : _save,
                    icon: _isSaving
                        ? const SizedBox.square(
                            dimension: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.save_outlined),
                    label: Text(
                      _isSaving
                          ? 'Salvando...'
                          : widget.sessionId == null
                          ? 'Criar sessão'
                          : 'Salvar alterações',
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

String _questionTypeLabel(StudySessionQuestionType type) => switch (type) {
  StudySessionQuestionType.multipleChoice => 'Múltipla escolha',
  StudySessionQuestionType.openEnded => 'Dissertativa',
};
