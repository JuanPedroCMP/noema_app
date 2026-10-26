import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noema/core/database/database.dart'
    show OpenEndedResponseLogData;
import 'package:noema/core/database/database_provider.dart';
import 'package:noema/core/design/theme/theme_tokens.dart';
import 'package:noema/feature/exercises/open_ended/data/open_ended_dao.dart';
import 'package:noema/feature/exercises/open_ended/data/open_ended_response_log_dao.dart';
import 'package:noema/feature/config/providers/user_provider.dart';
import 'package:noema/feature/graph/data/graph_access.dart';

enum OpenEndedType { essay, feynman }

/// Parameters:
/// Mode
/// 1 - Edit/Create (create if any valid id is given to openEndedId)
/// 2 - Do the exercice
/// 3 - Only view
class OpenEnded extends ConsumerStatefulWidget {
  const OpenEnded({
    super.key,
    required this.nodeId,
    this.openEndedId,
    this.studySessionId,
    this.studySessionLogId,
    this.onSendAnswer,
    this.onSave,
    required this.defaultMode,
  });

  final String nodeId;
  final int defaultMode;
  final String? openEndedId;
  final String? studySessionId;
  final String? studySessionLogId;
  final VoidCallback? onSendAnswer;
  final VoidCallback? onSave;

  @override
  ConsumerState<OpenEnded> createState() => _OpenEnded();
}

class _OpenEnded extends ConsumerState<OpenEnded> {
  String title = "";
  String statement = "";
  OpenEndedType type = OpenEndedType.essay;
  String referenceCorrectAnswer = "";
  String userAnswer = "";
  int mode = 0;
  String tempId = "";
  bool _isLoading = true;
  bool _isSaving = false;
  bool _isSending = false;
  bool _hasSubmitted = false;
  OpenEndedResponseLogData? _latestResponse;
  String? _loadError;

  late final TextEditingController titleController;
  late final TextEditingController statementController;
  late final TextEditingController typeController;
  late final TextEditingController referenceCorrectAnswerController;
  late final TextEditingController userAnswerController;

  String get _typeLabel =>
      type == OpenEndedType.feynman ? "Método Feynman" : "Dissertativa";

  @override
  void initState() {
    super.initState();

    mode = widget.defaultMode;

    titleController = TextEditingController();
    statementController = TextEditingController();
    typeController = TextEditingController();
    referenceCorrectAnswerController = TextEditingController();
    userAnswerController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    if (!mounted) return;
    if (widget.openEndedId == null || widget.openEndedId!.isEmpty) {
      try {
        final user = await ref.read(userProvider.future);
        await getGraphNodeForUser(
          db: ref.read(appDatabaseProvider),
          nodeId: widget.nodeId,
          userId: user.id,
        );
      } catch (error) {
        if (!mounted) return;
        setState(() {
          _isLoading = false;
          _loadError = 'Não foi possível abrir este node: $error';
        });
        return;
      }
      setState(() {
        _isLoading = false;
        title = "";
        statement = "";
        type = OpenEndedType.essay;
        referenceCorrectAnswer = "";
        userAnswer = "";
      });
      titleController.text = "";
      statementController.text = "";
      typeController.text = _typeLabel;
      referenceCorrectAnswerController.text = "";
      return;
    }

    try {
      final db = ref.read(appDatabaseProvider);
      final user = await ref.read(userProvider.future);
      await getGraphNodeForUser(
        db: db,
        nodeId: widget.nodeId,
        userId: user.id,
      );
      final data = await OpenEndedDao(db).getOpenEnded(id: widget.openEndedId!);
      if (!mounted) return;
      if (data == null) {
        setState(() {
          _isLoading = false;
          _loadError = "Questão não encontrada ou removida.";
        });
        return;
      }
      final latestResponse = mode == 3
          ? await OpenEndedResponseLogDao(
              db,
            ).getLatestResponseByQuestion(openEndedId: widget.openEndedId!)
          : null;
      if (!mounted) return;
      if (data.nodeId != widget.nodeId) {
        setState(() {
          _isLoading = false;
          _loadError = 'A questão não pertence a este node.';
        });
        return;
      }

      setState(() {
        _isLoading = false;
        title = data.title;
        statement = data.statement;
        type = data.type.toLowerCase() == "feynman"
            ? OpenEndedType.feynman
            : OpenEndedType.essay;
        referenceCorrectAnswer = data.referenceCorrectAnswer ?? "";
        _latestResponse = latestResponse;
        userAnswer = latestResponse?.userAnswer ?? "";
      });
      titleController.text = title;
      statementController.text = statement;
      typeController.text = _typeLabel;
      referenceCorrectAnswerController.text = referenceCorrectAnswer;
      userAnswerController.text = userAnswer;
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _loadError = "Não foi possível carregar a questão.";
      });
    }
  }

  String? get _questionId {
    final id = widget.openEndedId;
    if (id != null && id.isNotEmpty) return id;
    return tempId.isEmpty ? null : tempId;
  }

  Future<bool> save() async {
    if (title.trim().isEmpty || statement.trim().isEmpty) {
      return false;
    }
    final db = ref.read(appDatabaseProvider);
    final openEndedDao = OpenEndedDao(db);

    final currentId = _questionId;
    if (currentId == null) {
      final inserted = await openEndedDao.insertOpenEnded(
        nodeId: widget.nodeId,
        title: title.trim(),
        statement: statement.trim(),
        type: type.name.toUpperCase(),
        referenceCorrectAnswer: referenceCorrectAnswer.trim(),
      );
      tempId = inserted;
    } else {
      await openEndedDao.updateOpenEnded(
        id: currentId,
        nodeId: widget.nodeId,
        title: title.trim(),
        statement: statement.trim(),
        type: type.name.toUpperCase(),
        referenceCorrectAnswer: referenceCorrectAnswer.trim(),
      );
    }
    widget.onSave?.call();
    return true;
  }

  Future<void> sendAnswer() async {
    if (_isSending) return;
    final id = _questionId;
    if (id == null || id.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Esta questão ainda não foi salva.")),
      );
      return;
    }
    if (userAnswer.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Escreva uma resposta antes de enviar.")),
      );
      return;
    }

    setState(() => _isSending = true);
    final db = ref.read(appDatabaseProvider);
    final responseLogDao = OpenEndedResponseLogDao(db);
    final openEndedDao = OpenEndedDao(db);

    try {
      final question = await openEndedDao.getOpenEnded(id: id);
      if (question == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Esta questão não está mais disponível."),
            ),
          );
        }
        return;
      }

      final questionSnapshot = jsonEncode({
        'title': question.title,
        'statement': question.statement,
        'type': question.type,
        'referenceCorrectAnswer': question.referenceCorrectAnswer,
      });
      await responseLogDao.insertOpenEndedResponseLog(
        openEndedId: id,
        questionSnapshot: questionSnapshot,
        studySessionId: widget.studySessionId,
        studySessionLogId: widget.studySessionLogId,
        userAnswer: userAnswer.trim(),
      );
      if (!mounted) return;
      if (widget.onSendAnswer case final onSendAnswer?) {
        onSendAnswer();
      } else {
        setState(() => _hasSubmitted = true);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.onSendAnswer == null
                ? "Resposta registrada. Confira a resposta de referência."
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

  @override
  void dispose() {
    titleController.dispose();
    statementController.dispose();
    typeController.dispose();
    referenceCorrectAnswerController.dispose();
    userAnswerController.dispose();
    super.dispose();
  }

  void titleChanged(String value) {
    setState(() {
      title = value;
    });
  }

  void statementChanged(String value) {
    setState(() {
      statement = value;
    });
  }

  void typeChanged(String value) {
    setState(() {
      if (value.toLowerCase() == "feynman") {
        type = OpenEndedType.feynman;
      } else {
        type = OpenEndedType.essay;
      }
    });
  }

  void referenceCorrectAnswerChanged(String value) {
    setState(() {
      referenceCorrectAnswer = value;
    });
  }

  void userAnswerChanged(String value) {
    setState(() {
      userAnswer = value;
    });
  }

  Widget _questionPrompt({required String subtitle}) {
    final colors = Theme.of(context).colorScheme;
    return Card(
      color: colors.surfaceContainerLow,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                Chip(
                  avatar: const Icon(Icons.edit_note_rounded, size: 18),
                  label: Text(_typeLabel),
                  visualDensity: VisualDensity.compact,
                ),
                Text(subtitle, style: context.textTheme.labelLarge),
              ],
            ),
            const SizedBox(height: 8),
            Text(title, style: context.textTheme.headlineSmall),
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 8),
            SelectableText(statement, style: context.textTheme.bodyLarge),
          ],
        ),
      ),
    );
  }

  Widget _referenceAnswerCard() {
    if (referenceCorrectAnswer.trim().isEmpty) {
      return Card(
        child: ListTile(
          leading: const Icon(Icons.info_outline),
          title: const Text('Sem resposta de referência'),
          subtitle: const Text(
            'Esta questão ainda não tem uma resposta de referência cadastrada.',
          ),
        ),
      );
    }

    return Card(
      color: Theme.of(context).colorScheme.secondaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Resposta de referência',
              style: context.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            SelectableText(
              referenceCorrectAnswer,
              style: context.textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(4),
          child: (mode == 1)
              ? Column(
                  // Edição/Criação
                  spacing: context.spacing.md,
                  children: [
                    TextField(
                      onChanged: titleChanged,
                      controller: titleController,
                      decoration: InputDecoration(
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
                    TextField(
                      onChanged: typeChanged,
                      controller: typeController,
                      readOnly: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Tipo de questão",
                      ),
                      onTap: () async {
                        final value = await showModalBottomSheet<OpenEndedType>(
                          context: context,
                          builder: (context) => SafeArea(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                  title: const Text("Dissertativa"),
                                  onTap: () => Navigator.pop(
                                    context,
                                    OpenEndedType.essay,
                                  ),
                                ),
                                ListTile(
                                  title: const Text("Método Feynman"),
                                  onTap: () => Navigator.pop(
                                    context,
                                    OpenEndedType.feynman,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                        if (value != null) {
                          typeChanged(value.name);
                          typeController.text = value == OpenEndedType.feynman
                              ? "Método Feynman"
                              : "Dissertativa";
                        }
                      },
                    ),
                    TextField(
                      onChanged: referenceCorrectAnswerChanged,
                      controller: referenceCorrectAnswerController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Resposta de referência",
                      ),
                    ),
                    FilledButton(
                      onPressed: _isSaving
                          ? null
                          : () async {
                              if (title.trim().isEmpty ||
                                  statement.trim().isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Preencha o título e o enunciado.",
                                    ),
                                  ),
                                );
                                return;
                              }
                              setState(() => _isSaving = true);
                              final messenger = ScaffoldMessenger.of(context);
                              try {
                                final saved = await save();
                                if (mounted) {
                                  messenger.showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        saved
                                            ? "Questão salva."
                                            : "Não foi possível salvar a questão.",
                                      ),
                                    ),
                                  );
                                }
                              } catch (_) {
                                if (mounted) {
                                  messenger.showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "Não foi possível salvar a questão.",
                                      ),
                                    ),
                                  );
                                }
                              } finally {
                                if (mounted) setState(() => _isSaving = false);
                              }
                            },
                      child: Text(_isSaving ? "Salvando..." : "Salvar questão"),
                    ),
                  ],
                )
              : (mode == 2)
              ? Column(
                  spacing: context.spacing.md,
                  children: [
                    _questionPrompt(
                      subtitle: _hasSubmitted
                          ? 'Resposta registrada'
                          : 'Reflita e escreva com suas próprias palavras.',
                    ),
                    if (_hasSubmitted) ...[
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(18),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Sua resposta',
                                style: context.textTheme.titleMedium,
                              ),
                              const SizedBox(height: 8),
                              SelectableText(
                                userAnswer,
                                style: context.textTheme.bodyLarge,
                              ),
                            ],
                          ),
                        ),
                      ),
                      _referenceAnswerCard(),
                    ] else ...[
                      TextField(
                        maxLines: 10,
                        minLines: 5,
                        onChanged: userAnswerChanged,
                        controller: userAnswerController,
                        textCapitalization: TextCapitalization.sentences,
                        textInputAction: TextInputAction.newline,
                        decoration: const InputDecoration(
                          alignLabelWithHint: true,
                          border: OutlineInputBorder(),
                          labelText: "Sua resposta",
                          hintText:
                              "Explique seu raciocínio. Você pode usar várias linhas.",
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '${userAnswer.trim().split(RegExp(r'\s+')).where((word) => word.isNotEmpty).length} palavras',
                          style: context.textTheme.labelMedium,
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: _isSending ? null : sendAnswer,
                          icon: _isSending
                              ? const SizedBox.square(
                                  dimension: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(Icons.send_rounded),
                          label: Text(
                            _isSending ? "Registrando..." : "Enviar resposta",
                          ),
                        ),
                      ),
                    ],
                  ],
                )
              : (mode == 3)
              ? Column(
                  spacing: context.spacing.md,
                  children: [
                    _questionPrompt(subtitle: 'Visualização da questão'),
                    if (_latestResponse != null) ...[
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(18),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Sua tentativa mais recente',
                                style: context.textTheme.titleMedium,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                DateTime.fromMillisecondsSinceEpoch(
                                  _latestResponse!.answeredAt * 1000,
                                ).toLocal().toString().substring(0, 16),
                                style: context.textTheme.labelMedium,
                              ),
                              const SizedBox(height: 8),
                              SelectableText(
                                _latestResponse!.userAnswer ??
                                    'Resposta não registrada.',
                                style: context.textTheme.bodyLarge,
                              ),
                              if (_latestResponse!.aiFeedback
                                      ?.trim()
                                      .isNotEmpty ==
                                  true) ...[
                                const Divider(height: 24),
                                Text(
                                  'Feedback',
                                  style: context.textTheme.titleSmall,
                                ),
                                const SizedBox(height: 6),
                                Text(_latestResponse!.aiFeedback!),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ],
                    _referenceAnswerCard(),
                    if (_latestResponse == null)
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: () {
                            setState(() {
                              mode = 2;
                              userAnswer = '';
                              userAnswerController.clear();
                            });
                          },
                          icon: const Icon(Icons.play_arrow_rounded),
                          label: const Text('Responder questão'),
                        ),
                      )
                    else
                      TextButton.icon(
                        onPressed: () {
                          setState(() {
                            mode = 2;
                            userAnswer = '';
                            userAnswerController.clear();
                            _hasSubmitted = false;
                          });
                        },
                        icon: const Icon(Icons.replay_rounded),
                        label: const Text('Tentar novamente'),
                      ),
                  ],
                )
              : null,
        ),
      ),
    );
  }
}
