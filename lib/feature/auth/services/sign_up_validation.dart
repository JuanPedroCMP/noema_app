import 'password_policy.dart';

class SignUpValidation {
  const SignUpValidation._();

  static String? userName(String? value) {
    final username = value?.trim() ?? '';
    if (username.isEmpty) return 'Informe um nome de usuário.';
    if (username.length < 3 || username.length > 32) {
      return 'Use entre 3 e 32 caracteres.';
    }
    if (!RegExp(r'^[A-Za-z0-9._-]+$').hasMatch(username)) {
      return 'Use apenas letras, números, ponto, hífen ou sublinhado.';
    }
    return null;
  }

  static String? displayName(String? value) {
    final name = value?.trim() ?? '';
    if (name.isEmpty) return 'Informe como devemos chamar você.';
    if (name.length < 2 || name.length > 60) {
      return 'Use entre 2 e 60 caracteres.';
    }
    return null;
  }

  static String? email(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) return 'Informe seu e-mail.';
    if (email.length > 254 ||
        !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
      return 'Digite um endereço de e-mail válido.';
    }
    return null;
  }

  static String? password(String? value) => PasswordPolicy.validate(value);
}
