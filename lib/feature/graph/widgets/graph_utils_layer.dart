import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noema/core/database/database_provider.dart';
import 'package:noema/core/design/theme/theme_tokens.dart';
import 'package:noema/feature/graph/provider/graph_states_provider.dart';
import 'package:noema/feature/graph/provider/selected_provider.dart';
import 'package:noema/feature/graph/data/graph_edge_dao.dart';
import 'package:noema/feature/graph/data/graph_node_dao.dart';
import 'package:noema/feature/graph/service/sugiyama.dart';

class GraphUtilsLayer extends ConsumerStatefulWidget {
  const GraphUtilsLayer({super.key, required this.graphId});

  final String graphId;

  @override
  ConsumerState<GraphUtilsLayer> createState() => _GraphUtilsLayer();
}

class _GraphUtilsLayer extends ConsumerState<GraphUtilsLayer> {
  @override
  Widget build(BuildContext context) {
    final graphStatesNotifier = ref.watch(graphStatesProvider.notifier);
    final graphStates = ref.watch(graphStatesProvider);
    final selected = ref.watch(selectedProvider);

    return Wrap(
      spacing: context.spacing.lg,
      runSpacing: context.spacing.sm,
      children: [
        if (graphStates.isEditing) ...[
          OutlinedButton(
            onPressed: () {
              graphStatesNotifier.isCreatingNodeChanged(
                !graphStates.isCreatingNode,
              );
            },
            style: _actionStyle(context, graphStates.isCreatingNode),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add_circle_outline),
                SizedBox(width: 6),
                Text('Adicionar nó'),
              ],
            ),
          ),

          OutlinedButton(
            onPressed: () {
              graphStatesNotifier.isCreatingEdgeChanged(!graphStates.isCreatingEdge);
            },
            style: _actionStyle(context, graphStates.isCreatingEdge),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.linear_scale),
                SizedBox(width: 6),
                Text('Adicionar relação'),
              ],
            ),
          ),

          OutlinedButton(
            onPressed: selected.isEmpty
                ? null
                : () => _deleteSelected(context, ref, selected),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.delete_outline),
                SizedBox(width: 6),
                Text('Excluir selecionado'),
              ],
            ),
          ),
          OutlinedButton.icon(
            onPressed: () => graphStatesNotifier.isEditingChanged(false),
            icon: const Icon(Icons.close),
            label: const Text('Concluir'),
          ),
        ],
        if (!graphStates.isEditing) ...[
          OutlinedButton(
            onPressed: () {
              graphStatesNotifier.isEditingChanged(!graphStates.isEditing);
            },
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.edit_outlined),
                SizedBox(width: 6),
                Text('Editar grafo'),
              ],
            ),
          ),

          OutlinedButton(
            onPressed: () {
              sugiyama(widget.graphId, ref);
            },
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.auto_awesome_mosaic),
                SizedBox(width: 6),
                Text('Organizar'),
              ],
            ),
          ),
        ]
      ],
    );
  }

  ButtonStyle _actionStyle(BuildContext context, bool active) {
    return OutlinedButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      backgroundColor: active
          ? context.colors.primary.withValues(alpha: 0.12)
          : null,
      side: BorderSide(
        color: active ? context.colors.primary : context.colors.outline,
        width: active ? 2 : 1,
      ),
    );
  }

  Future<void> _deleteSelected(
    BuildContext context,
    WidgetRef ref,
    String selected,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir elemento?'),
        content: const Text(
          'A exclusão removerá o elemento do grafo. Esta ação não pode ser desfeita.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;

    final db = ref.read(appDatabaseProvider);
    final nodeDao = GraphNodeDao(db);
    final edgeDao = GraphEdgeDao(db);
    try {
      final node = await nodeDao.getGraphNode(id: selected);

      if (node != null) {
        await edgeDao.deleteEdgesByNode(nodeId: node.id);
        await nodeDao.deleteGraphNode(id: node.id);
      } else {
        await edgeDao.deleteGraphEdge(id: selected);
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Não foi possível excluir o elemento.')),
        );
      }
      return;
    }

    ref.read(selectedProvider.notifier).clear();
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Elemento excluído.')),
      );
    }
  }
}
