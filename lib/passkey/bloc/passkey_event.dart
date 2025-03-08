part of 'passkey_bloc.dart';

sealed class PasskeyEvent extends Equatable {
  const PasskeyEvent();

  @override
  List<Object> get props => [];
}

final class PasskeyInputChanged extends PasskeyEvent {
  const PasskeyInputChanged(this.value);
  final String value;

  @override
  List<Object> get props => [value];
}

final class ConfirmPasskeyInputChanged extends PasskeyEvent {
  const ConfirmPasskeyInputChanged(this.value);
  final String value;

  @override
  List<Object> get props => [value];
}

final class PasskeyInputSubmitted extends PasskeyEvent {
  const PasskeyInputSubmitted();
}

final class PassworthyTermsRequested extends PasskeyEvent {
  const PassworthyTermsRequested();
}
