import 'package:freezed_annotation/freezed_annotation.dart';

part 'color_form_state.freezed.dart';

@freezed
sealed class ColorUpFormState with _$ColorUpFormState {
  const factory ColorUpFormState({
    @Default(0) int color,
  }) = _ColorUpFormState;
}