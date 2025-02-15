import 'package:formz/formz.dart';

/// Validation errors for [Identity] form input.
enum IdentityValidationError {
  /// The identity input is empty.
  invalid,
}

/// {@template identity}
/// A form input for identity input.
/// {@endtemplate}
class Identity extends FormzInput<String, IdentityValidationError> {
  /// {@macro identity}
  const Identity.pure() : super.pure('');

  /// {@macro identity}
  const Identity.dirty([super.value = '']) : super.dirty();

  @override
  IdentityValidationError? validator(String value) {
    return value.isEmpty ? IdentityValidationError.invalid : null;
  }
}
