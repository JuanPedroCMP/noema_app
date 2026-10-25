import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noema/core/database/database_provider.dart';
import 'package:noema/core/design/theme/theme_tokens.dart';
import 'package:noema/feature/graph/data/graph_edge_dao.dart';
import 'package:noema/feature/graph/provider/edge_form_provider.dart';
import 'package:noema/feature/graph/provider/graph_provider.dart';
import 'package:noema/feature/graph/provider/graph_states_provider.dart';

class CreateEdge extends ConsumerWidget {
  const CreateEdge({super.key, required this.graphId});

  final String graphId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formEdge = ref.watch(edgeFormProvider);
    final formEdgeNotifier = ref.read(edgeFormProvider.notifier);
    final db = ref.read(appDatabaseProvider);
    final edgeDao = GraphEdgeDao(db);
    final nodesList = ref.watch(nodesProvider(graphId));
    final graphStatesNotifier = ref.read(graphStatesProvider.notifier);

    return SingleChildScrollView(
      child: Column(
        spacing: context.spacing.md,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Nova aresta",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          nodesList.when(
            data: (data) => DropdownMenu<String>(
              expandedInsets: EdgeInsets.zero,
              onSelected: (value) {
                if (value != null) {
                  formEdgeNotifier.sourceNodeIdChanged(value);
                }
              },
              label: const Text("Nó de origem"),
              dropdownMenuEntries: data
                  .map(
                    (node) => DropdownMenuEntry<String>(
                      label: node.title,
                      value: node.id,
                    ),
                  )
                  .toList(),
            ),
            error: (Object error, StackTrace stackTrace) => Text("Erro"),
            loading: () => Text("Carregando"),
          ),
          Row(
            children: [
              SizedBox(width: context.spacing.lg),
              Icon(Icons.arrow_downward_rounded),
            ],
          ),
          nodesList.when(
            data: (data) => DropdownMenu<String>(
              expandedInsets: EdgeInsets.zero,
              onSelected: (value) {
                if (value != null) {
                  formEdgeNotifier.targetNodeIdChanged(value);
                }
              },
              label: const Text("Nó de destino"),
              dropdownMenuEntries: data
                  .map(
                    (node) => DropdownMenuEntry<String>(
                      label: node.title,
                      value: node.id,
                    ),
                  )
                  .toList(),
            ),
            error: (Object error, StackTrace stackTrace) => Text("Erro"),
            loading: () => Text("Carregando"),
          ),

          DropdownMenu<String>(
            onSelected: (value) {
              if (value != null) {
                formEdgeNotifier.typeChanged(value);
              }
            },
            expandedInsets: EdgeInsets.zero,
            label: const Text("Tipo de relação"),
            dropdownMenuEntries: [
              DropdownMenuEntry(value: 'PREREQUISITE', label: 'PREREQUISITE'),
              DropdownMenuEntry(value: 'SUBTOPIC', label: 'SUBTOPIC'),
            ],
          ),

          TextField(
            keyboardType: TextInputType.number,
            onChanged: (value) {
              final weight = double.tryParse(value);
              if (weight != null && weight.isFinite) {
                formEdgeNotifier.weightChanged(weight);
              }
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Peso",
            ),
          ),
          Row(
            spacing: context.spacing.md,
            children: [
              OutlinedButton(
                onPressed: () async {
                  if (formEdge.sourceNodeId.isEmpty ||
                      formEdge.targetNodeId.isEmpty ||
                      formEdge.type.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Selecione origem, destino e tipo da aresta.",
                        ),
                      ),
                    );
                    return;
                  }

                  if (formEdge.sourceNodeId == formEdge.targetNodeId) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("A origem e o destino devem ser diferentes."),
                      ),
                    );
                    return;
                  }

                  try {
                    await edgeDao.insertGraphEdge(
                      graphId: graphId,
                      type: formEdge.type,
                      sourceNodeId: formEdge.sourceNodeId,
                      targetNodeId: formEdge.targetNodeId,
                      weight: formEdge.weight,
                    );
                    formEdgeNotifier.reset();
                    if (context.mounted) {
                      graphStatesNotifier.isCreatingEdgeChanged(false);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Aresta adicionada.")),
                      );
                    }
                  } catch (_) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Não foi possível adicionar a aresta."),
                        ),
                      );
                    }
                  }
                },
                child: Text("Criar"),
              ),

              OutlinedButton(
                onPressed: () {
                  graphStatesNotifier.isCreatingEdgeChanged(false);
                },
                child: Text("Cancelar"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
