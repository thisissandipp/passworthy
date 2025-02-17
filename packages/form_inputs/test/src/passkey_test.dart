// Ignore below specifics for testing environment.
// ignore_for_file: prefer_const_constructors

import 'package:form_inputs/form_inputs.dart';
import 'package:test/test.dart';

void main() {
  group('Passkey', () {
    test('works correctly', () {
      expect(Passkey.pure, returnsNormally);
      expect(() => Passkey.dirty('hello'), returnsNormally);
    });

    group('throws', () {
      test('characterLength when passkey is less than 12 characters', () {
        const passkey = Passkey.dirty('test');
        expect(passkey.isValid, isFalse);
        expect(passkey.error, contains(PasskeyValidationError.characterLength));
      });

      test('missingUppercaseLetter when passkey do not have uppercase', () {
        const passkey = Passkey.dirty('testtttttttttt');
        expect(passkey.isValid, isFalse);
        expect(
          passkey.error,
          contains(PasskeyValidationError.missingUppercaseLetter),
        );
      });

      test('missingLowercaseLetter when passkey do not have lowercase', () {
        const passkey = Passkey.dirty('TESTTTTTTTTTT');
        expect(passkey.isValid, isFalse);
        expect(
          passkey.error,
          contains(PasskeyValidationError.missingLowercaseLetter),
        );
      });

      test('missingNumber when passkey do not have number', () {
        const passkey = Passkey.dirty('tesTTTTTTTTTT');
        expect(passkey.isValid, isFalse);
        expect(
          passkey.error,
          contains(PasskeyValidationError.missingNumber),
        );
      });

      test(
        'missingSpecialCharacter when passkey do not have special character',
        () {
          const passkey = Passkey.dirty('testTTTTTT123');
          expect(passkey.isValid, isFalse);
          expect(
            passkey.error,
            contains(PasskeyValidationError.missingSpecialCharacter),
          );
        },
      );

      test(
        'invalid when passkey has an invalid character',
        () {
          const passkey = Passkey.dirty('testTT TTTT123');
          expect(passkey.isValid, isFalse);
          expect(
            passkey.error,
            contains(PasskeyValidationError.invalid),
          );
        },
      );
    });

    test('gets validated when the rules are matched', () {
      const passkey = Passkey.dirty('TopS3cret_#41');
      expect(passkey.isValid, isTrue);
      expect(passkey.error, null);
    });
  });
}
