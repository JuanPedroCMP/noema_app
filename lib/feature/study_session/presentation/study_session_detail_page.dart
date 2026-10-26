import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:noema/core/database/database.dart';
import 'package:noema/core/database/database_provider.dart';
import 'package:noema/core/router/route_paths.dart';
import 'package:noema/feature/config/providers/user_provider.dart';
import 'package:noema/feature/graph/data/graph_node_dao.dart';
import 'package:noema/feature/study_session/data/study_session_dao.dart';
import 'package:noema/feature/study_session/data/study_session_log_dao.dart';
import 'package:noema/feature/study_session/data/study_session_question_dao.dart';

class StudySessionDetailPage extends ConsumerStatefulWidget {
  const StudySessionDetailPage({super.key, required this.sessionId});

  final String sessionId;

  @override
  ConsumerState<StudySessionDetailPage> createState() =>
      _StudySessionDetailPageState();
}

class _StudySessionDetailPageState
    extends ConsumerState<StudySessionDetailPage> {
  StudySessionData? _session;
  List<StudySessionQuestionCandidate> _questions = [];
  List<StudySessionLogData> _history = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final db = ref.read(appDatabaseProvider);
      final sessionDao = StudySessionDao(db);
      final user = await ref.read(userProvider.future);
      final session = await sessionDao.getStudySession(id: widget.sessionId);
      if (session == null || session.softDeleted || session.userId != user.id) {
        throw StateError('Esta sessão não existe ou foi arquivada.');
      }
      final results = await Future.wait([
        StudySessionQuestionDao(
          db,
        ).getQuestionsBySession(studySessionId: widget.sessionId),
        StudySessionLogDao(db).getBySession(studySessionId: widget.sessionId),
      ]);
      if (!mounted) return;
      setState(() {
        _session = session;
        _questions = results[0] as List<StudySessionQuestionCandidate>;
        _history = results[1] as List<StudySessionLogData>;
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _error = 'Não foi possível abrir esta sessão: $error';
        _isLoading = false;
      });
    }
  }

  Future<void> _archiveSession() async {
    final session = _session;
    if (session == null) return;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Arquivar sessão?'),
        content: Text('“${session.title}” sairá da sua lista.'),
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
      if (mounted) context.pop();
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Não foi possível arquivar a sessão: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final session = _session;
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (_error != null || session == null) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(_error ?? 'Sessão não encontrada.'),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: _load,
                  child: const Text('Tentar novamente'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _load,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      session.title,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    if ((session.description ?? '').trim().isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(session.description!),
                    ],
                    const SizedBox(height: 14),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        Chip(
                          avatar: const Icon(Icons.timer_outlined, size: 18),
                          label: Text('${session.targetDurationMin} min'),
                        ),
                        Chip(
                          avatar: const Icon(
                            Icons.format_list_numbered,
                            size: 18,
                          ),
                          label: Text('${_questions.length} questões'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: _questions.isEmpty ? null : _runSession,
                            icon: const Icon(Icons.play_arrow_rounded),
                            label: const Text('Começar sessão'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          tooltip:
                              _history.any((log) => log.status == 'IN_PROGRESS')
                              ? 'Interrompa a realização ativa para editar'
                              : 'Editar sessão',
                          onPressed:
                              _history.any((log) => log.status == 'IN_PROGRESS')
                              ? null
                              : _editSession,
                          icon: const Icon(Icons.edit_outlined),
                        ),
                        IconButton(
                          tooltip: 'Arquivar sessão',
                          onPressed: _archiveSession,
                          icon: const Icon(Icons.archive_outlined),
                        ),
                      ],
                    ),
                    if (_questions.isEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          'Esta sessão ainda não tem questões. '
                          'Você pode arquivá-la ou criar outra com questões.',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    if (_sessionStatusHint(session.status).isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          _sessionStatusHint(session.status),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Sequência de questões',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            if (_questions.isEmpty)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(18),
                  child: Text('Nenhuma questão foi adicionada a esta sessão.'),
                ),
              )
            else
              for (var index = 0; index < _questions.length; index++)
                Card(
                  child: ListTile(
                    leading: CircleAvatar(child: Text('${index + 1}')),
                    title: Text(_questions[index].title),
                    subtitle: Text(
                      '${_questions[index].nodeTitle} · '
                      '${_questionTypeLabel(_questions[index].type)}',
                    ),
                    trailing: IconButton(
                      tooltip: 'Editar exercício',
                      onPressed: () => _editQuestion(_questions[index]),
                      icon: const Icon(Icons.edit_outlined),
                    ),
                  ),
                ),
            const SizedBox(height: 20),
            Text(
              'Histórico de realizações',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            if (_history.isEmpty)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(18),
                  child: Text(
                    'As realizações concluídas ou interrompidas aparecerão aqui.',
                  ),
                ),
              )
            else
              for (final log in _history)
                Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Icon(
                        log.status == 'COMPLETED'
                            ? Icons.check_rounded
                            : log.status == 'ABANDONED'
                            ? Icons.pause_rounded
                            : Icons.more_time_rounded,
                      ),
                    ),
                    title: Text(_logStatus(log.status)),
                    subtitle: Text(
                      '${_formatTimestamp(log.startedAt)} · '
                      '${log.completedActivities}/${log.totalActivities} questões'
                      '${log.actualDurationMin == null ? '' : ' · ${log.actualDurationMin} min'}'
                      '${log.endedAt == null ? '' : ' · Finalizada ${_formatTimestamp(log.endedAt!)}'}',
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _showRunSnapshot(log),
                  ),
                ),
          ],
        ),
      ),
    );
  }

  Future<void> _showRunSnapshot(StudySessionLogData log) async {
    final snapshot = log.questionsSnapshot;
    List<StudySessionAnswerLog> answers;
    try {
      answers = await StudySessionLogDao(
        ref.read(appDatabaseProvider),
      ).getAnswerDetails(studySessionLogId: log.id);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Não foi possível carregar as respostas: $error'),
        ),
      );
      return;
    }
    if (!mounted) return;
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) {
        final runSnapshot = _decodeSnapshot(snapshot);
        final decoded = runSnapshot.questions;
        final answersByQuestion = {
          for (final answer in answers) answer.questionId: answer,
        };
        final scoredAnswers = answers
            .where((answer) => answer.score != null)
            .toList();
        final averageScore = scoredAnswers.isEmpty
            ? null
            : scoredAnswers
                      .map((answer) => answer.score!)
                      .reduce((first, second) => first + second) /
                  scoredAnswers.length;
        final totalSeconds = log.endedAt == null
            ? null
            : log.endedAt! - log.startedAt;
        return SafeArea(
          child: SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.78,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    log.sessionTitleSnapshot,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      Chip(
                        avatar: const Icon(Icons.flag_outlined, size: 18),
                        label: Text(_logStatus(log.status)),
                      ),
                      Chip(
                        avatar: const Icon(Icons.play_arrow_rounded, size: 18),
                        label: Text(_formatTimestamp(log.startedAt)),
                      ),
                      if (totalSeconds != null)
                        Chip(
                          avatar: const Icon(Icons.timer_outlined, size: 18),
                          label: Text(_formatElapsed(totalSeconds)),
                        ),
                      if (runSnapshot.targetDurationMin != null)
                        Chip(
                          avatar: const Icon(Icons.flag_outlined, size: 18),
                          label: Text(
                            '${runSnapshot.targetDurationMin} min planejados',
                          ),
                        ),
                      Chip(
                        avatar: const Icon(Icons.checklist_rounded, size: 18),
                        label: Text(
                          '${log.completedActivities}/${log.totalActivities} concluídas',
                        ),
                      ),
                      if (answers.isNotEmpty)
                        Chip(
                          avatar: const Icon(Icons.history_rounded, size: 18),
                          label: Text(
                            '${answers.length} respostas registradas',
                          ),
                        ),
                      if (averageScore != null)
                        Chip(
                          avatar: const Icon(Icons.insights_rounded, size: 18),
                          label: Text('Média ${(averageScore * 100).round()}%'),
                        ),
                    ],
                  ),
                  if ((runSnapshot.description ?? '').trim().isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(runSnapshot.description!),
                  ],
                  if (runSnapshot.interleavingEnabled == true ||
                      runSnapshot.diagnosticFocus == true) ...[
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 8,
                      children: [
                        if (runSnapshot.interleavingEnabled == true)
                          const Chip(label: Text('Intercalamento')),
                        if (runSnapshot.diagnosticFocus == true)
                          const Chip(label: Text('Foco diagnóstico')),
                      ],
                    ),
                  ],
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView(
                      children: [
                        for (var index = 0; index < decoded.length; index++)
                          _QuestionRunLogCard(
                            number: index + 1,
                            snapshot: decoded[index],
                            answer: answersByQuestion[decoded[index]['id']],
                          ),
                        if (decoded.isEmpty)
                          const Card(
                            child: ListTile(
                              title: Text('Sem snapshot de questões'),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _editSession() async {
    await context.push(RoutePaths.studySessionEdit(widget.sessionId));
    if (mounted) await _load();
  }

  Future<void> _editQuestion(StudySessionQuestionCandidate question) async {
    try {
      final node = await GraphNodeDao(
        ref.read(appDatabaseProvider),
      ).getGraphNode(id: question.nodeId);
      if (!mounted) return;
      if (node == null || node.softDeleted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('O node deste exercício não está disponível.'),
          ),
        );
        return;
      }
      final path = question.type == StudySessionQuestionType.multipleChoice
          ? RoutePaths.multipleChoiceEdit(node.graphId, node.id, question.id)
          : RoutePaths.openEndedEdit(node.graphId, node.id, question.id);
      await context.push(path);
      if (mounted) await _load();
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Não foi possível abrir o exercício: $error')),
      );
    }
  }

  Future<void> _runSession() async {
    final session = _session;
    if (session == null) return;
    await context.push(RoutePaths.studySessionRun(session.id));
    if (mounted) await _load();
  }
}

class _SessionRunSnapshot {
  const _SessionRunSnapshot({
    required this.questions,
    this.targetDurationMin,
    this.description,
    this.interleavingEnabled,
    this.diagnosticFocus,
  });

  final List<Map<String, dynamic>> questions;
  final int? targetDurationMin;
  final String? description;
  final bool? interleavingEnabled;
  final bool? diagnosticFocus;
}

_SessionRunSnapshot _decodeSnapshot(String raw) {
  try {
    final decoded = jsonDecode(raw);
    if (decoded is List) {
      return _SessionRunSnapshot(
        questions: decoded.whereType<Map<String, dynamic>>().toList(),
      );
    }
    if (decoded is Map<String, dynamic>) {
      final rawQuestions = decoded['questions'];
      return _SessionRunSnapshot(
        questions: rawQuestions is List
            ? rawQuestions.whereType<Map<String, dynamic>>().toList()
            : const [],
        targetDurationMin: decoded['targetDurationMin'] is int
            ? decoded['targetDurationMin'] as int
            : null,
        description: decoded['description'] as String?,
        interleavingEnabled: decoded['interleavingEnabled'] as bool?,
        diagnosticFocus: decoded['diagnosticFocus'] as bool?,
      );
    }
    return const _SessionRunSnapshot(questions: []);
  } catch (_) {
    return const _SessionRunSnapshot(questions: []);
  }
}

String _questionTypeLabel(StudySessionQuestionType type) => switch (type) {
  StudySessionQuestionType.multipleChoice => 'Múltipla escolha',
  StudySessionQuestionType.openEnded => 'Dissertativa',
};

String _logStatus(String status) => switch (status) {
  'COMPLETED' => 'Concluída',
  'ABANDONED' => 'Interrompida',
  _ => 'Em andamento',
};

String _sessionStatusHint(String status) => switch (status) {
  'COMPLETED' =>
    'Sessão concluída anteriormente. Você pode executá-la novamente.',
  'ABANDONED' =>
    'A última realização foi interrompida; ela continua disponível no histórico.',
  'IN_PROGRESS' => 'Há uma realização em andamento para esta sessão.',
  _ => '',
};

String _formatElapsed(int seconds) {
  final minutes = seconds ~/ 60;
  final remainingSeconds = seconds % 60;
  if (minutes == 0) return '$remainingSeconds s';
  return remainingSeconds == 0
      ? '$minutes min'
      : '$minutes min $remainingSeconds s';
}

class _QuestionRunLogCard extends StatelessWidget {
  const _QuestionRunLogCard({
    required this.number,
    required this.snapshot,
    required this.answer,
  });

  final int number;
  final Map<String, dynamic> snapshot;
  final StudySessionAnswerLog? answer;

  @override
  Widget build(BuildContext context) {
    final isMultipleChoice =
        snapshot['type'] == 'multipleChoice' ||
        answer?.type == 'MULTIPLE_CHOICE';
    final title = snapshot['title']?.toString() ?? answer?.title ?? 'Questão';
    final subtitle = [
      snapshot['nodeTitle']?.toString(),
      isMultipleChoice ? 'Múltipla escolha' : 'Dissertativa',
      if (answer != null)
        'Respondida às ${_formatTimestamp(answer!.answeredAt)}',
      if (answer == null) 'Não respondida',
    ].whereType<String>().where((value) => value.isNotEmpty).join(' · ');

    return Card(
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        leading: CircleAvatar(child: Text('$number')),
        title: Text(title),
        subtitle: Text(subtitle),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if ((snapshot['statement']?.toString() ?? '').isNotEmpty) ...[
            Text(
              snapshot['statement'].toString(),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
          ],
          if (answer == null)
            const ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.hourglass_empty_rounded),
              title: Text('Nenhuma resposta registrada nesta realização.'),
            )
          else if (isMultipleChoice)
            _multipleChoiceAnswer(context)
          else
            _openEndedAnswer(context),
          if ((answer?.feedback ?? '').trim().isNotEmpty) ...[
            const Divider(height: 24),
            Text('Feedback', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 4),
            SelectableText(answer!.feedback!),
          ],
          if ((answer?.notes ?? '').trim().isNotEmpty) ...[
            const SizedBox(height: 12),
            Text('Anotações', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 4),
            SelectableText(answer!.notes!),
          ],
        ],
      ),
    );
  }

  Widget _multipleChoiceAnswer(BuildContext context) {
    final currentAnswer = answer!;
    final selectedIds = _decodeStringSet(currentAnswer.selectedChoiceIds);
    final choices = _decodeChoiceSnapshot(currentAnswer.questionChoiceSnapshot);
    final score = currentAnswer.score;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            if (currentAnswer.correctSelected != null &&
                currentAnswer.totalCorrectOption != null)
              Chip(
                avatar: const Icon(Icons.check_circle_outline, size: 18),
                label: Text(
                  '${currentAnswer.correctSelected}/'
                  '${currentAnswer.totalCorrectOption} corretas',
                ),
              ),
            if (currentAnswer.wrongSelected != null)
              Chip(
                avatar: const Icon(Icons.close_rounded, size: 18),
                label: Text('${currentAnswer.wrongSelected} incorretas'),
              ),
            if (score != null)
              Chip(label: Text('Aproveitamento ${(score * 100).round()}%')),
          ],
        ),
        const SizedBox(height: 8),
        for (final choice in choices)
          ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            leading: Icon(
              choice['is_correct'] == true
                  ? Icons.check_circle_rounded
                  : selectedIds.contains(choice['id']?.toString())
                  ? Icons.cancel_rounded
                  : Icons.radio_button_unchecked_rounded,
              color: choice['is_correct'] == true
                  ? Theme.of(context).colorScheme.primary
                  : selectedIds.contains(choice['id']?.toString())
                  ? Theme.of(context).colorScheme.error
                  : Theme.of(context).colorScheme.outline,
            ),
            title: Text(choice['statement']?.toString() ?? ''),
            subtitle: selectedIds.contains(choice['id']?.toString())
                ? const Text('Selecionada')
                : null,
          ),
      ],
    );
  }

  Widget _openEndedAnswer(BuildContext context) {
    final text = answer?.userAnswer?.trim();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Resposta registrada',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 6),
        SelectableText(
          text == null || text.isEmpty ? 'Resposta vazia.' : text,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        if (answer?.score != null) ...[
          const SizedBox(height: 8),
          Text('Pontuação: ${answer!.score}'),
        ],
      ],
    );
  }
}

Set<String> _decodeStringSet(String? raw) {
  if (raw == null) return const {};
  try {
    final value = jsonDecode(raw);
    return value is List ? value.whereType<String>().toSet() : const {};
  } on FormatException {
    return const {};
  }
}

List<Map<String, dynamic>> _decodeChoiceSnapshot(String? raw) {
  if (raw == null) return const [];
  try {
    final value = jsonDecode(raw);
    if (value is! List) return const [];
    return value
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  } on FormatException {
    return const [];
  } on TypeError {
    return const [];
  }
}

String _formatTimestamp(int timestamp) {
  final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000).toLocal();
  final day = date.day.toString().padLeft(2, '0');
  final month = date.month.toString().padLeft(2, '0');
  final hour = date.hour.toString().padLeft(2, '0');
  final minute = date.minute.toString().padLeft(2, '0');
  return '$day/$month/${date.year} às $hour:$minute';
}
