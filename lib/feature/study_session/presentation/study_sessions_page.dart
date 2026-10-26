import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:noema/core/database/database.dart';
import 'package:noema/core/database/database_provider.dart';
import 'package:noema/core/router/route_paths.dart';
import 'package:noema/feature/config/providers/user_provider.dart';
import 'package:noema/feature/study_session/data/study_session_dao.dart';

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
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _error = 'Não foi possível carregar as sessões: $error';
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
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
          children: [
            Text(
              'Agrupe questões de múltipla escolha e dissertativas, '
              'e acompanhe cada vez que realizar uma sessão.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 20),
            if (_isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: CircularProgressIndicator(),
                ),
              )
            else if (_error != null)
              _LoadError(message: _error!, onRetry: _loadSessions)
            else if (_sessions.isEmpty)
              const _EmptySessions()
            else
              for (final session in _sessions)
                Card(
                  clipBehavior: Clip.antiAlias,
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 10,
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
                      padding: const EdgeInsets.only(top: 6),
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
    );
  }
}

String _sessionStatus(String status) => switch (status) {
  'COMPLETED' => 'Concluída',
  'IN_PROGRESS' => 'Em andamento',
  'ABANDONED' => 'Interrompida',
  _ => 'Rascunho',
};

class _EmptySessions extends StatelessWidget {
  const _EmptySessions();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          children: [
            const Icon(Icons.playlist_add_check_rounded, size: 44),
            const SizedBox(height: 12),
            Text(
              'Nenhuma sessão criada',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 6),
            const Text(
              'Crie uma sessão com título e, se quiser, escolha questões '
              'para praticar em uma sequência.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _LoadError extends StatelessWidget {
  const _LoadError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.error_outline),
        title: Text(message),
        trailing: IconButton(
          tooltip: 'Tentar novamente',
          onPressed: onRetry,
          icon: const Icon(Icons.refresh),
        ),
      ),
    );
  }
}
