import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noema/core/database/database_provider.dart';
import 'package:noema/core/design/theme/theme_tokens.dart';
import 'package:noema/feature/exercises/multiple_choice/data/choice_dao.dart';
import 'package:noema/feature/exercises/multiple_choice/data/multiple_choice_dao.dart';
import 'package:noema/feature/exercises/multiple_choice/data/multiple_choice_response_log_dao.dart';
import 'package:noema/feature/exercises/multiple_choice/widgets/choise.dart';
import 'package:noema/feature/exercises/multiple_choice/widgets/manipulate_choise.dart';
import 'package:noema/feature/config/providers/user_provider.dart';
import 'package:noema/feature/graph/data/graph_access.dart';
import 'package:noema/core/database/database.dart'
    show ChoiceData, MultipleChoiceResponseLogData;
import 'package:noema/shared/floating_card/floating_card.dart';

/// Parameters:
/// Mode
/// 1 - Edit/Create (create if any valid id is given to multipleChoiseId)
/// 2 - Do the exercice
/// 3 - Only view
class MultipleChoise extends ConsumerStatefulWidget {
  const MultipleChoise({
    super.key,
    required this.nodeId,
    this.multipleChoiseId,
    this.studySessionId,
    this.studySessionLogId,
    this.onSendAnswer,
    required this.defaultMode,
  });

  final String nodeId;
  final int defaultMode;
  final String? multipleChoiseId;
  final String? studySessionId;
  final String? studySessionLogId;
  final VoidCallback? onSendAnswer;

  @override
  ConsumerState<MultipleChoise> createState() => _MultipleChoise();
}

class _MultipleChoise extends ConsumerState<MultipleChoise> {
  String title = "";
  String statement = "";
  List<ChoiceData> choises = [];
  bool isEditing = false;
  bool _isSaving = false;
  bool _isSending = false;
  bool _hasSubmitted = false;
  MultipleChoiceResponseLogData? _latestResponse;
  final Set<String> _latestSelectedChoiceIds = {};
  String editTarget = "";
  int mode = 0;
  bool _isLoading = true;
  String? _loadError;

  String tempId = "";
  final Set<String> _selectedChoiceIds = {};

  late final TextEditingController titleController;
  late final TextEditingController statementController;

  @override
  void initState() {
    super.initState();
    mode = widget.defaultMode;

    titleController = TextEditingController();
    statementController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    final questionId = _questionId;
    if (questionId == null || questionId.isEmpty) {
      try {
        final user = await ref.read(userProvider.future);
        await getGraphNodeForUser(
          db: ref.read(appDatabaseProvider),
          nodeId: widget.nodeId,
          userId: user.id,
        );
        if (!mounted) return;
        setState(() => _isLoading = false);
        titleController.text = "";
        statementController.text = "";
      } catch (error) {
        if (!mounted) return;
        setState(() {
          _isLoading = false;
          _loadError = 'Não foi possível abrir este node: $error';
        });
      }
      return;
    }

    try {
      final db = ref.read(appDatabaseProvider);
      final user = await ref.read(userProvider.future);
      await getGraphNodeForUser(db: db, nodeId: widget.nodeId, userId: user.id);
      final multipleChoiceDao = MultipleChoiceDao(db);
      final choiceDao = ChoiceDao(db);

      final data = await multipleChoiceDao.getMultipleChoice(id: questionId);

      if (!mounted) return;

      if (data == null) {
        setState(() {
          _isLoading = false;
          _loadError = "Questão não encontrada ou removida.";
          title = "";
          statement = "";
        });
        return;
      }
      if (data.nodeId != widget.nodeId) {
        setState(() {
          _isLoading = false;
          _loadError = "A questão não pertence a este node.";
        });
        return;
      }

      final listChoises = await choiceDao.getChoicesByQuestion(
        multipleChoiceId: questionId,
      );
      final latestResponse = mode == 3
          ? await MultipleChoiceResponseLogDao(
              db,
            ).getLatestResponseByQuestion(multipleChoiceId: questionId)
          : null;
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        title = data.title;
        statement = data.statement;
        choises = listChoises;
        _loadError = null;
        _latestResponse = latestResponse;
        _latestSelectedChoiceIds
          ..clear()
          ..addAll(
            latestResponse == null
                ? const <String>[]
                : (jsonDecode(latestResponse.selectedChoiceIds) as List)
                      .whereType<String>(),
          );
      });

      titleController.text = title;
      statementController.text = statement;
    } catch (_) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _loadError = "Não foi possível carregar a questão.";
        });
      }
    }
  }

  String? get _questionId {
    final id = widget.multipleChoiseId;
    if (id != null && id.isNotEmpty) return id;
    return tempId.isEmpty ? null : tempId;
  }

  Future<String?> save() async {
    final normalizedTitle = title.trim();
    final normalizedStatement = statement.trim();
    if (normalizedTitle.isEmpty || normalizedStatement.isEmpty) {
      return null;
    }

    final db = ref.read(appDatabaseProvider);
    final multipleChoiceDao = MultipleChoiceDao(db);

    final currentId = _questionId;
    if (currentId == null) {
      final newId = await multipleChoiceDao.insertMultipleChoice(
        nodeId: widget.nodeId,
        title: normalizedTitle,
        statement: normalizedStatement,
      );
      tempId = newId;
      return newId;
    } else {
      await multipleChoiceDao.updateMultipleChoice(
        id: currentId,
        title: normalizedTitle,
        statement: normalizedStatement,
      );

      return currentId;
    }
  }

  Future<void> sendAnswer() async {
    if (_isSending) return;
    final questionId = _questionId;
    if (questionId == null || questionId.isEmpty || choises.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Esta questão ainda não está pronta.")),
        );
      }
      return;
    }

    if (_selectedChoiceIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Selecione pelo menos uma alternativa.")),
      );
      return;
    }

    final correctIds = choises
        .where((choice) => choice.isCorrect)
        .map((choice) => choice.id)
        .toSet();
    if (correctIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Esta questão ainda não tem uma alternativa correta."),
        ),
      );
      return;
    }

    setState(() => _isSending = true);
    final selectedCorrect = _selectedChoiceIds.intersection(correctIds).length;
    final wrongSelected = _selectedChoiceIds.difference(correctIds).length;
    final db = ref.read(appDatabaseProvider);
    final responseDao = MultipleChoiceResponseLogDao(db);

    try {
      final rawScore = correctIds.isEmpty
          ? 0.0
          : (selectedCorrect - wrongSelected) / correctIds.length;
      await responseDao.insertMultipleChoiceResponseLog(
        multipleChoiceId: questionId,
        questionSnapshot: jsonEncode({'title': title, 'statement': statement}),
        questionChoiceSnapshot: jsonEncode(
          choises.map((choice) => choice.toJson()).toList(),
        ),
        selectedChoiceIds: jsonEncode(_selectedChoiceIds.toList()),
        totalCorrectOption: correctIds.length,
        correctSelected: selectedCorrect,
        wrongSelected: wrongSelected,
        totalQuestions: choises.length,
        studySessionId: widget.studySessionId,
        studySessionLogId: widget.studySessionLogId,
        score: rawScore.clamp(0.0, 1.0),
      );
      if (!mounted) return;
      if (widget.onSendAnswer case final onSendAnswer?) {
        onSendAnswer();
      } else if (mounted) {
        setState(() => _hasSubmitted = true);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.onSendAnswer == null
                ? "Resposta registrada. Confira o resultado abaixo."
                : "Resposta registrada.",
          ),
        ),
      );
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Não foi possível registrar a resposta."),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  Future<String?> _ensureQuestionSaved() async {
    return save();
  }

  Future<void> _saveQuestion() async {
    if (_isSaving) return;
    setState(() => _isSaving = true);
    try {
      final id = await _ensureQuestionSaved();
      if (!mounted) return;
      if (id == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Preencha título e enunciado.")),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Questão salva.")));
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Não foi possível salvar a questão.")),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _addChoice() async {
    if (_isSaving) return;
    setState(() => _isSaving = true);
    try {
      final id = await _ensureQuestionSaved();
      if (!mounted) return;
      if (id == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Preencha título e enunciado.")),
        );
        return;
      }
      await _loadData();
      if (!mounted) return;
      setState(() {
        editTarget = "";
        isEditing = true;
      });
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Não foi possível preparar a alternativa."),
        ),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _deleteChoice(ChoiceData choice) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Excluir alternativa?"),
        content: Text("“${choice.statement}” será removida da questão."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancelar"),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Excluir"),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    try {
      final db = ref.read(appDatabaseProvider);
      await ChoiceDao(db).deleteChoice(id: choice.id);
      await _loadData();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Não foi possível excluir a alternativa."),
        ),
      );
    }
  }

  void titleChanged(String value) {
    title = value;
  }

  void statementChanged(String value) {
    statement = value;
  }

  @override
  void dispose() {
    titleController.dispose();
    statementController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading && _questionId != null) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_loadError != null) {
      return Center(child: Text(_loadError!));
    }
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 820),
        child: SizedBox(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(4),
            child: Stack(
              children: [
                (mode == 1)
                    ? Column(
                        // Edição/Criação
                        spacing: context.spacing.md,
                        children: [
                          TextField(
                            onChanged: titleChanged,
                            controller: titleController,
                            maxLines: 3,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Título",
                            ),
                          ),
                          TextField(
                            onChanged: statementChanged,
                            controller: statementController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Enunciado",
                            ),
                          ),
                          for (final choise in choises) ...[
                            Row(
                              children: [
                                Expanded(
                                  child: Card(
                                    child: Choise(
                                      choiseId: choise.id,
                                      onChanged: (ChoiceData value) {},
                                      mode: 1,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      editTarget = choise.id;
                                      isEditing = true;
                                    });
                                  },
                                  icon: Icon(Icons.edit),
                                ),
                                IconButton(
                                  tooltip: "Excluir alternativa",
                                  onPressed: () => _deleteChoice(choise),
                                  icon: const Icon(Icons.delete_outline),
                                ),
                              ],
                            ),
                          ],
                          FilledButton.icon(
                            onPressed: _isSaving ? null : _addChoice,
                            icon: const Icon(Icons.add),
                            label: Text(
                              _isSaving
                                  ? "Preparando..."
                                  : "Adicionar alternativa",
                            ),
                          ),
                          FilledButton(
                            onPressed: _isSaving ? null : _saveQuestion,
                            child: Text(
                              _isSaving ? "Salvando..." : "Salvar questão",
                            ),
                          ),
                        ],
                      )
                    : (mode == 2)
                    ? Column(
                        spacing: context.spacing.md,
                        children: [
                          _QuestionPrompt(
                            title: title,
                            statement: statement,
                            subtitle: _hasSubmitted
                                ? 'Resultado da tentativa'
                                : 'Selecione todas as alternativas corretas.',
                          ),
                          if (!_hasSubmitted)
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                _selectedChoiceIds.isEmpty
                                    ? 'Nenhuma alternativa selecionada'
                                    : '${_selectedChoiceIds.length} alternativa(s) selecionada(s)',
                                style: context.textTheme.labelLarge,
                              ),
                            ),
                          for (final choise in choises) ...[
                            Card(
                              child: Choise(
                                choiseId: choise.id,
                                onChanged: (_) {},
                                mode: 2,
                                selected: _selectedChoiceIds.contains(
                                  choise.id,
                                ),
                                revealAnswer: _hasSubmitted,
                                onSelectionChanged: _hasSubmitted
                                    ? null
                                    : (selected) {
                                        setState(() {
                                          if (selected) {
                                            _selectedChoiceIds.add(choise.id);
                                          } else {
                                            _selectedChoiceIds.remove(
                                              choise.id,
                                            );
                                          }
                                        });
                                      },
                              ),
                            ),
                          ],
                          if (_hasSubmitted) _buildResultSummary(),
                          FilledButton.icon(
                            onPressed: _isSending || _hasSubmitted
                                ? null
                                : sendAnswer,
                            icon: Icon(
                              _hasSubmitted
                                  ? Icons.check_circle_outline
                                  : Icons.send_rounded,
                            ),
                            label: Text(
                              _isSending
                                  ? "Registrando..."
                                  : _hasSubmitted
                                  ? "Resposta registrada"
                                  : "Enviar resposta",
                            ),
                          ),
                        ],
                      )
                    : (mode == 3)
                    ? Column(
                        spacing: context.spacing.md,
                        children: [
                          _QuestionPrompt(
                            title: title,
                            statement: statement,
                            subtitle: _latestResponse == null
                                ? 'Visualização da questão'
                                : 'Resultado da tentativa mais recente',
                          ),
                          if (_latestResponse != null)
                            Card(
                              child: ListTile(
                                leading: const Icon(Icons.history_rounded),
                                title: Text(
                                  '${_latestResponse!.correctSelected} de '
                                  '${_latestResponse!.totalCorrectOption} corretas '
                                  'selecionadas',
                                ),
                                subtitle: Text(
                                  'Aproveitamento: '
                                  '${((_latestResponse!.score ?? 0) * 100).round()}%'
                                  ' · ${DateTime.fromMillisecondsSinceEpoch(_latestResponse!.answeredAt * 1000).toLocal().toString().substring(0, 16)}',
                                ),
                              ),
                            ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              _latestResponse == null
                                  ? 'Gabarito'
                                  : 'Alternativas e resultado',
                              style: context.textTheme.titleMedium,
                            ),
                          ),
                          for (final choise in choises)
                            Card(
                              child: Choise(
                                choiseId: choise.id,
                                onChanged: (_) {},
                                mode: _latestResponse == null ? 1 : 2,
                                selected: _latestSelectedChoiceIds.contains(
                                  choise.id,
                                ),
                                revealAnswer: _latestResponse != null,
                              ),
                            ),
                          if (_latestResponse?.aiFeedback?.trim().isNotEmpty ==
                              true)
                            Card(
                              child: ListTile(
                                leading: const Icon(Icons.feedback_outlined),
                                title: const Text('Feedback'),
                                subtitle: Text(_latestResponse!.aiFeedback!),
                              ),
                            ),
                        ],
                      )
                    : const SizedBox.shrink(),
                if (isEditing) ...[
                  Align(
                    alignment: Alignment.center,
                    child: FloatingCard(
                      width: max(
                        280,
                        min(720, MediaQuery.sizeOf(context).width - 32),
                      ),
                      padding: 20,
                      child: ManipulateChoise(
                        multipleChoiceId: widget.multipleChoiseId ?? tempId,
                        choiseId: editTarget,
                        onSave: () {
                          setState(() {
                            isEditing = false;
                          });
                          _loadData();
                        },
                        onCancel: () {
                          setState(() => isEditing = false);
                        },
                        onChanged: (ChoiceData value) {},
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResultSummary() {
    final correctIds = choises
        .where((choice) => choice.isCorrect)
        .map((choice) => choice.id)
        .toSet();
    final correctSelected = _selectedChoiceIds.intersection(correctIds).length;
    final wrongSelected = _selectedChoiceIds.difference(correctIds).length;
    final isPerfect =
        correctIds.isNotEmpty &&
        correctSelected == correctIds.length &&
        wrongSelected == 0;
    final colorScheme = Theme.of(context).colorScheme;
    final score = correctIds.isEmpty
        ? 0.0
        : ((correctSelected - wrongSelected) / correctIds.length).clamp(
            0.0,
            1.0,
          );

    return Card(
      color: isPerfect
          ? colorScheme.primaryContainer
          : colorScheme.errorContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              isPerfect ? Icons.task_alt_rounded : Icons.lightbulb_outline,
              color: isPerfect
                  ? colorScheme.onPrimaryContainer
                  : colorScheme.onErrorContainer,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isPerfect ? 'Muito bem!' : 'Revise as alternativas',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$correctSelected de ${correctIds.length} corretas '
                    'selecionadas · $wrongSelected incorreta(s) marcada(s)',
                  ),
                  const SizedBox(height: 4),
                  Text('Aproveitamento: ${(score * 100).round()}%'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuestionPrompt extends StatelessWidget {
  const _QuestionPrompt({
    required this.title,
    required this.statement,
    required this.subtitle,
  });

  final String title;
  final String statement;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Card(
      color: colors.surfaceContainerLow,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(subtitle, style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            Text(title, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 8),
            SelectableText(
              statement,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
