import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';
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
    emit(
      state.copyWith(isFirstTimeUser: isFirstTimeUser),
    );
  }

  FutureOr<void> _onPasskeyInputChanged(
    PasskeyInputChanged event,
    Emitter<PasskeyState> emit,
  ) async {
    final passkey = Passkey.dirty(event.value);
    final confirmPasskey = ConfirmPasskey.dirty(
      passkey: passkey.value,
      value: state.confirmPasskey.value,
    );

    emit(
      state.copyWith(
        passkey: passkey,
        confirmPasskey: confirmPasskey,
        isValid: Formz.validate([passkey, confirmPasskey]),
      ),
    );
  }

  FutureOr<void> _onConfirmPasskeyInputChanged(
    ConfirmPasskeyInputChanged event,
    Emitter<PasskeyState> emit,
  ) async {
    final confirmPasskey = ConfirmPasskey.dirty(
      passkey: state.passkey.value,
      value: event.value,
    );
    emit(
      state.copyWith(
        confirmPasskey: confirmPasskey,
        isValid: Formz.validate([state.passkey, confirmPasskey]),
      ),
    );
  }

  FutureOr<void> _onPasskeyInputSubmitted(
    PasskeyInputSubmitted event,
    Emitter<PasskeyState> emit,
  ) async {
    if (!state.isValid) return;
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

    if (state.isFirstTimeUser) {
      await _passkeyRepository.savePasskey(state.passkey.value);
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } else {
      final result = await _passkeyRepository.verifyPasskey(
        state.passkey.value,
      );
      emit(
        state.copyWith(
          status: result
              ? FormzSubmissionStatus.success
              : FormzSubmissionStatus.failure,
        ),
      );
    }
  }
}
