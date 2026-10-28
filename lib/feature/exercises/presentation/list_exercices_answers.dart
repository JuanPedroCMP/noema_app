import 'dart:convert';

import 'package:drift/drift.dart' show OrderingTerm, innerJoin;
import 'package:fsrs/fsrs.dart' as fsrs;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:noema/core/database/database.dart' hide OpenEnded;
import 'package:noema/core/database/database_provider.dart';
import 'package:noema/core/design/theme/theme_tokens.dart';
import 'package:noema/feature/ai/models/ai_agent_task.dart';
import 'package:noema/feature/ai/services/ai_content_generation_service.dart';
import 'package:noema/feature/config/providers/user_provider.dart';
import 'package:noema/feature/exercises/multiple_choice/data/multiple_choice_response_log_dao.dart';
import 'package:noema/feature/exercises/open_ended/data/open_ended_response_log_dao.dart';
import 'package:noema/feature/exercises/presentation/exercise_correction_dialog.dart';
import 'package:noema/feature/graph/data/graph_access.dart';
import 'package:noema/feature/review/data/fsrs_review_service.dart';

class ExercicesAnswerList extends ConsumerStatefulWidget {
  const ExercicesAnswerList({super.key, required this.nodeId});

  final String nodeId;

  @override
  ConsumerState<ExercicesAnswerList> createState() => _ExercicesAnswerList();
}

class _ExercicesAnswerList extends ConsumerState<ExercicesAnswerList> {
  List<(OpenEndedResponseLogData, OpenEndedData)> _openEndedLogs = [];
  List<(MultipleChoiceResponseLogData, MultipleChoiceData)>
  _multipleChoiceLogs = [];
  bool _isLoading = true;
  bool _isRefreshing = false;
  bool _hasLoaded = false;
  String? _error;
  String _search = '';
  String _filter = 'all';

  @override
  void initState() {
    super.initState();
    carregar();
  }

  Future<void> carregar() async {
    if (_isRefreshing) return;
    final isInitialLoad = !_hasLoaded;
    if (mounted) {
      setState(() {
        _isRefreshing = true;
        if (isInitialLoad) _isLoading = true;
      });
    }

    try {
      final db = ref.read(appDatabaseProvider);
      final openEndedQuery = db.select(db.openEndedResponseLog).join([
        innerJoin(
          db.openEnded,
          db.openEnded.id.equalsExp(db.openEndedResponseLog.openEndedId),
        ),
      ])..where(db.openEnded.nodeId.equals(widget.nodeId));
      openEndedQuery.orderBy([
        OrderingTerm.desc(db.openEndedResponseLog.answeredAt),
      ]);

      final multipleChoiceQuery = db.select(db.multipleChoiceResponseLog).join([
        innerJoin(
          db.multipleChoice,
          db.multipleChoice.id.equalsExp(
            db.multipleChoiceResponseLog.multipleChoiceId,
          ),
        ),
      ])..where(db.multipleChoice.nodeId.equals(widget.nodeId));
      multipleChoiceQuery.orderBy([
        OrderingTerm.desc(db.multipleChoiceResponseLog.answeredAt),
      ]);

      final results = await Future.wait([
        openEndedQuery.get(),
        multipleChoiceQuery.get(),
      ]);
      if (!mounted) return;

      setState(() {
        _openEndedLogs = results[0]
            .map(
              (row) => (
                row.readTable(db.openEndedResponseLog),
                row.readTable(db.openEnded),
              ),
            )
            .toList();
        _multipleChoiceLogs = results[1]
            .map(
              (row) => (
                row.readTable(db.multipleChoiceResponseLog),
                row.readTable(db.multipleChoice),
              ),
            )
            .toList();
        _hasLoaded = true;
        _isLoading = false;
        _isRefreshing = false;
        _error = null;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _isRefreshing = false;
        if (isInitialLoad) {
          _error = 'Não foi possível carregar o histórico de respostas.';
        }
      });
      if (!isInitialLoad) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            const SnackBar(
              content: Text('Não foi possível atualizar o histórico.'),
            ),
          );
      }
    }
  }

  String _date(int timestamp) {
    return DateFormat(
      'dd/MM/yyyy • HH:mm',
    ).format(DateTime.fromMillisecondsSinceEpoch(timestamp * 1000).toLocal());
  }

  Map<String, dynamic> _decodeSnapshot(String raw) {
    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) return decoded;
    } on FormatException {
      // Older or damaged history entries fall back to the saved question row.
    }
    return const {};
  }

  List<Map<String, dynamic>> _decodeChoices(String raw) {
    try {
      final decoded = jsonDecode(raw);
      if (decoded is List) {
        return decoded.whereType<Map<String, dynamic>>().toList();
      }
    } on FormatException {
      // Keep the history screen usable if a legacy snapshot is malformed.
    }
    return const [];
  }

  String _openEndedTitle(
    OpenEndedResponseLogData response,
    OpenEndedData question,
  ) =>
      _decodeSnapshot(response.questionSnapshot)['title'] as String? ??
      question.title;

  String _multipleChoiceTitle(
    MultipleChoiceResponseLogData response,
    MultipleChoiceData question,
  ) =>
      _decodeSnapshot(response.questionSnapshot)['title'] as String? ??
      question.title;

  String _score(double? score) {
    if (score == null) return 'Aguardando correção';
    return '${(score * 100).round()}% de aproveitamento';
  }

  String _duration(int seconds) {
    if (seconds <= 0) return 'tempo não registrado';
    final minutes = seconds ~/ 60;
    final remainder = seconds % 60;
    if (minutes == 0) return '$remainder s';
    return remainder == 0 ? '$minutes min' : '$minutes min $remainder s';
  }

  Future<void> _reviewOpenEnded(
    OpenEndedResponseLogData response,
    OpenEndedData question,
  ) async {
    final snapshot = _decodeSnapshot(response.questionSnapshot);
    final draft = await _showCorrectionDialog(
      title: _openEndedTitle(response, question),
      initialFeedback: response.aiFeedback,
      initialNotes: response.userNotes,
      initialScore: response.score,
      initialMastery: response.masteryDemonstrated,
      initialRating: _ratingForScore(response.score),
      onAiCorrection: () => _evaluateResponse(
        nodeId: question.nodeId,
        task: (snapshot['type'] as String?)?.toUpperCase() == 'FEYNMAN'
            ? AiAgentTask.evaluateFeynman
            : AiAgentTask.evaluateEssayQuestion,
        context: {
          'question': snapshot,
          'student_answer': response.userAnswer ?? '',
        },
      ),
    );
    if (draft == null || !mounted) return;

    try {
      final db = ref.read(appDatabaseProvider);
      await db.transaction(() async {
        await OpenEndedResponseLogDao(db).updateOpenEndedResponseLog(
          id: response.id,
          aiFeedback: draft.feedback,
          userNotes: draft.notes,
          score: draft.score,
          isCorrect: draft.score >= 0.6,
          masteryDemonstrated: draft.mastery,
          corrected: true,
        );
        await FsrsReviewService(db).review(
          itemType: ReviewItemType.openEnded,
          itemId: question.id,
          nodeId: question.nodeId,
          rating: draft.rating,
          durationSeconds: response.durationSeconds,
          score: draft.score,
          method: draft.usedAi
              ? ReviewMethod.aiCorrection
              : ReviewMethod.manualCorrection,
          sourceResponseId: response.id,
        );
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Correção salva e próxima revisão agendada.'),
        ),
      );
      await carregar();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível salvar a correção.')),
      );
    }
  }

  Future<void> _reviewMultipleChoice(
    MultipleChoiceResponseLogData response,
    MultipleChoiceData question,
  ) async {
    final snapshot = _decodeSnapshot(response.questionSnapshot);
    final choices = _decodeChoices(response.questionChoiceSnapshot);
    final selectedIds = <String>{};
    try {
      final decoded = jsonDecode(response.selectedChoiceIds);
      if (decoded is List) selectedIds.addAll(decoded.whereType<String>());
    } on FormatException {
      // Older attempts can have incomplete selection snapshots.
    }

    final draft = await _showCorrectionDialog(
      title: _multipleChoiceTitle(response, question),
      initialFeedback: response.aiFeedback,
      initialNotes: response.userNotes,
      initialScore: response.score,
      initialMastery: null,
      initialRating: _ratingForScore(response.score),
      onAiCorrection: () => _evaluateResponse(
        nodeId: question.nodeId,
        task: AiAgentTask.evaluateMultipleChoiceQuestion,
        context: {
          'question': snapshot,
          'alternatives': choices,
          'selected_alternative_ids': selectedIds.toList(),
          'objective_score': response.score,
          'correct_alternatives': choices
              .where((choice) => choice['is_correct'] == true)
              .toList(),
        },
      ),
    );
    if (draft == null || !mounted) return;

    try {
      final db = ref.read(appDatabaseProvider);
      await db.transaction(() async {
        await MultipleChoiceResponseLogDao(db).updateMultipleChoiceResponseLog(
          id: response.id,
          aiFeedback: draft.feedback,
          userNotes: draft.notes,
          score: draft.score,
          corrected: true,
        );
        await FsrsReviewService(db).review(
          itemType: ReviewItemType.multipleChoice,
          itemId: question.id,
          nodeId: question.nodeId,
          rating: draft.rating,
          durationSeconds: response.durationSeconds,
          score: draft.score,
          method: draft.usedAi
              ? ReviewMethod.aiCorrection
              : ReviewMethod.manualCorrection,
          sourceResponseId: response.id,
        );
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Revisão salva e próxima revisão agendada.'),
        ),
      );
      await carregar();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível salvar a revisão.')),
      );
    }
  }

  Future<Map<String, dynamic>> _evaluateResponse({
    required String nodeId,
    required AiAgentTask task,
    required Map<String, dynamic> context,
  }) async {
    final user = await ref.read(userProvider.future);
    final node = await getGraphNodeForUser(
      db: ref.read(appDatabaseProvider),
      nodeId: nodeId,
      userId: user.id,
    );
    final prompt =
        '''
Avalie esta tentativa de estudo com rigor pedagógico, respeito e foco no aprendizado.
Tipo de tarefa: ${task.label}.
Contexto do nó: ${jsonEncode({'title': node.title, 'description': node.description, 'type': node.type})}
Dados da tentativa: ${jsonEncode(context)}

Considere a resposta de referência e as alternativas corretas quando estiverem
presentes. Não invente informações ausentes. Em múltipla escolha, explique por
que a seleção está correta ou incorreta e corrija equívocos conceituais.
Retorne somente um objeto JSON com:
{
  "feedback": "feedback claro e específico em português",
  "score": 0.0,
  "is_correct": false,
  "mastery_demonstrated": "WEAK|PARTIAL|ADEQUATE|STRONG",
  "weight": 0
}
score deve ser um número entre 0 e 1; weight, se usado, deve ser de 0 a 100.
''';
    return ref
        .read(aiContentGenerationServiceProvider)
        .generate(task: task, prompt: prompt);
  }

  Future<ExerciseCorrectionDraft?> _showCorrectionDialog({
    required String title,
    required String? initialFeedback,
    required String? initialNotes,
    required double? initialScore,
    required String? initialMastery,
    required fsrs.Rating initialRating,
    required Future<Map<String, dynamic>> Function() onAiCorrection,
  }) {
    return showDialog<ExerciseCorrectionDraft>(
      context: context,
      builder: (context) => ExerciseCorrectionDialog(
        title: title,
        initialFeedback: initialFeedback,
        initialNotes: initialNotes,
        initialScore: initialScore,
        initialMastery: initialMastery,
        initialRating: initialRating,
        onAiCorrection: onAiCorrection,
      ),
    );
  }

  fsrs.Rating _ratingForScore(double? score) {
    if (score == null || score < 0.25) return fsrs.Rating.again;
    if (score < 0.6) return fsrs.Rating.hard;
    if (score < 0.9) return fsrs.Rating.good;
    return fsrs.Rating.easy;
  }

  Future<void> _showOpenEndedAnswer(
    OpenEndedResponseLogData response,
    OpenEndedData question,
  ) {
    final snapshot = _decodeSnapshot(response.questionSnapshot);
    return showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_openEndedTitle(response, question)),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Enunciado', style: context.textTheme.titleSmall),
              const SizedBox(height: 4),
              Text(snapshot['statement'] as String? ?? question.statement),
              if ((snapshot['referenceCorrectAnswer'] as String?)
                      ?.trim()
                      .isNotEmpty ==
                  true) ...[
                const SizedBox(height: 16),
                Text(
                  'Resposta de referência',
                  style: context.textTheme.titleSmall,
                ),
                const SizedBox(height: 4),
                Text(snapshot['referenceCorrectAnswer'] as String),
              ],
              const SizedBox(height: 16),
              Text('Sua resposta', style: context.textTheme.titleSmall),
              const SizedBox(height: 4),
              SelectableText(response.userAnswer ?? 'Resposta não registrada.'),
              if (response.aiFeedback?.isNotEmpty == true) ...[
                const SizedBox(height: 16),
                Text('Feedback', style: context.textTheme.titleSmall),
                const SizedBox(height: 4),
                Text(response.aiFeedback!),
              ],
              if (response.userNotes?.trim().isNotEmpty == true) ...[
                const SizedBox(height: 16),
                Text(
                  'Anotações da revisão',
                  style: context.textTheme.titleSmall,
                ),
                const SizedBox(height: 4),
                Text(response.userNotes!),
              ],
            ],
          ),
        ),
        actions: [
          TextButton.icon(
            onPressed: () {
              Navigator.pop(context);
              _reviewOpenEnded(response, question);
            },
            icon: const Icon(Icons.rate_review_outlined),
            label: Text(
              response.corrected ? 'Revisar correção' : 'Corrigir resposta',
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  Future<void> _showMultipleChoiceAnswer(
    MultipleChoiceResponseLogData response,
    MultipleChoiceData question,
  ) {
    final snapshot = _decodeSnapshot(response.questionSnapshot);
    final choices = _decodeChoices(response.questionChoiceSnapshot);
    final selectedIdList = <String>{};
    try {
      final decoded = jsonDecode(response.selectedChoiceIds);
      if (decoded is List) selectedIdList.addAll(decoded.whereType<String>());
    } on FormatException {
      // An invalid selection snapshot should not prevent other history entries
      // from opening.
    }

    return showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_multipleChoiceTitle(response, question)),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(snapshot['statement'] as String? ?? question.statement),
              const SizedBox(height: 16),
              Text(
                'Resultado: ${_score(response.score)}',
                style: context.textTheme.titleSmall,
              ),
              if (response.aiFeedback?.trim().isNotEmpty == true) ...[
                const SizedBox(height: 12),
                Text('Feedback', style: context.textTheme.titleSmall),
                const SizedBox(height: 4),
                Text(response.aiFeedback!),
              ],
              if (response.userNotes?.trim().isNotEmpty == true) ...[
                const SizedBox(height: 12),
                Text(
                  'Anotações da revisão',
                  style: context.textTheme.titleSmall,
                ),
                const SizedBox(height: 4),
                Text(response.userNotes!),
              ],
              const SizedBox(height: 16),
              Text('Alternativas', style: context.textTheme.titleSmall),
              const SizedBox(height: 4),
              if (choices.isEmpty)
                const Text(
                  'As alternativas desta tentativa não estão disponíveis.',
                )
              else
                for (final choice in choices)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(
                      selectedIdList.contains(choice['id'])
                          ? Icons.radio_button_checked
                          : Icons.radio_button_unchecked,
                      color: choice['is_correct'] == true
                          ? Theme.of(context).colorScheme.primary
                          : selectedIdList.contains(choice['id'])
                          ? Theme.of(context).colorScheme.error
                          : null,
                    ),
                    title: Text(
                      choice['statement'] as String? ?? '',
                      style: TextStyle(
                        fontWeight: choice['is_correct'] == true
                            ? FontWeight.w600
                            : null,
                      ),
                    ),
                    subtitle: Text(
                      [
                        if (selectedIdList.contains(choice['id']))
                          'Selecionada',
                        if (choice['is_correct'] == true) 'Correta',
                        if ((choice['explanation'] as String?)
                                ?.trim()
                                .isNotEmpty ==
                            true)
                          choice['explanation'] as String,
                      ].join(' · '),
                    ),
                  ),
            ],
          ),
        ),
        actions: [
          TextButton.icon(
            onPressed: () {
              Navigator.pop(context);
              _reviewMultipleChoice(response, question);
            },
            icon: const Icon(Icons.rate_review_outlined),
            label: Text(
              response.corrected ? 'Revisar feedback' : 'Adicionar feedback',
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  Widget _responseCard({
    required String title,
    required String type,
    required bool corrected,
    required String subtitle,
    required String score,
    required VoidCallback onTap,
    required IconData icon,
  }) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(child: Icon(icon)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: context.textTheme.titleMedium),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(type, style: context.textTheme.labelMedium),
                        Chip(
                          label: Text(corrected ? 'Corrigida' : 'A corrigir'),
                          visualDensity: VisualDensity.compact,
                          padding: EdgeInsets.zero,
                          labelStyle: Theme.of(context).textTheme.labelSmall,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(score, style: context.textTheme.labelLarge),
                  const SizedBox(height: 4),
                  const Icon(Icons.chevron_right),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_error!, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: carregar,
              icon: const Icon(Icons.refresh),
              label: const Text('Tentar novamente'),
            ),
          ],
        ),
      );
    }

    final responses =
        <
            ({
              int answeredAt,
              String title,
              String type,
              bool corrected,
              String searchText,
              Widget card,
            })
          >[
            for (final (response, question) in _openEndedLogs)
              (
                answeredAt: response.answeredAt,
                title: _openEndedTitle(response, question),
                type: 'open',
                corrected: response.corrected,
                searchText:
                    '${_openEndedTitle(response, question)} '
                    '${_decodeSnapshot(response.questionSnapshot)['statement'] ?? question.statement}',
                card: _responseCard(
                  title: _openEndedTitle(response, question),
                  type: 'Questão aberta',
                  corrected: response.corrected,
                  subtitle:
                      '${_date(response.answeredAt)} · ${_duration(response.durationSeconds)}',
                  score: _score(response.score),
                  icon: Icons.edit_note_rounded,
                  onTap: () => _showOpenEndedAnswer(response, question),
                ),
              ),
            for (final (response, question) in _multipleChoiceLogs)
              (
                answeredAt: response.answeredAt,
                title: _multipleChoiceTitle(response, question),
                type: 'multiple',
                corrected: response.corrected,
                searchText:
                    '${_multipleChoiceTitle(response, question)} '
                    '${_decodeSnapshot(response.questionSnapshot)['statement'] ?? question.statement}',
                card: _responseCard(
                  title: _multipleChoiceTitle(response, question),
                  type: 'Múltipla escolha',
                  corrected: response.corrected,
                  subtitle:
                      '${_date(response.answeredAt)} · ${_duration(response.durationSeconds)}',
                  score: _score(response.score),
                  icon: Icons.checklist_rounded,
                  onTap: () => _showMultipleChoiceAnswer(response, question),
                ),
              ),
          ]
          ..sort((a, b) => b.answeredAt.compareTo(a.answeredAt));
    final query = _search.trim().toLowerCase();
    final filteredResponses = responses.where((response) {
      final matchesFilter = switch (_filter) {
        'queue' => !response.corrected,
        'corrected' => response.corrected,
        'open' => response.type == 'open',
        'multiple' => response.type == 'multiple',
        _ => true,
      };
      return matchesFilter &&
          (query.isEmpty || response.searchText.toLowerCase().contains(query));
    }).toList();
    final pendingCount = responses
        .where((response) => !response.corrected)
        .length;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Suas respostas',
                      style: context.textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${responses.length} ${responses.length == 1 ? 'tentativa' : 'tentativas'} · $pendingCount aguardando correção',
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Atualizar histórico',
                onPressed: _isRefreshing ? null : carregar,
                icon: _isRefreshing
                    ? const SizedBox.square(
                        dimension: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.refresh),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            onChanged: (value) => setState(() => _search = value),
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: 'Buscar no histórico',
              border: const OutlineInputBorder(),
              suffixIcon: _search.isEmpty
                  ? null
                  : IconButton(
                      tooltip: 'Limpar busca',
                      onPressed: () => setState(() => _search = ''),
                      icon: const Icon(Icons.clear),
                    ),
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final (value, label) in [
                ('all', 'Todas'),
                ('queue', 'Fila de correção'),
                ('corrected', 'Corrigidas'),
                ('open', 'Dissertativas'),
                ('multiple', 'Múltipla escolha'),
              ])
                ChoiceChip(
                  label: Text(label),
                  selected: _filter == value,
                  onSelected: (_) => setState(() => _filter = value),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: RefreshIndicator(
              onRefresh: carregar,
              child: responses.isEmpty
                  ? ListView(
                      children: [
                        const SizedBox(height: 40),
                        Icon(
                          Icons.history_rounded,
                          size: 48,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Você ainda não respondeu a nenhuma questão deste tópico.',
                          textAlign: TextAlign.center,
                          style: context.textTheme.bodyLarge,
                        ),
                      ],
                    )
                  : filteredResponses.isEmpty
                  ? ListView(
                      children: const [
                        SizedBox(height: 40),
                        Center(
                          child: Text('Nenhuma tentativa corresponde à busca.'),
                        ),
                      ],
                    )
                  : ListView(
                      children: [
                        for (final item in filteredResponses) item.card,
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
