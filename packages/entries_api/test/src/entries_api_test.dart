import 'dart:async';

import 'package:cryptography/cryptography.dart';
import 'package:entries_api/entries_api.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

class MockPasswordCryptography extends Mock implements PasswordCryptography {}

class MockEntry extends Mock implements Entry {}

class TestEntriesApi extends EntriesApi {
  TestEntriesApi({
    PasswordCryptography? passwordCryptography,
  }) : super(
          passwordCryptography:
              passwordCryptography ?? MockPasswordCryptography(),
        );

  @override
  FutureOr<T> runInBackground<T>(FutureOr<T> Function() computation) {
    return computation();
  }

  @override
  dynamic noSuchMethod(Invocation invocation) {
    return super.noSuchMethod(invocation);
  }
}

class AnotherTestEntriesApi extends EntriesApi {
  AnotherTestEntriesApi({
    PasswordCryptography? passwordCryptography,
  }) : super(
          passwordCryptography:
              passwordCryptography ?? MockPasswordCryptography(),
        );

  @override
  dynamic noSuchMethod(Invocation invocation) {
    return super.noSuchMethod(invocation);
  }
}

void main() {
  group('EntriesAPI', () {
    test('can be constructed', () {
      expect(TestEntriesApi.new, returnsNormally);
    });

    group('applyEncryption', () {
      late Entry entry;
      late PasswordCryptography cryptography;
      late EntriesApi api;

      setUp(() {
        entry = Entry(
          platform: 'platform',
          identity: 'identity',
          password: 'password',
          createdAt: DateTime.now(),
        );

        cryptography = MockPasswordCryptography();
        api = TestEntriesApi(passwordCryptography: cryptography);

        when(() => cryptography.encrypt(any(), any())).thenReturn('encrypted');
      });

      test('calls the encryption on cryptography', () async {
        late Entry encryptedEntry;
        await api.applyEncryption(
          entry: entry,
          passkey: 'passkey',
          operation: (encrypted) {
            encryptedEntry = encrypted;
          },
        );

        expect(encryptedEntry.password, equals('encrypted'));
        verify(() => cryptography.encrypt('password', 'passkey')).called(1);
      });
    });

    group('applyDecryption', () {
      late Entry entry;
      late PasswordCryptography cryptography;
      late EntriesApi api;

      setUp(() {
        entry = Entry(
          platform: 'platform',
          identity: 'identity',
          password: 'password',
          createdAt: DateTime.now(),
        );

        cryptography = MockPasswordCryptography();
        api = TestEntriesApi(passwordCryptography: cryptography);

        when(() => cryptography.decrypt(any(), any())).thenReturn('password');
      });

      test('calls the decryption on cryptography', () async {
        final result = await api.applyDecryption(
          passkey: 'passkey',
          operation: () {
            return entry.copyWith(password: 'encrypted');
          },
        );

        expect(result.password, equals('password'));
        verify(() => cryptography.decrypt('encrypted', 'passkey')).called(1);
      });
    });

    group('runInBackground', () {
      test('executes computation in isolate and returns result', () async {
        final api = AnotherTestEntriesApi();
        Future<int> computation() async => 42;

        final result = await api.runInBackground(computation);
        expect(result, equals(42));
      });
    });
  });
}
