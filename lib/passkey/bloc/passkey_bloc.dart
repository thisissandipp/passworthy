import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:passkey_repository/passkey_repository.dart';

part 'passkey_event.dart';
part 'passkey_state.dart';

class PasskeyBloc extends Bloc<PasskeyEvent, PasskeyState> {
  PasskeyBloc({
    required PasskeyRepository passkeyRepository,
  })  : _passkeyRepository = passkeyRepository,
        super(const PasskeyState()) {
    on<FirstTimeUserCheckRequested>(_onFirstTimeUserCheckRequested);
    on<PasskeyInputChanged>(_onPasskeyInputChanged);
    on<ConfirmPasskeyInputChanged>(_onConfirmPasskeyInputChanged);
    on<PasskeyInputSubmitted>(_onPasskeyInputSubmitted);
  }

  final PasskeyRepository _passkeyRepository;

  FutureOr<void> _onFirstTimeUserCheckRequested(
    FirstTimeUserCheckRequested event,
    Emitter<PasskeyState> emit,
  ) async {
    final isFirstTimeUser = await _passkeyRepository.isFirstTimeUser();
    emit(state.copyWith(isFirstTimeUser: isFirstTimeUser));
  }

  FutureOr<void> _onPasskeyInputChanged(
    PasskeyInputChanged event,
    Emitter<PasskeyState> emit,
  ) async {
    emit(
      state.copyWith(passkeyInput: event.value, errorMessage: ''),
    );
  }

  FutureOr<void> _onConfirmPasskeyInputChanged(
    ConfirmPasskeyInputChanged event,
    Emitter<PasskeyState> emit,
  ) async {
    emit(
      state.copyWith(confirmPasskeyInput: event.value, errorMessage: ''),
    );
  }

  FutureOr<void> _onPasskeyInputSubmitted(
    PasskeyInputSubmitted event,
    Emitter<PasskeyState> emit,
  ) async {
    if (state.isFirstTimeUser) {
      if (state.passkeyInput.isEmpty ||
          state.confirmPasskeyInput.isEmpty ||
          state.passkeyInput != state.confirmPasskeyInput) {
        emit(
          state.copyWith(
            errorMessage: 'Either the inputs are empty or they do not match',
          ),
        );
        return;
      }

      await _passkeyRepository.savePasskey(state.passkeyInput);
      emit(state.copyWith(isVerified: true, errorMessage: ''));
    } else {
      final result = await _passkeyRepository.verifyPasskey(state.passkeyInput);
      emit(state.copyWith(isVerified: result, errorMessage: ''));
    }
  }
}
