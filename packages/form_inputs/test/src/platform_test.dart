// ignore_for_file: prefer_const_constructors, avoid_redundant_argument_values

import 'package:form_inputs/form_inputs.dart';
import 'package:test/test.dart';

void main() {
  group('Platform', () {
    test('works correctly', () {
      expect(Platform.pure, returnsNormally);
      expect(() => Platform.dirty('hello'), returnsNormally);
    });

    test('throws invalid error when platform is empty', () {
      final platform = Platform.dirty('');
      expect(platform.isValid, isFalse);
      expect(platform.error, PlatformValidationError.invalid);
    });

    test('does not throw error when platform is not empty', () {
      final platform = Platform.dirty('identity');
      expect(platform.isValid, isTrue);
      expect(platform.error, isNull);
    });
  });
}
