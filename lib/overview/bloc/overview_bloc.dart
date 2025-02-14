import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:entries_api/entries_api.dart';
import 'package:entries_repository/entries_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:passkey_repository/passkey_repository.dart';

part 'overview_event.dart';
part 'overview_state.dart';

class OverviewBloc extends Bloc<OverviewEvent, OverviewState> {
  OverviewBloc({
    required EntriesRepository entriesRepository,
    required PasskeyRepository passkeyRepository,
  })  : _entriesRepository = entriesRepository,
        _passkeyRepository = passkeyRepository,
        super(const OverviewState()) {
    on<OverviewSubscriptionRequested>(
      _onOverviewSubscriptionRequested,
      transformer: restartable(),
    );
    on<OverviewEntryDeleted>(_onOverviewEntryDeleted);
    on<OverviewSearchInputChanged>(_onOverviewSearchInputChanged);
  }

  final EntriesRepository _entriesRepository;
  final PasskeyRepository _passkeyRepository;

  FutureOr<void> _onOverviewSubscriptionRequested(
    OverviewSubscriptionRequested event,
    Emitter<OverviewState> emit,
  ) async {
    emit(state.copyWith(status: () => OverviewStatus.loading));

    final passkey = _passkeyRepository.cachedPasskey();

    if (passkey == null) {
      emit(
        state.copyWith(
          status: () => OverviewStatus.failure,
          error: () => OverviewError.nullPasskey,
        ),
      );
      return;
    }

    await emit.forEach(
      state.searchText.isEmpty
          ? _entriesRepository.getEntries(passkey: passkey)
          : _entriesRepository.getEntriesWithFilter(
              passkey: passkey,
              searchText: state.searchText,
            ),
      onData: (entries) => state.copyWith(
        entries: () => entries,
        status: () => OverviewStatus.success,
        error: () => null,
      ),
      onError: (_, __) => state.copyWith(
        status: () => OverviewStatus.failure,
        error: () => OverviewError.readEntries,
      ),
    );
  }

  FutureOr<void> _onOverviewEntryDeleted(
    OverviewEntryDeleted event,
    Emitter<OverviewState> emit,
  ) async {
    await _entriesRepository.deleteEntry(entry: event.entryToBeDeleted);
  }

  FutureOr<void> _onOverviewSearchInputChanged(
    OverviewSearchInputChanged event,
    Emitter<OverviewState> emit,
  ) async {
    emit(state.copyWith(searchText: () => event.value));
    add(const OverviewSubscriptionRequested());
  }
}
