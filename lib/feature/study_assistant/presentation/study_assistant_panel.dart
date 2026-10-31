import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:noema/core/router/route_paths.dart';
import 'package:noema/feature/study_assistant/models/study_assistant_action.dart';
import 'package:noema/feature/study_assistant/models/study_assistant_state.dart';
import 'package:noema/feature/study_assistant/providers/study_assistant_preferences_provider.dart';
import 'package:noema/feature/study_assistant/providers/study_assistant_provider.dart';

class StudyAssistantPanel extends ConsumerStatefulWidget {
  const StudyAssistantPanel({super.key});

  @override
  ConsumerState<StudyAssistantPanel> createState() =>
      _StudyAssistantPanelState();
}

class _StudyAssistantPanelState extends ConsumerState<StudyAssistantPanel> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _send([String? suggestion]) async {
    final text = suggestion ?? _messageController.text;
    if (text.trim().isEmpty) return;
    _messageController.clear();
    final request = ref.read(studyAssistantProvider.notifier).send(
      text: text,
      currentPath: GoRouterState.of(context).uri.path,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _scrollToLatest();
    });
    await request;
    if (!mounted || !_scrollController.hasClients) return;
    await _scrollToLatest();
  }

  Future<void> _scrollToLatest() async {
    if (!_scrollController.hasClients) return;
    await _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
    );
  }

  Future<void> _setGoal(String currentGoal) async {
    final controller = TextEditingController(text: currentGoal);
    final goal = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Seu objetivo de estudo'),
        content: TextField(
          controller: controller,
          autofocus: true,
          maxLength: 160,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: 'Ex.: Aprender cálculo para a prova de dezembro',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: const Text('Salvar objetivo'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (goal == null || !mounted) return;
    try {
      await ref
          .read(studyAssistantSettingsProvider.notifier)
          .setLearningGoal(goal);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Não foi possível salvar o objetivo: $error')),
      );
    }
  }

  Future<void> _openAction(StudyAssistantAction action) async {
    if (action.type == StudyAssistantActionType.createGraph &&
        action.prompt.trim().length < 5) {
      _showActionError('A proposta não inclui um tema suficiente para o grafo.');
      return;
    }
    if (action.type == StudyAssistantActionType.createFlashcards &&
        action.prompt.isEmpty) {
      _showActionError('A proposta não inclui um tema para os flashcards.');
      return;
    }

    late final StudyAssistantSettings settings;
    try {
      settings = await ref.read(studyAssistantSettingsProvider.future);
    } catch (error) {
      if (mounted) _showActionError('Não foi possível carregar preferências: $error');
      return;
    }
    if (!mounted) return;
    final autoGenerate = settings.autoGenerateActions;
    final assistant = ref.read(studyAssistantProvider.notifier);
    final handoff = StudyAssistantHandoff(
      type: action.type,
      prompt: action.prompt,
      exerciseType: action.exerciseType,
      graphId: action.graphId,
      nodeId: action.nodeId,
      autoGenerate: autoGenerate,
    );

    switch (action.type) {
      case StudyAssistantActionType.navigate:
        final destination = _destinationPath(action.destination);
        if (destination == null) {
          _showActionError('Essa página não está disponível para navegação.');
          return;
        }
        assistant.close();
        context.go(destination);
      case StudyAssistantActionType.createGraph:
      case StudyAssistantActionType.createFlashcards:
      case StudyAssistantActionType.createExercise:
        assistant.prepareAction(action, autoGenerate: autoGenerate);
        switch (action.type) {
          case StudyAssistantActionType.createGraph:
            context.go(RoutePaths.graphs, extra: handoff);
          case StudyAssistantActionType.createFlashcards:
            context.go(RoutePaths.flashcards, extra: handoff);
          case StudyAssistantActionType.createExercise:
            final graphId = action.graphId;
            final nodeId = action.nodeId;
            if (graphId == null || nodeId == null) {
              context.go(RoutePaths.graphs, extra: handoff);
            } else {
              final isOpenEnded = action.exerciseType == 'open_ended';
              context.go(
                isOpenEnded
                    ? RoutePaths.openEndedCreate(graphId, nodeId)
                    : RoutePaths.multipleChoiceCreate(graphId, nodeId),
                extra: handoff,
              );
            }
          case StudyAssistantActionType.navigate:
            break;
        }
    }
  }

  String? _destinationPath(String? destination) => switch (destination) {
    'home' => RoutePaths.home,
    'graphs' => RoutePaths.graphs,
    'flashcards' => RoutePaths.flashcards,
    'notes' => RoutePaths.notes,
    'study_sessions' => RoutePaths.studySessions,
    _ => null,
  };

  void _showActionError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _togglePinned(bool isPinned) async {
    try {
      await ref
          .read(studyAssistantSettingsProvider.notifier)
          .setPinPanel(!isPinned);
    } catch (error) {
      if (!mounted) return;
      _showActionError('Não foi possível salvar a preferência: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(studyAssistantProvider);
    final preferences = ref.watch(studyAssistantSettingsProvider).asData?.value;
    final theme = Theme.of(context);
    return Material(
      elevation: 8,
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(20),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
              _buildHeader(
                state,
                preferences?.learningGoal ?? '',
                isPinned: preferences?.pinPanel ?? false,
              ),
              if (preferences?.learningGoal.isNotEmpty == true)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  color: theme.colorScheme.secondaryContainer,
                  child: Text(
                    'Objetivo: ${preferences!.learningGoal}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelMedium,
                  ),
                ),
              if (state.error != null) _buildError(state.error!),
              Expanded(
                child: state.messages.isEmpty
                    ? _buildWelcome()
                    : ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(14),
                        itemCount: state.messages.length +
                            (state.isSending ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == state.messages.length) {
                            return const _TypingIndicator();
                          }
                          final message = state.messages[index];
                          return _MessageBubble(
                            message: message,
                            onAction: _openAction,
                          );
                        },
                      ),
              ),
              _buildComposer(state),
        ],
      ),
    );
  }

  Widget _buildHeader(
    StudyAssistantState state,
    String goal, {
    required bool isPinned,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 8, 6, 8),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            child: Icon(
              Icons.auto_awesome,
              size: 19,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Assistente de estudos',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                Text('Planeje, entenda e pratique'),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Definir objetivo de estudo',
            onPressed: () => _setGoal(goal),
            icon: const Icon(Icons.flag_outlined),
          ),
          if (state.messages.isNotEmpty)
            IconButton(
              tooltip: 'Limpar conversa',
              onPressed: state.isSending
                  ? null
                  : () => ref
                      .read(studyAssistantProvider.notifier)
                      .clearConversation(),
              icon: const Icon(Icons.delete_sweep_outlined),
            ),
          IconButton(
              tooltip: isPinned
                  ? 'Desafixar painel'
                  : 'Manter painel fixado ao lado',
              onPressed: () => _togglePinned(isPinned),
              icon: Icon(
                isPinned ? Icons.push_pin : Icons.push_pin_outlined,
              ),
            ),
          IconButton(
            tooltip: 'Fechar assistente',
            onPressed: () =>
                ref.read(studyAssistantProvider.notifier).close(),
            icon: const Icon(Icons.close),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcome() {
    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        Text(
          'Vamos estudar melhor?',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        const Text(
          'Posso explicar conceitos, organizar um plano e preparar atividades. '
          'Quando uma ação exigir geração, você confirma antes de começar.',
        ),
        const SizedBox(height: 18),
        for (final prompt in const [
          'Ajude-me a montar um plano de estudo para esta semana.',
          'Explique o assunto que estou estudando de forma simples.',
          'Quero praticar: sugira um exercício sobre meu objetivo.',
        ])
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: OutlinedButton(
              onPressed: () => _send(prompt),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(prompt),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildError(String error) {
    return Container(
      width: double.infinity,
      color: Theme.of(context).colorScheme.errorContainer,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: Text(
        error,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: Theme.of(context).colorScheme.onErrorContainer),
      ),
    );
  }

  Widget _buildComposer(StudyAssistantState state) {
    final sendOnEnter =
        ref.watch(studyAssistantSettingsProvider).asData?.value.sendOnEnter ??
        false;
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: TextField(
                controller: _messageController,
                enabled: !state.isSending,
                minLines: 1,
                maxLines: 4,
                maxLength: 1000,
                textInputAction: sendOnEnter
                    ? TextInputAction.send
                    : TextInputAction.newline,
                buildCounter:
                    (
                      context, {
                      required currentLength,
                      required isFocused,
                      maxLength,
                    }) => null,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  hintText: 'Pergunte ou descreva seu objetivo...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(18)),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                ),
                onSubmitted: sendOnEnter ? (_) => _send() : null,
              ),
            ),
            const SizedBox(width: 8),
            IconButton.filled(
              tooltip: 'Enviar mensagem',
              onPressed: state.isSending ? null : _send,
              icon: state.isSending
                  ? const SizedBox.square(
                      dimension: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.send),
            ),
          ],
        ),
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message, required this.onAction});

  final StudyAssistantMessage message;
  final ValueChanged<StudyAssistantAction> onAction;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final color = message.isUser ? colors.primaryContainer : colors.surfaceContainerHigh;
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 310),
        child: Card(
          color: color,
          margin: const EdgeInsets.only(bottom: 10),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SelectableText(message.text),
                if (message.actions.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  for (final action in message.actions)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () => onAction(action),
                          icon: Icon(_iconFor(action.type), size: 18),
                          label: Text(action.title),
                        ),
                      ),
                    ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _iconFor(StudyAssistantActionType type) => switch (type) {
    StudyAssistantActionType.navigate => Icons.open_in_new,
    StudyAssistantActionType.createGraph => Icons.account_tree_outlined,
    StudyAssistantActionType.createFlashcards => Icons.style_outlined,
    StudyAssistantActionType.createExercise => Icons.quiz_outlined,
  };
}

class _TypingIndicator extends StatelessWidget {
  const _TypingIndicator();

  @override
  Widget build(BuildContext context) {
    return const Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox.square(
              dimension: 14,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            SizedBox(width: 10),
            Text('Pensando...'),
          ],
        ),
      ),
    );
  }
}
