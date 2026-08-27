
import 'package:freezed_annotation/freezed_annotation.dart';

part 'edge_form_state.freezed.dart';

@freezed
sealed class EdgeformState with _$EdgeformState {
  const factory EdgeformState({
    @Default("") String graphId,
    @Default("") String sourceNodeId,
    @Default("") String targetNodeId,
    @Default("") String type,
    @Default(0) double weight,
  }) = _EdgeformState;
}