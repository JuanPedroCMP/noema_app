import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:noema/core/database/database.dart' hide OpenEnded;
import 'package:noema/core/database/database_provider.dart';
import 'package:noema/core/design/theme/theme_tokens.dart';
import 'package:noema/feature/graph/data/learning_resource_dao.dart';
import 'package:noema/feature/graph/provider/selected_provider.dart';
import 'package:noema/feature/exercises/open_ended/presentation/open_ended.dart';

class NodeDetails extends ConsumerWidget {
  const NodeDetails({super.key, required this.node});

  final GraphNodeData node;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedNotifier = ref.watch(selectedProvider.notifier);
    final db = ref.read(appDatabaseProvider);

    final learningResouce = LearningResourceDao(db);

    final resourcesFuture = learningResouce.getLearningResourcesByNode(
      nodeId: node.id,
    );

    return SizedBox(
      width: 600,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                spacing: context.spacing.sm,
                children: [
                  Spacer(),
                  IconButton(
                    onPressed: () {
                      selectedNotifier.selectedChanged("none");
                    },
                    icon: Icon(Icons.close_rounded),
                  ),
                ],
              ),
              Text(node.title, style: context.textTheme.headlineMedium),
              Divider(),
              if (node.description == null || node.description == "")
                Text(
                  "Sem descrição, você pode adicionar uma descrição ou pedir para o assistente gerar.",
                )
              else
                Text(node.description!, style: context.textTheme.bodyMedium),
              // Recursos
              Text("Veja sobre", style: context.textTheme.titleMedium),
              FutureBuilder(
                future: resourcesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }

                  if (snapshot.hasError) {
                    return Text('Erro ao carregar recursos');
                  }

                  final resources = snapshot.data ?? [];

                  if (resources.isEmpty) {
                    return const Text('Nenhum recurso encontrado');
                  }

                  return Column(
                    children: resources
                        .map(
                          (resource) => Row(children: [Text(resource.title)]),
                        )
                        .toList(),
                  );
                },
              ),
              Divider(),
              OutlinedButton(
                onPressed: () {
                  context.push("/graphs/${node.graphId}/exercices/${node.id}");
                },
                child: Text("Ir para grafo"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
