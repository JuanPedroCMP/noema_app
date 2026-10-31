import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noema/feature/study_assistant/models/study_assistant_action.dart';
import 'package:noema/feature/study_assistant/models/study_assistant_state.dart';
import 'package:noema/feature/study_assistant/services/study_assistant_service.dart';

class StudyAssistantNotifier extends Notifier<StudyAssistantState> {
  @override
  StudyAssistantState build() => const StudyAssistantState();

  void open() => state = state.copyWith(isOpen: true);

  void close() => state = state.copyWith(isOpen: false);

  void clearConversation() {
    if (state.isSending) return;
    state = state.copyWith(messages: const [], clearError: true);
  }

  void consumeHandoff() {
    state = state.copyWith(clearPendingHandoff: true);
  }

  void prepareAction(
    StudyAssistantAction action, {
    required bool autoGenerate,
  }) {
    state = state.copyWith(
      pendingHandoff: StudyAssistantHandoff(
        type: action.type,
        prompt: action.prompt,
        exerciseType: action.exerciseType,
        graphId: action.graphId,
        nodeId: action.nodeId,
        autoGenerate: autoGenerate,
      ),
      isOpen: false,
    );
  }

  Future<void> send({
    required String text,
    required String currentPath,
  }) async {
    final message = text.trim();
    if (message.isEmpty || state.isSending) return;
    if (message.length > 1000) {
      state = state.copyWith(
        error: 'A mensagem deve ter no máximo 1.000 caracteres.',
      );
      return;
    }

    final messages = [
      ...state.messages,
      StudyAssistantMessage(text: message, isUser: true),
    ];
    state = state.copyWith(
      messages: messages,
      isSending: true,
      clearError: true,
    );
    try {
      final response = await ref
          .read(studyAssistantServiceProvider)
          .respond(history: messages, currentPath: currentPath);
      if (!ref.mounted) return;
      state = state.copyWith(
        messages: [
          ...messages,
          StudyAssistantMessage(
            text: response.text,
            isUser: false,
            actions: response.actions,
          ),
        ].takeLast(30).toList(growable: false),
        isSending: false,
        clearError: true,
      );
    } catch (error) {
      if (!ref.mounted) return;
      state = state.copyWith(
        isSending: false,
        error: 'Não foi possível responder: $error',
      );
    }
  }
}

extension<T> on List<T> {
  Iterable<T> takeLast(int count) => skip(length > count ? length - count : 0);
}

final studyAssistantProvider =
    NotifierProvider<StudyAssistantNotifier, StudyAssistantState>(
      StudyAssistantNotifier.new,
    );
