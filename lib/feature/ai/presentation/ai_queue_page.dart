import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noema/core/database/database_provider.dart';
import 'package:noema/feature/ai/data/ai_background_task_dao.dart';
import 'package:noema/feature/ai/providers/ai_background_task_provider.dart';
import 'package:noema/feature/ai/services/ai_background_task_runner.dart';
import 'package:noema/shared/widgets/responsive_content.dart';

class AiQueuePage extends ConsumerWidget {
  const AiQueuePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(aiBackgroundTaskItemsProvider);
    final runner = ref.watch(aiBackgroundTaskRunnerProvider);
    return DefaultTabController(
      length: 4,
      child: AppResponsiveContent(
        maxWidth: 1000,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: ListenableBuilder(
                    listenable: runner,
                    builder: (context, _) => Row(
                      children: [
                        Icon(
                          runner.isPaused
                              ? Icons.pause_circle_outline
                              : Icons.play_circle_outline,
                          color: Theme.of(context).colorScheme.primary,
                          size: 32,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                runner.isPaused
                                    ? 'Fila pausada'
                                    : runner.activeTasks == 0
                                    ? 'Fila ativa'
                                    : 'Processando ${runner.activeTasks} '
                                          'tarefa(s)',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                runner.isPaused
                                    ? 'As tarefas agendadas serão retomadas '
                                          'quando você reativar a fila.'
                                    : 'Gerações iniciadas por você continuam '
                                          'independentes desta fila.',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        OutlinedButton.icon(
                          onPressed: runner.isPaused
                              ? runner.resume
                              : runner.pause,
                          icon: Icon(
                            runner.isPaused ? Icons.play_arrow : Icons.pause,
                          ),
                          label: Text(runner.isPaused ? 'Retomar' : 'Pausar'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Tarefas automáticas de IA',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  IconButton(
                    tooltip: 'Limpar tarefas concluídas',
                    onPressed: () => _clearFinished(context, ref),
                    icon: const Icon(Icons.cleaning_services_outlined),
                  ),
                  IconButton(
                    tooltip: 'Atualizar fila',
                    onPressed: () =>
                        ref.invalidate(aiBackgroundTaskItemsProvider),
                    icon: const Icon(Icons.refresh),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              tasks.when(
                loading: () => const Expanded(
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (error, _) => Expanded(
                  child: _QueueLoadError(
                    error: error,
                    onRetry: () => ref.invalidate(aiBackgroundTaskItemsProvider),
                  ),
                ),
                data: (items) => Expanded(
                  child: Column(
                    children: [
                      const TabBar(
                        isScrollable: true,
                        tabs: [
                          Tab(text: 'Na fila'),
                          Tab(text: 'Retentativas'),
                          Tab(text: 'Falhas'),
                          Tab(text: 'Concluídas'),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: TabBarView(
                          children: [
                            _TaskList(
                              items: _filterItems(
                                items,
                                const {aiTaskPending, aiTaskRunning},
                              ),
                            ),
                            _TaskList(
                              items: _filterItems(items, const {aiTaskRetryWait}),
                            ),
                            _TaskList(
                              items: _filterItems(items, const {aiTaskFailed}),
                            ),
                            _TaskList(
                              items: _filterItems(items, const {
                                aiTaskCompleted,
                                aiTaskCanceled,
                              }),
                              includeCanceled: true,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<AiQueueItem> _filterItems(
    List<AiQueueItem> items,
    Set<String> statuses,
  ) {
    return items
        .where((item) => statuses.contains(item.task.status))
        .toList(growable: false);
  }

  Future<void> _clearFinished(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Limpar histórico concluído?'),
        content: const Text(
          'As tarefas concluídas e canceladas serão removidas da lista. '
          'As respostas e correções já salvas serão mantidas.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Manter'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Limpar'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    try {
      await AiBackgroundTaskDao(
        ref.read(appDatabaseProvider),
      ).clearFinished();
    } catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Não foi possível limpar o histórico: $error')),
      );
    }
  }
}

class _QueueLoadError extends StatelessWidget {
  const _QueueLoadError({required this.error, required this.onRetry});

  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, size: 40),
          const SizedBox(height: 12),
          const Text('Não foi possível carregar a fila de IA.'),
          const SizedBox(height: 4),
          Text(error.toString(), textAlign: TextAlign.center),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('Tentar novamente'),
          ),
        ],
      ),
    );
  }
}

class _TaskList extends ConsumerWidget {
  const _TaskList({required this.items, this.includeCanceled = false});

  final List<AiQueueItem> items;
  final bool includeCanceled;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 42,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: 8),
            Text(
              'Nenhuma tarefa nesta lista.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      );
    }
    return ListView.separated(
      itemCount: items.length,
      separatorBuilder: (_, _) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final item = items[index];
        return Card(
          child: ListTile(
            leading: _TaskStatusIcon(status: item.task.status),
            title: Text(
              '${_taskTypeLabel(item.task.taskType)} · ${item.node.title}',
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${item.graph.title} · ${_statusLabel(item.task.status)}'),
                  if (item.task.status == aiTaskRetryWait &&
                      item.task.nextAttemptAt != null)
                    Text(
                      'Nova tentativa: ${_formatTime(item.task.nextAttemptAt!)}',
                    ),
                  if (item.task.status == aiTaskRunning)
                    Text('Tentativa ${item.task.attemptCount} de 3'),
                  if (item.task.lastError?.isNotEmpty == true)
                    Text(
                      item.task.lastError!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  if (includeCanceled && item.task.status == aiTaskCanceled)
                    const Text('Esta tarefa foi cancelada.'),
                ],
              ),
            ),
            isThreeLine: item.task.lastError?.isNotEmpty == true ||
                item.task.status == aiTaskRetryWait,
            trailing: _TaskActions(item: item),
          ),
        );
      },
    );
  }

  String _formatTime(int epochMilliseconds) {
    final time = DateTime.fromMillisecondsSinceEpoch(
      epochMilliseconds,
    ).toLocal();
    final date = '${time.day.toString().padLeft(2, '0')}/'
        '${time.month.toString().padLeft(2, '0')} '
        '${time.hour.toString().padLeft(2, '0')}:'
        '${time.minute.toString().padLeft(2, '0')}';
    return date;
  }

  String _statusLabel(String status) => switch (status) {
    aiTaskPending => 'Aguardando',
    aiTaskRunning => 'Em andamento',
    aiTaskRetryWait => 'Nova tentativa agendada',
    aiTaskFailed => 'Falhou após as tentativas automáticas',
    aiTaskCompleted => 'Concluída',
    aiTaskCanceled => 'Cancelada',
    _ => status,
  };

  String _taskTypeLabel(String taskType) => switch (taskType) {
    aiNodeDescriptionTaskType => 'Descrição do nó',
    aiOpenEndedCorrectionTaskType => 'Correção dissertativa',
    aiMultipleChoiceCorrectionTaskType => 'Correção de múltipla escolha',
    _ => 'Tarefa de IA',
  };
}

class _TaskActions extends ConsumerWidget {
  const _TaskActions({required this.item});

  final AiQueueItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final canRetry =
        item.task.status == aiTaskFailed ||
        item.task.status == aiTaskRetryWait;
    final canCancel =
        item.task.status == aiTaskPending ||
        item.task.status == aiTaskRetryWait ||
        item.task.status == aiTaskFailed;
    if (!canRetry && !canCancel) return const SizedBox.shrink();
    return Wrap(
      spacing: 4,
      children: [
        if (canRetry)
          IconButton(
            tooltip: 'Reenfileirar tarefa',
            onPressed: () async {
              try {
                await AiBackgroundTaskDao(
                  ref.read(appDatabaseProvider),
                ).retryNow(item.task.id);
              } catch (error) {
                _showError(context, 'Não foi possível reenfileirar', error);
              }
            },
            icon: const Icon(Icons.refresh),
          ),
        if (canCancel)
          IconButton(
            tooltip: 'Cancelar tarefa',
            onPressed: () async {
              try {
                await AiBackgroundTaskDao(
                  ref.read(appDatabaseProvider),
                ).cancel(item.task.id);
              } catch (error) {
                _showError(context, 'Não foi possível cancelar', error);
              }
            },
            icon: const Icon(Icons.close),
          ),
      ],
    );
  }

  void _showError(BuildContext context, String message, Object error) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('$message: $error')));
  }
}

class _TaskStatusIcon extends StatelessWidget {
  const _TaskStatusIcon({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final color = status == aiTaskFailed
        ? Theme.of(context).colorScheme.error
        : Theme.of(context).colorScheme.primary;
    return status == aiTaskRunning
        ? SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: color,
            ),
          )
        : Icon(
            switch (status) {
              aiTaskPending => Icons.schedule,
              aiTaskRetryWait => Icons.replay_circle_filled_outlined,
              aiTaskFailed => Icons.error_outline,
              aiTaskCompleted => Icons.check_circle_outline,
              aiTaskCanceled => Icons.cancel_outlined,
              _ => Icons.auto_awesome_outlined,
            },
            color: color,
          );
  }
}
