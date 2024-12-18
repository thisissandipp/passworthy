// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:cryptography/cryptography.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:passkey_repository/passkey_repository.dart';

class MockPasskeyCryptography extends Mock implements PasskeyCryptography {}

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

class PasskeyRepositoryTest extends PasskeyRepository {
  PasskeyRepositoryTest({
    super.passkeyCryptography,
    super.secureStorage,
  });

  @override
  FutureOr<T> runInBackground<T>(FutureOr<T> Function() computation) {
    return computation();
  }
}

void main() {
  group('PasskeyFailure', () {
    test('props are defined', () {
      final failure = WrongOldPasskeyFailure();
      expect(failure.props, equals(<Object>[]));
    });
  });

  group('PasskeyRepository', () {
    late MockPasskeyCryptography passkeyCryptography;
    late MockFlutterSecureStorage secureStorage;
    late PasskeyRepository passkeyRepository;

    setUp(() {
      passkeyCryptography = MockPasskeyCryptography();
      secureStorage = MockFlutterSecureStorage();
      passkeyRepository = PasskeyRepositoryTest(
        passkeyCryptography: passkeyCryptography,
        secureStorage: secureStorage,
      );

      when(() => passkeyCryptography.hash(any())).thenReturn('encrypted');
      when(
        () => secureStorage.write(
          key: any(named: 'key'),
          value: any(named: 'value'),
        ),
      ).thenAnswer((_) async {});
    });

    test(
      'create [PasskeyCryptography] and [FlutterSecureStorage] instances '
      'internally when not injected',
      () => expect(PasskeyRepository.new, isNot(throwsException)),
    );

    test('savePasskey encrypts and saves the encrypted passkey', () async {
      await passkeyRepository.savePasskey('mysecurepasskey');
      verify(() => passkeyCryptography.hash('mysecurepasskey')).called(1);
      verify(
        () => secureStorage.write(
          key: PasskeyRepository.kPasskeyStorageKey,
          value: 'encrypted',
        ),
      ).called(1);
    });

    group('isFirstTimeUser', () {
      test('returns true when there is no saved encrypted keypass', () async {
        when(
          () => secureStorage.read(key: any(named: 'key')),
        ).thenAnswer((_) async => null);
        final actual = await passkeyRepository.isFirstTimeUser();
        expect(actual, isTrue);
      });

      test('returns false when there is a saved encrypted keypass', () async {
        when(
          () => secureStorage.read(key: any(named: 'key')),
        ).thenAnswer((_) async => 'something');
        final actual = await passkeyRepository.isFirstTimeUser();
        expect(actual, isFalse);
      });
    });

    group('verifyPasskey', () {
      setUp(() {
        when(
          () => secureStorage.read(key: any(named: 'key')),
        ).thenAnswer((_) async => 'encryptedpasskey');
      });

      test('returns false when there is no locally stored hash', () async {
        when(
          () => secureStorage.read(key: any(named: 'key')),
        ).thenAnswer((_) async => null);

        final result = await passkeyRepository.verifyPasskey('mypasskey');
        expect(result, isFalse);
        verify(
          () => secureStorage.read(key: PasskeyRepository.kPasskeyStorageKey),
        ).called(1);
      });

      test('returns false when the input do not match', () async {
        when(() => passkeyCryptography.verify(any(), any())).thenReturn(false);
        final result = await passkeyRepository.verifyPasskey('mypasskey');
        expect(result, isFalse);

        verify(
          () => secureStorage.read(key: PasskeyRepository.kPasskeyStorageKey),
        ).called(1);
        verify(
          () => passkeyCryptography.verify('mypasskey', 'encryptedpasskey'),
        ).called(1);
      });

      test('returns true when the input matches the hashed keypass', () async {
        when(() => passkeyCryptography.verify(any(), any())).thenReturn(true);
        final result = await passkeyRepository.verifyPasskey('mypasskey');
        expect(result, isTrue);

        verify(
          () => secureStorage.read(key: PasskeyRepository.kPasskeyStorageKey),
        ).called(1);
        verify(
          () => passkeyCryptography.verify('mypasskey', 'encryptedpasskey'),
        ).called(1);
      });
    });

    group('updatePasskey', () {
      setUp(() {
        when(
          () => secureStorage.read(key: any(named: 'key')),
        ).thenAnswer((_) async => 'encryptedpasskey');
        when(() => passkeyCryptography.verify(any(), any())).thenReturn(true);
        when(
          () => secureStorage.write(
            key: any(named: 'key'),
            value: any(named: 'value'),
          ),
        ).thenAnswer((_) async {});
      });

      test(
        'throws [WrongOldPasskeyFailure] when the oldPasskey do not match',
        () async {
          when(
            () => passkeyCryptography.verify(any(), any()),
          ).thenReturn(false);
          await expectLater(
            () => passkeyRepository.updatePasskey('oldPasskey', 'newPasskey'),
            throwsA(isA<WrongOldPasskeyFailure>()),
          );
        },
      );

      test('updates the new passkey', () async {
        when(
          () => passkeyCryptography.verify(any(), any()),
        ).thenReturn(true);
        when(
          () => passkeyCryptography.hash('newPasskey'),
        ).thenReturn('newencrypted');

        await passkeyRepository.updatePasskey('oldPasskey', 'newPasskey');

        verify(
          () => secureStorage.read(
            key: PasskeyRepository.kPasskeyStorageKey,
          ),
        ).called(1);
        verify(() => passkeyCryptography.hash('newPasskey')).called(1);

        verify(
          () => secureStorage.write(
            key: PasskeyRepository.kPasskeyStorageKey,
            value: 'newencrypted',
          ),
        ).called(1);
      });
    });

    group('runInBackground', () {
      test('executes computation in isolate and returns result', () async {
        final repository = PasskeyRepository();
        Future<int> computation() async => 42;

        final result = await repository.runInBackground(computation);
        expect(result, equals(42));
      });
    });
  });
}
