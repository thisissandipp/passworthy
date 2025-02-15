// ignore_for_file: prefer_const_constructors, avoid_redundant_argument_values

import 'package:form_inputs/form_inputs.dart';
import 'package:test/test.dart';

void main() {
  group('Identity', () {
    test('works correctly', () {
      expect(Identity.pure, returnsNormally);
      expect(() => Identity.dirty('hello'), returnsNormally);
    });

    test('throws invalid error when identity is empty', () {
      final identity = Identity.dirty('');
      expect(identity.isValid, isFalse);
      expect(identity.error, IdentityValidationError.invalid);
    });

    test('does not throw error when identity is not empty', () {
      final identity = Identity.dirty('identity');
      expect(identity.isValid, isTrue);
      expect(identity.error, isNull);
    });
  });
}
