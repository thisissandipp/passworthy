import 'package:formz/formz.dart';

/// Validation errors for [Password] form input.
enum PasswordValidationError {
  /// The password input is empty.
  invalid,
}

/// {@template password}
/// A form input for password input.
/// {@endtemplate}
class Password extends FormzInput<String, PasswordValidationError> {
  /// {@macro password}
  const Password.pure() : super.pure('');

  /// {@macro password}
  const Password.dirty([super.value = '']) : super.dirty();

  @override
  PasswordValidationError? validator(String value) {
    return value.isEmpty ? PasswordValidationError.invalid : null;
  }
}
