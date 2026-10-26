import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noema/core/database/database_provider.dart';
import 'package:noema/core/design/theme/theme_tokens.dart';
import 'package:noema/feature/exercises/open_ended/data/open_ended_dao.dart';
import 'package:noema/feature/exercises/open_ended/data/open_ended_response_log_dao.dart';

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
    this.onSendAnswer,
    this.onSave,
    required this.defaultMode,
  });

  final String nodeId;
  final int defaultMode;
  final String? openEndedId;
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
  String? _loadError;

  late final TextEditingController titleController;
  late final TextEditingController statementController;
  late final TextEditingController typeController;
  late final TextEditingController referenceCorrectAnswerController;
  late final TextEditingController userAnswerController;

  String get _typeLabel => type == OpenEndedType.feynman
      ? "Método Feynman"
      : "Dissertativa";

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
    if (widget.openEndedId == null || widget.openEndedId!.isEmpty) {
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
      final data = await OpenEndedDao(
        db,
      ).getOpenEnded(id: widget.openEndedId!);
      if (!mounted) return;
      if (data == null) {
        setState(() {
          _isLoading = false;
          _loadError = "Questão não encontrada ou removida.";
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
      });
      titleController.text = title;
      statementController.text = statement;
      typeController.text = _typeLabel;
      referenceCorrectAnswerController.text = referenceCorrectAnswer;
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
            const SnackBar(content: Text("Esta questão não está mais disponível.")),
          );
        }
        return;
      }

      final questionSnapshot = jsonEncode(question.toJson());
      await responseLogDao.insertOpenEndedResponseLog(
        openEndedId: id,
        questionSnapshot: questionSnapshot,
        userAnswer: userAnswer.trim(),
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
                                onTap: () =>
                                    Navigator.pop(context, OpenEndedType.essay),
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
                // Resposta
                spacing: context.spacing.md,
                children: [
                  Text(title, style: context.textTheme.headlineMedium),
                  Text(_typeLabel, style: context.textTheme.labelMedium),

                  Divider(),
                  Text(statement, style: context.textTheme.bodyMedium),

                  TextField(
                    maxLines: 8,
                    onChanged: userAnswerChanged,
                    controller: userAnswerController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Sua resposta...",
                    ),
                  ),
                  FilledButton(
                    onPressed: _isSending ? null : sendAnswer,
                    child: Text(_isSending ? "Enviando..." : "Enviar resposta"),
                  ),
                ],
              )
            : (mode == 3)
            ? Column(
                // Visualização
                spacing: context.spacing.md,
                children: [
                  Text(title, style: context.textTheme.headlineMedium),
                  Text(_typeLabel, style: context.textTheme.labelMedium),

                  Divider(),
                  Text(statement, style: context.textTheme.bodyMedium),

                  TextField(
                    onChanged: userAnswerChanged,
                    controller: userAnswerController,
                    readOnly: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Sua resposta...",
                    ),
                  ),
                  const SizedBox.shrink(),
                ],
              )
            : null,
      ),
    );
  }
}
