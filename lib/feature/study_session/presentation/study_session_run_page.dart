import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:noema/core/database/database.dart' hide OpenEnded;
import 'package:noema/core/database/database_provider.dart';
import 'package:noema/feature/exercises/multiple_choice/presentation/multiple_choice.dart';
import 'package:noema/feature/exercises/open_ended/presentation/open_ended.dart';
import 'package:noema/feature/config/providers/user_provider.dart';
import 'package:noema/feature/study_session/data/study_session_dao.dart';
import 'package:noema/feature/study_session/data/study_session_log_dao.dart';
import 'package:noema/feature/study_session/data/study_session_question_dao.dart';

class StudySessionRunPage extends ConsumerStatefulWidget {
  const StudySessionRunPage({super.key, required this.sessionId});

  final String sessionId;

  @override
  ConsumerState<StudySessionRunPage> createState() =>
      _StudySessionRunPageState();
}

class _StudySessionRunPageState extends ConsumerState<StudySessionRunPage> {
  StudySessionData? _session;
  List<StudySessionQuestionCandidate> _questions = [];
  String? _logId;
  String? _error;
  DateTime? _startedAt;
  int _currentIndex = 0;
  bool _isLoading = true;
  bool _isAdvancing = false;
  bool _isFinished = false;
  bool _isAbandoned = false;
  bool _isConfirmingExit = false;

  @override
  void initState() {
    super.initState();
    _startSession();
  }

  Future<void> _startSession() async {
    try {
      final db = ref.read(appDatabaseProvider);
      final user = await ref.read(userProvider.future);
      final session = await StudySessionDao(
        db,
      ).getStudySession(id: widget.sessionId);
      if (session == null ||
          session.softDeleted ||
          session.userId != user.id) {
        throw StateError('Esta sessão não existe ou foi arquivada.');
      }
      final questions = await StudySessionQuestionDao(
        db,
      ).getQuestionsBySession(studySessionId: widget.sessionId);
      if (questions.isEmpty) {
        throw StateError('Adicione pelo menos uma questão antes de começar.');
      }

      final startedAt = DateTime.now();
      final snapshot = jsonEncode({
        'targetDurationMin': session.targetDurationMin,
        'description': session.description,
        'interleavingEnabled': session.interleavingEnabled,
        'diagnosticFocus': session.diagnosticFocus,
        'questions': [
          for (final question in questions)
            {
              'id': question.id,
              'type': question.type.name,
              'title': question.title,
              'statement': question.statement,
              'nodeId': question.nodeId,
              'nodeTitle': question.nodeTitle,
            },
        ],
      });

      late final String logId;
      await db.transaction(() async {
        logId = await StudySessionLogDao(db).start(
          studySessionId: session.id,
          title: session.title,
          questionsSnapshot: snapshot,
        );
        await StudySessionDao(
          db,
        ).markSessionStarted(id: session.id, totalActivities: questions.length);
      });
      if (!mounted) return;
      setState(() {
        _session = session;
        _questions = questions;
        _logId = logId;
        _startedAt = startedAt;
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _error = error.toString().replaceFirst('Bad state: ', '');
        _isLoading = false;
      });
    }
  }

  int get _elapsedMinutes {
    final startedAt = _startedAt;
    if (startedAt == null) return 0;
    final elapsedSeconds = DateTime.now().difference(startedAt).inSeconds;
    return (elapsedSeconds / 60).ceil();
  }

  Future<void> _advance() async {
    if (_isAdvancing || _isFinished || _isAbandoned) return;
    final logId = _logId;
    final session = _session;
    if (logId == null || session == null) return;
    setState(() => _isAdvancing = true);

    final completed = _currentIndex + 1;
    final durationMinutes = _elapsedMinutes;
    try {
      final db = ref.read(appDatabaseProvider);
      if (completed == _questions.length) {
        await db.transaction(() async {
          await StudySessionLogDao(db).finish(
            id: logId,
            status: 'COMPLETED',
            completedActivities: completed,
            totalActivities: _questions.length,
            actualDurationMin: durationMinutes,
          );
          await StudySessionDao(db).markSessionCompleted(
            id: session.id,
            actualDurationMin: durationMinutes,
            completedActivities: completed,
            totalActivities: _questions.length,
          );
        });
        if (!mounted) return;
        setState(() {
          _currentIndex = completed;
          _isFinished = true;
          _isAdvancing = false;
        });
      } else {
        await db.transaction(() async {
          await StudySessionLogDao(
            db,
          ).updateProgress(id: logId, completedActivities: completed);
          await StudySessionDao(db).updateSessionProgress(
            id: session.id,
            completedActivities: completed,
          );
        });
        if (!mounted) return;
        setState(() {
          _currentIndex = completed;
          _isAdvancing = false;
        });
      }
    } catch (error) {
      if (!mounted) return;
      setState(() => _isAdvancing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Não foi possível atualizar o progresso: $error'),
        ),
      );
    }
  }

  Future<void> _leaveSession() async {
    if (_isAdvancing) return;
    if (_isFinished || _isAbandoned) {
      if (mounted) context.pop();
      return;
    }
    if (_isConfirmingExit || _logId == null) return;
    _isConfirmingExit = true;
    final shouldLeave = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Interromper sessão?'),
        content: const Text(
          'O progresso desta realização será salvo no histórico.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Continuar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Interromper'),
          ),
        ],
      ),
    );
    _isConfirmingExit = false;
    if (shouldLeave != true || !mounted) return;

    try {
      final db = ref.read(appDatabaseProvider);
      await db.transaction(() async {
        await StudySessionLogDao(db).finish(
          id: _logId!,
          status: 'ABANDONED',
          completedActivities: _currentIndex,
          totalActivities: _questions.length,
          actualDurationMin: _elapsedMinutes,
        );
        await StudySessionDao(db).markSessionAbandoned(
          id: widget.sessionId,
          completedActivities: _currentIndex,
        );
      });
      if (!mounted) return;
      setState(() => _isAbandoned = true);
      context.pop();
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Não foi possível salvar a interrupção: $error'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (_error != null || _session == null) {
      return Scaffold(
        appBar: AppBar(leading: const BackButton()),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.info_outline, size: 36),
                const SizedBox(height: 12),
                Text(
                  _error ?? 'Não foi possível iniciar esta sessão.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () => context.pop(),
                  child: const Text('Voltar'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return PopScope(
      canPop: _isFinished || _isAbandoned,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) unawaited(_leaveSession());
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            tooltip: 'Sair da sessão',
            onPressed: _isAdvancing ? null : _leaveSession,
            icon: const Icon(Icons.close),
          ),
          title: Text(
            _session!.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: _isFinished
              ? Center(
                  child: SingleChildScrollView(
                    child: _CompletionCard(
                      title: _session!.title,
                      completed: _questions.length,
                      durationMinutes: _elapsedMinutes,
                      onClose: () => context.pop(),
                    ),
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    LinearProgressIndicator(
                      value: _currentIndex / _questions.length,
                      minHeight: 8,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Questão ${_currentIndex + 1} de ${_questions.length}',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: _buildCurrentQuestion(),
                        ),
                      ),
                    ),
                    if (_isAdvancing)
                      const Padding(
                        padding: EdgeInsets.only(top: 12),
                        child: LinearProgressIndicator(),
                      ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildCurrentQuestion() {
    final question = _questions[_currentIndex];
    final logId = _logId!;
    return switch (question.type) {
      StudySessionQuestionType.multipleChoice => MultipleChoise(
        key: ValueKey('mc:${question.id}:$_currentIndex'),
        nodeId: question.nodeId,
        multipleChoiseId: question.id,
        studySessionId: widget.sessionId,
        studySessionLogId: logId,
        defaultMode: 2,
        onSendAnswer: _advance,
      ),
      StudySessionQuestionType.openEnded => OpenEnded(
        key: ValueKey('oe:${question.id}:$_currentIndex'),
        nodeId: question.nodeId,
        openEndedId: question.id,
        studySessionId: widget.sessionId,
        studySessionLogId: logId,
        defaultMode: 2,
        onSendAnswer: _advance,
      ),
    };
  }
}

class _CompletionCard extends StatelessWidget {
  const _CompletionCard({
    required this.title,
    required this.completed,
    required this.durationMinutes,
    required this.onClose,
  });

  final String title;
  final int completed;
  final int durationMinutes;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Icon(
              Icons.task_alt_rounded,
              size: 56,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 12),
            Text(
              'Sessão concluída!',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              '$title · $completed questões · $durationMinutes min',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: onClose,
              child: const Text('Ver histórico da sessão'),
            ),
          ],
        ),
      ),
    );
  }
}
