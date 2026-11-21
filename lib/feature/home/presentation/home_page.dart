import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:noema/shared/localization/runtime_localization.dart';
import 'package:noema/core/database/database.dart';
import 'package:noema/core/database/database_provider.dart';
import 'package:noema/core/design/tokens/layout.dart';
import 'package:noema/core/design/theme/theme_tokens.dart';
import 'package:noema/core/router/route_paths.dart';
import 'package:noema/feature/auth/providers/account_state.dart';
import 'package:noema/feature/config/providers/user_provider.dart';
import 'package:noema/feature/graph/service/learning_path.dart';
import 'package:noema/feature/review/data/domain_dashboard_service.dart';
import 'package:noema/feature/review/data/exercise_review_queue_service.dart';
import 'package:noema/feature/review/presentation/domain_dashboard_card.dart';
import 'package:noema/feature/review/presentation/exercise_review_queue_page.dart';
import 'package:noema/shared/widgets/app_card.dart';
import 'package:noema/shared/widgets/responsive_content.dart';

final _homeGraphRecommendationsProvider =
    FutureProvider<List<_GraphRecommendation>>((ref) async {
      final database = ref.watch(appDatabaseProvider);
      final user = await ref.watch(userProvider.future);
      final graphRows =
          await (database.select(database.knowledgeGraph)
                ..where(
                  (graph) =>
                      graph.userId.equals(user.id) &
                      graph.softDeleted.equals(false) &
                      graph.isArchived.equals(false),
                )
                ..orderBy([(graph) => OrderingTerm.desc(graph.updatedAt)]))
              .get();
      final recommendations = <_GraphRecommendation>[];
      for (final graph in graphRows) {
        final nodes =
            await (database.select(database.graphNode)..where(
                  (node) =>
                      node.graphId.equals(graph.id) &
                      node.softDeleted.equals(false),
                ))
                .get();
        final edges = await (database.select(
          database.graphEdge,
        )..where((edge) => edge.graphId.equals(graph.id))).get();
        final path = LearningPath.analyze(
          nodes: [
            for (final node in nodes)
              LearningPathNode(
                id: node.id,
                title: node.title,
                masteryScore: node.masteryScore,
              ),
          ],
          relations: [
            for (final edge in edges)
              LearningPathRelation(
                sourceId: edge.sourceNodeId,
                targetId: edge.targetNodeId,
                type: edge.type,
              ),
          ],
        );
        final nodeById = {for (final node in nodes) node.id: node};
        recommendations.add(
          _GraphRecommendation(
            id: graph.id,
            title: graph.title,
            nodeCount: nodes.length,
            masteredCount: path.masteredCount,
            recommendedNode: path.recommendedNodeIds.isEmpty
                ? null
                : nodeById[path.recommendedNodeIds.first],
            hasUnresolvedNodes: path.hasUnresolvedNodes,
          ),
        );
      }
      recommendations.sort((a, b) {
        final aReady = a.recommendedNode != null ? 0 : 1;
        final bReady = b.recommendedNode != null ? 0 : 1;
        if (aReady != bReady) return aReady.compareTo(bReady);
        final progress =
            (b.masteredCount / (b.nodeCount == 0 ? 1 : b.nodeCount)).compareTo(
              a.masteredCount / (a.nodeCount == 0 ? 1 : a.nodeCount),
            );
        return progress != 0 ? progress : a.title.compareTo(b.title);
      });
      return recommendations;
    });

class _GraphRecommendation {
  const _GraphRecommendation({
    required this.id,
    required this.title,
    required this.nodeCount,
    required this.masteredCount,
    required this.recommendedNode,
    required this.hasUnresolvedNodes,
  });

  final String id;
  final String title;
  final int nodeCount;
  final int masteredCount;
  final GraphNodeData? recommendedNode;
  final bool hasUnresolvedNodes;
}

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final graphs = ref.watch(_homeGraphRecommendationsProvider);
    final dashboard = ref.watch(domainDashboardProvider);
    final reviewQueue = ref.watch(exerciseReviewQueueProvider);
    final user = ref.watch(userProvider).asData?.value;
    final firstName = user?.displayName.trim().split(RegExp(r'\s+')).first;
    final hour = DateTime.now().hour;
    final greeting = hour < 12
        ? 'Bom dia'
        : hour < 18
        ? 'Boa tarde'
        : 'Boa noite';
    return AppResponsiveContent(
      maxWidth: AppLayoutTokens.widePageContentWidth,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: context.spacing.lg,
          children: [
            AppPageHeader(
              title:
                  '$greeting, ${firstName?.isNotEmpty == true ? firstName : 'estudante'}',
              subtitle: 'Um passo de cada vez. Seu aprendizado continua aqui.',
              actions: [
                TextButton.icon(
                  onPressed: () => context.go(RoutePaths.dashboard),
                  icon: const Icon(Icons.insights_outlined),
                  label: const RuntimeLocalizedText('Meu progresso'),
                ),
              ],
            ),
            _HomeWelcomeCard(
              onExploreGraphs: () => context.go(RoutePaths.graphs),
              onOpenDashboard: () => context.go(RoutePaths.dashboard),
            ),
            _HomeProgressOverview(summary: dashboard),
            LayoutBuilder(
              builder: (context, constraints) {
                final recommendations = _HomeGraphRecommendations(
                  graphs: graphs,
                  onRetry: () =>
                      ref.invalidate(_homeGraphRecommendationsProvider),
                );
                final reviews = _HomeReviewSummary(queue: reviewQueue);
                if (constraints.maxWidth < 760) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: context.spacing.lg,
                    children: [reviews, recommendations],
                  );
                }
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 5, child: reviews),
                    SizedBox(width: context.spacing.lg),
                    Expanded(flex: 7, child: recommendations),
                  ],
                );
              },
            ),
            _HomeRecentActivity(summary: dashboard),
            AppCard(
              padding: EdgeInsets.zero,
              onTap: () => context.go(RoutePaths.studySessions),
              child: ListTile(
                leading: Icon(
                  Icons.playlist_add_check_circle_outlined,
                  color: context.colors.primary,
                ),
                title: const RuntimeLocalizedText('Sessões de estudo'),
                subtitle: const Text(
                  'Organize atividades e acompanhe cada sessão.',
                ),
                trailing: const Icon(Icons.arrow_forward_rounded),
              ),
            ),
            const _AccountActions(),
          ],
        ),
      ),
    );
  }
}

class _HomeWelcomeCard extends StatelessWidget {
  const _HomeWelcomeCard({
    required this.onExploreGraphs,
    required this.onOpenDashboard,
  });

  final VoidCallback onExploreGraphs;
  final VoidCallback onOpenDashboard;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return AppCard(
      padding: EdgeInsets.zero,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(context.radius.card),
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.bottomRight,
              colors: [
                colors.primary,
                Color.lerp(colors.primary, colors.tertiary, .38)!,
              ],
            ),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxWidth < 620;
              return Stack(
                children: [
                  Positioned(
                    right: compact ? -52 : 70,
                    top: -98,
                    child: _HeroOrb(
                      diameter: compact ? 220 : 280,
                      color: colors.onPrimary.withValues(alpha: .08),
                    ),
                  ),
                  Positioned(
                    right: compact ? 18 : 150,
                    bottom: -96,
                    child: _HeroOrb(
                      diameter: compact ? 150 : 190,
                      color: context.semanticColors.highlight.withValues(
                        alpha: .14,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(
                      compact ? context.spacing.lg : context.spacing.xl,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'NOEMA  ·  SEU ESPAÇO DE APRENDIZADO',
                                style: context.textTheme.labelLarge?.copyWith(
                                  color: colors.onPrimary.withValues(
                                    alpha: .78,
                                  ),
                                  letterSpacing: 1.1,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Conhecimento se constrói um passo de cada vez.',
                                style:
                                    (compact
                                            ? context.textTheme.headlineSmall
                                            : context.textTheme.headlineMedium)
                                        ?.copyWith(
                                          color: colors.onPrimary,
                                          fontWeight: FontWeight.w700,
                                        ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Retome uma revisão ou avance pelo próximo tópico recomendado.',
                                style: context.textTheme.bodyLarge?.copyWith(
                                  color: colors.onPrimary.withValues(
                                    alpha: .86,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 22),
                              Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                children: [
                                  FilledButton.icon(
                                    onPressed: onExploreGraphs,
                                    style: FilledButton.styleFrom(
                                      backgroundColor: colors.onPrimary,
                                      foregroundColor: colors.primary,
                                    ),
                                    icon: const Icon(
                                      Icons.account_tree_outlined,
                                    ),
                                    label: const RuntimeLocalizedText(
                                      'Explorar grafos',
                                    ),
                                  ),
                                  TextButton.icon(
                                    onPressed: onOpenDashboard,
                                    style: TextButton.styleFrom(
                                      foregroundColor: colors.onPrimary,
                                    ),
                                    icon: const Icon(Icons.insights_outlined),
                                    label: const RuntimeLocalizedText(
                                      'Ver progresso',
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        if (!compact) ...[
                          const SizedBox(width: 20),
                          Container(
                            width: 116,
                            height: 116,
                            decoration: BoxDecoration(
                              color: colors.onPrimary.withValues(alpha: .12),
                              borderRadius: BorderRadius.circular(36),
                              border: Border.all(
                                color: colors.onPrimary.withValues(alpha: .18),
                              ),
                            ),
                            child: Icon(
                              Icons.auto_awesome_rounded,
                              size: 56,
                              color: context.semanticColors.highlight,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _HeroOrb extends StatelessWidget {
  const _HeroOrb({required this.diameter, required this.color});

  final double diameter;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    width: diameter,
    height: diameter,
    decoration: BoxDecoration(shape: BoxShape.circle, color: color),
  );
}

class _HomeProgressOverview extends StatelessWidget {
  const _HomeProgressOverview({required this.summary});

  final AsyncValue<DomainDashboardSummary> summary;

  @override
  Widget build(BuildContext context) {
    return summary.when(
      loading: () => const LinearProgressIndicator(),
      error: (_, _) => const SizedBox.shrink(),
      data: (data) => LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 520;
          final tileWidth = compact
              ? (constraints.maxWidth - 12) / 2
              : (constraints.maxWidth - 24) / 3;
          final mastery = data.averageMastery == null
              ? '—'
              : '${(data.averageMastery! * 100).round()}%';
          final metrics = [
            _HomeMetric(
              icon: Icons.insights_outlined,
              label: 'Domínio médio',
              value: mastery,
              color: context.colors.primary,
            ),
            _HomeMetric(
              icon: Icons.check_circle_outline_rounded,
              label: 'Conceitos dominados',
              value: '${data.masteredConcepts}',
              color: context.semanticColors.success,
            ),
            _HomeMetric(
              icon: Icons.calendar_month_outlined,
              label: 'Dias com revisão',
              value: '${data.activeReviewDays}',
              color: context.semanticColors.accent,
            ),
          ];
          return Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              for (var index = 0; index < metrics.length; index++)
                SizedBox(
                  width: compact && index == 2
                      ? constraints.maxWidth
                      : tileWidth,
                  child: metrics[index],
                ),
            ],
          );
        },
      ),
    );
  }
}

class _HomeMetric extends StatelessWidget {
  const _HomeMetric({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: .12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(icon, color: color, size: 19),
                    ),
                    const Spacer(),
                    Text(value, style: context.textTheme.titleLarge),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  label,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.colors.onSurfaceVariant,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeReviewSummary extends ConsumerWidget {
  const _HomeReviewSummary({required this.queue});

  final AsyncValue<List<ExerciseReviewGroup>> queue;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    return AppCard(
      padding: const EdgeInsets.all(20),
      child: queue.when(
        loading: () => const _HomeReviewStatus(
          icon: Icons.hourglass_top_rounded,
          message: 'Preparando sua fila de revisões…',
        ),
        error: (_, _) => _HomeReviewError(
          onRetry: () => ref.invalidate(exerciseReviewQueueProvider),
        ),
        data: (groups) {
          final total = groups.fold<int>(
            0,
            (count, group) => count + group.items.length,
          );
          final hasDueReviews = total > 0;
          final statusColor = hasDueReviews
              ? context.semanticColors.warning
              : context.semanticColors.success;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: .12),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Icon(Icons.auto_stories_rounded, color: statusColor),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Revisões de hoje',
                          style: context.textTheme.titleMedium,
                        ),
                        Text(
                          hasDueReviews
                              ? '$total ${total == 1 ? 'exercício pronto' : 'exercícios prontos'}'
                              : 'Tudo em dia',
                          style: context.textTheme.bodySmall?.copyWith(
                            color: colors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (hasDueReviews)
                    CircleAvatar(
                      radius: 17,
                      backgroundColor: statusColor.withValues(alpha: .14),
                      foregroundColor: statusColor,
                      child: Text(
                        total > 99 ? '99+' : '$total',
                        style: context.textTheme.labelLarge?.copyWith(
                          color: statusColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                hasDueReviews
                    ? 'Reforce o que você já aprendeu com uma sessão curta.'
                    : 'Você está em dia com as revisões espaçadas.',
                style: context.textTheme.bodyMedium,
              ),
              if (groups.isNotEmpty) ...[
                const SizedBox(height: 14),
                for (final group in groups.take(2))
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      children: [
                        Icon(
                          Icons.subdirectory_arrow_right_rounded,
                          size: 17,
                          color: colors.onSurfaceVariant,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            '${group.graphTitle} · ${group.nodeTitle}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: context.textTheme.bodySmall,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
              const SizedBox(height: 14),
              FilledButton.tonalIcon(
                onPressed: () => context.go(
                  hasDueReviews ? RoutePaths.exerciseReview : RoutePaths.graphs,
                ),
                icon: Icon(
                  hasDueReviews
                      ? Icons.play_arrow_rounded
                      : Icons.account_tree_outlined,
                ),
                label: Text(
                  hasDueReviews ? 'Começar revisão' : 'Explorar grafos',
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _HomeReviewStatus extends StatelessWidget {
  const _HomeReviewStatus({required this.icon, required this.message});

  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Icon(icon, color: context.colors.primary),
      const SizedBox(width: 12),
      Expanded(child: Text(message)),
    ],
  );
}

class _HomeReviewError extends StatelessWidget {
  const _HomeReviewError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const _HomeReviewStatus(
        icon: Icons.error_outline_rounded,
        message: 'Não foi possível carregar as revisões.',
      ),
      Align(
        alignment: Alignment.centerRight,
        child: TextButton.icon(
          onPressed: onRetry,
          icon: const Icon(Icons.refresh_rounded),
          label: const RuntimeLocalizedText('Tentar novamente'),
        ),
      ),
    ],
  );
}

class _HomeGraphRecommendations extends StatelessWidget {
  const _HomeGraphRecommendations({
    required this.graphs,
    required this.onRetry,
  });

  final AsyncValue<List<_GraphRecommendation>> graphs;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(AppLayoutTokens.sectionPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(Icons.account_tree_outlined, color: context.colors.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Continue seus estudos',
                  style: context.textTheme.titleLarge,
                ),
              ),
              TextButton(
                onPressed: () => context.go(RoutePaths.graphs),
                child: const RuntimeLocalizedText('Ver grafos'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          graphs.when(
            loading: () => const LinearProgressIndicator(),
            error: (_, _) => _HomeReviewError(onRetry: onRetry),
            data: (items) => items.isEmpty
                ? _HomeEmptyGraphs(
                    onExplore: () => context.go(RoutePaths.graphs),
                  )
                : Column(
                    children: [
                      _FeaturedGraphRecommendation(graph: items.first),
                      for (final graph in items.skip(1).take(2))
                        _GraphRecommendationTile(graph: graph),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class _HomeEmptyGraphs extends StatelessWidget {
  const _HomeEmptyGraphs({required this.onExplore});

  final VoidCallback onExplore;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 20),
    child: Column(
      children: [
        Icon(
          Icons.account_tree_outlined,
          size: 36,
          color: context.colors.onSurfaceVariant,
        ),
        const SizedBox(height: 8),
        Text(
          'Seus próximos passos aparecem aqui.',
          style: context.textTheme.titleSmall,
        ),
        const SizedBox(height: 4),
        Text(
          'Crie ou importe um grafo para receber recomendações de estudo.',
          textAlign: TextAlign.center,
          style: context.textTheme.bodySmall?.copyWith(
            color: context.colors.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: onExplore,
          icon: const Icon(Icons.add_rounded),
          label: const RuntimeLocalizedText('Criar ou importar grafo'),
        ),
      ],
    ),
  );
}

class _FeaturedGraphRecommendation extends StatelessWidget {
  const _FeaturedGraphRecommendation({required this.graph});

  final _GraphRecommendation graph;

  @override
  Widget build(BuildContext context) {
    final recommendedNode = graph.recommendedNode;
    final progress = graph.nodeCount == 0
        ? 0.0
        : (graph.masteredCount / graph.nodeCount).clamp(0.0, 1.0).toDouble();
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Material(
        color: context.colors.primaryContainer,
        borderRadius: BorderRadius.circular(20),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => context.go(RoutePaths.graph(graph.id)),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Icon(
                      recommendedNode == null
                          ? Icons.auto_awesome_outlined
                          : Icons.lightbulb_outline_rounded,
                      color: context.colors.onPrimaryContainer,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        recommendedNode == null
                            ? 'Continue neste grafo'
                            : 'PRÓXIMO PASSO',
                        style: context.textTheme.labelLarge?.copyWith(
                          color: context.colors.onPrimaryContainer.withValues(
                            alpha: .76,
                          ),
                          letterSpacing: .8,
                        ),
                      ),
                    ),
                    const Icon(Icons.arrow_forward_rounded, size: 18),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  graph.title,
                  style: context.textTheme.titleLarge?.copyWith(
                    color: context.colors.onPrimaryContainer,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  recommendedNode != null
                      ? 'Estude agora · ${recommendedNode.title}'
                      : graph.hasUnresolvedNodes
                      ? 'Revise as relações para identificar o próximo tópico.'
                      : graph.nodeCount == 0
                      ? 'Adicione conceitos ao grafo para começar.'
                      : 'Todos os tópicos estão dominados.',
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: context.colors.onPrimaryContainer,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 8,
                    backgroundColor: context.colors.onPrimaryContainer
                        .withValues(alpha: .16),
                    color: context.colors.primary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${graph.masteredCount} de ${graph.nodeCount} tópicos dominados',
                  style: context.textTheme.labelMedium?.copyWith(
                    color: context.colors.onPrimaryContainer,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GraphRecommendationTile extends StatelessWidget {
  const _GraphRecommendationTile({required this.graph});

  final _GraphRecommendation graph;

  @override
  Widget build(BuildContext context) {
    final recommendedNode = graph.recommendedNode;
    final progress = graph.nodeCount == 0
        ? 0.0
        : (graph.masteredCount / graph.nodeCount).clamp(0.0, 1.0).toDouble();
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Material(
        color: context.colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => context.go(RoutePaths.graph(graph.id)),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        graph.title,
                        style: context.textTheme.titleMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Icon(Icons.arrow_forward_rounded, size: 20),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  recommendedNode != null
                      ? 'Estude agora · ${recommendedNode.title}'
                      : graph.hasUnresolvedNodes
                      ? 'Revise as relações para identificar o próximo tópico.'
                      : graph.nodeCount == 0
                      ? 'Adicione conceitos ao grafo.'
                      : 'Todos os tópicos estão dominados.',
                  style: context.textTheme.bodyMedium,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 6,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      '${graph.masteredCount}/${graph.nodeCount}',
                      style: context.textTheme.labelSmall,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HomeRecentActivity extends StatelessWidget {
  const _HomeRecentActivity({required this.summary});

  final AsyncValue<DomainDashboardSummary> summary;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(AppLayoutTokens.sectionPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(Icons.history_rounded, color: context.colors.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Atividade recente',
                  style: context.textTheme.titleLarge,
                ),
              ),
              TextButton(
                onPressed: () => context.go(RoutePaths.dashboard),
                child: const RuntimeLocalizedText('Ver painel'),
              ),
            ],
          ),
          summary.when(
            loading: () => const LinearProgressIndicator(),
            error: (error, _) => RuntimeLocalizedText(
              'Não foi possível carregar o histórico: $error',
            ),
            data: (data) => data.recentActivity.isEmpty
                ? const RuntimeLocalizedText('Suas atividades aparecerão aqui.')
                : Column(
                    children: [
                      for (final activity in data.recentActivity.take(4))
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(
                            Icons.check_circle_outline_rounded,
                          ),
                          title: Text(activity.nodeTitle),
                          subtitle: Text(
                            '${activity.graphTitle} · '
                            '${activity.activityType.isEmpty ? activity.eventOrigin : activity.activityType}',
                          ),
                          trailing: RuntimeLocalizedText(
                            '${(activity.score * 100).round()}%',
                          ),
                        ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class _AccountActions extends ConsumerWidget {
  const _AccountActions();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppCard(
      padding: const EdgeInsets.all(16),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final logout = OutlinedButton.icon(
            onPressed: () async {
              try {
                final localCleanupError = await endAccountSession(ref);
                if (!context.mounted) return;
                context.go(RoutePaths.login);
                if (localCleanupError != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'A sessão foi encerrada, mas o estado local '
                        'não pôde ser atualizado: $localCleanupError',
                      ),
                    ),
                  );
                }
              } catch (error) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: RuntimeLocalizedText(
                        'Não foi possível sair: $error',
                      ),
                    ),
                  );
                }
                return;
              }
            },
            icon: const Icon(Icons.logout),
            label: const RuntimeLocalizedText('Sair'),
          );
          if (constraints.maxWidth < 420) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const RuntimeLocalizedText('Sua área de estudos está pronta.'),
                const SizedBox(height: 8),
                Align(alignment: Alignment.centerRight, child: logout),
              ],
            );
          }
          return Row(
            children: [
              const Expanded(
                child: RuntimeLocalizedText('Sua área de estudos está pronta.'),
              ),
              logout,
            ],
          );
        },
      ),
    );
  }
}
