import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noema/core/database/database_provider.dart';
import 'package:noema/core/design/theme/theme_tokens.dart';
import 'package:noema/feature/exercises/multiple_choice/data/choice_dao.dart';
import 'package:noema/feature/exercises/multiple_choice/data/multiple_choice_dao.dart';
import 'package:noema/feature/exercises/multiple_choice/provider/open_ended_mode_provider.dart';
import 'package:noema/feature/exercises/multiple_choice/widgets/choise.dart';
import 'package:noema/feature/exercises/multiple_choice/widgets/manipulate_choise.dart';
import 'package:noema/core/database/database.dart' show ChoiceData;
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
  final Function? onSendAnswer;

  @override
  ConsumerState<MultipleChoise> createState() => _MultipleChoise();
}

class _MultipleChoise extends ConsumerState<MultipleChoise> {
  String title = "";
  String statement = "";
  List<ChoiceData> choises = [];
  bool isEditing = false;
  String editTarget = "";
  int mode = 0;

  String tempId = "";

  late final TextEditingController titleController;
  late final TextEditingController statementController;

  @override
  void initState() {
    super.initState();
    setState(() {
      mode = widget.defaultMode;
    });

    titleController = TextEditingController();
    statementController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  void _loadData() async {
    if (widget.multipleChoiseId == null || widget.multipleChoiseId!.isEmpty) {
      titleController.text = "";
      statementController.text = "";
      return;
    }

    final db = ref.watch(appDatabaseProvider);
    final multipleChoiceDao = MultipleChoiceDao(db);
    final choiceDao = ChoiceDao(db);

    final data = await multipleChoiceDao.getMultipleChoice(
      id: widget.multipleChoiseId!,
    );

    final listChoises = await choiceDao.getChoicesByQuestion(
      multipleChoiceId: widget.multipleChoiseId!,
    );
    print("1");

    if (!mounted) return;
    print("2");

    if (data == null) return;

    setState(() {
      title = data.title;
      statement = data.statement;
      choises = listChoises;
    });

    titleController.text = title;
    statementController.text = statement;
  }

  Future<String?> save() async {
    final db = ref.watch(appDatabaseProvider);
    final multipleChoiceDao = MultipleChoiceDao(db);

    if (widget.multipleChoiseId == null || widget.multipleChoiseId!.isEmpty) {
      final newId = await multipleChoiceDao.insertMultipleChoice(
        nodeId: widget.nodeId,
        title: title,
        statement: statement,
      );
      setState(() {
        tempId = newId.toString();
      });
      return tempId;
    } else {
      await multipleChoiceDao.updateMultipleChoice(
        id: widget.multipleChoiseId!,
        title: title,
        statement: statement,
      );

      return widget.multipleChoiseId;
    }
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

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
                    for (final choise in choises) ...[
                      Row(
                        children: [
                          Card(
                            child: Choise(
                              choiseId: choise.id,
                              onChanged: (ChoiceData value) {},
                              mode: 1,
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
                        ],
                      ),
                    ],
                    OutlinedButton(
                      onPressed: () {
                        save();
                        _loadData();
                        setState(() {
                          isEditing = true;
                          editTarget = "";
                        });
                      },
                      child: Text("Adicionar nova opc"),
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
                    Divider(),
                    Text(statement, style: context.textTheme.bodyMedium),
                    for (final choise in choises) ...[
                      Card(
                        child: Choise(
                          choiseId: choise.id,
                          onChanged: (ChoiceData value) {},
                          mode: 0,
                        ),
                      ),
                    ],
                    OutlinedButton(
                      onPressed: () {
                        sendAnswer();
                      },
                      child: Text("Enviar"),
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
                    OutlinedButton(onPressed: () {}, child: Text("Voltar")),
                  ],
                )
              : SizedBox(),
          if (isEditing) ...[
            Align(
              alignment: Alignment.center,
              child: FloatingCard(
                width: 1000,
                height: 1000,
                child: ManipulateChoise(
                  multipleChoiceId: widget.multipleChoiseId ?? tempId,
                  choiseId: editTarget,
                  onSave: (value) {
                    setState(() {
                      isEditing = false;
                    });
                    _loadData();
                  },
                  onChanged: (ChoiceData value) {},
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
