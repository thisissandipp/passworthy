// ignore_for_file: prefer_const_constructors, avoid_redundant_argument_values

import 'package:form_inputs/form_inputs.dart';
import 'package:test/test.dart';

void main() {
  group('Password', () {
    test('works correctly', () {
      expect(Password.pure, returnsNormally);
      expect(() => Password.dirty('hello'), returnsNormally);
    });

    test('throws invalid error when password is empty', () {
      final password = Password.dirty('');
      expect(password.isValid, isFalse);
      expect(password.error, PasswordValidationError.invalid);
    });

    test('does not throw error when password is not empty', () {
      final password = Password.dirty('identity');
      expect(password.isValid, isTrue);
      expect(password.error, isNull);
    });
  });
}
