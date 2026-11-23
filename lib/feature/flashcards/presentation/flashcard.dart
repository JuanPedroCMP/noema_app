import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noema/l10n/app_localizations.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:noema/core/database/database.dart';
import 'package:noema/core/database/database_provider.dart';
import 'package:noema/core/design/tokens/layout.dart';
import 'package:noema/feature/config/providers/user_provider.dart';
import 'package:noema/feature/ai/models/ai_agent_task.dart';
import 'package:noema/feature/ai/services/ai_content_generation_service.dart';
import 'package:noema/feature/flashcards/data/flashcard_dao.dart';
import 'package:noema/feature/study_assistant/models/study_assistant_action.dart';
import 'package:noema/feature/study_assistant/providers/study_assistant_provider.dart';
import 'package:noema/shared/widgets/app_card.dart';
import 'package:noema/shared/widgets/async_state_view.dart';
import 'package:noema/shared/widgets/responsive_content.dart';

typedef CustomDeckEntry = ({
  FlashcardGroupData deck,
  List<FlashcardData> cards,
});

typedef FlashcardPageData = ({
  List<FlashcardData> cards,
  List<FlashcardData> dueCards,
  List<GraphNodeData> nodes,
  List<KnowledgeGraphData> graphs,
  List<CustomDeckEntry> customDecks,
});

final flashcardsProvider = FutureProvider.autoDispose
    .family<FlashcardPageData, String?>((ref, nodeId) async {
      final user = await ref.watch(userProvider.future);
      final dao = FlashcardDao(ref.read(appDatabaseProvider));
      final cards = nodeId == null
          ? await dao.getByUser(user.id)
          : await dao.getByNode(nodeId: nodeId, userId: user.id);
      final dueCards = await dao.getDueCards(cards);
      final nodes = await dao.getNodesByUser(user.id);
      final graphs = await dao.getGraphsByUser(user.id);
      final customDecks = nodeId == null
          ? await dao.getCustomDecksByUser(user.id)
          : <CustomDeckEntry>[];

      return (
        cards: cards,
        dueCards: dueCards,
        nodes: nodes,
        graphs: graphs,
        customDecks: customDecks,
      );
    });

class FlashcardPage extends ConsumerStatefulWidget {
  const FlashcardPage({super.key, this.nodeId, this.initialHandoff});

  final String? nodeId;
  final StudyAssistantHandoff? initialHandoff;

  @override
  ConsumerState<FlashcardPage> createState() => _FlashcardPageState();
}

class _FlashcardPageState extends ConsumerState<FlashcardPage> {
  String? _activeDeckName;
  List<FlashcardData> _selectedDeckAllCards = [];
  List<FlashcardData> _studyCards = [];
  int _studyIndex = 0;
  int _reviewedCount = 0;
  int _totalReviewSeconds = 0;
  bool _showAnswer = false;
  bool _isReviewing = false;
  bool _sessionComplete = false;
  bool _isGeneratingAssistantCards = false;
  bool _assistantAutoGenerationScheduled = false;
  bool _assistantHandoffDismissed = false;
  bool _showAiGenerationCard = false;
  String? _assistantNodeId;
  int _assistantCardCount = 4;
  late final TextEditingController _assistantPromptController;
  String _search = '';
  final Stopwatch _reviewTimer = Stopwatch();

  @override
  void initState() {
    super.initState();
    _assistantPromptController = TextEditingController(
      text: widget.initialHandoff?.prompt ?? '',
    );
    _assistantNodeId = widget.initialHandoff?.nodeId ?? widget.nodeId;
  }

  @override
  void didUpdateWidget(covariant FlashcardPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialHandoff != widget.initialHandoff) {
      _assistantPromptController.text = widget.initialHandoff?.prompt ?? '';
      _assistantNodeId = widget.initialHandoff?.nodeId ?? widget.nodeId;
      _assistantAutoGenerationScheduled = false;
      _assistantHandoffDismissed = false;
    }
  }

  @override
  void dispose() {
    _assistantPromptController.dispose();
    super.dispose();
  }

  void _startDeck(
    String name,
    List<FlashcardData> cards,
    List<FlashcardData> dueCards,
  ) {
    if (cards.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.flashcardDeckEmpty),
        ),
      );
      return;
    }
    setState(() {
      _activeDeckName = name;
      _selectedDeckAllCards = List.of(cards);
      _studyCards = dueCards;
      _studyIndex = 0;
      _reviewedCount = 0;
      _totalReviewSeconds = 0;
      _showAnswer = false;
      _sessionComplete = dueCards.isEmpty;
      _reviewTimer
        ..reset()
        ..start();
    });
  }

  void _stopStudy() {
    ref.invalidate(flashcardsProvider(widget.nodeId));
    setState(() {
      _activeDeckName = null;
      _selectedDeckAllCards = [];
      _studyCards = [];
      _studyIndex = 0;
      _reviewedCount = 0;
      _totalReviewSeconds = 0;
      _showAnswer = false;
      _sessionComplete = false;
      _reviewTimer.stop();
    });
  }

  Future<void> _review(FlashcardData card, String rating) async {
    if (_isReviewing) return;
    setState(() => _isReviewing = true);
    try {
      final durationSeconds = _reviewTimer.elapsed.inSeconds;
      final result = await FlashcardDao(
        ref.read(appDatabaseProvider),
      ).logReview(card: card, rating: rating, durationSeconds: durationSeconds);
      if (!mounted) return;
      final nextIndex = _studyIndex + 1;
      setState(() {
        _reviewedCount++;
        _totalReviewSeconds += durationSeconds;
        _studyIndex = nextIndex;
        _showAnswer = false;
        _sessionComplete = nextIndex >= _studyCards.length;
        if (!_sessionComplete) {
          _reviewTimer
            ..reset()
            ..start();
        } else {
          _reviewTimer.stop();
        }
      });
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!.nextReviewDate(
                DateFormat('dd/MM/yyyy HH:mm').format(result.dueAt.toLocal()),
              ),
            ),
          ),
        );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.reviewRecordFailed),
        ),
      );
    } finally {
      if (mounted) setState(() => _isReviewing = false);
    }
  }

  Future<void> _openCardEditor({
    FlashcardData? card,
    required List<GraphNodeData> nodes,
  }) async {
    if (nodes.isEmpty && card == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.createNodeBeforeCards),
        ),
      );
      return;
    }
    final draft = await showDialog<_FlashcardDraft>(
      context: context,
      builder: (_) => _FlashcardDialog(
        card: card,
        nodes: nodes,
        selectedNodeId: widget.nodeId,
      ),
    );
    if (draft == null || !mounted) return;
    try {
      final dao = FlashcardDao(ref.read(appDatabaseProvider));
      if (card == null) {
        final user = await ref.read(userProvider.future);
        await dao.create(
          userId: user.id,
          nodeId: draft.nodeId,
          title: draft.title,
          statement: draft.statement,
          targetSkill: draft.targetSkill,
        );
      } else {
        final changed = await dao.updateCard(
          id: card.id,
          title: draft.title,
          statement: draft.statement,
          targetSkill: draft.targetSkill,
        );
        if (!changed) throw StateError('Flashcard not found.');
      }
      if (!mounted) return;
      ref.invalidate(flashcardsProvider(widget.nodeId));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            card == null
                ? AppLocalizations.of(context)!.flashcardCreated
                : AppLocalizations.of(context)!.flashcardSaved,
          ),
        ),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.flashcardSaveFailed),
        ),
      );
    }
  }

  Future<void> _openCustomDeckEditor({
    required List<FlashcardData> cards,
    required List<GraphNodeData> nodes,
    required List<KnowledgeGraphData> graphs,
    CustomDeckEntry? entry,
  }) async {
    final result = await showDialog<_CustomDeckDraft>(
      context: context,
      builder: (_) => _CustomDeckDialog(
        cards: cards,
        nodes: nodes,
        graphs: graphs,
        initialDeck: entry,
      ),
    );
    if (result == null || !mounted) return;
    try {
      final user = await ref.read(userProvider.future);
      await FlashcardDao(ref.read(appDatabaseProvider)).saveCustomDeck(
        deckId: entry?.deck.id,
        userId: user.id,
        name: result.name,
        flashcardIds: result.cardIds,
      );
      if (!mounted) return;
      ref.invalidate(flashcardsProvider(widget.nodeId));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            entry == null
                ? AppLocalizations.of(context)!.deckCreated
                : AppLocalizations.of(context)!.deckUpdated,
          ),
        ),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.deckSaveFailed)),
      );
    }
  }

  Future<void> _deleteCard(FlashcardData card) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.deleteFlashcardTitle),
        content: Text(
          AppLocalizations.of(context)!.cardRemovedFromDecks(card.title),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(AppLocalizations.of(context)!.deleteFlashcard),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    try {
      final deleted = await FlashcardDao(
        ref.read(appDatabaseProvider),
      ).deleteCard(card.id);
      if (!deleted) throw StateError('Flashcard not found.');
      if (!mounted) return;
      ref.invalidate(flashcardsProvider(widget.nodeId));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.deleteFlashcardFailed),
        ),
      );
    }
  }

  Future<void> _deleteCustomDeck(FlashcardGroupData deck) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.deleteDeckTitle),
        content: Text(
          AppLocalizations.of(context)!.deckRemovedCardsRemain(deck.name),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(AppLocalizations.of(context)!.deleteFlashcard),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    try {
      final user = await ref.read(userProvider.future);
      final deleted = await FlashcardDao(
        ref.read(appDatabaseProvider),
      ).deleteCustomDeck(deckId: deck.id, userId: user.id);
      if (!deleted) throw StateError('Deck not found.');
      if (!mounted) return;
      ref.invalidate(flashcardsProvider(widget.nodeId));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.deleteDeckFailed)),
      );
    }
  }

  Future<void> _generateAssistantCards(FlashcardPageData data) async {
    if (_isGeneratingAssistantCards) return;
    final prompt = _assistantPromptController.text.trim();
    final nodeId = _assistantNodeId;
    if (prompt.isEmpty || nodeId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.topicAndNodeRequired),
        ),
      );
      return;
    }
    final matchingNodes = data.nodes.where((item) => item.id == nodeId);
    if (matchingNodes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.chooseAvailableNode),
        ),
      );
      return;
    }
    final node = matchingNodes.first;
    final cardCount = _assistantCardCount;
    setState(() => _isGeneratingAssistantCards = true);
    try {
      final response = await ref
          .read(aiContentGenerationServiceProvider)
          .generate(
            task: AiAgentTask.createFlashcards,
            prompt:
                '''
Crie exatamente $cardCount ${cardCount == 1 ? 'flashcard' : 'flashcards'} de estudo objetivos.
Tema pedido: $prompt
Nó de estudo: ${node.title}
Descrição do nó: ${node.description ?? 'não informada'}
Retorne somente JSON no formato {"flashcards":[{"title":"pergunta curta","statement":"resposta correta, clara e suficiente","target_skill":"habilidade avaliada"}]}.
Retorne exatamente $cardCount item(ns) na lista. Cada cartão deve testar uma ideia diferente. Não inclua texto fora do JSON.
''',
          );
      final cards = _parseSuggestedCards(response, expectedCount: cardCount);
      if (!mounted) return;
      final accepted = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            AppLocalizations.of(context)!.suggestedFlashcards(cards.length),
          ),
          content: SizedBox(
            width: 520,
            height: 420,
            child: ListView.separated(
              itemCount: cards.length,
              separatorBuilder: (_, _) => const Divider(),
              itemBuilder: (context, index) {
                final card = cards[index];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(card.title),
                  subtitle: Text(
                    card.statement,
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(AppLocalizations.of(context)!.dismiss),
            ),
            FilledButton.icon(
              onPressed: () => Navigator.pop(context, true),
              icon: const Icon(Icons.save_outlined),
              label: Text(AppLocalizations.of(context)!.saveCard),
            ),
          ],
        ),
      );
      if (accepted != true || !mounted) return;
      final user = await ref.read(userProvider.future);
      final dao = FlashcardDao(ref.read(appDatabaseProvider));
      await ref.read(appDatabaseProvider).transaction(() async {
        for (final card in cards) {
          await dao.create(
            userId: user.id,
            nodeId: node.id,
            title: card.title,
            statement: card.statement,
            targetSkill: card.targetSkill,
          );
        }
      });
      if (!mounted) return;
      ref.invalidate(flashcardsProvider(widget.nodeId));
      if (widget.initialHandoff?.type ==
          StudyAssistantActionType.createFlashcards) {
        ref.read(studyAssistantProvider.notifier).consumeHandoff();
      }
      setState(() {
        _assistantHandoffDismissed = true;
        _showAiGenerationCard = false;
      });
      _assistantPromptController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!.savedFlashcards(cards.length),
          ),
        ),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!.generateFlashcardsFailed('$error'),
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => _isGeneratingAssistantCards = false);
    }
  }

  List<({String title, String statement, String? targetSkill})>
  _parseSuggestedCards(
    Map<String, dynamic> response, {
    required int expectedCount,
  }) {
    final rawCards = response['flashcards'];
    if (rawCards is! List ||
        rawCards.length != expectedCount ||
        rawCards.length > 8) {
      throw const FormatException(
        'A quantidade de flashcards retornada não corresponde à solicitada.',
      );
    }
    return rawCards
        .map((item) {
          if (item is! Map) {
            throw const FormatException('Um flashcard retornado é inválido.');
          }
          final card = Map<String, dynamic>.from(item);
          final title = card['title'];
          final statement = card['statement'];
          final skill = card['targetSkill'] ?? card['target_skill'];
          if (title is! String ||
              title.trim().isEmpty ||
              title.trim().length > 160 ||
              statement is! String ||
              statement.trim().isEmpty ||
              statement.trim().length > 3000) {
            throw const FormatException(
              'Cada flashcard precisa de pergunta e resposta.',
            );
          }
          return (
            title: title.trim(),
            statement: statement.trim(),
            targetSkill: skill is String ? skill.trim() : null,
          );
        })
        .toList(growable: false);
  }

  void _openAiGeneration(FlashcardPageData data) {
    if (data.nodes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.createNodeBeforeGenerate),
        ),
      );
      return;
    }

    final selectedNode = data.nodes.firstWhere(
      (node) => node.id == _assistantNodeId,
      orElse: () => data.nodes.first,
    );
    _assistantNodeId = selectedNode.id;
    if (_assistantPromptController.text.trim().isEmpty) {
      _assistantPromptController.text =
          'Crie flashcards de estudo sobre ${selectedNode.title}.';
    }
    setState(() {
      _showAiGenerationCard = true;
      _assistantHandoffDismissed = false;
    });
  }

  void _closeAiGeneration() {
    if (widget.initialHandoff?.type ==
        StudyAssistantActionType.createFlashcards) {
      ref.read(studyAssistantProvider.notifier).consumeHandoff();
    }
    setState(() {
      _showAiGenerationCard = false;
      _assistantHandoffDismissed = true;
    });
  }

  Widget _buildAssistantGenerationCard(FlashcardPageData data) {
    final handoff = widget.initialHandoff;
    if (_assistantHandoffDismissed ||
        (handoff?.type != StudyAssistantActionType.createFlashcards &&
            !_showAiGenerationCard)) {
      return const SizedBox.shrink();
    }
    final firstNodeId = data.nodes.isEmpty ? null : data.nodes.first.id;
    if (_assistantNodeId == null ||
        !data.nodes.any((node) => node.id == _assistantNodeId)) {
      _assistantNodeId = firstNodeId;
    }
    if (handoff?.autoGenerate == true && !_assistantAutoGenerationScheduled) {
      _assistantAutoGenerationScheduled = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _generateAssistantCards(data);
      });
    }
    if (data.nodes.isEmpty) {
      return Card(
        child: ListTile(
          leading: Icon(Icons.info_outline),
          title: Text(AppLocalizations.of(context)!.noNodeCardsTitle),
          subtitle: Text(AppLocalizations.of(context)!.noNodeCardsMessage),
        ),
      );
    }
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    AppLocalizations.of(context)!.createFlashcardsWithAi,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                IconButton(
                  tooltip: AppLocalizations.of(context)!.closeGeneration,
                  onPressed: _closeAiGeneration,
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(AppLocalizations.of(context)!.reviewThemeBeforeGenerate),
            const SizedBox(height: 12),
            TextField(
              controller: _assistantPromptController,
              enabled: !_isGeneratingAssistantCards,
              maxLines: 2,
              maxLength: 1000,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.themeInstructions,
                border: OutlineInputBorder(),
              ),
            ),
            DropdownButtonFormField<String>(
              initialValue: _assistantNodeId,
              isExpanded: true,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.linkNode,
              ),
              items: [
                for (final node in data.nodes)
                  DropdownMenuItem(
                    value: node.id,
                    child: Text(node.title, overflow: TextOverflow.ellipsis),
                  ),
              ],
              onChanged: (value) => setState(() => _assistantNodeId = value),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<int>(
              initialValue: _assistantCardCount,
              isExpanded: true,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.numberFlashcards,
              ),
              items: [
                for (var count = 1; count <= 8; count++)
                  DropdownMenuItem(
                    value: count,
                    child: Text(
                      '$count ${count == 1 ? 'flashcard' : 'flashcards'}',
                    ),
                  ),
              ],
              onChanged: _isGeneratingAssistantCards
                  ? null
                  : (value) {
                      if (value != null) {
                        setState(() => _assistantCardCount = value);
                      }
                    },
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton.icon(
                onPressed: _isGeneratingAssistantCards
                    ? null
                    : () => _generateAssistantCards(data),
                icon: _isGeneratingAssistantCards
                    ? const SizedBox.square(
                        dimension: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.auto_awesome),
                label: Text(
                  _isGeneratingAssistantCards
                      ? AppLocalizations.of(context)!.generatingPreview
                      : AppLocalizations.of(context)!.generatePreview,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAiGenerationAction(FlashcardPageData data) {
    if (_showAiGenerationCard ||
        (widget.initialHandoff?.type ==
                StudyAssistantActionType.createFlashcards &&
            !_assistantHandoffDismissed)) {
      return const SizedBox.shrink();
    }
    return Align(
      alignment: Alignment.centerRight,
      child: OutlinedButton.icon(
        onPressed: _isGeneratingAssistantCards
            ? null
            : () => _openAiGeneration(data),
        icon: const Icon(Icons.auto_awesome_rounded),
        label: Text(AppLocalizations.of(context)!.createWithAi),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppResponsiveContent(
      maxWidth: AppLayoutTokens.flashcardContentWidth,
      child: ref
          .watch(flashcardsProvider(widget.nodeId))
          .when(
            loading: () => AppLoadingView(
              label: AppLocalizations.of(context)!.flashcardsLoading,
            ),
            error: (error, stack) => AppErrorView(
              message: AppLocalizations.of(context)!.flashcardsLoadFailed,
              onRetry: () => ref.invalidate(flashcardsProvider(widget.nodeId)),
            ),
            data: (data) => _activeDeckName == null
                ? Column(
                    children: [
                      _buildAssistantGenerationCard(data),
                      _buildAiGenerationAction(data),
                      Expanded(child: _buildDeckLibrary(context, data)),
                    ],
                  )
                : _buildStudySession(context),
          ),
    );
  }

  Widget _buildDeckLibrary(BuildContext context, FlashcardPageData data) {
    final nodeNames = {for (final node in data.nodes) node.id: node.title};
    final graphNames = {for (final graph in data.graphs) graph.id: graph.title};
    final cardsByNode = <String, List<FlashcardData>>{};
    for (final card in data.cards) {
      cardsByNode.putIfAbsent(card.nodeId, () => []).add(card);
    }

    final search = _search.trim().toLowerCase();
    final visibleCards = data.cards.where((card) {
      final nodeName = nodeNames[card.nodeId] ?? '';
      return '${card.title} ${card.statement} ${card.targetSkill ?? ''} $nodeName'
          .toLowerCase()
          .contains(search);
    }).toList();

    if (widget.nodeId != null) {
      final nodeName =
          nodeNames[widget.nodeId] ??
          AppLocalizations.of(context)!.nodeUnavailable;
      return _buildNodeDeck(context, data, nodeName, cardsByNode);
    }

    final graphDecks =
        <({KnowledgeGraphData graph, List<FlashcardData> cards})>[];
    for (final graph in data.graphs) {
      final nodeIds = data.nodes
          .where((node) => node.graphId == graph.id)
          .map((node) => node.id)
          .toSet();
      final cards = data.cards
          .where((card) => nodeIds.contains(card.nodeId))
          .toList();
      if (cards.isNotEmpty) graphDecks.add((graph: graph, cards: cards));
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 20,
        children: [
          AppPageHeader(
            title: AppLocalizations.of(context)!.flashcardsTitle,
            subtitle: AppLocalizations.of(
              context,
            )!.flashcardLibrarySummary(data.cards.length, data.dueCards.length),
            actions: [
              IconButton(
                tooltip: AppLocalizations.of(context)!.updateDecks,
                onPressed: () =>
                    ref.invalidate(flashcardsProvider(widget.nodeId)),
                icon: const Icon(Icons.refresh),
              ),
              OutlinedButton.icon(
                onPressed: () => _openCardEditor(nodes: data.nodes),
                icon: const Icon(Icons.add),
                label: Text(AppLocalizations.of(context)!.newCard),
              ),
              FilledButton.icon(
                onPressed: data.cards.isEmpty
                    ? null
                    : () => _openCustomDeckEditor(
                        cards: data.cards,
                        nodes: data.nodes,
                        graphs: data.graphs,
                      ),
                icon: const Icon(Icons.library_add_outlined),
                label: Text(AppLocalizations.of(context)!.createDeck),
              ),
            ],
          ),
          _buildAiGenerationAction(data),
          if (data.cards.isEmpty)
            AppEmptyView(
              icon: Icons.style_outlined,
              title: AppLocalizations.of(context)!.emptyFlashcardLibrary,
              message: AppLocalizations.of(
                context,
              )!.emptyFlashcardLibraryMessage,
              action: FilledButton.icon(
                onPressed: () => _openCardEditor(nodes: data.nodes),
                icon: const Icon(Icons.add),
                label: Text(AppLocalizations.of(context)!.createFirstCard),
              ),
            )
          else ...[
            if (data.dueCards.isNotEmpty)
              _ReviewOverview(
                dueCount: data.dueCards.length,
                totalCount: data.cards.length,
                onReview: () => _startDeck(
                  AppLocalizations.of(context)!.reviewNow,
                  data.cards,
                  data.dueCards,
                ),
              ),
            _SectionHeader(
              title: AppLocalizations.of(context)!.automaticDecks,
              subtitle: AppLocalizations.of(context)!.generatedFromGraphs,
            ),
            if (graphDecks.isNotEmpty) ...[
              Text(
                AppLocalizations.of(context)!.byGraph,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              for (final entry in graphDecks)
                _DeckTile(
                  title: entry.graph.title,
                  subtitle: AppLocalizations.of(
                    context,
                  )!.automaticGraphDeck(entry.cards.length),
                  icon: Icons.account_tree_outlined,
                  onTap: () => _startDeck(
                    entry.graph.title,
                    entry.cards,
                    _filterDue(entry.cards, data.dueCards),
                  ),
                  trailing: _StudyCount(
                    count: _filterDue(entry.cards, data.dueCards).length,
                  ),
                ),
            ],
            if (data.nodes.any(
              (node) => cardsByNode[node.id]?.isNotEmpty == true,
            )) ...[
              Text(
                AppLocalizations.of(context)!.byNode,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              for (final node in data.nodes)
                if (cardsByNode[node.id]?.isNotEmpty == true)
                  _DeckTile(
                    title: node.title,
                    subtitle: AppLocalizations.of(context)!.cardCountInDeck(
                      cardsByNode[node.id]!.length,
                      graphNames[node.graphId] ??
                          AppLocalizations.of(context)!.graphFallback,
                    ),
                    icon: Icons.account_tree_outlined,
                    onTap: () => _startDeck(
                      node.title,
                      cardsByNode[node.id]!,
                      _filterDue(cardsByNode[node.id]!, data.dueCards),
                    ),
                    trailing: _StudyCount(
                      count: _filterDue(
                        cardsByNode[node.id]!,
                        data.dueCards,
                      ).length,
                    ),
                  ),
            ],
            _SectionHeader(
              title: AppLocalizations.of(context)!.myDecks,
              subtitle: AppLocalizations.of(context)!.customDecksDescription,
              trailing: TextButton.icon(
                onPressed: () => _openCustomDeckEditor(
                  cards: data.cards,
                  nodes: data.nodes,
                  graphs: data.graphs,
                ),
                icon: const Icon(Icons.add),
                label: Text(AppLocalizations.of(context)!.newCard),
              ),
            ),
            if (data.customDecks.isEmpty)
              _HintCard(
                text: AppLocalizations.of(context)!.customDecksDescription,
              )
            else
              for (final entry in data.customDecks)
                _DeckTile(
                  title: entry.deck.name,
                  subtitle: AppLocalizations.of(context)!.cardCountInDeck(
                    entry.cards.length,
                    AppLocalizations.of(context)!.customDeckKind,
                  ),
                  icon: Icons.style_outlined,
                  onTap: () => _startDeck(
                    entry.deck.name,
                    entry.cards,
                    _filterDue(entry.cards, data.dueCards),
                  ),
                  onEdit: () => _openCustomDeckEditor(
                    cards: data.cards,
                    nodes: data.nodes,
                    graphs: data.graphs,
                    entry: entry,
                  ),
                  onDelete: () => _deleteCustomDeck(entry.deck),
                  trailing: _StudyCount(
                    count: _filterDue(entry.cards, data.dueCards).length,
                  ),
                ),
            const Divider(),
            ExpansionTile(
              title: Text(
                AppLocalizations.of(context)!.allCards(data.cards.length),
              ),
              subtitle: Text(
                AppLocalizations.of(context)!.searchEditRemoveCards,
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    onChanged: (value) => setState(() => _search = value),
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: AppLocalizations.of(context)!.searchCardNode,
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                for (final card in visibleCards)
                  AppCard(
                    title: card.title,
                    subtitle:
                        card.targetSkill ??
                        nodeNames[card.nodeId] ??
                        AppLocalizations.of(context)!.flashcard,
                    onTap: () => _openCardEditor(card: card, nodes: data.nodes),
                    trailing: IconButton(
                      tooltip: AppLocalizations.of(context)!.deleteFlashcard,
                      onPressed: () => _deleteCard(card),
                      icon: const Icon(Icons.delete_outline),
                    ),
                    child: Text(
                      card.statement,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                if (visibleCards.isEmpty)
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      AppLocalizations.of(context)!.noCardsMatchSearch,
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNodeDeck(
    BuildContext context,
    FlashcardPageData data,
    String nodeName,
    Map<String, List<FlashcardData>> cardsByNode,
  ) {
    final cards = cardsByNode[widget.nodeId] ?? const <FlashcardData>[];
    final dueCards = _filterDue(cards, data.dueCards);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 20,
        children: [
          AppPageHeader(
            title: nodeName,
            subtitle: AppLocalizations.of(
              context,
            )!.flashcardLibrarySummary(cards.length, dueCards.length),
            actions: [
              OutlinedButton.icon(
                onPressed: () => _openCardEditor(nodes: data.nodes),
                icon: const Icon(Icons.add),
                label: Text(AppLocalizations.of(context)!.newCard),
              ),
              FilledButton.icon(
                onPressed: cards.isEmpty
                    ? null
                    : () => _startDeck(nodeName, cards, dueCards),
                icon: const Icon(Icons.play_arrow_rounded),
                label: Text(AppLocalizations.of(context)!.studyDeck),
              ),
            ],
          ),
          _buildAiGenerationAction(data),
          if (cards.isEmpty)
            AppEmptyView(
              icon: Icons.style_outlined,
              title: AppLocalizations.of(context)!.nodeNoCardsTitle,
              message: AppLocalizations.of(context)!.nodeNoCardsMessage,
              action: FilledButton.icon(
                onPressed: () => _openCardEditor(nodes: data.nodes),
                icon: const Icon(Icons.add),
                label: Text(AppLocalizations.of(context)!.newFlashcard),
              ),
            )
          else ...[
            if (dueCards.isEmpty)
              _HintCard(text: AppLocalizations.of(context)!.allCardsUpToDate),
            if (dueCards.isNotEmpty)
              _ReviewOverview(
                dueCount: dueCards.length,
                totalCount: cards.length,
                onReview: () => _startDeck(nodeName, cards, dueCards),
              ),
            Text(
              AppLocalizations.of(context)!.nodeCards,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            for (final card in cards)
              AppCard(
                title: card.title,
                subtitle:
                    card.targetSkill ?? AppLocalizations.of(context)!.flashcard,
                onTap: () => _openCardEditor(card: card, nodes: data.nodes),
                trailing: IconButton(
                  tooltip: AppLocalizations.of(context)!.deleteFlashcard,
                  onPressed: () => _deleteCard(card),
                  icon: const Icon(Icons.delete_outline),
                ),
                child: Text(
                  card.statement,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
          ],
        ],
      ),
    );
  }

  Widget _buildStudySession(BuildContext context) {
    final activeName = _activeDeckName!;
    if (_sessionComplete || _studyCards.isEmpty) {
      return _StudyCompleteView(
        deckName: activeName,
        reviewedCount: _reviewedCount,
        totalReviewSeconds: _totalReviewSeconds,
        hasCards: _studyCards.isNotEmpty,
        onBack: _stopStudy,
        onStudyAll: () => setState(() {
          _studyCards = List.of(_selectedDeckAllCards);
          _studyIndex = 0;
          _reviewedCount = 0;
          _totalReviewSeconds = 0;
          _showAnswer = false;
          _sessionComplete = _studyCards.isEmpty;
          _reviewTimer
            ..reset()
            ..start();
        }),
      );
    }

    final card = _studyCards[_studyIndex];
    final completed = _reviewedCount;
    final progress = _studyCards.isEmpty ? 0.0 : completed / _studyCards.length;

    void flip() => setState(() => _showAnswer = !_showAnswer);
    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.space): flip,
        const SingleActivator(LogicalKeyboardKey.enter): () {
          if (!_showAnswer) setState(() => _showAnswer = true);
        },
        const SingleActivator(LogicalKeyboardKey.escape): _stopStudy,
        const SingleActivator(LogicalKeyboardKey.digit1): () {
          if (_showAnswer && !_isReviewing) _review(card, 'again');
        },
        const SingleActivator(LogicalKeyboardKey.digit2): () {
          if (_showAnswer && !_isReviewing) _review(card, 'hard');
        },
        const SingleActivator(LogicalKeyboardKey.digit3): () {
          if (_showAnswer && !_isReviewing) _review(card, 'good');
        },
        const SingleActivator(LogicalKeyboardKey.digit4): () {
          if (_showAnswer && !_isReviewing) _review(card, 'easy');
        },
      },
      child: Focus(
        autofocus: true,
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  tooltip: AppLocalizations.of(context)!.returnDecksEsc,
                  onPressed: _stopStudy,
                  icon: const Icon(Icons.arrow_back),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        activeName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        AppLocalizations.of(context)!.cardProgress(
                          _studyIndex + 1,
                          _studyCards.length,
                          completed,
                        ),
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Semantics(
              label: AppLocalizations.of(context)!.reviewProgress,
              value: '${(progress * 100).round()} por cento',
              child: LinearProgressIndicator(value: progress),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Center(
                child: _StudyCard(
                  key: ValueKey('${card.id}-$_showAnswer'),
                  card: card,
                  showAnswer: _showAnswer,
                  onFlip: flip,
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (!_showAnswer)
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => setState(() => _showAnswer = true),
                  child: Padding(
                    padding: EdgeInsets.all(14),
                    child: Text(AppLocalizations.of(context)!.showAnswerSpace),
                  ),
                ),
              )
            else
              _RatingBar(
                isSaving: _isReviewing,
                onRate: (rating) => _review(card, rating),
              ),
          ],
        ),
      ),
    );
  }
}

List<FlashcardData> _filterDue(
  List<FlashcardData> cards,
  List<FlashcardData> dueCards,
) {
  final dueIds = dueCards.map((card) => card.id).toSet();
  return cards.where((card) => dueIds.contains(card.id)).toList();
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.subtitle,
    this.trailing,
  });

  final String title;
  final String subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 4),
              Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
        trailing ?? const SizedBox.shrink(),
      ],
    );
  }
}

class _DeckTile extends StatelessWidget {
  const _DeckTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
    required this.trailing,
    this.onEdit,
    this.onDelete,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;
  final Widget trailing;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(child: Icon(icon)),
        title: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Text(subtitle),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            trailing,
            if (onEdit != null || onDelete != null)
              PopupMenuButton<String>(
                tooltip: AppLocalizations.of(context)!.deckOptions,
                onSelected: (value) {
                  if (value == 'edit') onEdit?.call();
                  if (value == 'delete') onDelete?.call();
                },
                itemBuilder: (context) => [
                  if (onEdit != null)
                    PopupMenuItem(
                      value: 'edit',
                      child: Text(AppLocalizations.of(context)!.edit),
                    ),
                  if (onDelete != null)
                    PopupMenuItem(
                      value: 'delete',
                      child: Text(
                        AppLocalizations.of(context)!.deleteFlashcard,
                      ),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _StudyCount extends StatelessWidget {
  const _StudyCount({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: AppLocalizations.of(context)!.dueCardsNow(count),
      child: Chip(
        avatar: const Icon(Icons.schedule, size: 16),
        label: Text('$count'),
        visualDensity: VisualDensity.compact,
      ),
    );
  }
}

class _HintCard extends StatelessWidget {
  const _HintCard({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.info_outline),
            const SizedBox(width: 12),
            Expanded(child: Text(text)),
          ],
        ),
      ),
    );
  }
}

class _ReviewOverview extends StatelessWidget {
  const _ReviewOverview({
    required this.dueCount,
    required this.totalCount,
    required this.onReview,
  });

  final int dueCount;
  final int totalCount;
  final VoidCallback onReview;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      color: theme.colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              Icons.bolt_rounded,
              size: 28,
              color: theme.colorScheme.onPrimaryContainer,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.cardCountInDeck(
                      dueCount,
                      AppLocalizations.of(context)!.flashcard,
                    ),
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                  Text(
                    AppLocalizations.of(
                      context,
                    )!.reviewedCardsSummary(totalCount),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            FilledButton.tonalIcon(
              onPressed: onReview,
              icon: const Icon(Icons.play_arrow_rounded),
              label: Text(AppLocalizations.of(context)!.reviewNow),
            ),
          ],
        ),
      ),
    );
  }
}

class _StudyCard extends StatelessWidget {
  const _StudyCard({
    super.key,
    required this.card,
    required this.showAnswer,
    required this.onFlip,
  });

  final FlashcardData card;
  final bool showAnswer;
  final VoidCallback onFlip;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Semantics(
      button: true,
      label: showAnswer
          ? AppLocalizations.of(context)!.flashcardAnswer
          : AppLocalizations.of(context)!.flashcardQuestion,
      hint: AppLocalizations.of(context)!.revealCardHint,
      onTap: onFlip,
      child: GestureDetector(
        onTap: onFlip,
        onVerticalDragEnd: (details) {
          if ((details.primaryVelocity ?? 0) < -250) onFlip();
        },
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 680, minHeight: 280),
          child: Card(
            color: showAnswer
                ? colors.secondaryContainer
                : colors.surfaceContainerHigh,
            clipBehavior: Clip.antiAlias,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              transitionBuilder: (child, animation) => FadeTransition(
                opacity: animation,
                child: ScaleTransition(scale: animation, child: child),
              ),
              child: Padding(
                key: ValueKey(showAnswer),
                padding: const EdgeInsets.all(32),
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        showAnswer
                            ? AppLocalizations.of(context)!.answerLabel
                            : AppLocalizations.of(context)!.questionLabel,
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      const SizedBox(height: 24),
                      SelectableText(
                        showAnswer ? card.statement : card.title,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        showAnswer
                            ? AppLocalizations.of(context)!.tapToQuestion
                            : AppLocalizations.of(context)!.tapToReveal,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RatingBar extends StatelessWidget {
  const _RatingBar({required this.isSaving, required this.onRate});

  final bool isSaving;
  final ValueChanged<String> onRate;

  @override
  Widget build(BuildContext context) {
    final ratings = [
      (
        AppLocalizations.of(context)!.ratingAgain,
        'again',
        '1',
        Theme.of(context).colorScheme.error,
      ),
      (
        AppLocalizations.of(context)!.ratingHard,
        'hard',
        '2',
        Theme.of(context).colorScheme.tertiary,
      ),
      (
        AppLocalizations.of(context)!.ratingGood,
        'good',
        '3',
        Theme.of(context).colorScheme.primary,
      ),
      (
        AppLocalizations.of(context)!.ratingEasy,
        'easy',
        '4',
        Theme.of(context).colorScheme.secondary,
      ),
    ];
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final rating in ratings)
          FilledButton.tonal(
            onPressed: isSaving ? null : () => onRate(rating.$2),
            style: FilledButton.styleFrom(
              foregroundColor: rating.$4,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(rating.$1),
                const SizedBox(height: 2),
                Text(
                  AppLocalizations.of(context)!.keyboardKey(rating.$3),
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ],
            ),
          ),
        if (isSaving)
          const SizedBox.square(
            dimension: 24,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
      ],
    );
  }
}

class _StudyCompleteView extends StatelessWidget {
  const _StudyCompleteView({
    required this.deckName,
    required this.reviewedCount,
    required this.totalReviewSeconds,
    required this.hasCards,
    required this.onBack,
    required this.onStudyAll,
  });

  final String deckName;
  final int reviewedCount;
  final int totalReviewSeconds;
  final bool hasCards;
  final VoidCallback onBack;
  final VoidCallback onStudyAll;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              hasCards ? Icons.celebration_outlined : Icons.event_available,
              size: 64,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              hasCards
                  ? AppLocalizations.of(context)!.reviewComplete
                  : AppLocalizations.of(context)!.allCaughtUp,
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            if (hasCards) ...[
              const SizedBox(height: 8),
              Text(
                AppLocalizations.of(
                  context,
                )!.reviewTime(_formatReviewDuration(totalReviewSeconds)),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
            const SizedBox(height: 8),
            Text(
              hasCards
                  ? AppLocalizations.of(
                      context,
                    )!.cardsReviewed(reviewedCount, deckName)
                  : AppLocalizations.of(context)!.noPendingCards,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 8,
              children: [
                OutlinedButton(
                  onPressed: onBack,
                  child: Text(AppLocalizations.of(context)!.backToDecks),
                ),
                if (!hasCards)
                  FilledButton(
                    onPressed: onStudyAll,
                    child: Text(AppLocalizations.of(context)!.studyAllAnyway),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

String _formatReviewDuration(int totalSeconds) {
  final minutes = totalSeconds ~/ 60;
  final seconds = totalSeconds % 60;
  if (minutes == 0) return '$seconds s';
  return seconds == 0 ? '$minutes min' : '$minutes min $seconds s';
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
  const _FlashcardDialog({
    required this.nodes,
    required this.selectedNodeId,
    this.card,
  });

  final FlashcardData? card;
  final List<GraphNodeData> nodes;
  final String? selectedNodeId;

  @override
  State<_FlashcardDialog> createState() => _FlashcardDialogState();
}

class _FlashcardDialogState extends State<_FlashcardDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _title;
  late final TextEditingController _statement;
  late final TextEditingController _skill;
  String? _nodeId;

  @override
  void initState() {
    super.initState();
    _nodeId =
        widget.selectedNodeId ??
        widget.card?.nodeId ??
        (widget.nodes.isEmpty ? null : widget.nodes.first.id);
    _title = TextEditingController(text: widget.card?.title);
    _statement = TextEditingController(text: widget.card?.statement);
    _skill = TextEditingController(text: widget.card?.targetSkill);
  }

  @override
  void dispose() {
    _title.dispose();
    _statement.dispose();
    _skill.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.card == null
            ? AppLocalizations.of(context)!.newFlashcard
            : AppLocalizations.of(context)!.editFlashcard,
      ),
      content: SizedBox(
        width: 460,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 12,
              children: [
                if (widget.selectedNodeId == null && widget.card == null)
                  DropdownButtonFormField<String>(
                    initialValue: _nodeId,
                    isExpanded: true,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.relatedNode,
                      border: OutlineInputBorder(),
                    ),
                    items: [
                      for (final node in widget.nodes)
                        DropdownMenuItem(
                          value: node.id,
                          child: Text(
                            '${node.title} · ${node.type}',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                    onChanged: (value) => setState(() => _nodeId = value),
                    validator: (value) => value == null
                        ? AppLocalizations.of(context)!.selectNode
                        : null,
                  ),
                TextFormField(
                  controller: _title,
                  textCapitalization: TextCapitalization.sentences,
                  maxLength: 120,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.frontCard,
                    hintText: AppLocalizations.of(context)!.questionConceptTerm,
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value?.trim().isEmpty == true
                      ? AppLocalizations.of(context)!.frontRequired
                      : null,
                ),
                TextFormField(
                  controller: _statement,
                  textCapitalization: TextCapitalization.sentences,
                  minLines: 3,
                  maxLines: 7,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.backCard,
                    hintText: AppLocalizations.of(context)!.answerExplanation,
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                  validator: (value) => value?.trim().isEmpty == true
                      ? AppLocalizations.of(context)!.answerRequired
                      : null,
                ),
                TextFormField(
                  controller: _skill,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.skill,
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(AppLocalizations.of(context)!.cancel),
        ),
        FilledButton(
          onPressed: () {
            if (!(_formKey.currentState?.validate() ?? false) ||
                _nodeId == null) {
              return;
            }
            Navigator.pop(
              context,
              _FlashcardDraft(
                nodeId: _nodeId!,
                title: _title.text.trim(),
                statement: _statement.text.trim(),
                targetSkill: _skill.text.trim().isEmpty
                    ? null
                    : _skill.text.trim(),
              ),
            );
          },
          child: Text(AppLocalizations.of(context)!.saveCard),
        ),
      ],
    );
  }
}

class _CustomDeckDraft {
  const _CustomDeckDraft({required this.name, required this.cardIds});

  final String name;
  final List<String> cardIds;
}

class _CustomDeckDialog extends StatefulWidget {
  const _CustomDeckDialog({
    required this.cards,
    required this.nodes,
    required this.graphs,
    required this.initialDeck,
  });

  final List<FlashcardData> cards;
  final List<GraphNodeData> nodes;
  final List<KnowledgeGraphData> graphs;
  final CustomDeckEntry? initialDeck;

  @override
  State<_CustomDeckDialog> createState() => _CustomDeckDialogState();
}

class _CustomDeckDialogState extends State<_CustomDeckDialog> {
  late final TextEditingController _name;
  late final Set<String> _selectedIds;
  String _search = '';
  String? _validationError;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.initialDeck?.deck.name);
    _selectedIds =
        widget.initialDeck?.cards.map((card) => card.id).toSet() ?? <String>{};
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final nodeNames = {for (final node in widget.nodes) node.id: node.title};
    final nodeGraphIds = {
      for (final node in widget.nodes) node.id: node.graphId,
    };
    final graphNames = {
      for (final graph in widget.graphs) graph.id: graph.title,
    };
    final query = _search.trim().toLowerCase();
    final cards = widget.cards.where((card) {
      return '${card.title} ${card.statement} ${nodeNames[card.nodeId] ?? ''}'
          .toLowerCase()
          .contains(query);
    });

    return AlertDialog(
      title: Text(
        widget.initialDeck == null
            ? AppLocalizations.of(context)!.createDeckTitle
            : AppLocalizations.of(context)!.editDeckTitle,
      ),
      content: SizedBox(
        width: 560,
        height: MediaQuery.sizeOf(context).height * .65,
        child: Column(
          children: [
            TextField(
              controller: _name,
              textCapitalization: TextCapitalization.sentences,
              maxLength: 80,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.deckName,
                border: OutlineInputBorder(),
              ),
              onChanged: (_) => setState(() => _validationError = null),
            ),
            TextField(
              onChanged: (value) => setState(() => _search = value),
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: AppLocalizations.of(context)!.searchCardsAnyGraph,
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Text(
                    AppLocalizations.of(
                      context,
                    )!.selectedCards(_selectedIds.length),
                  ),
                ),
                TextButton(
                  onPressed: () => setState(() {
                    _selectedIds.addAll(cards.map((card) => card.id));
                  }),
                  child: Text(AppLocalizations.of(context)!.selectVisible),
                ),
                TextButton(
                  onPressed: () => setState(() {
                    for (final card in cards) {
                      _selectedIds.remove(card.id);
                    }
                  }),
                  child: Text(AppLocalizations.of(context)!.clearVisible),
                ),
              ],
            ),
            if (_validationError != null)
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  _validationError!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
            Expanded(
              child: ListView(
                children: [
                  for (final card in cards)
                    CheckboxListTile(
                      value: _selectedIds.contains(card.id),
                      onChanged: (selected) => setState(() {
                        if (selected == true) {
                          _selectedIds.add(card.id);
                        } else {
                          _selectedIds.remove(card.id);
                        }
                      }),
                      title: Text(card.title),
                      subtitle: Text(
                        '${nodeNames[card.nodeId] ?? AppLocalizations.of(context)!.nodeUnavailable} · ${graphNames[nodeGraphIds[card.nodeId]] ?? AppLocalizations.of(context)!.graphFallback}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                  if (cards.isEmpty)
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        AppLocalizations.of(context)!.noCardsMatchSearch,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(AppLocalizations.of(context)!.cancel),
        ),
        FilledButton(
          onPressed: () {
            if (_name.text.trim().isEmpty) {
              setState(
                () => _validationError = AppLocalizations.of(
                  context,
                )!.deckNameRequired,
              );
              return;
            }
            if (_selectedIds.isEmpty) {
              setState(
                () => _validationError = AppLocalizations.of(
                  context,
                )!.atLeastOneCard,
              );
              return;
            }
            Navigator.pop(
              context,
              _CustomDeckDraft(
                name: _name.text.trim(),
                cardIds: _selectedIds.toList(),
              ),
            );
          },
          child: Text(AppLocalizations.of(context)!.saveDeck),
        ),
      ],
    );
  }
}
