import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:noema/core/database/database.dart' hide OpenEnded;
import 'package:noema/core/database/database_provider.dart';
import 'package:noema/core/design/theme/theme_tokens.dart';
import 'package:noema/core/router/route_paths.dart';
import 'package:noema/feature/graph/data/learning_resource_dao.dart';
import 'package:noema/feature/graph/provider/selected_provider.dart';

class NodeDetails extends ConsumerStatefulWidget {
  const NodeDetails({
    super.key,
    required this.node,
    this.onClose,
    this.scrollController,
  });

  final GraphNodeData node;
  final VoidCallback? onClose;
  final ScrollController? scrollController;

  @override
  ConsumerState<NodeDetails> createState() => _NodeDetailsState();
}

class _NodeDetailsState extends ConsumerState<NodeDetails> {
  late Future<List<LearningResourceData>> _resourcesFuture;

  @override
  void initState() {
    super.initState();
    _loadResources();
  }

  @override
  void didUpdateWidget(covariant NodeDetails oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.node.id != widget.node.id) _loadResources();
  }

  void _loadResources() {
    _resourcesFuture = LearningResourceDao(
      ref.read(appDatabaseProvider),
    ).getLearningResourcesByNode(nodeId: widget.node.id);
  }

  @override
  Widget build(BuildContext context) {
    final node = widget.node;
    final colors = context.colors;
    final textTheme = context.textTheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: SingleChildScrollView(
        controller: widget.scrollController,
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: colors.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _nodeIcon(node.type),
                    color: colors.onPrimaryContainer,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'CONCEITO',
                        style: textTheme.labelSmall?.copyWith(
                          color: colors.onSurfaceVariant,
                          letterSpacing: 0.8,
                        ),
                      ),
                      Text(
                        'Informações e materiais',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.titleSmall,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'Fechar detalhes',
                  onPressed:
                      widget.onClose ??
                      ref.read(selectedProvider.notifier).clear,
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: Chip(
                avatar: Icon(_nodeIcon(node.type), size: 17),
                label: Text(_nodeTypeLabel(node.type)),
                visualDensity: VisualDensity.compact,
                side: BorderSide(color: colors.outlineVariant),
                backgroundColor: colors.surfaceContainerLow,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              node.title,
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                height: 1.15,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: colors.outlineVariant),
              ),
              child: Text(
                node.description?.trim().isNotEmpty == true
                    ? node.description!
                    : 'Este conceito ainda não tem descrição.',
                style: textTheme.bodyMedium?.copyWith(
                  color: node.description?.trim().isNotEmpty == true
                      ? colors.onSurface
                      : colors.onSurfaceVariant,
                  height: 1.45,
                ),
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Icon(
                  Icons.menu_book_outlined,
                  size: 18,
                  color: colors.primary,
                ),
                const SizedBox(width: 8),
                Text('Materiais de estudo', style: textTheme.titleSmall),
              ],
            ),
            const SizedBox(height: 8),
            FutureBuilder<List<LearningResourceData>>(
              future: _resourcesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.all(12),
                    child: Center(
                      child: SizedBox.square(
                        dimension: 22,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                  );
                }
                if (snapshot.hasError) {
                  return Text(
                    'Não foi possível carregar os materiais.',
                    style: textTheme.bodySmall?.copyWith(color: colors.error),
                  );
                }

                final resources = snapshot.data ?? const [];
                if (resources.isEmpty) {
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: colors.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: colors.outlineVariant),
                    ),
                    child: Text(
                      'Nenhum material relacionado ainda.',
                      style: textTheme.bodySmall?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  );
                }
                return Column(
                  children: [
                    for (final resource in resources)
                      Container(
                        margin: const EdgeInsets.only(bottom: 6),
                        decoration: BoxDecoration(
                          color: colors.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10,
                          ),
                          dense: true,
                          leading: Icon(
                            Icons.menu_book_outlined,
                            color: colors.primary,
                          ),
                          title: Text(
                            resource.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: resource.author?.isNotEmpty == true
                              ? Text(resource.author!)
                              : null,
                        ),
                      ),
                  ],
                );
              },
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                OutlinedButton.icon(
                  onPressed: () =>
                      context.push(RoutePaths.exercises(node.graphId, node.id)),
                  icon: const Icon(Icons.quiz_outlined),
                  label: const Text('Exercícios'),
                ),
                FilledButton.tonalIcon(
                  onPressed: () => context.push(
                    RoutePaths.flashcardsForNode(node.graphId, node.id),
                  ),
                  icon: const Icon(Icons.style_outlined),
                  label: const Text('Flashcards'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _nodeIcon(String type) {
    switch (type.toUpperCase()) {
      case 'AREA':
        return Icons.public_outlined;
      case 'TOPIC':
        return Icons.folder_open_outlined;
      case 'SUBCONCEPT':
        return Icons.account_tree_outlined;
      default:
        return Icons.lightbulb_outline_rounded;
    }
  }

  String _nodeTypeLabel(String type) {
    switch (type.toUpperCase()) {
      case 'AREA':
        return 'Área';
      case 'TOPIC':
        return 'Tópico';
      case 'SUBCONCEPT':
        return 'Subconceito';
      default:
        return 'Conceito';
    }
  }
}
