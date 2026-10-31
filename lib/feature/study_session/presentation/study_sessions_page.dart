import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:noema/core/database/database.dart';
import 'package:noema/core/database/database_provider.dart';
import 'package:noema/core/design/tokens/layout.dart';
import 'package:noema/core/design/theme/theme_tokens.dart';
import 'package:noema/core/router/route_paths.dart';
import 'package:noema/feature/config/providers/user_provider.dart';
import 'package:noema/feature/study_session/data/study_session_dao.dart';
import 'package:noema/shared/widgets/async_state_view.dart';
import 'package:noema/shared/widgets/responsive_content.dart';

class StudySessionsPage extends ConsumerStatefulWidget {
  const StudySessionsPage({super.key});

  @override
  ConsumerState<StudySessionsPage> createState() => _StudySessionsPageState();
}

class _StudySessionsPageState extends ConsumerState<StudySessionsPage> {
  List<StudySessionData> _sessions = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadSessions();
  }

  Future<void> _loadSessions() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final user = await ref.read(userProvider.future);
      final sessions = await StudySessionDao(
        ref.read(appDatabaseProvider),
      ).getStudySessionsByUser(userId: user.id);
      if (!mounted) return;
      setState(() {
        _sessions = sessions;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _error = 'Não foi possível carregar as sessões.';
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteSession(StudySessionData session) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Arquivar sessão?'),
        content: Text('“${session.title}” sairá da sua lista de sessões.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Arquivar'),
          ),
        ],
      ),
    );
    if (confirm != true) return;

    try {
      await StudySessionDao(
        ref.read(appDatabaseProvider),
      ).deleteStudySession(id: session.id);
      await _loadSessions();
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Não foi possível arquivar a sessão: $error')),
      );
    }
  }

  Future<void> _createSession() async {
    await context.push<String>(RoutePaths.studySessionCreate());
    if (mounted) await _loadSessions();
  }

  Future<void> _openSession(StudySessionData session) async {
    await context.push(RoutePaths.studySession(session.id));
    if (mounted) await _loadSessions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _createSession,
        icon: const Icon(Icons.add),
        label: const Text('Nova sessão'),
      ),
      body: RefreshIndicator(
        onRefresh: _loadSessions,
        child: AppResponsiveContent(
          maxWidth: AppLayoutTokens.pageContentWidth,
          child: ListView(
            padding: const EdgeInsets.only(
              bottom: AppLayoutTokens.floatingActionClearance,
            ),
            children: [
              AppPageHeader(
                title: 'Sessões de estudo',
                subtitle:
                    'Agrupe questões e acompanhe cada realização em uma sequência.',
              ),
              SizedBox(height: context.spacing.lg),
              if (_isLoading)
                const SizedBox(
                  height: 180,
                  child: AppLoadingView(label: 'Carregando sessões...'),
                )
              else if (_error != null)
                AppErrorView(message: _error!, onRetry: _loadSessions)
              else if (_sessions.isEmpty)
                const AppEmptyView(
                  icon: Icons.playlist_add_check_rounded,
                  title: 'Nenhuma sessão criada',
                  message:
                      'Crie uma sessão e escolha questões para praticar em uma sequência.',
                )
              else
                for (final session in _sessions)
                  Card(
                    clipBehavior: Clip.antiAlias,
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: AppLayoutTokens.listItemHorizontalPadding,
                        vertical: AppLayoutTokens.listItemVerticalPadding,
                      ),
                      leading: const CircleAvatar(
                        child: Icon(Icons.playlist_add_check_rounded),
                      ),
                      title: Text(
                        session.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Padding(
                        padding: EdgeInsets.only(top: context.spacing.xs + 2),
                        child: Text(
                          [
                            _sessionStatus(session.status),
                            '${session.targetDurationMin} min planejados',
                            if ((session.description ?? '').trim().isNotEmpty)
                              session.description!.trim(),
                          ].join(' · '),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      trailing: PopupMenuButton<String>(
                        tooltip: 'Ações da sessão',
                        onSelected: (action) {
                          if (action == 'archive') _deleteSession(session);
                        },
                        itemBuilder: (context) => const [
                          PopupMenuItem(
                            value: 'archive',
                            child: Text('Arquivar'),
                          ),
                        ],
                      ),
                      onTap: () => _openSession(session),
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}

String _sessionStatus(String status) => switch (status) {
  'COMPLETED' => 'Concluída',
  'IN_PROGRESS' => 'Em andamento',
  'ABANDONED' => 'Interrompida',
  _ => 'Rascunho',
};
