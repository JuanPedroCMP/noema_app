import 'package:freezed_annotation/freezed_annotation.dart';

part 'sign_up_form_state.freezed.dart';

@freezed
sealed class SignUpFormState with _$SignUpFormState {
  const factory SignUpFormState({
    @Default('') String email,
    @Default('') String password,
    @Default('') String userName,
    @Default('') String displayName,
    @Default(false) bool loading,
  }) = _SignUpFormState;
}