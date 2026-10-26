import 'dart:convert';

import 'package:drift/drift.dart' show OrderingTerm, innerJoin;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:noema/core/database/database.dart' hide OpenEnded;
import 'package:noema/core/database/database_provider.dart';
import 'package:noema/core/design/theme/theme_tokens.dart';

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
  String? _error;
  String _search = '';
  String _filter = 'all';

  @override
  void initState() {
    super.initState();
    carregar();
  }

  Future<void> carregar() async {
    if (mounted) setState(() => _isLoading = true);

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
        _isLoading = false;
        _error = null;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _error = 'Não foi possível carregar o histórico de respostas.';
      });
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
            ],
          ),
        ),
        actions: [
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
                    Text(type, style: context.textTheme.labelMedium),
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
              String searchText,
              Widget card,
            })
          >[
            for (final (response, question) in _openEndedLogs)
              (
                answeredAt: response.answeredAt,
                title: _openEndedTitle(response, question),
                type: 'open',
                searchText:
                    '${_openEndedTitle(response, question)} '
                    '${_decodeSnapshot(response.questionSnapshot)['statement'] ?? question.statement}',
                card: _responseCard(
                  title: _openEndedTitle(response, question),
                  type: 'Questão aberta',
                  subtitle: _date(response.answeredAt),
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
                searchText:
                    '${_multipleChoiceTitle(response, question)} '
                    '${_decodeSnapshot(response.questionSnapshot)['statement'] ?? question.statement}',
                card: _responseCard(
                  title: _multipleChoiceTitle(response, question),
                  type: 'Múltipla escolha',
                  subtitle: _date(response.answeredAt),
                  score: _score(response.score),
                  icon: Icons.checklist_rounded,
                  onTap: () => _showMultipleChoiceAnswer(response, question),
                ),
              ),
          ]
          ..sort((a, b) => b.answeredAt.compareTo(a.answeredAt));
    final query = _search.trim().toLowerCase();
    final filteredResponses = responses.where((response) {
      return (_filter == 'all' || response.type == _filter) &&
          (query.isEmpty || response.searchText.toLowerCase().contains(query));
    }).toList();

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
                      '${responses.length} ${responses.length == 1 ? 'tentativa registrada' : 'tentativas registradas'}',
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Atualizar histórico',
                onPressed: carregar,
                icon: const Icon(Icons.refresh),
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
            children: [
              for (final (value, label) in [
                ('all', 'Todas'),
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
