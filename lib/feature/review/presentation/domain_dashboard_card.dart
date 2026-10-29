import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:noema/core/database/database_provider.dart';
import 'package:noema/core/router/route_paths.dart';
import 'package:noema/feature/config/providers/user_provider.dart';
import 'package:noema/feature/review/data/domain_dashboard_service.dart';

final domainDashboardProvider = StreamProvider<DomainDashboardSummary>((ref) async* {
  final database = ref.watch(appDatabaseProvider);
  final user = await ref.watch(userProvider.future);
  yield* DomainDashboardService(database).watch(userId: user.id);
});

class DomainDashboardCard extends ConsumerWidget {
  const DomainDashboardCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(domainDashboardProvider);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: summary.when(
          loading: () => const _DashboardLoading(),
          error: (error, _) => _DashboardError(
            error: error,
            onRetry: () => ref.invalidate(domainDashboardProvider),
          ),
          data: (data) => _DashboardContent(summary: data),
        ),
      ),
    );
  }
}

class _DashboardLoading extends StatelessWidget {
  const _DashboardLoading();

  @override
  Widget build(BuildContext context) => const Row(
    children: [
      SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
      SizedBox(width: 12),
      Text('Carregando seu domínio por conceito...'),
    ],
  );
}

class _DashboardError extends StatelessWidget {
  const _DashboardError({required this.error, required this.onRetry});

  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      const Icon(Icons.error_outline),
      const SizedBox(width: 12),
      Expanded(child: Text('Não foi possível carregar o painel: $error')),
      IconButton(
        tooltip: 'Tentar novamente',
        onPressed: onRetry,
        icon: const Icon(Icons.refresh),
      ),
    ],
  );
}

class _DashboardContent extends StatelessWidget {
  const _DashboardContent({required this.summary});

  final DomainDashboardSummary summary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final pointsWithData = summary.recentProgress
        .where((point) => point.averageScore != null)
        .length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Icon(Icons.insights_outlined, color: theme.colorScheme.primary),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Domínio por conceito',
                style: theme.textTheme.titleLarge,
              ),
            ),
            TextButton(
              onPressed: () => context.go(RoutePaths.graphs),
              child: const Text('Explorar grafos'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _SummaryChip(
              label: 'Dominados',
              count: summary.masteredConcepts,
              icon: Icons.check_circle_outline,
              color: theme.colorScheme.primary,
            ),
            _SummaryChip(
              label: 'Frágeis',
              count: summary.fragileConcepts,
              icon: Icons.warning_amber_outlined,
              color: theme.colorScheme.error,
            ),
            _SummaryChip(
              label: 'Sem avaliação',
              count: summary.unassessedConcepts,
              icon: Icons.help_outline,
              color: theme.colorScheme.secondary,
            ),
            _SummaryChip(
              label: 'Pré-requisitos críticos',
              count: summary.criticalPrerequisites,
              icon: Icons.account_tree_outlined,
              color: theme.colorScheme.tertiary,
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text('Evolução nos últimos 14 dias', style: theme.textTheme.titleSmall),
        const SizedBox(height: 8),
        SizedBox(
          height: 150,
          child: pointsWithData < 2
              ? Center(
                  child: Text(
                    pointsWithData == 0
                        ? 'Revise conceitos para começar a acompanhar sua evolução.'
                        : 'Continue estudando para formar uma tendência.',
                    textAlign: TextAlign.center,
                  ),
                )
              : LineChart(
                  LineChartData(
                    minY: 0,
                    maxY: 1,
                    minX: 0,
                    maxX: 13,
                    gridData: const FlGridData(show: true, drawVerticalLine: false),
                    borderData: FlBorderData(show: false),
                    titlesData: FlTitlesData(
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      leftTitles: const AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 36,
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 3,
                          reservedSize: 24,
                          getTitlesWidget: (value, meta) {
                            final index = value.toInt();
                            if (index < 0 ||
                                index >= summary.recentProgress.length) {
                              return const SizedBox.shrink();
                            }
                            final date = summary.recentProgress[index].date;
                            return SideTitleWidget(
                              meta: meta,
                              child: Text(
                                '${date.day.toString().padLeft(2, '0')}/'
                                '${date.month.toString().padLeft(2, '0')}',
                                style: theme.textTheme.labelSmall,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    lineBarsData: [
                      LineChartBarData(
                        spots: [
                          for (var index = 0;
                              index < summary.recentProgress.length;
                              index++)
                            if (summary.recentProgress[index].averageScore
                                case final score?)
                              FlSpot(index.toDouble(), score),
                        ],
                        isCurved: true,
                        barWidth: 3,
                        dotData: const FlDotData(show: true),
                        color: theme.colorScheme.primary,
                      ),
                    ],
                  ),
                ),
        ),
      ],
    );
  }
}

class _SummaryChip extends StatelessWidget {
  const _SummaryChip({
    required this.label,
    required this.count,
    required this.icon,
    required this.color,
  });

  final String label;
  final int count;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) => Chip(
    avatar: Icon(icon, size: 18, color: color),
    label: Text('$label: $count'),
  );
}
