import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_form_state.freezed.dart';

@freezed
sealed class LoginFormState with _$LoginFormState {
  const factory LoginFormState({
    @Default('') String user,
    @Default('') String password,
    @Default(false) bool loading,
  }) = _LoginFormState;
}