import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:entries_api/entries_api.dart';
import 'package:entries_repository/entries_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:passkey_repository/passkey_repository.dart';

part 'create_event.dart';
part 'create_state.dart';

class CreateBloc extends Bloc<CreateEvent, CreateState> {
  CreateBloc({
    required EntriesRepository entriesRepository,
    required PasskeyRepository passkeyRepository,
    required Entry? initialEntry,
  })  : _entriesRepository = entriesRepository,
        _passkeyRepository = passkeyRepository,
        super(
          CreateState(
            initialEntry: initialEntry,
            platform: initialEntry?.platform ?? '',
            identity: initialEntry?.identity ?? '',
            password: initialEntry?.password ?? '',
          ),
        ) {
    on<PlatformInputChanged>(_onPlatformInputChanged);
    on<IdentityInputChanged>(_onIdentityInputChanged);
    on<PasswordInputChanged>(_onPasswordInputChanged);
    on<EntrySubmitted>(_onEntrySubmitted);
  }

  final EntriesRepository _entriesRepository;
  final PasskeyRepository _passkeyRepository;

  FutureOr<void> _onPlatformInputChanged(
    PlatformInputChanged event,
    Emitter<CreateState> emit,
  ) {
    emit(state.copyWith(platform: event.value));
  }

  FutureOr<void> _onIdentityInputChanged(
    IdentityInputChanged event,
    Emitter<CreateState> emit,
  ) {
    emit(state.copyWith(identity: event.value));
  }

  FutureOr<void> _onPasswordInputChanged(
    PasswordInputChanged event,
    Emitter<CreateState> emit,
  ) {
    emit(state.copyWith(password: event.value));
  }

  FutureOr<void> _onEntrySubmitted(
    EntrySubmitted event,
    Emitter<CreateState> emit,
  ) async {
    emit(state.copyWith(status: CreateEntryStatus.loading));
    final passkey = _passkeyRepository.cachedPasskey();

    if (passkey == null) {
      emit(state.copyWith(status: CreateEntryStatus.failure));
      return;
    }

    final entry = state.isNewEntry
        ? Entry(
            platform: state.platform,
            identity: state.identity,
            password: state.password,
            createdAt: DateTime.now(),
          )
        : state.initialEntry!.copyWith(
            platform: state.platform,
            identity: state.identity,
            password: state.password,
          );

    try {
      await _entriesRepository.saveEntry(entry: entry, passkey: passkey);
      emit(state.copyWith(status: CreateEntryStatus.success));
    } catch (_) {
      emit(state.copyWith(status: CreateEntryStatus.failure));
    }
  }
}
