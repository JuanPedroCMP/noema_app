import 'package:noema/feature/study_assistant/models/study_assistant_action.dart';

class StudyAssistantMessage {
  const StudyAssistantMessage({
    required this.text,
    required this.isUser,
    this.actions = const [],
  });

  final String text;
  final bool isUser;
  final List<StudyAssistantAction> actions;
}

class StudyAssistantState {
  const StudyAssistantState({
    this.messages = const [],
    this.isOpen = false,
    this.isSending = false,
    this.learningGoal = '',
    this.error,
    this.pendingHandoff,
  });

  final List<StudyAssistantMessage> messages;
  final bool isOpen;
  final bool isSending;
  final String learningGoal;
  final String? error;
  final StudyAssistantHandoff? pendingHandoff;

  StudyAssistantState copyWith({
    List<StudyAssistantMessage>? messages,
    bool? isOpen,
    bool? isSending,
    String? learningGoal,
    String? error,
    bool clearError = false,
    StudyAssistantHandoff? pendingHandoff,
    bool clearPendingHandoff = false,
  }) {
    return StudyAssistantState(
      messages: messages ?? this.messages,
      isOpen: isOpen ?? this.isOpen,
      isSending: isSending ?? this.isSending,
      learningGoal: learningGoal ?? this.learningGoal,
      error: clearError ? null : error ?? this.error,
      pendingHandoff: clearPendingHandoff
          ? null
          : pendingHandoff ?? this.pendingHandoff,
    );
  }
}

class StudyAssistantSettings {
  const StudyAssistantSettings({
    this.autoGenerateActions = false,
    this.learningGoal = '',
    this.pinPanel = false,
    this.responseStyle = StudyAssistantResponseStyle.balanced,
    this.sendOnEnter = false,
  });

  final bool autoGenerateActions;
  final String learningGoal;
  final bool pinPanel;
  final StudyAssistantResponseStyle responseStyle;
  final bool sendOnEnter;

  StudyAssistantSettings copyWith({
    bool? autoGenerateActions,
    String? learningGoal,
    bool? pinPanel,
    StudyAssistantResponseStyle? responseStyle,
    bool? sendOnEnter,
  }) {
    return StudyAssistantSettings(
      autoGenerateActions: autoGenerateActions ?? this.autoGenerateActions,
      learningGoal: learningGoal ?? this.learningGoal,
      pinPanel: pinPanel ?? this.pinPanel,
      responseStyle: responseStyle ?? this.responseStyle,
      sendOnEnter: sendOnEnter ?? this.sendOnEnter,
    );
  }
}

enum StudyAssistantResponseStyle {
  concise,
  balanced,
  detailed;

  static StudyAssistantResponseStyle fromPreference(Object? value) =>
      switch (value) {
        'concise' => StudyAssistantResponseStyle.concise,
        'detailed' => StudyAssistantResponseStyle.detailed,
        _ => StudyAssistantResponseStyle.balanced,
      };
}
