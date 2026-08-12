import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'user_form_state.dart';

class UserFormNotifier extends Notifier<UserFormState> {
  @override
  UserFormState build() => const UserFormState();

  void userNameChanged(String value) {
    state = state.copyWith(userName: value);
  }

  void displayNameChanged(String value) {
    state = state.copyWith(displayName: value);
  }

  void emailChanged(String value) {
    state = state.copyWith(email: value);
  }

  void passwordChanged(String value) {
    state = state.copyWith(password: value);
  }

  void passwordVerifyChanged(String value) {
    state = state.copyWith(passwordVerify: value);
  }

  void isEditingChanged(bool value) {
    state = state.copyWith(isEditing: !value);
  }

  void reset() {
    state = const UserFormState();
  }
}

final userFormProvider = NotifierProvider<UserFormNotifier, UserFormState>(
  UserFormNotifier.new,
);
