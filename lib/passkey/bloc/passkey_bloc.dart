import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';
import 'package:onboarding_repository/onboarding_repository.dart';
import 'package:passkey_repository/passkey_repository.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

part 'passkey_event.dart';
part 'passkey_state.dart';

class PasskeyBloc extends Bloc<PasskeyEvent, PasskeyState> {
  PasskeyBloc({
    required OnboardingRepository onboardingRepository,
    required PasskeyRepository passkeyRepository,
  })  : _onboardingRepository = onboardingRepository,
        _passkeyRepository = passkeyRepository,
        super(const PasskeyState()) {
    on<PasskeyInputChanged>(_onPasskeyInputChanged);
    on<ConfirmPasskeyInputChanged>(_onConfirmPasskeyInputChanged);
    on<PasskeyInputSubmitted>(_onPasskeyInputSubmitted);
    on<PassworthyTermsRequested>(_onPassworthyTermsRequested);
  }

  final OnboardingRepository _onboardingRepository;
  final PasskeyRepository _passkeyRepository;

  FutureOr<void> _onPasskeyInputChanged(
    PasskeyInputChanged event,
    Emitter<PasskeyState> emit,
  ) async {
    final passkey = Passkey.dirty(event.value);
    final confirmPasskey = state.confirmPasskey.value.isEmpty
        ? ConfirmPasskey.pure(passkey: passkey.value)
        : ConfirmPasskey.dirty(
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

    final isFirstTimeUser = _onboardingRepository.isFirstTimeUser();
    if (isFirstTimeUser) {
      await _passkeyRepository.savePasskey(state.passkey.value);
      await _onboardingRepository.setOnboarded();
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

  FutureOr<void> _onPassworthyTermsRequested(
    PassworthyTermsRequested event,
    Emitter<PasskeyState> emit,
  ) async {
    final supportUri = Uri.https('passworthy.thisissandipp.com', '/terms');
    try {
      await url_launcher.launchUrl(supportUri);
    } on PlatformException catch (_) {}
  }
}
