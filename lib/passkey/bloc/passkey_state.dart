// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'passkey_bloc.dart';

class PasskeyState extends Equatable {
  const PasskeyState({
    this.isFirstTimeUser = true,
    this.passkey = const Passkey.pure(),
    this.confirmPasskey = const ConfirmPasskey.pure(),
    this.status = FormzSubmissionStatus.initial,
    this.isValid = false,
  });

  final bool isFirstTimeUser;
  final Passkey passkey;
  final ConfirmPasskey confirmPasskey;
  final FormzSubmissionStatus status;
  final bool isValid;

  @override
  List<Object?> get props => [
        isFirstTimeUser,
        passkey,
        confirmPasskey,
        status,
        isValid,
      ];

  PasskeyState copyWith({
    bool? isFirstTimeUser,
    Passkey? passkey,
    ConfirmPasskey? confirmPasskey,
    FormzSubmissionStatus? status,
    bool? isValid,
  }) {
    return PasskeyState(
      isFirstTimeUser: isFirstTimeUser ?? this.isFirstTimeUser,
      passkey: passkey ?? this.passkey,
      confirmPasskey: confirmPasskey ?? this.confirmPasskey,
      status: status ?? this.status,
      isValid: isValid ?? this.isValid,
    );
  }
}

extension PasskeyValidationErrorExt on List<PasskeyValidationError> {
  PasskeyValidationError get prioritized {
    final error = switch (this) {
      final x when x.contains(PasskeyValidationError.invalid) =>
        PasskeyValidationError.invalid,
      final x when x.contains(PasskeyValidationError.characterLength) =>
        PasskeyValidationError.characterLength,
      final x when x.contains(PasskeyValidationError.missingUppercaseLetter) =>
        PasskeyValidationError.missingUppercaseLetter,
      final x when x.contains(PasskeyValidationError.missingLowercaseLetter) =>
        PasskeyValidationError.missingLowercaseLetter,
      final x when x.contains(PasskeyValidationError.missingNumber) =>
        PasskeyValidationError.missingNumber,
      final x when x.contains(PasskeyValidationError.missingSpecialCharacter) =>
        PasskeyValidationError.missingSpecialCharacter,
      _ => PasskeyValidationError.invalid,
    };
    return error;
  }
}
