import 'package:formz/formz.dart';

/// Validation errors for [Platform] form input.
enum PlatformValidationError {
  /// The platform input is empty.
  invalid,
}

/// {@template platform}
/// A form input for platform input.
/// {@endtemplate}
class Platform extends FormzInput<String, PlatformValidationError> {
  /// {@macro platform}
  const Platform.pure() : super.pure('');

  /// {@macro platform}
  const Platform.dirty([super.value = '']) : super.dirty();

  @override
  PlatformValidationError? validator(String value) {
    return value.isEmpty ? PlatformValidationError.invalid : null;
  }
}
