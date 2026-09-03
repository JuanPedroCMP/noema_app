import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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
  List<OpenEndedData> _openEndeds = [];
  List<MultipleChoiceData> _multipleChoices = [];

  int opc = 0;
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

  void changeQuestionId(String value) {
    setState(() {
      questionId = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final String currentUri = GoRouterState.of(context).uri.toString();

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
                      context.push(
                        "$currentUri/get_open_ended/${widget.nodeId}/${openEnded.id}",
                      );
                    },
                    child: Text("Visualizar"),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      context.push(
                        "$currentUri/updade_open_ended/${widget.nodeId}/${openEnded.id}",
                      );
                    },
                    child: Text("Editar"),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      context.push(
                        "$currentUri/do_open_ended/${widget.nodeId}/${openEnded.id}",
                      );
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
                      context.push(
                        "$currentUri/get_multiple_choise/${widget.nodeId}/${multipleChoise.id}",
                      );
                    },
                    child: Text("Visualizar"),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      context.push(
                        "$currentUri/updade_multiple_choise/${widget.nodeId}/${multipleChoise.id}",
                      );
                    },
                    child: Text("Editar"),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      context.push(
                        "$currentUri/do_multiple_choise/${widget.nodeId}/${multipleChoise.id}",
                      );
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
                              context.push(
                                "$currentUri/create_open_ended/${widget.nodeId}",
                              );
                            },
                            child: Row(children: [Text("Criar questão Vazia")]),
                          ),
                          VerticalDivider(),
                          OutlinedButton(
                            onPressed: () {},
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
                  context.push(
                    "$currentUri/create_open_ended/${widget.nodeId}",
                  );
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
                  context.push(
                    "$currentUri/create_multiple_choise/${widget.nodeId}",
                  );
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
              SingleChildScrollView(
                child: Wrap(
                  spacing: context.spacing.sm,
                  runSpacing: context.spacing.sm,
                  children: [...openEndedMap, ...multipleChoiseMap],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
