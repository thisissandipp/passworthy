import 'package:formz/formz.dart';

/// Validation errors for [ConfirmPasskeyValidationError] form input.
enum ConfirmPasskeyValidationError {
  /// The confirm passkey do not match the passkey.
  invalid,
}

/// {@template confirm_passkey}
/// A form input for confirm passkey input.
/// {@endtemplate}
class ConfirmPasskey extends FormzInput<String, ConfirmPasskeyValidationError> {
  /// {@macro confirm_passkey}
  const ConfirmPasskey.pure({this.passkey = ''}) : super.pure('');

  /// {@macro confirm_passkey}
  const ConfirmPasskey.dirty({required this.passkey, String value = ''})
      : super.dirty(value);

  /// The original passkey.
  final String passkey;

  @override
  ConfirmPasskeyValidationError? validator(String value) {
    return passkey == value ? null : ConfirmPasskeyValidationError.invalid;
  }
}
