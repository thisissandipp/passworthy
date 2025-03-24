import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:entries_api/entries_api.dart';
import 'package:entries_repository/entries_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:passkey_repository/passkey_repository.dart';

part 'details_event.dart';
part 'details_state.dart';

class DetailsBloc extends Bloc<DetailsEvent, DetailsState> {
  DetailsBloc({
    required Entry entry,
    required EntriesRepository entriesRepository,
    required PasskeyRepository passkeyRepository,
  })  : _entriesRepository = entriesRepository,
        _passkeyRepository = passkeyRepository,
        super(DetailsState(entry: entry)) {
    on<EntryDeletionRequested>(_onEntryDeletionRequested);
    on<EntryFavoriteStatusChanged>(_onEntryFavoriteStatusChanged);
    on<PasswordVisibilityToggled>(_onPasswordVisibilityToggled);
  }

  final EntriesRepository _entriesRepository;
  final PasskeyRepository _passkeyRepository;

  FutureOr<void> _onEntryDeletionRequested(
    EntryDeletionRequested event,
    Emitter<DetailsState> emit,
  ) async {
    return _entriesRepository.deleteEntry(entry: state.entry);
  }

  FutureOr<void> _onEntryFavoriteStatusChanged(
    EntryFavoriteStatusChanged event,
    Emitter<DetailsState> emit,
  ) async {
    final updatedEntry = state.entry.copyWith(
      isFavorite: !state.entry.isFavorite,
    );

    final passkey = _passkeyRepository.cachedPasskey();
    // TODO(thisissandipp): Not a good code to put an ! at passkey.
    await _entriesRepository.saveEntry(entry: updatedEntry, passkey: passkey!);
    emit(state.copyWith(entry: updatedEntry));
  }

  FutureOr<void> _onPasswordVisibilityToggled(
    PasswordVisibilityToggled event,
    Emitter<DetailsState> emit,
  ) async {
    emit(state.copyWith(showPassword: !state.showPassword));
  }
}
