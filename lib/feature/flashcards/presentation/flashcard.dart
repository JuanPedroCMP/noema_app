import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noema/core/database/database.dart';
import 'package:noema/core/database/database_provider.dart';
import 'package:noema/feature/config/providers/user_provider.dart';
import 'package:noema/feature/flashcards/data/flashcard_dao.dart';
import 'package:noema/shared/widgets/app_card.dart';
import 'package:noema/shared/widgets/async_state_view.dart';
import 'package:noema/shared/widgets/responsive_content.dart';

final flashcardsProvider = FutureProvider.autoDispose<List<FlashcardData>>((
  ref,
) async {
  final user = await ref.watch(userProvider.future);
  return FlashcardDao(ref.read(appDatabaseProvider)).getByUser(user.id);
});

class FlashcardPage extends ConsumerStatefulWidget {
  const FlashcardPage({super.key});
  @override
  ConsumerState<FlashcardPage> createState() => _FlashcardPageState();
}

class _FlashcardPageState extends ConsumerState<FlashcardPage> {
  int _studyIndex = 0;
  bool _showAnswer = false;

  Future<void> _openEditor({FlashcardData? card}) async {
    final draft = await showDialog<_FlashcardDraft>(
      context: context,
      builder: (_) => _FlashcardDialog(card: card),
    );
    if (draft == null || !mounted) return;
    final dao = FlashcardDao(ref.read(appDatabaseProvider));
    if (card == null) {
      await dao.create(
        nodeId: draft.nodeId,
        title: draft.title,
        statement: draft.statement,
        targetSkill: draft.targetSkill,
      );
    } else {
      await dao.updateCard(
        id: card.id,
        title: draft.title,
        statement: draft.statement,
        targetSkill: draft.targetSkill,
      );
    }
    ref.invalidate(flashcardsProvider);
  }

  Future<void> _review(FlashcardData card, String rating) async {
    await FlashcardDao(
      ref.read(appDatabaseProvider),
    ).logReview(card: card, rating: rating);
    if (!mounted) return;
    final cards =
        ref.read(flashcardsProvider).asData?.value ?? const <FlashcardData>[];
    setState(() {
      _showAnswer = false;
      if (cards.isNotEmpty) _studyIndex = (_studyIndex + 1) % cards.length;
    });
  }

  Future<void> _delete(FlashcardData card) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir flashcard?'),
        content: Text('O cartão "${card.title}" será removido da revisão.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    await FlashcardDao(ref.read(appDatabaseProvider)).deleteCard(card.id);
    ref.invalidate(flashcardsProvider);
  }

  @override
  Widget build(BuildContext context) {
    return AppResponsiveContent(
      maxWidth: 1100,
      child: ref
          .watch(flashcardsProvider)
          .when(
            loading: () =>
                const AppLoadingView(label: 'Carregando flashcards...'),
            error: (error, stack) => AppErrorView(
              message: 'Não foi possível carregar seus flashcards.',
              onRetry: () => ref.invalidate(flashcardsProvider),
            ),
            data: (cards) => _buildContent(context, cards),
          ),
    );
  }

  Widget _buildContent(BuildContext context, List<FlashcardData> cards) {
    final studying = cards.isEmpty ? null : cards[_studyIndex % cards.length];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 20,
      children: [
        AppPageHeader(
          title: 'Flashcards',
          subtitle: cards.isEmpty
              ? 'Crie cartões para revisar conceitos importantes.'
              : '${cards.length} ${cards.length == 1 ? 'cartão disponível' : 'cartões disponíveis'}',
          actions: [
            FilledButton.icon(
              onPressed: () => _openEditor(),
              icon: const Icon(Icons.add),
              label: const Text('Novo flashcard'),
            ),
          ],
        ),
        if (studying != null)
          _StudyCard(
            card: studying,
            showAnswer: _showAnswer,
            onReveal: () => setState(() => _showAnswer = true),
            onReview: (rating) => _review(studying, rating),
          ),
        if (cards.isEmpty)
          AppEmptyView(
            icon: Icons.style_outlined,
            title: 'Nenhum flashcard ainda',
            message: 'Crie seu primeiro cartão e comece uma revisão rápida.',
            action: FilledButton.icon(
              onPressed: () => _openEditor(),
              icon: const Icon(Icons.add),
              label: const Text('Criar flashcard'),
            ),
          )
        else
          ...cards.map(
            (card) => AppCard(
              title: card.title,
              subtitle: card.targetSkill,
              onTap: () => _openEditor(card: card),
              trailing: IconButton(
                tooltip: 'Excluir flashcard',
                onPressed: () => _delete(card),
                icon: const Icon(Icons.delete_outline),
              ),
              child: Text(
                card.statement,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
      ],
    );
  }
}

class _StudyCard extends StatelessWidget {
  const _StudyCard({
    required this.card,
    required this.showAnswer,
    required this.onReveal,
    required this.onReview,
  });
  final FlashcardData card;
  final bool showAnswer;
  final VoidCallback onReveal;
  final ValueChanged<String> onReview;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Revisão atual',
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: 12),
            Text(card.title, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 20),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              child: showAnswer
                  ? Text(card.statement, key: const ValueKey('answer'))
                  : const Text(
                      'Tente lembrar a resposta antes de revelar.',
                      key: ValueKey('prompt'),
                    ),
            ),
            const SizedBox(height: 24),
            if (!showAnswer)
              FilledButton.icon(
                onPressed: onReveal,
                icon: const Icon(Icons.visibility),
                label: const Text('Revelar resposta'),
              )
            else
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 8,
                runSpacing: 8,
                children: [
                  _ReviewButton(
                    label: 'Difícil',
                    value: 'hard',
                    onTap: onReview,
                  ),
                  _ReviewButton(label: 'Bom', value: 'good', onTap: onReview),
                  _ReviewButton(label: 'Fácil', value: 'easy', onTap: onReview),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _ReviewButton extends StatelessWidget {
  const _ReviewButton({
    required this.label,
    required this.value,
    required this.onTap,
  });
  final String label;
  final String value;
  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(onPressed: () => onTap(value), child: Text(label));
  }
}

class _FlashcardDraft {
  const _FlashcardDraft({
    required this.nodeId,
    required this.title,
    required this.statement,
    this.targetSkill,
  });
  final String nodeId;
  final String title;
  final String statement;
  final String? targetSkill;
}

class _FlashcardDialog extends StatefulWidget {
  const _FlashcardDialog({this.card});
  final FlashcardData? card;
  @override
  State<_FlashcardDialog> createState() => _FlashcardDialogState();
}

class _FlashcardDialogState extends State<_FlashcardDialog> {
  late final TextEditingController _node;
  late final TextEditingController _title;
  late final TextEditingController _statement;
  late final TextEditingController _skill;

  @override
  void initState() {
    super.initState();
    _node = TextEditingController(text: widget.card?.nodeId);
    _title = TextEditingController(text: widget.card?.title);
    _statement = TextEditingController(text: widget.card?.statement);
    _skill = TextEditingController(text: widget.card?.targetSkill);
  }

  @override
  void dispose() {
    _node.dispose();
    _title.dispose();
    _statement.dispose();
    _skill.dispose();
    super.dispose();
  }

  void _save() {
    if (_node.text.trim().isEmpty ||
        _title.text.trim().isEmpty ||
        _statement.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha nó, título e resposta.')),
      );
      return;
    }
    Navigator.pop(
      context,
      _FlashcardDraft(
        nodeId: _node.text.trim(),
        title: _title.text.trim(),
        statement: _statement.text.trim(),
        targetSkill: _skill.text.trim().isEmpty ? null : _skill.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.card == null ? 'Novo flashcard' : 'Editar flashcard'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 12,
          children: [
            if (widget.card == null)
              TextField(
                controller: _node,
                decoration: const InputDecoration(
                  labelText: 'ID do nó',
                  helperText: 'Associe o cartão a um nó do grafo.',
                ),
              ),
            TextField(
              controller: _title,
              decoration: const InputDecoration(labelText: 'Título'),
            ),
            TextField(
              controller: _statement,
              minLines: 3,
              maxLines: 6,
              decoration: const InputDecoration(labelText: 'Resposta'),
            ),
            TextField(
              controller: _skill,
              decoration: const InputDecoration(
                labelText: 'Habilidade (opcional)',
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        FilledButton(onPressed: _save, child: const Text('Salvar')),
      ],
    );
  }
}
