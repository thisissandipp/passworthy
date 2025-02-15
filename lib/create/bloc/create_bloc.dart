import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:entries_api/entries_api.dart';
import 'package:entries_repository/entries_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';
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
            platform: initialEntry != null
                ? Platform.dirty(initialEntry.platform)
                : const Platform.pure(),
            identity: initialEntry != null
                ? Identity.dirty(initialEntry.identity)
                : const Identity.pure(),
            password: initialEntry != null
                ? Password.dirty(initialEntry.password)
                : const Password.pure(),
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
    final platform = Platform.dirty(event.value);
    emit(
      state.copyWith(
        platform: platform,
        isFormValid: Formz.validate([platform, state.identity, state.password]),
      ),
    );
  }

  FutureOr<void> _onIdentityInputChanged(
    IdentityInputChanged event,
    Emitter<CreateState> emit,
  ) {
    final identity = Identity.dirty(event.value);
    emit(
      state.copyWith(
        identity: identity,
        isFormValid: Formz.validate([state.platform, identity, state.password]),
      ),
    );
  }

  FutureOr<void> _onPasswordInputChanged(
    PasswordInputChanged event,
    Emitter<CreateState> emit,
  ) {
    final password = Password.dirty(event.value);
    emit(
      state.copyWith(
        password: password,
        isFormValid: Formz.validate([state.platform, state.identity, password]),
      ),
    );
  }

  FutureOr<void> _onEntrySubmitted(
    EntrySubmitted event,
    Emitter<CreateState> emit,
  ) async {
    if (!state.isFormValid) return;
    emit(state.copyWith(createStatus: CreateEntryStatus.loading));
    final passkey = _passkeyRepository.cachedPasskey();

    if (passkey == null) {
      emit(state.copyWith(createStatus: CreateEntryStatus.failure));
      return;
    }

    final entry = state.isNewEntry
        ? Entry(
            platform: state.platform.value,
            identity: state.identity.value,
            password: state.password.value,
            createdAt: DateTime.now(),
          )
        : state.initialEntry!.copyWith(
            platform: state.platform.value,
            identity: state.identity.value,
            password: state.password.value,
          );

    try {
      await _entriesRepository.saveEntry(entry: entry, passkey: passkey);
      emit(state.copyWith(createStatus: CreateEntryStatus.success));
    } catch (_) {
      emit(state.copyWith(createStatus: CreateEntryStatus.failure));
    }
  }
}
