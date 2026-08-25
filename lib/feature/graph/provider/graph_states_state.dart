
import 'package:freezed_annotation/freezed_annotation.dart';

part 'graph_states_state.freezed.dart';

@freezed
sealed class GraphStatesSate with _$GraphStatesSate {
  const factory GraphStatesSate({
    @Default(false) bool isEditing,
    @Default(false) bool isCreatingNode,
    @Default(false) bool isCreatingEdge,
  }) = _GraphStatesSate;
}