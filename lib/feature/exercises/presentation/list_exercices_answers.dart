import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:noema/core/database/database.dart' hide OpenEnded;
import 'package:noema/core/database/database_provider.dart';
import 'package:noema/core/design/theme/theme_tokens.dart';
import 'package:noema/shared/floating_card/floating_card.dart';

class ExercicesAnswerList extends ConsumerStatefulWidget {
  const ExercicesAnswerList({super.key, required this.nodeId});

  final String nodeId;

  @override
  ConsumerState<ExercicesAnswerList> createState() => _ExercicesAnswerList();
}

class _ExercicesAnswerList extends ConsumerState<ExercicesAnswerList> {
  List<OpenEndedResponseLogData> _openEndedLogs = [];
  List<MultipleChoiceResponseLogData> _multipleChoiceLogs = [];

  int opc = 0;
  String questionId = "";

  @override 
  void initState() {
    super.initState();
    carregar();
  }

  Future<void> carregar() async {
    final db = ref.read(appDatabaseProvider);

    final openEndedLogs = await db.select(db.openEndedResponseLog).get();
    final multipleChoiceLogs = await db.select(db.multipleChoiceResponseLog).get();

    if (!mounted) return;

    setState(() async {
      _openEndedLogs = openEndedLogs;
      _multipleChoiceLogs = multipleChoiceLogs;
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

    final openEndedMap = _openEndedLogs.map((openEndedLog) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "ID: ${openEndedLog.id}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text("Título: ${openEndedLog.isCorrect}"),
              const SizedBox(height: 8),
              Text("Descrição: ${openEndedLog.score}"),
              Row(
                spacing: context.spacing.md,
                mainAxisSize: MainAxisSize.min,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      context.push(
                        "$currentUri/get_open_ended/${widget.nodeId}/${openEndedLog.id}",
                      );
                    },
                    child: Text("Visualizar"),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      context.push(
                        "$currentUri/updade_open_ended/${widget.nodeId}/${openEndedLog.id}",
                      );
                    },
                    child: Text("Editar"),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      context.push(
                        "$currentUri/do_open_ended/${widget.nodeId}/${openEndedLog.id}",
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

    final multipleChoiseMap = _multipleChoiceLogs.map((multipleChoiseLog) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "ID: ${multipleChoiseLog.id}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text("Título: ${multipleChoiseLog.score}"),
              const SizedBox(height: 8),
              Text("Descrição: ${multipleChoiseLog.id}"),
              Row(
                spacing: context.spacing.md,
                mainAxisSize: MainAxisSize.min,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      context.push(
                        "$currentUri/get_multiple_choise/${widget.nodeId}/${multipleChoiseLog.id}",
                      );
                    },
                    child: Text("Visualizar"),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      context.push(
                        "$currentUri/updade_multiple_choise/${widget.nodeId}/${multipleChoiseLog.id}",
                      );
                    },
                    child: Text("Editar"),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      context.push(
                        "$currentUri/do_multiple_choise/${widget.nodeId}/${multipleChoiseLog.id}",
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

    if (_openEndedLogs.isEmpty) {
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
