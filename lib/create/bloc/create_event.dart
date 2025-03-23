part of 'create_bloc.dart';

sealed class CreateEvent extends Equatable {
  const CreateEvent();

  @override
  List<Object> get props => [];
}

final class PlatformInputChanged extends CreateEvent {
  const PlatformInputChanged(this.value);
  final String value;

  @override
  List<Object> get props => [value];
}

final class IdentityInputChanged extends CreateEvent {
  const IdentityInputChanged(this.value);
  final String value;

  @override
  List<Object> get props => [value];
}

final class PasswordInputChanged extends CreateEvent {
  const PasswordInputChanged(this.value);
  final String value;

  @override
  List<Object> get props => [value];
}

final class AdditionalNotesChanged extends CreateEvent {
  const AdditionalNotesChanged(this.value);
  final String value;

  @override
  List<Object> get props => [value];
}

final class EntrySubmitted extends CreateEvent {
  const EntrySubmitted();
}
