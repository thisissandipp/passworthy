// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'passkey_bloc.dart';

class PasskeyState extends Equatable {
  const PasskeyState({
    this.isFirstTimeUser = true,
    this.passkeyInput = '',
    this.confirmPasskeyInput = '',
    this.errorMessage = '',
    this.isVerified = false,
  });

  final bool isFirstTimeUser;
  final String passkeyInput;
  final String confirmPasskeyInput;
  final String errorMessage;
  final bool isVerified;

  @override
  List<Object?> get props => [
        isFirstTimeUser,
        passkeyInput,
        confirmPasskeyInput,
        errorMessage,
        isVerified,
      ];

  PasskeyState copyWith({
    bool? isFirstTimeUser,
    String? passkeyInput,
    String? confirmPasskeyInput,
    String? errorMessage,
    bool? isVerified,
  }) {
    return PasskeyState(
      isFirstTimeUser: isFirstTimeUser ?? this.isFirstTimeUser,
      passkeyInput: passkeyInput ?? this.passkeyInput,
      confirmPasskeyInput: confirmPasskeyInput ?? this.confirmPasskeyInput,
      errorMessage: errorMessage ?? this.errorMessage,
      isVerified: isVerified ?? this.isVerified,
    );
  }
}
