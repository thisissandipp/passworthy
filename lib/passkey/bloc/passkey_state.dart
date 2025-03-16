part of 'passkey_bloc.dart';

class PasskeyState extends Equatable {
  const PasskeyState({
    this.passkey = const Passkey.pure(),
    this.confirmPasskey = const ConfirmPasskey.pure(),
    this.status = FormzSubmissionStatus.initial,
    this.isValid = false,
  });

  final Passkey passkey;
  final ConfirmPasskey confirmPasskey;
  final FormzSubmissionStatus status;
  final bool isValid;

  @override
  List<Object?> get props => [passkey, confirmPasskey, status, isValid];

  PasskeyState copyWith({
    Passkey? passkey,
    ConfirmPasskey? confirmPasskey,
    FormzSubmissionStatus? status,
    bool? isValid,
  }) {
    return PasskeyState(
      passkey: passkey ?? this.passkey,
      confirmPasskey: confirmPasskey ?? this.confirmPasskey,
      status: status ?? this.status,
      isValid: isValid ?? this.isValid,
    );
  }
}

extension PasskeyValidationErrorExt on List<PasskeyValidationError>? {
  bool get missing12Characters =>
      this?.contains(PasskeyValidationError.characterLength) ?? false;

  bool get missingUppercaseLetter =>
      this?.contains(PasskeyValidationError.missingUppercaseLetter) ?? false;

  bool get missingLowercaseLetter =>
      this?.contains(PasskeyValidationError.missingLowercaseLetter) ?? false;

  bool get missingNumber =>
      this?.contains(PasskeyValidationError.missingNumber) ?? false;

  bool get missingSpecialCharacter =>
      this?.contains(PasskeyValidationError.missingSpecialCharacter) ?? false;
}
