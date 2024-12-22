// ignore_for_file: avoid_redundant_argument_values

import 'package:flutter_test/flutter_test.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';
import 'package:passworthy/passkey/passkey.dart';

void main() {
  group('PasskeyState', () {
    PasskeyState createSubject({
      bool isFirstTimeUser = false,
      Passkey passkey = const Passkey.pure(),
      ConfirmPasskey confirmPasskey = const ConfirmPasskey.pure(),
      FormzSubmissionStatus status = FormzSubmissionStatus.initial,
      bool isValid = false,
    }) {
      return PasskeyState(
        isFirstTimeUser: isFirstTimeUser,
        passkey: passkey,
        confirmPasskey: confirmPasskey,
        status: status,
        isValid: isValid,
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
            const Passkey.pure(), // passkey
            const ConfirmPasskey.pure(), // confirmPasskey
            FormzSubmissionStatus.initial, // status
            false, // isValid
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
            passkey: null,
            confirmPasskey: null,
            status: null,
            isValid: null,
          ),
          equals(createSubject()),
        );
      });

      test('returns the updated copy of this for every non-null parameter', () {
        expect(
          createSubject().copyWith(
            isFirstTimeUser: true,
            passkey: const Passkey.dirty('abc'),
            confirmPasskey: const ConfirmPasskey.dirty(
              passkey: 'a',
              value: 'x',
            ),
            status: FormzSubmissionStatus.success,
            isValid: true,
          ),
          equals(
            createSubject(
              isFirstTimeUser: true,
              passkey: const Passkey.dirty('abc'),
              confirmPasskey: const ConfirmPasskey.dirty(
                passkey: 'a',
                value: 'x',
              ),
              status: FormzSubmissionStatus.success,
              isValid: true,
            ),
          ),
        );
      });
    });
  });
}
