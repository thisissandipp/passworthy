// A passkey must have
// - at least 12 characters
// - at least one uppercase letter
// - at least one lowercase letter
// - at least one number
// - at least one special character
//
// Permissible special characters -
// @ ! # $ % ^ & * ( ) _ - + = { } [ ] : ; < > , . ? / | \ ~

import 'package:formz/formz.dart';

/// Validation errors for [Passkey] form input.
enum PasskeyValidationError {
  /// The passkey is less than 12 characters.
  characterLength,

  /// The passkey is missing a uppercase letter.
  missingUppercaseLetter,

  /// The passkey is missing a lowercase letter.
  missingLowercaseLetter,

  /// The passkey is missing a number.
  missingNumber,

  /// The passkey does not have a special character in it.
  missingSpecialCharacter,

  /// A generic error, probably the passkey contains a character
  /// which is not permissible.
  invalid,
}

/// {@template passkey}
/// A form input for passkey input.
/// {@endtemplate}
class Passkey extends FormzInput<String, List<PasskeyValidationError>> {
  /// {@macro passkey}
  const Passkey.pure() : super.pure('');

  /// {@macro passkey}
  const Passkey.dirty([super.value = '']) : super.dirty();

  static final RegExp _charactersLengthRegExp = RegExp(r'^.{12,}$');

  static final RegExp _uppercaseLetterRegExp = RegExp('[A-Z]');

  static final RegExp _lowercaseLetterRegExp = RegExp('[a-z]');

  static final RegExp _numberRegExp = RegExp(r'\d');

  static final RegExp _specialCharacterRegExp = RegExp(
    r'[!@#$%^&*()_\-+=\[\]{}:;<>,.?/|\\~]',
  );

  static final RegExp _permissibleCharactersRegExp = RegExp(
    r'^[A-Za-z0-9!@#$%^&*()_\-+=\[\]{}:;<>,.?/|\\~]+$',
  );

  @override
  List<PasskeyValidationError>? validator(String? value) {
    final errors = <PasskeyValidationError>[...PasskeyValidationError.values];

    if (_charactersLengthRegExp.hasMatch(value ?? '')) {
      errors.remove(PasskeyValidationError.characterLength);
    }

    if (_uppercaseLetterRegExp.hasMatch(value ?? '')) {
      errors.remove(PasskeyValidationError.missingUppercaseLetter);
    }

    if (_lowercaseLetterRegExp.hasMatch(value ?? '')) {
      errors.remove(PasskeyValidationError.missingLowercaseLetter);
    }

    if (_numberRegExp.hasMatch(value ?? '')) {
      errors.remove(PasskeyValidationError.missingNumber);
    }

    if (_specialCharacterRegExp.hasMatch(value ?? '')) {
      errors.remove(PasskeyValidationError.missingSpecialCharacter);
    }

    if (_permissibleCharactersRegExp.hasMatch(value ?? '')) {
      errors.remove(PasskeyValidationError.invalid);
    }

    return errors.isEmpty ? null : errors;
  }
}
