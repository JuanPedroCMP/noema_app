import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:noema/core/database/database_provider.dart';
import 'package:noema/feature/graph/data/graph_edge_dao.dart';
import 'package:noema/feature/graph/data/graph_node_dao.dart';
import 'package:noema/feature/graph/provider/edge_form_provider.dart';
import 'package:noema/feature/graph/provider/graph_provider.dart';
import 'package:noema/feature/graph/provider/node_form_provider.dart';

enum NodeType { AREA, TOPIC, CONCEPT, SUBCONCEPT }

class ManageGraph extends ConsumerWidget {
  const ManageGraph({super.key, required this.graphId});

  final String graphId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formNode = ref.watch(nodeFormProvider);
    final formNodeNotifier = ref.watch(nodeFormProvider.notifier);
    final formEdge = ref.watch(edgeFormProvider);
    final formEdgeNotifier = ref.watch(edgeFormProvider.notifier);
    final db = ref.watch(appDatabaseProvider);
    final nodeDao = GraphNodeDao(db);
    final edgeDao = GraphEdgeDao(db);
    final nodesList = ref.watch(nodesProvider(graphId));

    return SingleChildScrollView(
      child: Column(
        children: [
          Text("Node id: ${formNode.isSkipped}"),
          DropdownMenu<String>(
            onSelected: (value) {
              if (value != null) {
                formNodeNotifier.typeChanged(value);
              }
            },
            label: Text("Type"),
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
              labelText: "titleChanged",
            ),
          ),
          TextField(
            onChanged: formNodeNotifier.descriptionChanged,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: "descriptionChanged",
            ),
          ),
          TextField(
            keyboardType: TextInputType.number,
            onChanged: (value) =>
                formNodeNotifier.maesteryScoreChanged(double.parse(value)),
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: "maesteryScoreChanged",
            ),
          ),
          Switch(
            value: formNode.isSkipped,
            onChanged: formNodeNotifier.isSkippedChanged,
          ),
          TextField(
            keyboardType: TextInputType.number,
            onChanged: (value) =>
                formNodeNotifier.positionXChanged(double.parse(value)),
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: "positionXChanged",
            ),
          ),
          TextField(
            keyboardType: TextInputType.number,
            onChanged: (value) =>
                formNodeNotifier.positionYChanged(double.parse(value)),
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: "positionYChanged",
            ),
          ),
          TextField(
            onChanged: formNodeNotifier.aiSynthesisChanged,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: "aiSynthesisChanged",
            ),
          ),

          OutlinedButton(
            onPressed: () async {
              await nodeDao.insertGraphNode(
                graphId: graphId,
                type: formNode.type,
                title: formNode.title,
                positionX: formNode.positionX,
                positionY: formNode.positionY,
              );
            },
            child: Text("Criar"),
          ),

          SizedBox(height: 35),
          Divider(),
          SizedBox(height: 35),

          Text("Edges"),
          nodesList.when(
            data: (data) => DropdownMenu<String>(
              onSelected: (value) {
                if (value != null) {
                  formEdgeNotifier.sourceNodeIdChanged(value);
                }
              },
              label: Text("Source"),
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
          nodesList.when(
            data: (data) => DropdownMenu<String>(
              onSelected: (value) {
                if (value != null) {
                  formEdgeNotifier.targetNodeIdChanged(value);
                }
              },
              label: Text("Target"),
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
            label: Text("Type"),
            dropdownMenuEntries: [
              DropdownMenuEntry(
                value: 'STRONG_PREREQUISITE',
                label: 'STRONG_PREREQUISITE',
              ),
              DropdownMenuEntry(
                value: 'WEAK_PREREQUISITE',
                label: 'WEAK_PREREQUISITE',
              ),
              DropdownMenuEntry(value: 'RELATED', label: 'RELATED'),
              DropdownMenuEntry(value: 'APPLIES', label: 'APPLIES'),
              DropdownMenuEntry(value: 'GENERALIZES', label: 'GENERALIZES'),
              DropdownMenuEntry(value: 'INSTANTIATES', label: 'INSTANTIATES'),
            ],
          ),

          Switch(
            value: formEdge.isBidirectional,
            onChanged: formEdgeNotifier.isBidirectionalChanged,
          ),
          TextField(
            keyboardType: TextInputType.number,
            onChanged: (value) =>
                formEdgeNotifier.weightChanged(double.parse(value)),
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: "weightChanged",
            ),
          ),

          OutlinedButton(
            onPressed: () async {
              await edgeDao.insertGraphEdge(
                graphId: graphId,
                type: formEdge.type,
                sourceNodeId: formEdge.sourceNodeId,
                targetNodeId: formEdge.targetNodeId,
              );
            },
            child: Text("Criar"),
          ),

          OutlinedButton(
            onPressed: () {
              context.pop();
            },
            child: Text("Voltar"),
          ),
        ],
      ),
    );
  }
}
