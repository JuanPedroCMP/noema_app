import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:noema/core/database/database.dart';
import 'package:noema/core/database/database_provider.dart';
import 'package:noema/core/design/tokens/layout.dart';
import 'package:noema/core/design/theme/theme_tokens.dart';
import 'package:noema/core/network/api_client.dart';
import 'package:noema/core/router/route_paths.dart';
import 'package:noema/feature/auth/providers/account_state.dart';
import 'package:noema/feature/auth/providers/auth_state_provider.dart';
import 'package:noema/feature/config/data/user_dao.dart';
import 'package:noema/feature/config/providers/user_provider.dart';
import 'package:noema/feature/auth/services/login_service.dart';
import 'package:noema/feature/graph/service/learning_path.dart';
import 'package:noema/feature/review/data/domain_dashboard_service.dart';
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
    return AppResponsiveContent(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: context.spacing.lg,
          children: [
            AppPageHeader(
              title: 'Continue seu aprendizado',
              subtitle: 'Revise o que aprendeu e avance no próximo tópico.',
              actions: [
                TextButton.icon(
                  onPressed: () => context.go(RoutePaths.dashboard),
                  icon: const Icon(Icons.insights_outlined),
                  label: const Text('Painel'),
                ),
              ],
            ),
            const ExerciseReviewQueueSection(compact: true),
            _HomeGraphRecommendations(graphs: graphs),
            _HomeRecentActivity(summary: dashboard),
            AppCard(
              padding: EdgeInsets.zero,
              onTap: () => context.go(RoutePaths.studySessions),
              child: const ListTile(
                leading: Icon(Icons.playlist_add_check_circle_outlined),
                title: Text('Sessões de estudo'),
                subtitle: Text('Organize atividades e acompanhe cada sessão.'),
                trailing: Icon(Icons.chevron_right),
              ),
            ),
            _AccountActions(),
          ],
        ),
      ),
    );
  }
}

class _HomeGraphRecommendations extends StatelessWidget {
  const _HomeGraphRecommendations({required this.graphs});

  final AsyncValue<List<_GraphRecommendation>> graphs;

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
                  'Seu próximo passo',
                  style: context.textTheme.titleLarge,
                ),
              ),
              TextButton(
                onPressed: () => context.go(RoutePaths.graphs),
                child: const Text('Ver grafos'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          graphs.when(
            loading: () => const LinearProgressIndicator(),
            error: (error, _) =>
                Text('Não foi possível carregar recomendações: $error'),
            data: (items) => items.isEmpty
                ? const Text(
                    'Crie ou importe um grafo para receber recomendações.',
                  )
                : Column(
                    children: [
                      for (final graph in items.take(4))
                        _GraphRecommendationTile(graph: graph),
                    ],
                  ),
          ),
        ],
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
        : graph.masteredCount / graph.nodeCount;
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
                const SizedBox(height: 10),
                LinearProgressIndicator(value: progress.clamp(0.0, 1.0)),
                const SizedBox(height: 4),
                Text(
                  '${graph.masteredCount} de ${graph.nodeCount} tópicos dominados',
                  style: context.textTheme.labelSmall,
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
                child: const Text('Ver painel'),
              ),
            ],
          ),
          summary.when(
            loading: () => const LinearProgressIndicator(),
            error: (error, _) =>
                Text('Não foi possível carregar o histórico: $error'),
            data: (data) => data.recentActivity.isEmpty
                ? const Text('Suas atividades aparecerão aqui.')
                : Column(
                    children: [
                      for (final activity in data.recentActivity.take(5))
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
                          trailing: Text('${(activity.score * 100).round()}%'),
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
    final storage = ref.read(secureSorageProvider);
    return AppCard(
      padding: const EdgeInsets.all(16),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final logout = OutlinedButton.icon(
            onPressed: () async {
              try {
                await storage.delete(key: 'access_token');
                await storage.delete(key: 'access_token_remote_owner_id');
                await storage.delete(key: 'access_token_remote_onwer_id');
              } catch (error) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Não foi possível sair: $error')),
                  );
                }
                return;
              }
              clearApiAccessToken(ref.read(apiClientProvider));
              try {
                await AppUserDao(
                  ref.read(appDatabaseProvider),
                ).deactivateAllUsers();
              } catch (error) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'A sessão foi encerrada, mas o estado local '
                        'não pôde ser atualizado: $error',
                      ),
                    ),
                  );
                }
              } finally {
                resetAccountScopedState(ref);
                ref.invalidate(authStateProvider);
                if (context.mounted) context.go(RoutePaths.login);
              }
            },
            icon: const Icon(Icons.logout),
            label: const Text('Sair'),
          );
          if (constraints.maxWidth < 420) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('Sua área de estudos está pronta.'),
                const SizedBox(height: 8),
                Align(alignment: Alignment.centerRight, child: logout),
              ],
            );
          }
          return Row(
            children: [
              const Expanded(child: Text('Sua área de estudos está pronta.')),
              logout,
            ],
          );
        },
      ),
    );
  }
}
