import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noema/core/database/database.dart' hide OpenEnded;
import 'package:noema/core/database/database_provider.dart';
import 'package:noema/core/design/theme/theme_tokens.dart';
import 'package:noema/feature/exercises/multiple_choice/data/multiple_choice_dao.dart';
import 'package:noema/feature/exercises/multiple_choice/presentation/multiple_choice.dart';
import 'package:noema/feature/exercises/multiple_choice/provider/open_ended_mode_provider.dart';
import 'package:noema/feature/exercises/open_ended/data/open_ended_dao.dart';
import 'package:noema/feature/exercises/open_ended/presentation/open_ended.dart';
import 'package:noema/feature/exercises/open_ended/provider/open_ended_mode_provider.dart';
import 'package:noema/feature/graph/pages/create_graph_with_ai.dart';
import 'package:noema/shared/floating_card/floating_card.dart';

class ExercicesList extends ConsumerStatefulWidget {
  const ExercicesList({super.key, required this.nodeId});

  final String nodeId;

  @override
  ConsumerState<ExercicesList> createState() => _ExercicesList();
}

class _ExercicesList extends ConsumerState<ExercicesList> {
  // TODO Consertar
  List<OpenEndedData> _openEndeds = [];
  List<MultipleChoiceData> _multipleChoices = [];

  int opc = 0;
  int opc2 = 0;
  String questionId = "";

  @override
  void initState() {
    super.initState();
    carregar();
  }

  Future<void> carregar() async {
    final db = ref.read(appDatabaseProvider);

    final openEndedDao = OpenEndedDao(db);
    final multipleChoiceDao = MultipleChoiceDao(db);

    final openEndeds = await openEndedDao.getOpenEndedsByNode(
      nodeId: widget.nodeId,
    );
    final multipleChoices = await multipleChoiceDao.getMultipleChoicesByNode(
      nodeId: widget.nodeId,
    );

    if (!mounted) return;

    setState(() {
      _openEndeds = openEndeds;
      _multipleChoices = multipleChoices;
    });
  }

  void changeOpc(int value) {
    setState(() {
      opc = value;
    });
  }

  void changeOpc2(int value) {
    setState(() {
      opc = value;
    });
  }

  void changeQuestionId(String value) {
    setState(() {
      questionId = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final modeNotifier = ref.watch(modeOpenEndedProvider.notifier);
    final modeMultipleChoiseNotifier = ref.watch(
      modeMultipleChoiseProvider.notifier,
    );

    final openEndedMap = _openEndeds.map((openEnded) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "ID: ${openEnded.id}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text("Título: ${openEnded.title}"),
              const SizedBox(height: 8),
              Text("Descrição: ${openEnded.statement}"),
              Row(
                spacing: context.spacing.md,
                mainAxisSize: MainAxisSize.min,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      changeQuestionId(openEnded.id);
                      changeOpc2(2);
                      modeNotifier.modeChanged(3);
                    },
                    child: Text("Visualizar"),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      changeQuestionId(openEnded.id);
                      changeOpc2(1);
                      modeNotifier.modeChanged(1);
                    },
                    child: Text("Editar"),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      changeQuestionId(openEnded.id);
                      changeOpc2(0);
                      modeNotifier.modeChanged(2);
                    },
                    child: Text("Realizar"),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }).toList();

    final multipleChoiseMap = _multipleChoices.map((multipleChoise) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "ID: ${multipleChoise.id}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text("Título: ${multipleChoise.title}"),
              const SizedBox(height: 8),
              Text("Descrição: ${multipleChoise.statement}"),
              Row(
                spacing: context.spacing.md,
                mainAxisSize: MainAxisSize.min,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      changeQuestionId(multipleChoise.id);
                      changeOpc2(4);
                      modeMultipleChoiseNotifier.modeChanged(3);
                    },
                    child: Text("Visualizar"),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      changeQuestionId(multipleChoise.id);
                      changeOpc2(5);
                      modeMultipleChoiseNotifier.modeChanged(1);
                    },
                    child: Text("Editar"),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      changeQuestionId(multipleChoise.id);
                      changeOpc2(4);
                      modeMultipleChoiseNotifier.modeChanged(2);
                    },
                    child: Text("Realizar"),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }).toList();

    if (_openEndeds.isEmpty) {
      return Center(
        child: Column(
          children: [
            Text("Nenhuma questão encontrada, Crie sua primeira questão!"),
            Align(
              alignment: Alignment.center,
              child: FloatingCard(
                width: 500,
                height: 250,
                child: SingleChildScrollView(
                  child: Column(
                    spacing: context.spacing.md,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        spacing: context.spacing.md,
                        children: [
                          OutlinedButton(
                            onPressed: () {
                              if (opc != 2) {
                                changeOpc(2);
                              } else {
                                changeOpc(0);
                              }
                            },
                            child: Row(children: [Text("Criar questão Vazia")]),
                          ),
                          VerticalDivider(),
                          OutlinedButton(
                            onPressed: () {
                              if (opc != 3) {
                                changeOpc(3);
                              } else {
                                changeOpc(0);
                              }
                            },
                            child: Row(
                              children: [Text("Gerar Questão Com IA")],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (opc == 1)
              Align(
                alignment: Alignment.center,
                child: FloatingCard(
                  width: 600,
                  child: SingleChildScrollView(
                    child: OpenEnded(nodeId: widget.nodeId),
                  ),
                ),
              ),
            if (opc == 3)
              Align(
                alignment: Alignment.center,
                child: FloatingCard(
                  width: 600,
                  child: SingleChildScrollView(child: CreateGraphWithAi()),
                ),
              ),
          ],
        ),
      );
    }

    return Align(
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            spacing: context.spacing.md,
            mainAxisSize: MainAxisSize.min,
            children: [
              OutlinedButton(
                onPressed: () {
                  if (opc != 1) {
                    changeOpc(1);
                  } else {
                    changeOpc(0);
                  }
                },
                child: Row(
                  spacing: context.spacing.md,
                  children: [
                    Text("Criar Nova questão"),
                    Icon(Icons.add_rounded),
                  ],
                ),
              ),
              OutlinedButton(
                onPressed: () {
                  if (opc != 3) {
                    changeOpc(3);
                  } else {
                    changeOpc(0);
                  }
                },
                child: Row(
                  spacing: context.spacing.md,
                  children: [
                    Text("Criar Nova questão alternativa"),
                    Icon(Icons.add_rounded),
                  ],
                ),
              ),
              OutlinedButton(
                onPressed: () {
                  carregar();
                },
                child: Icon(Icons.replay_outlined),
              ),
            ],
          ),
          SizedBox(height: context.spacing.sm),
          Stack(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Wrap(
                    spacing: context.spacing.sm,
                    runSpacing: context.spacing.sm,
                    children: [...openEndedMap, ...multipleChoiseMap],
                  ),
                ),
              ),
              if (opc2 == 1)
                Align(
                  alignment: Alignment.center,
                  child: FloatingCard(
                    width: 500,
                    height: 250,
                    child: SingleChildScrollView(
                      child: OpenEnded(
                        nodeId: widget.nodeId,
                        openEndedId: questionId,
                      ),
                    ),
                  ),
                ),
              if (opc2 == 2)
                Align(
                  alignment: Alignment.center,
                  child: FloatingCard(
                    width: 600,
                    child: SingleChildScrollView(
                      child: OpenEnded(
                        nodeId: widget.nodeId,
                        openEndedId: questionId,
                      ),
                    ),
                  ),
                ),
              if (opc2 == 0)
                Align(
                  alignment: Alignment.center,
                  child: FloatingCard(
                    width: 600,
                    child: SingleChildScrollView(
                      child: OpenEnded(
                        nodeId: widget.nodeId,
                        openEndedId: questionId,
                      ),
                    ),
                  ),
                ),
              if (opc2 == 4) // fazer
                Align(
                  alignment: Alignment.center,
                  child: FloatingCard(
                    width: 600,
                    child: SingleChildScrollView(
                      child: MultipleChoise(
                        nodeId: widget.nodeId,
                        multipleChoiseId: questionId,
                      ),
                    ),
                  ),
                ),
              if (opc2 == 5) // Criar
                Align(
                  alignment: Alignment.center,
                  child: FloatingCard(
                    width: 600,
                    child: SingleChildScrollView(
                      child: MultipleChoise(
                        nodeId: widget.nodeId,
                        multipleChoiseId: questionId,
                      ),
                    ),
                  ),
                ),
              if (opc == 2)
                Align(
                  alignment: Alignment.center,
                  child: FloatingCard(
                    width: 600,
                    child: SingleChildScrollView(
                      child: OpenEnded(nodeId: widget.nodeId),
                    ),
                  ),
                ),
              if (opc == 3) // Criar
                Align(
                  alignment: Alignment.center,
                  child: FloatingCard(
                    width: 600,
                    child: SingleChildScrollView(
                      child: MultipleChoise(nodeId: widget.nodeId),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
