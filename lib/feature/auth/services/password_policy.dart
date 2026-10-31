class PasswordPolicy {
  const PasswordPolicy._();

  static const minimumLength = 8;

  static bool hasMinimumLength(String value) =>
      value.runes.length >= minimumLength;

  static bool hasLetter(String value) => RegExp(r'[A-Za-z]').hasMatch(value);

  static bool hasNumber(String value) => RegExp(r'\d').hasMatch(value);

  static bool isValid(String value) =>
      hasMinimumLength(value) && hasLetter(value) && hasNumber(value);

  static String? validate(String? value) {
    if (value == null || value.isEmpty) return 'Informe uma senha.';
    if (!hasMinimumLength(value)) {
      return 'Use pelo menos $minimumLength caracteres.';
    }
    if (!hasLetter(value) || !hasNumber(value)) {
      return 'Inclua pelo menos uma letra e um número.';
    }
    return null;
  }
}
