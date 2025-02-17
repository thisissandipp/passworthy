// Ignore below specifics for testing environment.
// ignore_for_file: prefer_const_constructors

import 'package:form_inputs/form_inputs.dart';
import 'package:test/test.dart';

void main() {
  group('ConfirmPasskey', () {
    test('works correctly', () {
      expect(ConfirmPasskey.pure, returnsNormally);
      expect(() => ConfirmPasskey.dirty(passkey: 'hello'), returnsNormally);
    });

    group('throws', () {
      test('invalid when the value do not match passkey', () {
        final passkey = ConfirmPasskey.dirty(passkey: 'passkey', value: 'pass');
        expect(passkey.isValid, isFalse);
        expect(passkey.error, equals(ConfirmPasskeyValidationError.invalid));
      });
    });

    test('returns true when the value matches the passkey', () {
      final passkey = ConfirmPasskey.dirty(passkey: 'pass', value: 'pass');
      expect(passkey.isValid, isTrue);
      expect(passkey.error, isNull);
    });
  });
}
