// ignore_for_file: avoid_redundant_argument_values

import 'package:flutter_test/flutter_test.dart';
import 'package:passworthy/passkey/passkey.dart';

void main() {
  group('PasskeyState', () {
    PasskeyState createSubject({
      bool isFirstTimeUser = false,
      String passkeyInput = '',
      String confirmPasskeyInput = '',
      String errorMessage = '',
      bool isVerified = false,
    }) {
      return PasskeyState(
        isFirstTimeUser: isFirstTimeUser,
        passkeyInput: passkeyInput,
        confirmPasskeyInput: confirmPasskeyInput,
        errorMessage: errorMessage,
        isVerified: isVerified,
      );
    }

    test('constructor works correctly', () {
      expect(createSubject, returnsNormally);
    });

    test('supports value equality', () {
      expect(createSubject(), equals(createSubject()));
    });

    test('props are correct', () {
      expect(
        createSubject().props,
        equals(
          <Object?>[
            false, // isFirstTimeUser
            '', // passkeyInput
            '', // confirmPasskeyInput
            '', // errorMessage
            false, // isVerified
          ],
        ),
      );
    });

    group('copyWith', () {
      test('returns same object if no argument is passed', () {
        expect(
          createSubject().copyWith(),
          equals(createSubject()),
        );
      });

      test('returns the old value for each parameter if null is provided', () {
        expect(
          createSubject().copyWith(
            isFirstTimeUser: null,
            passkeyInput: null,
            confirmPasskeyInput: null,
            errorMessage: null,
            isVerified: null,
          ),
          equals(createSubject()),
        );
      });

      test('returns the updated copy of this for every non-null parameter', () {
        expect(
          createSubject().copyWith(
            isFirstTimeUser: true,
            passkeyInput: 'hello',
            confirmPasskeyInput: 'hello',
            errorMessage: 'error',
            isVerified: true,
          ),
          equals(
            createSubject(
              isFirstTimeUser: true,
              passkeyInput: 'hello',
              confirmPasskeyInput: 'hello',
              errorMessage: 'error',
              isVerified: true,
            ),
          ),
        );
      });
    });
  });
}
