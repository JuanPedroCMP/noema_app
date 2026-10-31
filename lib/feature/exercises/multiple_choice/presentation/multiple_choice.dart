import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:fsrs/fsrs.dart' as fsrs;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noema/feature/ai/models/ai_agent_task.dart';
import 'package:noema/feature/ai/services/ai_content_generation_service.dart';
import 'package:noema/feature/ai/data/ai_background_task_dao.dart';
import 'package:noema/core/database/database_provider.dart';
import 'package:noema/core/design/tokens/layout.dart';
import 'package:noema/core/design/theme/theme_tokens.dart';
import 'package:noema/feature/exercises/multiple_choice/data/choice_dao.dart';
import 'package:noema/feature/exercises/multiple_choice/data/multiple_choice_dao.dart';
import 'package:noema/feature/exercises/multiple_choice/data/multiple_choice_response_log_dao.dart';
import 'package:noema/feature/exercises/data/exercise_correction_queue.dart';
import 'package:noema/feature/exercises/multiple_choice/widgets/choise.dart';
import 'package:noema/feature/exercises/multiple_choice/widgets/manipulate_choise.dart';
import 'package:noema/feature/config/providers/user_provider.dart';
import 'package:noema/feature/graph/data/graph_access.dart';
import 'package:noema/feature/review/data/fsrs_review_service.dart';
import 'package:noema/core/database/database.dart'
    show ChoiceData, MultipleChoiceResponseLogData;
import 'package:noema/shared/floating_card/floating_card.dart';
import 'package:noema/feature/study_assistant/providers/study_assistant_provider.dart';

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
    this.initialAiInstructions,
    this.autoGenerateAi = false,
    required this.defaultMode,
  });

  final String nodeId;
  final int defaultMode;
  final String? multipleChoiseId;
  final String? studySessionId;
  final String? studySessionLogId;
  final VoidCallback? onSendAnswer;
  final String? initialAiInstructions;
  final bool autoGenerateAi;

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
  bool _isGenerating = false;
  bool _isAiGenerated = false;
  bool _hasSubmitted = false;
  final Stopwatch _answerTimer = Stopwatch();
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
    _answerTimer.start();

    titleController = TextEditingController();
    statementController = TextEditingController();
    if (widget.initialAiInstructions != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          ref.read(studyAssistantProvider.notifier).consumeHandoff();
        }
      });
    }

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
        if (widget.autoGenerateAi) {
          unawaited(_generateWithAi(skipInstructionPrompt: true));
        }
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
        _isAiGenerated = data.isAiGenerated;
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
        isAiGenerated: _isAiGenerated,
      );
      tempId = newId;
      return newId;
    } else {
      await multipleChoiceDao.updateMultipleChoice(
        id: currentId,
        title: normalizedTitle,
        statement: normalizedStatement,
        isAiGenerated: _isAiGenerated,
      );

      return currentId;
    }
  }

  Future<void> _generateWithAi({bool skipInstructionPrompt = false}) async {
    if (_isGenerating || _isSaving) return;
    final instructions = skipInstructionPrompt
        ? widget.initialAiInstructions ?? ''
        : await _askAiInstructions();
    if (instructions == null || !mounted) return;

    setState(() {
      _isGenerating = true;
      _loadError = null;
    });

    try {
      final user = await ref.read(userProvider.future);
      final node = await getGraphNodeForUser(
        db: ref.read(appDatabaseProvider),
        nodeId: widget.nodeId,
        userId: user.id,
      );
      final prompt = StringBuffer()
        ..writeln(
          'Crie uma questão de múltipla escolha para este nó de estudo.',
        )
        ..writeln('Nó: ${node.title}')
        ..writeln('Descrição: ${node.description ?? "não informada"}')
        ..writeln(
          'Instruções adicionais: ${instructions.trim().isEmpty ? "sem instruções adicionais" : instructions.trim()}',
        )
        ..writeln(
          'Retorne título, enunciado e pelo menos 4 alternativas objetivas, '
          'com uma única alternativa correta. Cada alternativa deve incluir '
          'is_correct (boolean), statement, explanation e weigth (inteiro).',
        );
      final response = await ref
          .read(aiContentGenerationServiceProvider)
          .generate(
            task: AiAgentTask.createMultipleChoiceQuestion,
            prompt: prompt.toString(),
          );
      final draft = _parseAiQuestion(response);
      if (!mounted) return;
      final accepted = await _previewAiQuestion(draft);
      if (accepted != true || !mounted) return;

      final db = ref.read(appDatabaseProvider);
      final savedQuestionId = await db.transaction(() async {
        title = draft.title;
        statement = draft.statement;
        _isAiGenerated = true;
        titleController.text = title;
        statementController.text = statement;
        final id = await save();
        if (id == null) {
          throw StateError('A questão gerada não pôde ser salva.');
        }

        final choiceDao = ChoiceDao(db);
        await choiceDao.deleteChoicesByQuestion(multipleChoiceId: id);
        for (final choice in draft.choices) {
          await choiceDao.insertChoice(
            multipleChoiceId: id,
            isCorrect: choice.isCorrect,
            statement: choice.statement,
            explanation: choice.explanation,
            weight: choice.weight,
            isAiGenerated: true,
          );
        }
        return id;
      });

      tempId = savedQuestionId;
      await _loadData();
      if (mounted) _showAiMessage('Questão gerada e aplicada ao editor.');
    } on DioException catch (error) {
      if (mounted) _showAiMessage(_aiApiError(error));
    } on FormatException catch (error) {
      if (mounted) _showAiMessage('Resposta da IA inválida: ${error.message}');
    } catch (error) {
      if (mounted) {
        _showAiMessage(
          error is StateError
              ? error.message
              : 'Não foi possível gerar a questão. Verifique a configuração '
                    'do agente e das chaves de IA.',
        );
      }
    } finally {
      if (mounted) setState(() => _isGenerating = false);
    }
  }

  Future<String?> _askAiInstructions() async {
    final controller = TextEditingController(
      text: widget.initialAiInstructions ?? '',
    );
    try {
      return await showDialog<String>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Gerar questão com IA'),
          content: SizedBox(
            width: 440,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'A questão será baseada no nó atual. Você pode orientar '
                  'a dificuldade ou o aspecto que deseja avaliar.',
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: controller,
                  autofocus: true,
                  maxLines: 3,
                  maxLength: 300,
                  decoration: const InputDecoration(
                    labelText: 'Orientação adicional (opcional)',
                    hintText: 'Ex.: nível intermediário, foco em aplicação',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancelar'),
            ),
            FilledButton.icon(
              onPressed: () => Navigator.pop(dialogContext, controller.text),
              icon: const Icon(Icons.auto_awesome),
              label: const Text('Gerar'),
            ),
          ],
        ),
      );
    } finally {
      controller.dispose();
    }
  }

  _AiMultipleChoiceDraft _parseAiQuestion(Map<String, dynamic> response) {
    final choices = response['choises'] ?? response['choices'];
    if (choices is! List) {
      throw const FormatException('A lista de alternativas não foi retornada.');
    }
    final parsedChoices = choices.map((item) {
      if (item is! Map) {
        throw const FormatException('Uma alternativa possui formato inválido.');
      }
      final isCorrect = item['is_correct'];
      final choiceStatement = item['statement'];
      if (isCorrect is! bool ||
          choiceStatement is! String ||
          choiceStatement.trim().isEmpty) {
        throw const FormatException('Uma alternativa está incompleta.');
      }
      final explanation = item['explanation'];
      final weightValue = item['weigth'] ?? item['weight'];
      return _AiChoiceDraft(
        isCorrect: isCorrect,
        statement: choiceStatement.trim(),
        explanation: explanation is String ? explanation.trim() : '',
        weight: weightValue is num ? weightValue.toInt() : null,
      );
    }).toList();
    if (parsedChoices.length < 2 ||
        parsedChoices.where((choice) => choice.isCorrect).length != 1) {
      throw const FormatException(
        'A questão precisa ter pelo menos duas alternativas e exatamente '
        'uma correta.',
      );
    }
    final generatedTitle = response['title'];
    final generatedStatement = response['statement'];
    if (generatedTitle is! String ||
        generatedTitle.trim().isEmpty ||
        generatedStatement is! String ||
        generatedStatement.trim().isEmpty) {
      throw const FormatException('Título ou enunciado não foi retornado.');
    }
    return _AiMultipleChoiceDraft(
      title: generatedTitle.trim(),
      statement: generatedStatement.trim(),
      choices: parsedChoices,
    );
  }

  Future<bool?> _previewAiQuestion(_AiMultipleChoiceDraft draft) {
    return showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Revise a questão gerada'),
        content: SizedBox(
          width: 520,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  draft.title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(draft.statement),
                const Divider(height: 24),
                for (var index = 0; index < draft.choices.length; index++)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(
                      draft.choices[index].isCorrect
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      color: draft.choices[index].isCorrect
                          ? Theme.of(context).colorScheme.primary
                          : null,
                    ),
                    title: Text(draft.choices[index].statement),
                    subtitle: draft.choices[index].explanation.isEmpty
                        ? null
                        : Text(draft.choices[index].explanation),
                  ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Descartar'),
          ),
          FilledButton.icon(
            onPressed: () => Navigator.pop(dialogContext, true),
            icon: const Icon(Icons.check),
            label: const Text('Aplicar ao editor'),
          ),
        ],
      ),
    );
  }

  String _aiApiError(DioException error) {
    final status = error.response?.statusCode;
    if (status == 401 || status == 403) {
      return 'Sua sessão expirou ou não está autorizada para usar a IA.';
    }
    if (status == 404) return 'O agente de geração de questões não existe.';
    if (status == 429) return 'Muitas solicitações. Aguarde e tente novamente.';
    if (status != null && status >= 500) {
      return 'O serviço de IA falhou. Tente novamente mais tarde.';
    }
    if (error.response == null) {
      return 'Sem conexão com o serviço de IA. Verifique sua internet.';
    }
    return 'Não foi possível gerar a questão (HTTP $status).';
  }

  void _showAiMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
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
    final score = ((selectedCorrect - wrongSelected) / correctIds.length).clamp(
      0.0,
      1.0,
    );
    final durationSeconds = _answerTimer.elapsed.inSeconds;
    final db = ref.read(appDatabaseProvider);
    final responseDao = MultipleChoiceResponseLogDao(db);
    String? responseId;

    try {
      await db.transaction(() async {
        responseId = await responseDao.insertMultipleChoiceResponseLog(
          multipleChoiceId: questionId,
          questionSnapshot: jsonEncode({
            'title': title,
            'statement': statement,
          }),
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
          score: score,
          durationSeconds: durationSeconds,
        );
        await FsrsReviewService(db).review(
          itemType: ReviewItemType.multipleChoice,
          itemId: questionId,
          nodeId: widget.nodeId,
          rating: _ratingForScore(score),
          durationSeconds: durationSeconds,
          score: score,
          method: ReviewMethod.autoScore,
          sourceResponseId: responseId,
        );
      });
      var correctionMessage = '';
      try {
        final result = await enqueueExerciseCorrectionIfAutomatic(
          ref: ref,
          nodeId: widget.nodeId,
          responseId: responseId!,
          taskType: aiMultipleChoiceCorrectionTaskType,
        );
        correctionMessage = switch (result) {
          ExerciseCorrectionEnqueueResult.queued =>
            ' A explicação com IA entrou na fila.',
          ExerciseCorrectionEnqueueResult.manual =>
            ' Você poderá revisar a tentativa manualmente pelo histórico.',
        };
      } catch (error) {
        correctionMessage =
            ' A resposta foi salva, mas não foi possível agendar a correção: $error';
      }
      _answerTimer.stop();
      if (!mounted) return;
      if (widget.onSendAnswer case final onSendAnswer?) {
        onSendAnswer();
      } else if (mounted) {
        setState(() => _hasSubmitted = true);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Resposta registrada.$correctionMessage')),
      );
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Não foi possível registrar a resposta: $error'),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  fsrs.Rating _ratingForScore(double score) {
    if (score < 0.25) return fsrs.Rating.again;
    if (score < 0.6) return fsrs.Rating.hard;
    if (score < 0.9) return fsrs.Rating.good;
    return fsrs.Rating.easy;
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
    _answerTimer.stop();
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
                          Align(
                            alignment: Alignment.centerLeft,
                            child: OutlinedButton.icon(
                              onPressed: _isGenerating || _isSaving
                                  ? null
                                  : _generateWithAi,
                              icon: _isGenerating
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Icon(Icons.auto_awesome),
                              label: Text(
                                _isGenerating
                                    ? 'Gerando questão...'
                                    : 'Gerar questão com IA',
                              ),
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
                            onPressed:
                                _isSending ||
                                    _hasSubmitted ||
                                    _selectedChoiceIds.isEmpty
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
                                  : _selectedChoiceIds.isEmpty
                                  ? "Selecione uma alternativa"
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
        padding: const EdgeInsets.all(AppLayoutTokens.cardPadding),
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

class _AiMultipleChoiceDraft {
  const _AiMultipleChoiceDraft({
    required this.title,
    required this.statement,
    required this.choices,
  });

  final String title;
  final String statement;
  final List<_AiChoiceDraft> choices;
}

class _AiChoiceDraft {
  const _AiChoiceDraft({
    required this.isCorrect,
    required this.statement,
    required this.explanation,
    required this.weight,
  });

  final bool isCorrect;
  final String statement;
  final String explanation;
  final int? weight;
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
        padding: const EdgeInsets.all(AppLayoutTokens.cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(subtitle, style: Theme.of(context).textTheme.labelLarge),
            SizedBox(height: context.spacing.sm),
            Text(title, style: Theme.of(context).textTheme.headlineSmall),
            SizedBox(height: context.spacing.sm + context.spacing.xs),
            const Divider(),
            SizedBox(height: context.spacing.sm),
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
