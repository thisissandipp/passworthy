part of 'details_bloc.dart';

sealed class DetailsEvent extends Equatable {
  const DetailsEvent();

  @override
  List<Object> get props => [];
}

final class EntryDeletionRequested extends DetailsEvent {
  const EntryDeletionRequested();
}

final class EntryFavoriteStatusChanged extends DetailsEvent {
  const EntryFavoriteStatusChanged();
}

final class PasswordVisibilityToggled extends DetailsEvent {
  const PasswordVisibilityToggled();
}
