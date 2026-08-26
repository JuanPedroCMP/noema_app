import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noema/core/database/database_provider.dart';
import 'package:noema/core/design/theme/theme_tokens.dart';
import 'package:noema/feature/graph/data/graph_node_dao.dart';
import 'package:noema/feature/graph/provider/graph_states_provider.dart';
import 'package:noema/feature/graph/provider/node_form_provider.dart';

class CreateNode extends ConsumerWidget {
  const CreateNode({super.key, required this.graphId});

  final String graphId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formNode = ref.watch(nodeFormProvider);
    final formNodeNotifier = ref.watch(nodeFormProvider.notifier);
    final db = ref.watch(appDatabaseProvider);
    final nodeDao = GraphNodeDao(db);

    final graphStatesNotifier = ref.watch(graphStatesProvider.notifier);

    return SingleChildScrollView(
      child: Column(
        spacing: context.spacing.md,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Node id: ${formNode.isSkipped}"),
          DropdownMenu<String>(
            onSelected: (value) {
              if (value != null) {
                formNodeNotifier.typeChanged(value);
              }
            },
            label: Text("Tipo"),
            dropdownMenuEntries: [
              DropdownMenuEntry(value: 'AREA', label: 'AREA'),
              DropdownMenuEntry(value: 'TOPIC', label: 'TOPIC'),
              DropdownMenuEntry(value: 'CONCEPT', label: 'CONCEPT'),
              DropdownMenuEntry(value: 'SUBCONCEPT', label: 'SUBCONCEPT'),
            ],
          ),
          TextField(
            onChanged: formNodeNotifier.titleChanged,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Título",
            ),
          ),
          TextField(
            onChanged: formNodeNotifier.descriptionChanged,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Descrição",
            ),
          ),

          Row(
            spacing: context.spacing.md,
            children: [
              OutlinedButton(
                onPressed: () async {
                  await nodeDao.insertGraphNode(
                    graphId: graphId,
                    type: formNode.type,
                    title: formNode.title,
                    positionX: 10,
                    positionY: 10,
                  );
                },
                child: Text("Criar"),
              ),

              OutlinedButton(
                onPressed: () {
                  graphStatesNotifier.isCreatingNodeChanged(false);
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
