
import 'package:freezed_annotation/freezed_annotation.dart';

part 'node_form_state.freezed.dart';

@freezed
sealed class NodeformState with _$NodeformState {
  const factory NodeformState({
    @Default("") String graphId,
    @Default("") String type,
    @Default("") String title,
    @Default("") String description,
    @Default(0) double maesteryScore,
    @Default(false) bool isSkipped,
    @Default(0) double positionX,
    @Default(0) double positionY,
    @Default("") String aiSynthesis,
  }) = _NodeformState;
}