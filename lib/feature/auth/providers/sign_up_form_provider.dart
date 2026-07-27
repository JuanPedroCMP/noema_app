
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noema/feature/auth/providers/sign_up_form_state.dart';

class SignUpFormNotifier extends Notifier<SignUpFormState> {
  @override
  SignUpFormState build() {
    return const SignUpFormState();
  }

  void emailChanged(String value) {
    state = state.copyWith(email: value);
  }

  void passwordChanged(String value) {
    state = state.copyWith(password: value);
  }

  void userNameChanged(String value) {
    state = state.copyWith(userName: value);
  }

  void displayNameChanged(String value) {
    state = state.copyWith(displayName: value);
  }

  void setLoading(bool value) {
    state = state.copyWith(loading: value);
  }

  void reset() {
    state = const SignUpFormState();
  }
}

final signUpFormProvider = NotifierProvider<SignUpFormNotifier, SignUpFormState>(SignUpFormNotifier.new);