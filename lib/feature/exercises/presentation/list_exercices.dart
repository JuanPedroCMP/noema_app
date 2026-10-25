import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:noema/core/database/database.dart' hide OpenEnded;
import 'package:noema/core/database/database_provider.dart';
import 'package:noema/core/design/theme/theme_tokens.dart';
import 'package:noema/feature/exercises/multiple_choice/data/multiple_choice_dao.dart';
import 'package:noema/feature/exercises/open_ended/data/open_ended_dao.dart';
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
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    carregar();
  }

  Future<void> carregar() async {
    if (mounted) setState(() => _isLoading = true);
    final db = ref.read(appDatabaseProvider);

    final openEndedDao = OpenEndedDao(db);
    final multipleChoiceDao = MultipleChoiceDao(db);

    try {
      final results = await Future.wait([
        openEndedDao.getOpenEndedsByNode(nodeId: widget.nodeId),
        multipleChoiceDao.getMultipleChoicesByNode(nodeId: widget.nodeId),
      ]);

      final openEndeds = results[0] as List<OpenEndedData>;
      final multipleChoices = results[1] as List<MultipleChoiceData>;

      if (!mounted) return;

      setState(() {
        _openEndeds = openEndeds;
        _multipleChoices = multipleChoices;
        _isLoading = false;
        _error = null;
      });
    } catch (_) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _error = "Não foi possível carregar as questões.";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(
        child: FilledButton.icon(
          onPressed: carregar,
          icon: const Icon(Icons.refresh),
          label: Text(_error!),
        ),
      );
    }
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
              Wrap(
                spacing: context.spacing.md,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      context.push(
                        "$currentUri/open-ended/${openEnded.id}/view",
                      );
                    },
                    child: Text("Visualizar"),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      context.push(
                        "$currentUri/open-ended/${openEnded.id}/edit",
                      );
                    },
                    child: Text("Editar"),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      context.push(
                        "$currentUri/open-ended/${openEnded.id}/answer",
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
              Wrap(
                spacing: context.spacing.md,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      context.push(
                        "$currentUri/multiple-choice/${multipleChoise.id}/view",
                      );
                    },
                    child: Text("Visualizar"),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      context.push(
                        "$currentUri/multiple-choice/${multipleChoise.id}/edit",
                      );
                    },
                    child: Text("Editar"),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      context.push(
                        "$currentUri/multiple-choice/${multipleChoise.id}/answer",
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

    if (_openEndeds.isEmpty && _multipleChoices.isEmpty) {
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
                      Wrap(
                        spacing: context.spacing.md,
                        children: [
                          OutlinedButton(
                            onPressed: () {
                              context.push(
                                "$currentUri/open-ended/create",
                              );
                            },
                            child: Row(children: [Text("Criar questão Vazia")]),
                          ),
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
          Wrap(
            spacing: context.spacing.md,
            children: [
              OutlinedButton(
                onPressed: () {
                  context.push(
                    "$currentUri/open-ended/create",
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
                    "$currentUri/multiple-choice/create",
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
          Expanded(
            child: SingleChildScrollView(
              child: Wrap(
                spacing: context.spacing.sm,
                runSpacing: context.spacing.sm,
                children: [...openEndedMap, ...multipleChoiseMap],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
