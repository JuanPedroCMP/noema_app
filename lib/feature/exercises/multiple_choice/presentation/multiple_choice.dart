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
import 'package:noema/core/database/database.dart'
    show ChoiceData, MultipleChoiceData;
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
    this.onSendAnswer,
    required this.defaultMode,
  });

  final String nodeId;
  final int defaultMode;
  final String? multipleChoiseId;
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
      if (mounted) setState(() => _isLoading = false);
      titleController.text = "";
      statementController.text = "";
      return;
    }

    try {
      final db = ref.read(appDatabaseProvider);
      final multipleChoiceDao = MultipleChoiceDao(db);
      final choiceDao = ChoiceDao(db);

      final results = await Future.wait([
        multipleChoiceDao.getMultipleChoice(id: questionId),
        choiceDao.getChoicesByQuestion(multipleChoiceId: questionId),
      ]);
      final data = results[0] as MultipleChoiceData?;
      final listChoises = results[1] as List<ChoiceData>;

      if (!mounted) return;

      if (data == null) {
        setState(() {
          _isLoading = false;
          _loadError = "Questão não encontrada ou removida.";
          title = "";
          statement = "";
          choises = listChoises;
        });
        return;
      }

      setState(() {
        _isLoading = false;
        title = data.title;
        statement = data.statement;
        choises = listChoises;
        _loadError = null;
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
        questionChoiceSnapshot: jsonEncode(
          choises.map((choice) => choice.toJson()).toList(),
        ),
        selectedChoiceIds: jsonEncode(_selectedChoiceIds.toList()),
        totalCorrectOption: correctIds.length,
        correctSelected: selectedCorrect,
        wrongSelected: wrongSelected,
        totalQuestions: choises.length,
        score: rawScore.clamp(0.0, 1.0),
      );
      if (!mounted) return;
      widget.onSendAnswer?.call();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Resposta registrada.")));
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
        const SnackBar(content: Text("Não foi possível excluir a alternativa.")),
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
    return SizedBox(
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
                          _isSaving ? "Preparando..." : "Adicionar alternativa",
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
                    // Resposta
                    spacing: context.spacing.md,
                    children: [
                      Text(title, style: context.textTheme.headlineMedium),
                      Divider(),
                      Text(statement, style: context.textTheme.bodyMedium),
                      Text(
                        '${_selectedChoiceIds.length} alternativa(s) selecionada(s)',
                        style: context.textTheme.labelMedium,
                      ),
                      for (final choise in choises) ...[
                        Card(
                          child: Choise(
                            choiseId: choise.id,
                            onChanged: (ChoiceData value) {
                              if (value.isCorrect) {
                                _selectedChoiceIds.add(value.id);
                              } else {
                                _selectedChoiceIds.remove(value.id);
                              }
                            },
                            mode: 0,
                          ),
                        ),
                      ],
                      FilledButton(
                        onPressed: _isSending ? null : sendAnswer,
                        child: Text(
                          _isSending ? "Enviando..." : "Enviar resposta",
                        ),
                      ),
                    ],
                  )
                : (mode == 3)
                ? Column(
                    // Visualização
                    spacing: context.spacing.md,
                    children: [
                      Text(title, style: context.textTheme.headlineMedium),
                      Divider(),
                      Text(statement, style: context.textTheme.bodyMedium),
                      for (final choise in choises) ...[
                        Card(
                          child: Choise(
                            choiseId: choise.id,
                            onChanged: (ChoiceData value) {},
                            mode: 1,
                          ),
                        ),
                      ],
                      const SizedBox.shrink(),
                    ],
                  )
                : SizedBox(),
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
    );
  }
}
