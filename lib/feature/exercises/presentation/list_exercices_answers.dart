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
    ).format(DateTime.fromMillisecondsSinceEpoch(timestamp * 1000));
  }

  String _score(double? score) {
    if (score == null) return 'Aguardando correção';
    return '${(score * 100).round()}% de aproveitamento';
  }

  Future<void> _showOpenEndedAnswer(
    OpenEndedResponseLogData response,
    OpenEndedData question,
  ) {
    return showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(question.title),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Enunciado', style: context.textTheme.titleSmall),
              const SizedBox(height: 4),
              Text(question.statement),
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
    final choices = (jsonDecode(response.questionChoiceSnapshot) as List)
        .whereType<Map<String, dynamic>>()
        .toList();
    final selectedIds = (jsonDecode(response.selectedChoiceIds) as List)
        .whereType<String>()
        .toSet();
    final selectedChoices = choices.where(
      (choice) => selectedIds.contains(choice['id']),
    );

    return showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(question.title),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(question.statement),
              const SizedBox(height: 16),
              Text(
                'Alternativas selecionadas',
                style: context.textTheme.titleSmall,
              ),
              const SizedBox(height: 4),
              if (selectedChoices.isEmpty)
                const Text('Nenhuma alternativa selecionada.')
              else
                for (final choice in selectedChoices)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(
                      choice['is_correct'] == true
                          ? Icons.check_circle_outline
                          : Icons.cancel_outlined,
                      color: choice['is_correct'] == true
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.error,
                    ),
                    title: Text(choice['statement'] as String? ?? ''),
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

    final responses = <({int answeredAt, Widget card})>[
      for (final (response, question) in _openEndedLogs)
        (
          answeredAt: response.answeredAt,
          card: _responseCard(
            title: question.title,
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
          card: _responseCard(
            title: question.title,
            type: 'Múltipla escolha',
            subtitle: _date(response.answeredAt),
            score: _score(response.score),
            icon: Icons.checklist_rounded,
            onTap: () => _showMultipleChoiceAnswer(response, question),
          ),
        ),
    ]..sort((a, b) => b.answeredAt.compareTo(a.answeredAt));

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
                  : ListView(
                      children: [for (final item in responses) item.card],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
