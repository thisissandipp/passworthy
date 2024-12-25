import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:onboarding_repository/onboarding_repository.dart';

part 'onboarding_event.dart';
part 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  OnboardingBloc({
    required OnboardingRepository onboardingRepository,
  })  : _onboardingRepository = onboardingRepository,
        super(const OnboardingState()) {
    on<CheckFirstTimeUserRequested>(_onCheckFirstTimeUserRequested);
  }

  final OnboardingRepository _onboardingRepository;

  FutureOr<void> _onCheckFirstTimeUserRequested(
    CheckFirstTimeUserRequested event,
    Emitter<OnboardingState> emit,
  ) async {
    final isFirstTimeUser = _onboardingRepository.isFirstTimeUser();
    emit(state.copyWith(isFirstTimeUser: isFirstTimeUser));
  }
}
