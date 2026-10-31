import 'package:flutter_test/flutter_test.dart';
import 'package:noema/feature/auth/services/password_policy.dart';

void main() {
  group('PasswordPolicy', () {
    test('requires at least eight characters', () {
      expect(PasswordPolicy.validate('ab12'), 'Use pelo menos 8 caracteres.');
      expect(PasswordPolicy.hasMinimumLength('abcd1234'), isTrue);
    });

    test('requires both a letter and a number', () {
      expect(
        PasswordPolicy.validate('abcdefgh'),
        'Inclua pelo menos uma letra e um número.',
      );
      expect(
        PasswordPolicy.validate('12345678'),
        'Inclua pelo menos uma letra e um número.',
      );
    });

    test('accepts a password meeting all requirements', () {
      expect(PasswordPolicy.validate('noema2026'), isNull);
      expect(PasswordPolicy.isValid('noema2026'), isTrue);
    });

    test('does not silently trim or alter passwords', () {
      expect(PasswordPolicy.isValid(' noema2026 '), isTrue);
      expect(PasswordPolicy.validate(''), 'Informe uma senha.');
    });
  });
}
