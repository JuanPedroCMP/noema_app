import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noema/core/database/database_provider.dart';
import 'package:noema/core/design/theme/theme_tokens.dart';
import 'package:noema/feature/exercises/open_ended/data/open_ended_dao.dart';
import 'package:noema/feature/exercises/open_ended/provider/open_ended_mode_provider.dart';

enum OpenEndedType { ESSAY, FEYNMAN }

class MultipleChoise extends ConsumerStatefulWidget {
  // Refazer da forma correta
  const MultipleChoise({
    super.key,
    required this.nodeId,
    this.openEndedId,
    this.onSendAnswer,
  });

  final String nodeId;
  final String? openEndedId;

  final Function? onSendAnswer;

  @override
  ConsumerState<MultipleChoise> createState() => _MultipleChoise();
}

class _MultipleChoise extends ConsumerState<MultipleChoise> {
  String title = "";
  String statement = "";
  OpenEndedType type = OpenEndedType.ESSAY;
  String referenceCorrectAnswer = "";
  String userAnswer = "";

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (widget.openEndedId == null) {
        return;
      }

      final db = ref.watch(appDatabaseProvider);
      final openEndedDao = OpenEndedDao(db);

      final data = await openEndedDao.getOpenEnded(id: widget.openEndedId!);

      if (!mounted) return;

      setState(() {
        title = data?.title ?? "";
        statement = data?.statement ?? "";
        if (data?.type.toLowerCase() == "feynman") {
          type = OpenEndedType.FEYNMAN;
        } else {
          type = OpenEndedType.ESSAY;
        }
        referenceCorrectAnswer = data?.referenceCorrectAnswer ?? "";
      });
    });
  }

  void loadData() async {
    if (widget.openEndedId == null) {
        return;
      }

      final db = ref.watch(appDatabaseProvider);
      final openEndedDao = OpenEndedDao(db);

      final data = await openEndedDao.getOpenEnded(id: widget.openEndedId!);

      if (!mounted) return;

      setState(() {
        title = data?.title ?? "";
        statement = data?.statement ?? "";
        if (data?.type.toLowerCase() == "feynman") {
          type = OpenEndedType.FEYNMAN;
        } else {
          type = OpenEndedType.ESSAY;
        }
        referenceCorrectAnswer = data?.referenceCorrectAnswer ?? "";
      });
  }

  void save() async {
    final db = ref.watch(appDatabaseProvider);
    final openEndedDao = OpenEndedDao(db);

    if (widget.openEndedId == null) {
      await openEndedDao.insertOpenEnded(
        nodeId: widget.nodeId,
        title: title,
        statement: statement,
        type: type.name,
        referenceCorrectAnswer: referenceCorrectAnswer,
      );
    } else {
      await openEndedDao.updateOpenEnded(
        id: widget.openEndedId!,
        nodeId: widget.nodeId,
        title: title,
        statement: statement,
        type: type.name,
        referenceCorrectAnswer: referenceCorrectAnswer,
      );
    }

    final questions = await openEndedDao.getOpenEndedsByNode(
      nodeId: widget.nodeId,
    );

    for (final item in questions) {
      print(item);
    }

    print(questions.toString());
  }

  void sendAnswer() {}

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
        type = OpenEndedType.FEYNMAN;
      } else {
        type = OpenEndedType.ESSAY;
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

  late TextEditingController titleController;
  late TextEditingController statementController;
  late TextEditingController typeController;
  late TextEditingController referenceCorrectAnswerController;
  late TextEditingController userAnswerController;

  @override
  Widget build(BuildContext context) {
    titleController = TextEditingController(text: title);
    statementController = TextEditingController(text: statement);
    typeController = TextEditingController(text: type.name);
    referenceCorrectAnswerController = TextEditingController(
      text: referenceCorrectAnswer,
    );
    userAnswerController = TextEditingController(text: userAnswer);

    final mode = ref.watch(modeOpenEndedProvider);
    final modeNotifier = ref.watch(modeOpenEndedProvider.notifier);

    loadData();

    return SizedBox(
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
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Tipo",
                  ),
                ),
                TextField(
                  onChanged: referenceCorrectAnswerChanged,
                  controller: referenceCorrectAnswerController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "referenceCorrectAnswer",
                  ),
                ),
                OutlinedButton(
                  onPressed: () {
                    save();
                  },
                  child: Text("Salvar"),
                ),
              ],
            )
          : (mode == 2)
          ? Column(
              // Resposta
              spacing: context.spacing.md,
              children: [
                Text(title, style: context.textTheme.headlineMedium),
                Text(type.name, style: context.textTheme.labelMedium),

                Divider(),
                Text(statement, style: context.textTheme.bodyMedium),

                TextField(
                  onChanged: userAnswerChanged,
                  controller: userAnswerController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Sua resposta...",
                  ),
                ),
                OutlinedButton(
                  onPressed: () {
                    sendAnswer();
                  },
                  child: Text("Enviar"),
                ),
              ],
            )
          : (mode == 3) ? Column(
              // Visualização
               spacing: context.spacing.md,
              children: [
                Text(title, style: context.textTheme.headlineMedium),
                Text(type.name, style: context.textTheme.labelMedium),

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
                OutlinedButton(
                  onPressed: () {
                  },
                  child: Text("Voltar"),
                ),
              ],
            ) : null
    );
  }
}
