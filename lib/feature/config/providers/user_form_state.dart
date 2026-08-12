import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_form_state.freezed.dart';

@freezed
sealed class UserFormState with _$UserFormState{
  const factory UserFormState({
    @Default("") String userName,
    @Default("") String displayName,
    @Default("") String email,
    @Default("") String password,
    @Default("") String passwordVerify,
    @Default(false) bool isEditing,
  }) = _UserFormState;
}