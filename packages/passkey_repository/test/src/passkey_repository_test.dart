// Ignore below specifics for testing environment.
// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:cache/cache.dart';
import 'package:cryptography/cryptography.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:passkey_repository/passkey_repository.dart';

class MockPasskeyCryptography extends Mock implements PasskeyCryptography {}

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

class MockCacheClient extends Mock implements CacheClient {}

class PasskeyRepositoryTest extends PasskeyRepository {
  PasskeyRepositoryTest({
    required super.cacheClient,
    required super.passkeyStorageKey,
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
    const passkeyStorageKey = '__passkey_storage_key__';

    late MockPasskeyCryptography passkeyCryptography;
    late MockFlutterSecureStorage secureStorage;
    late PasskeyRepository passkeyRepository;
    late CacheClient cacheClient;

    setUp(() {
      passkeyCryptography = MockPasskeyCryptography();
      secureStorage = MockFlutterSecureStorage();
      cacheClient = MockCacheClient();

      passkeyRepository = PasskeyRepositoryTest(
        passkeyCryptography: passkeyCryptography,
        secureStorage: secureStorage,
        cacheClient: cacheClient,
        passkeyStorageKey: passkeyStorageKey,
      );

      when(() => passkeyCryptography.hash(any())).thenReturn('encrypted');
      when(
        () => secureStorage.write(
          key: any(named: 'key'),
          value: any(named: 'value'),
        ),
      ).thenAnswer((_) async {});

      when(() => cacheClient.read(key: any(named: 'key'))).thenReturn('cached');
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
          key: passkeyStorageKey,
          value: 'encrypted',
        ),
      ).called(1);
      verify(
        () => cacheClient.write(
          key: PasskeyRepository.kPasskeyCacheKey,
          value: 'encrypted',
        ),
      ).called(1);
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
          () => secureStorage.read(key: passkeyStorageKey),
        ).called(1);
      });

      test('returns false when the input do not match', () async {
        when(() => passkeyCryptography.verify(any(), any())).thenReturn(false);
        final result = await passkeyRepository.verifyPasskey('mypasskey');
        expect(result, isFalse);

        verify(
          () => secureStorage.read(key: passkeyStorageKey),
        ).called(1);
        verify(
          () => passkeyCryptography.verify('mypasskey', 'encryptedpasskey'),
        ).called(1);
      });

      test('returns true when the input matches the hashed keypass', () async {
        when(() => passkeyCryptography.verify(any(), any())).thenReturn(true);
        final result = await passkeyRepository.verifyPasskey('mypasskey');
        expect(result, isTrue);

        verify(() => secureStorage.read(key: passkeyStorageKey)).called(1);
        verify(
          () => passkeyCryptography.verify('mypasskey', 'encryptedpasskey'),
        ).called(1);

        verify(
          () => cacheClient.write(
            key: PasskeyRepository.kPasskeyCacheKey,
            value: 'encryptedpasskey',
          ),
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

        verify(() => secureStorage.read(key: passkeyStorageKey)).called(1);
        verify(() => passkeyCryptography.hash('newPasskey')).called(1);

        verify(
          () => secureStorage.write(
            key: passkeyStorageKey,
            value: 'newencrypted',
          ),
        ).called(1);
      });
    });

    group('cachedPasskey', () {
      test('returns cached passkey', () {
        passkeyRepository.cachedPasskey();
        verify(
          () => cacheClient.read<String>(
            key: PasskeyRepository.kPasskeyCacheKey,
          ),
        ).called(1);
      });
    });

    group('runInBackground', () {
      test('executes computation in isolate and returns result', () async {
        final repository = PasskeyRepository(
          cacheClient: cacheClient,
          passkeyStorageKey: passkeyStorageKey,
        );
        Future<int> computation() async => 42;

        final result = await repository.runInBackground(computation);
        expect(result, equals(42));
      });
    });
  });
}
