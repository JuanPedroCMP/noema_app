import 'package:freezed_annotation/freezed_annotation.dart';

part 'preferences_state.freezed.dart';

enum EdgeStyle { straight, oneVertex, cubic, rounded }

@freezed
sealed class PreferencesState with _$PreferencesState {
  const factory PreferencesState({
    @Default(true) bool autoCorrectOpenEndedWhithAi,
    @Default(true) bool autoFeedbackMultipleChoiseWhithAi,
    @Default(EdgeStyle.rounded) EdgeStyle edgeStyle,
  }) = _PreferencesState;
}
