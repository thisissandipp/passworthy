// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:passkey_repository/passkey_repository.dart';
import 'package:passworthy/passkey/passkey.dart';

import '../../helpers/helpers.dart';

void main() {
  group('PasskeyBloc', () {
    late PasskeyRepository passkeyRepository;

    setUp(() {
      passkeyRepository = MockPasskeyRepository();
      when(() => passkeyRepository.savePasskey(any())).thenAnswer((_) async {});
      when(() => passkeyRepository.verifyPasskey(any())).thenAnswer(
        (_) async => true,
      );
    });

    PasskeyBloc buildBloc() {
      return PasskeyBloc(passkeyRepository: passkeyRepository);
    }

    test('constructor works correctly', () {
      expect(buildBloc, returnsNormally);
    });

    test('has an initial state', () {
      expect(buildBloc().state, equals(PasskeyState()));
    });

    group('FirstTimeUserCheckRequested', () {
      blocTest<PasskeyBloc, PasskeyState>(
        'emits state with correct [isFirstTimeUser] as repository method',
        build: buildBloc,
        setUp: () => when(() => passkeyRepository.isFirstTimeUser()).thenAnswer(
          (_) async => false,
        ),
        act: (bloc) => bloc.add(FirstTimeUserCheckRequested()),
        expect: () => [PasskeyState(isFirstTimeUser: false)],
        verify: (_) {
          verify(() => passkeyRepository.isFirstTimeUser()).called(1);
        },
      );
    });

    group('PasskeyInputChanged', () {
      blocTest<PasskeyBloc, PasskeyState>(
        'emits state with updated [passkeyInput]',
        build: buildBloc,
        act: (bloc) => bloc.add(PasskeyInputChanged('a')),
        expect: () => [
          PasskeyState(passkeyInput: 'a'),
        ],
      );
    });

    group('ConfirmPasskeyInputChanged', () {
      blocTest<PasskeyBloc, PasskeyState>(
        'emits state with updated [confirmPasskeyInput]',
        build: buildBloc,
        act: (bloc) => bloc.add(ConfirmPasskeyInputChanged('a')),
        expect: () => [
          PasskeyState(confirmPasskeyInput: 'a'),
        ],
      );
    });

    group('PasskeyInputSubmitted', () {
      blocTest<PasskeyBloc, PasskeyState>(
        'emits error message for first time user when passkey input is empty',
        build: buildBloc,
        seed: PasskeyState.new,
        act: (bloc) => bloc.add(PasskeyInputSubmitted()),
        expect: () => <PasskeyState>[
          PasskeyState(
            errorMessage: 'Either the inputs are empty or they do not match',
          ),
        ],
      );

      blocTest<PasskeyBloc, PasskeyState>(
        'emits error for first time user when confirm passskey input is empty',
        build: buildBloc,
        seed: () => PasskeyState(passkeyInput: 'abc'),
        act: (bloc) => bloc.add(PasskeyInputSubmitted()),
        expect: () => <PasskeyState>[
          PasskeyState(
            passkeyInput: 'abc',
            errorMessage: 'Either the inputs are empty or they do not match',
          ),
        ],
      );

      blocTest<PasskeyBloc, PasskeyState>(
        'emits error for first time user when passkey and confirm '
        'passskey do not match',
        build: buildBloc,
        seed: () => PasskeyState(
          passkeyInput: 'abc',
          confirmPasskeyInput: 'def',
        ),
        act: (bloc) => bloc.add(PasskeyInputSubmitted()),
        expect: () => <PasskeyState>[
          PasskeyState(
            passkeyInput: 'abc',
            confirmPasskeyInput: 'def',
            errorMessage: 'Either the inputs are empty or they do not match',
          ),
        ],
      );

      blocTest<PasskeyBloc, PasskeyState>(
        'emits verified for first time user after encrypting passkey',
        build: buildBloc,
        seed: () => PasskeyState(
          passkeyInput: 'abc',
          confirmPasskeyInput: 'abc',
        ),
        act: (bloc) => bloc.add(PasskeyInputSubmitted()),
        expect: () => <PasskeyState>[
          PasskeyState(
            passkeyInput: 'abc',
            confirmPasskeyInput: 'abc',
            isVerified: true,
          ),
        ],
        verify: (_) {
          verify(() => passkeyRepository.savePasskey('abc')).called(1);
        },
      );

      blocTest<PasskeyBloc, PasskeyState>(
        'emits result from repository verify passkey method for old user',
        build: buildBloc,
        seed: () => PasskeyState(
          isFirstTimeUser: false,
          passkeyInput: 'xyz',
        ),
        act: (bloc) => bloc.add(PasskeyInputSubmitted()),
        expect: () => <PasskeyState>[
          PasskeyState(
            isFirstTimeUser: false,
            passkeyInput: 'xyz',
            isVerified: true,
          ),
        ],
        verify: (_) {
          verify(() => passkeyRepository.verifyPasskey('xyz')).called(1);
        },
      );
    });
  });
}
