part of 'onboarding_bloc.dart';

class OnboardingState extends Equatable {
  const OnboardingState({
    this.isFirstTimeUser = true,
  });

  final bool isFirstTimeUser;

  @override
  List<Object> get props => [isFirstTimeUser];

  OnboardingState copyWith({
    bool? isFirstTimeUser,
  }) {
    return OnboardingState(
      isFirstTimeUser: isFirstTimeUser ?? this.isFirstTimeUser,
    );
  }
}
