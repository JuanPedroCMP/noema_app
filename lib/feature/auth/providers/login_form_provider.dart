import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noema/feature/auth/providers/login_form_state.dart';

class LoginFormNotifier extends Notifier<LoginFormState>{
  @override
  LoginFormState build() {
    return const LoginFormState();
  }

  void userChanged(String value) {
    state = state.copyWith(user: value);
  }

  void passwordChanged(String value) {
    state = state.copyWith(password: value);
  }

  void loadingChanged(bool value) {
    state = state.copyWith(loading: value);
  }

  void reset() {
    state = const LoginFormState();
  }
}

final loginFormProvider = NotifierProvider<LoginFormNotifier, LoginFormState>(LoginFormNotifier.new);