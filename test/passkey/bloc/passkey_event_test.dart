// Ignore below specifics for testing environment.
// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:passworthy/passkey/passkey.dart';

void main() {
  group('PasskeyEvent', () {
    group('ConfirmPasskeyInputChanged', () {
      test('supports value equality', () {
        expect(
          ConfirmPasskeyInputChanged('abc'),
          equals(ConfirmPasskeyInputChanged('abc')),
        );
      });

      test('props are correct', () {
        expect(
          ConfirmPasskeyInputChanged('abc').props,
          equals(<Object?>['abc']),
        );
      });
    });

    group('ConfirmPasskeyInputChanged', () {
      test('supports value equality', () {
        expect(
          ConfirmPasskeyInputChanged('abc'),
          equals(ConfirmPasskeyInputChanged('abc')),
        );
      });

      test('props are correct', () {
        expect(
          ConfirmPasskeyInputChanged('abc').props,
          equals(<Object?>['abc']),
        );
      });
    });

    group('PasskeyInputSubmitted', () {
      test('supports value equality', () {
        expect(
          PasskeyInputSubmitted(),
          equals(PasskeyInputSubmitted()),
        );
      });

      test('props are correct', () {
        expect(
          PasskeyInputSubmitted().props,
          equals(<Object?>[]),
        );
      });
    });
  });
}
