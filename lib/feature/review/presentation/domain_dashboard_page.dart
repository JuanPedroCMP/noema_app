import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:noema/feature/review/data/domain_dashboard_service.dart';
import 'package:noema/feature/review/presentation/domain_dashboard_card.dart';

class DomainDashboardPage extends ConsumerWidget {
  const DomainDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(domainDashboardProvider);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Painel de aprendizagem', style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 4),
              Text(
                'Domínio, desempenho e atividade registrados no app.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 18),
              summary.when(
                loading: () => const Card(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                ),
                error: (error, _) => Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text('Não foi possível carregar o painel: $error'),
                  ),
                ),
                data: (data) => _DashboardDetails(summary: data),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashboardDetails extends StatelessWidget {
  const _DashboardDetails({required this.summary});

  final DomainDashboardSummary summary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final stats = [
      ('Grafos', summary.graphCount, Icons.account_tree_outlined),
      ('Nós', summary.nodePerformance.length, Icons.hub_outlined),
      ('Revisões', summary.reviewCount, Icons.replay_rounded),
      ('Sessões', summary.sessionMinutes, Icons.timer_outlined),
      ('Revisão', summary.reviewMinutes, Icons.hourglass_bottom_rounded),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            for (final (label, value, icon) in stats)
              SizedBox(
                width: 220,
                child: Card(
                  child: ListTile(
                    leading: Icon(icon, color: theme.colorScheme.primary),
                    title: Text(
                      label == 'Sessões' || label == 'Revisão'
                          ? '${value} min'
                          : '$value',
                      style: theme.textTheme.titleLarge,
                    ),
                    subtitle: Text(
                      label == 'Sessões'
                          ? 'tempo registrado em sessões'
                          : label == 'Revisão'
                          ? 'tempo de revisão registrado'
                          : label.toLowerCase(),
                    ),
                  ),
                ),
              ),
            SizedBox(
              width: 220,
              child: Card(
                child: ListTile(
                  leading: Icon(
                    Icons.track_changes_outlined,
                    color: theme.colorScheme.primary,
                  ),
                  title: Text(
                    summary.averageMastery == null
                        ? '—'
                        : '${(summary.averageMastery! * 100).round()}%',
                    style: theme.textTheme.titleLarge,
                  ),
                  subtitle: const Text('domínio médio avaliado'),
                ),
              ),
            ),
            SizedBox(
              width: 220,
              child: Card(
                child: ListTile(
                  leading: Icon(
                    Icons.check_circle_outline_rounded,
                    color: theme.colorScheme.primary,
                  ),
                  title: Text(
                    summary.averageAccuracy == null
                        ? '—'
                        : '${(summary.averageAccuracy! * 100).round()}%',
                    style: theme.textTheme.titleLarge,
                  ),
                  subtitle: const Text('média das revisões com nota'),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const DomainDashboardCard(),
        const SizedBox(height: 16),
        _MetricList(
          title: 'Desempenho por grafo',
          emptyMessage: 'Crie um grafo para acompanhar seu desempenho.',
          child: Column(
            children: [
              for (final graph in summary.graphPerformance)
                ListTile(
                  leading: const Icon(Icons.account_tree_outlined),
                  title: Text(graph.graphTitle),
                  subtitle: Text('${graph.nodeCount} nós'),
                  trailing: Text(
                    graph.averageMastery == null
                        ? 'Sem avaliação'
                        : '${(graph.averageMastery! * 100).round()}%',
                  ),
                ),
            ],
          ),
          isEmpty: summary.graphPerformance.isEmpty,
        ),
        const SizedBox(height: 16),
        _MetricList(
          title: 'Desempenho por nó',
          emptyMessage: 'Ainda não há nós nos grafos.',
          child: Column(
            children: [
              for (final node in summary.nodePerformance)
                ListTile(
                  leading: const Icon(Icons.lightbulb_outline_rounded),
                  title: Text(node.nodeTitle),
                  subtitle: Text(
                    '${node.graphTitle} · ${node.reviewCount} revisão(ões)'
                    '${node.averageAccuracy == null ? '' : ' · nota média ${(node.averageAccuracy! * 100).round()}%'}',
                  ),
                  trailing: Text(
                    node.masteryScore == null
                        ? '—'
                        : '${(node.masteryScore! * 100).round()}%',
                  ),
                ),
            ],
          ),
          isEmpty: summary.nodePerformance.isEmpty,
        ),
        const SizedBox(height: 16),
        _MetricList(
          title: 'Atividade recente',
          emptyMessage: 'Suas atividades de estudo aparecerão aqui.',
          child: Column(
            children: [
              for (final activity in summary.recentActivity)
                ListTile(
                  leading: const Icon(Icons.history_rounded),
                  title: Text(activity.nodeTitle),
                  subtitle: Text(
                    '${activity.graphTitle} · ${_activityLabel(activity)} · '
                    '${DateFormat.yMd().add_Hm().format(activity.loggedAt)}',
                  ),
                  trailing: Text('${(activity.score * 100).round()}%'),
                ),
            ],
          ),
          isEmpty: summary.recentActivity.isEmpty,
        ),
        const SizedBox(height: 8),
        Text(
          'O tempo exibido é o registrado em sessões concluídas. '
          'Não representa o tempo total em primeiro plano no app.',
          style: theme.textTheme.bodySmall,
        ),
      ],
    );
  }

  String _activityLabel(DashboardActivity activity) {
    final sessionType = activity.activityType;
    if (sessionType.isNotEmpty) return sessionType.replaceAll('_', ' ');
    return switch (activity.eventOrigin) {
      'STUDY_SESSION' => 'Sessão de estudo',
      'REVISION' => 'Revisão',
      'MANUAL' => 'Atualização manual',
      _ => activity.eventOrigin.replaceAll('_', ' '),
    };
  }
}

class _MetricList extends StatelessWidget {
  const _MetricList({
    required this.title,
    required this.emptyMessage,
    required this.child,
    required this.isEmpty,
  });

  final String title;
  final String emptyMessage;
  final Widget child;
  final bool isEmpty;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          if (isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(emptyMessage),
            )
          else
            child,
        ],
      ),
    ),
  );
}
