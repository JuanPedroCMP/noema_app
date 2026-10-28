import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noema/core/database/database_provider.dart';
import 'package:noema/core/design/theme/theme_tokens.dart';
import 'package:noema/feature/graph/data/graph_edge_dao.dart';
import 'package:noema/feature/graph/data/graph_node_dao.dart';
import 'package:noema/feature/graph/provider/graph_states_provider.dart';
import 'package:noema/feature/graph/provider/selected_provider.dart';

class GraphUtilsLayer extends ConsumerWidget {
  const GraphUtilsLayer({
    super.key,
    required this.onOrganize,
    required this.onCreateNode,
    required this.onCreateEdge,
    required this.canOrganize,
    this.isOrganizing = false,
  });

  final Future<void> Function() onOrganize;
  final VoidCallback onCreateNode;
  final VoidCallback onCreateEdge;
  final bool canOrganize;
  final bool isOrganizing;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final graphStates = ref.watch(graphStatesProvider);
    final graphStatesNotifier = ref.read(graphStatesProvider.notifier);
    final selected = ref.watch(selectedProvider);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: graphStates.isEditing
          ? [
              FilledButton.tonalIcon(
                onPressed: onCreateNode,
                icon: const Icon(Icons.add_circle_outline),
                label: const Text('Adicionar nó'),
                style: _actionStyle(context, false),
              ),
              const SizedBox(width: 8),
              FilledButton.tonalIcon(
                onPressed: onCreateEdge,
                icon: const Icon(Icons.linear_scale),
                label: const Text('Adicionar relação'),
                style: _actionStyle(context, graphStates.isCreatingEdge),
              ),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                onPressed: selected.isEmpty
                    ? null
                    : () => _deleteSelected(context, ref, selected),
                icon: const Icon(Icons.delete_outline),
                label: const Text('Excluir selecionado'),
              ),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                onPressed: () => graphStatesNotifier.isEditingChanged(false),
                icon: const Icon(Icons.check_rounded),
                label: const Text('Concluir edição'),
              ),
            ]
          : [
              FilledButton.tonalIcon(
                onPressed: () => graphStatesNotifier.isEditingChanged(true),
                icon: const Icon(Icons.edit_outlined),
                label: const Text('Editar grafo'),
              ),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                onPressed: !canOrganize || isOrganizing ? null : onOrganize,
                icon: isOrganizing
                    ? const SizedBox.square(
                        dimension: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.auto_awesome_mosaic_outlined),
                label: Text(isOrganizing ? 'Organizando…' : 'Organizar'),
              ),
            ],
    );
  }

  ButtonStyle _actionStyle(BuildContext context, bool active) {
    return FilledButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      backgroundColor: active
          ? context.colors.primaryContainer
          : context.colors.surfaceContainerLow,
      foregroundColor: active
          ? context.colors.onPrimaryContainer
          : context.colors.onSurface,
      side: BorderSide(
        color: active ? context.colors.primary : context.colors.outlineVariant,
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
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Não foi possível excluir o elemento: $error'),
          ),
        );
      }
      return;
    }

    ref.read(selectedProvider.notifier).clear();
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Elemento excluído.')));
    }
  }
}
