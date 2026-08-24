import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noema/core/database/database.dart';
import 'package:noema/core/database/database_provider.dart';
import 'package:noema/core/design/theme/theme_tokens.dart';
import 'package:noema/feature/graph/data/learning_resource_dao.dart';

class NodeCard extends ConsumerWidget {
  NodeCard({super.key, required this.node});

  GraphNodeData node;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final user = await userNotifier.getUser();

    final db = ref.read(appDatabaseProvider);
    final dao = (db);

    final learningResouce = LearningResourceDao(db);

    final resources = learningResouce.getLearningResourcesByNode(nodeId: node.id);


    return SizedBox(
      width: 600,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(Icons.accessible),
                  Icon(Icons.add_box_outlined),
                  Text(node.type),
                  Text(node.masteryScore.toString()),
                ],
              ),
              Text(node.title, style: context.textTheme.titleMedium),
              Divider(),
              if (node.description == null || node.description == "")
                Text(
                  "Sem descrição, você pode adicionar uma descrição ou pedir para o assistente gerar.",
                )
              else
                Text(node.description!, style: context.textTheme.bodyMedium),
              // Recursos
              Text("Veja sobre", style: context.textTheme.titleMedium),
              for(final resource in resources){
                // Arrumar isso
              }
            ],
          ),
        ),
      ),
    );
  }
}
