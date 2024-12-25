// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:onboarding_repository/onboarding_repository.dart';
import 'package:passkey_repository/passkey_repository.dart';
import 'package:passworthy/passkey/passkey.dart';

import '../../helpers/helpers.dart';

void main() {
  group('PasskeyBloc', () {
    late OnboardingRepository onboardingRepository;
    late PasskeyRepository passkeyRepository;

    setUp(() {
      onboardingRepository = MockOnboardingRepository();
      passkeyRepository = MockPasskeyRepository();

      when(() => onboardingRepository.isFirstTimeUser()).thenReturn(false);
      when(() => onboardingRepository.setOnboarded()).thenAnswer(
        (_) async => true,
      );
      when(() => passkeyRepository.savePasskey(any())).thenAnswer((_) async {});
      when(() => passkeyRepository.verifyPasskey(any())).thenAnswer(
        (_) async => true,
      );
    });

    PasskeyBloc buildBloc() {
      return PasskeyBloc(
        onboardingRepository: onboardingRepository,
        passkeyRepository: passkeyRepository,
      );
    }

    test('constructor works correctly', () {
      expect(buildBloc, returnsNormally);
    });

    test('has an initial state', () {
      expect(buildBloc().state, equals(PasskeyState()));
    });

    group('PasskeyInputChanged', () {
      blocTest<PasskeyBloc, PasskeyState>(
        'emits state with updated [passkeyInput]',
        build: buildBloc,
        act: (bloc) => bloc.add(PasskeyInputChanged('a')),
        expect: () => [
          PasskeyState(
            passkey: Passkey.dirty('a'),
            confirmPasskey: ConfirmPasskey.dirty(passkey: 'a'),
          ),
        ],
      );
    });

    group('ConfirmPasskeyInputChanged', () {
      blocTest<PasskeyBloc, PasskeyState>(
        'emits state with updated [confirmPasskeyInput]',
        build: buildBloc,
        act: (bloc) => bloc.add(ConfirmPasskeyInputChanged('a')),
        expect: () => [
          PasskeyState(
            confirmPasskey: ConfirmPasskey.dirty(
              passkey: '',
              value: 'a',
            ),
          ),
        ],
      );
    });

    group('PasskeyInputSubmitted', () {
      blocTest<PasskeyBloc, PasskeyState>(
        'returns when isValid is false',
        build: buildBloc,
        seed: PasskeyState.new,
        act: (bloc) => bloc.add(PasskeyInputSubmitted()),
        expect: () => <PasskeyState>[],
      );

      blocTest<PasskeyBloc, PasskeyState>(
        'emits progress, success for first time user after saving the passkey',
        build: buildBloc,
        setUp: () {
          when(() => onboardingRepository.isFirstTimeUser()).thenReturn(true);
        },
        seed: () => PasskeyState(
          passkey: Passkey.dirty('abc'),
          isValid: true,
        ),
        act: (bloc) => bloc.add(PasskeyInputSubmitted()),
        expect: () => <PasskeyState>[
          PasskeyState(
            passkey: Passkey.dirty('abc'),
            isValid: true,
            status: FormzSubmissionStatus.inProgress,
          ),
          PasskeyState(
            passkey: Passkey.dirty('abc'),
            isValid: true,
            status: FormzSubmissionStatus.success,
          ),
        ],
        verify: (_) {
          verify(() => passkeyRepository.savePasskey('abc')).called(1);
          verify(() => onboardingRepository.setOnboarded()).called(1);
        },
      );

      blocTest<PasskeyBloc, PasskeyState>(
        'emits progress, success for existing user after verifying the passkey',
        build: buildBloc,
        setUp: () {
          when(() => onboardingRepository.isFirstTimeUser()).thenReturn(false);
        },
        seed: () => PasskeyState(
          passkey: Passkey.dirty('abc'),
          isValid: true,
        ),
        act: (bloc) => bloc.add(PasskeyInputSubmitted()),
        expect: () => <PasskeyState>[
          PasskeyState(
            passkey: Passkey.dirty('abc'),
            isValid: true,
            status: FormzSubmissionStatus.inProgress,
          ),
          PasskeyState(
            passkey: Passkey.dirty('abc'),
            isValid: true,
            status: FormzSubmissionStatus.success,
          ),
        ],
        verify: (_) {
          verify(() => passkeyRepository.verifyPasskey('abc')).called(1);
        },
      );

      blocTest<PasskeyBloc, PasskeyState>(
        'emits progress, failure for existing user after verifying the passkey',
        build: buildBloc,
        setUp: () {
          when(() => passkeyRepository.verifyPasskey(any())).thenAnswer(
            (_) async => false,
          );
        },
        seed: () => PasskeyState(
          passkey: Passkey.dirty('abc'),
          isValid: true,
        ),
        act: (bloc) => bloc.add(PasskeyInputSubmitted()),
        expect: () => <PasskeyState>[
          PasskeyState(
            passkey: Passkey.dirty('abc'),
            isValid: true,
            status: FormzSubmissionStatus.inProgress,
          ),
          PasskeyState(
            passkey: Passkey.dirty('abc'),
            isValid: true,
            status: FormzSubmissionStatus.failure,
          ),
        ],
        verify: (_) {
          verify(() => passkeyRepository.verifyPasskey('abc')).called(1);
        },
      );
    });
  });
}
