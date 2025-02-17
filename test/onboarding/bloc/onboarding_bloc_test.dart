// Ignore below specifics for testing environment.
// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:onboarding_repository/onboarding_repository.dart';
import 'package:passworthy/onboarding/onboarding.dart';

import '../../helpers/helpers.dart';

void main() {
  group('OnboardingBloc', () {
    late OnboardingRepository repository;

    setUp(() {
      repository = MockOnboardingRepository();
      when(() => repository.isFirstTimeUser()).thenReturn(false);
    });

    OnboardingBloc buildBloc() {
      return OnboardingBloc(onboardingRepository: repository);
    }

    test('constructor works correctly', () {
      expect(buildBloc, returnsNormally);
    });

    test('has an initial state', () {
      expect(buildBloc().state, equals(OnboardingState()));
    });

    group('CheckFirstTimeUserRequested', () {
      blocTest<OnboardingBloc, OnboardingState>(
        'emits result from repository method',
        build: buildBloc,
        act: (bloc) => bloc.add(CheckFirstTimeUserRequested()),
        expect: () => <OnboardingState>[
          OnboardingState(isFirstTimeUser: false),
        ],
        verify: (_) {
          verify(() => repository.isFirstTimeUser()).called(1);
        },
      );
    });
  });
}
