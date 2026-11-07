import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:noema/core/database/database_provider.dart';
import 'package:noema/core/router/route_paths.dart';
import 'package:noema/feature/config/providers/user_provider.dart';
import 'package:noema/feature/review/data/exercise_review_queue_service.dart';

final exerciseReviewQueueProvider =
    StreamProvider.autoDispose<List<ExerciseReviewGroup>>((ref) async* {
      final database = ref.watch(appDatabaseProvider);
      final user = await ref.watch(userProvider.future);
      yield* ExerciseReviewQueueService(
        database,
      ).watch(userId: user.id);
    });

class ExerciseReviewQueuePage extends StatelessWidget {
  const ExerciseReviewQueuePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: const ExerciseReviewQueueSection(),
        ),
      ),
    );
  }
}

class ExerciseReviewQueueSection extends ConsumerWidget {
  const ExerciseReviewQueueSection({super.key, this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queue = ref.watch(exerciseReviewQueueProvider);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: queue.when(
          loading: () => const _QueueStatus(
            icon: Icons.hourglass_top_rounded,
            message: 'Carregando sua fila de exercícios…',
          ),
          error: (error, _) => _QueueError(
            error: error,
            onRetry: () => ref.invalidate(exerciseReviewQueueProvider),
          ),
          data: (groups) => _QueueContent(
            groups: groups,
            compact: compact,
          ),
        ),
      ),
    );
  }
}

class _QueueContent extends StatelessWidget {
  const _QueueContent({required this.groups, required this.compact});

  final List<ExerciseReviewGroup> groups;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final total = groups.fold<int>(0, (count, group) => count + group.items.length);
    final visibleGroups = compact ? groups.take(3) : groups;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Icon(Icons.quiz_outlined, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Revisão de exercícios', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 2),
                  Text(
                    'Revisões espaçadas, agrupadas por grafo e tópico.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            if (total > 0) Chip(label: Text('$total')),
          ],
        ),
        const SizedBox(height: 12),
        if (total == 0)
          const _QueueStatus(
            icon: Icons.check_circle_outline_rounded,
            message: 'Nenhum exercício vencido. Continue estudando no seu ritmo.',
          )
        else ...[
          for (final group in visibleGroups)
            _ReviewGroupTile(group: group, compact: compact),
          if (compact)
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () => context.go(RoutePaths.exerciseReview),
                icon: const Icon(Icons.arrow_forward_rounded),
                label: const Text('Abrir fila completa'),
              ),
            ),
        ],
      ],
    );
  }
}

class _ReviewGroupTile extends StatelessWidget {
  const _ReviewGroupTile({required this.group, required this.compact});

  final ExerciseReviewGroup group;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final items = compact ? group.items.take(2) : group.items;
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '${group.graphTitle}  ·  ${group.nodeTitle}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelLarge,
              ),
              for (final item in items)
                ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(
                    item.type.databaseValue == 'OPEN_ENDED'
                        ? Icons.edit_note_rounded
                        : Icons.checklist_rounded,
                  ),
                  title: Text(item.title, maxLines: 2, overflow: TextOverflow.ellipsis),
                  subtitle: Text(
                    item.type.databaseValue == 'OPEN_ENDED'
                        ? 'Questão aberta'
                        : 'Múltipla escolha',
                  ),
                  trailing: const Icon(Icons.play_arrow_rounded),
                  onTap: () {
                    final location = item.type.databaseValue == 'OPEN_ENDED'
                        ? RoutePaths.openEndedAnswer(
                            item.graphId,
                            item.nodeId,
                            item.id,
                          )
                        : RoutePaths.multipleChoiceAnswer(
                            item.graphId,
                            item.nodeId,
                            item.id,
                          );
                    context.push(location);
                  },
                ),
              if (compact && group.items.length > 2)
                Text(
                  '+ ${group.items.length - 2} exercício(s) neste tópico',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QueueStatus extends StatelessWidget {
  const _QueueStatus({required this.icon, required this.message});

  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 12),
    child: Row(
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 10),
        Expanded(child: Text(message)),
      ],
    ),
  );
}

class _QueueError extends StatelessWidget {
  const _QueueError({required this.error, required this.onRetry});

  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      const Icon(Icons.error_outline_rounded),
      const SizedBox(width: 10),
      Expanded(child: Text('Falha ao carregar a fila: $error')),
      IconButton(
        tooltip: 'Tentar novamente',
        onPressed: onRetry,
        icon: const Icon(Icons.refresh_rounded),
      ),
    ],
  );
}
