// Ignore below specifics for testing environment.
// ignore_for_file: prefer_const_constructors

import 'package:cryptography/cryptography.dart';
import 'package:test/test.dart';

void main() {
  const passkey = 'myT0-pS3cr37';
  const password = 'y3s-1ts^s!mPL3';

  group('AES', () {
    late AES aes;
    late PBKDF2 pbkdf2;

    late String hash;

    setUp(() {
      aes = AES();
      pbkdf2 = PBKDF2();
      hash = pbkdf2.hash(passkey);
    });

    test('contructor works perfectly', () {
      expect(AES.new, returnsNormally);
    });

    test('encrypts the password correctly', () {
      final encrypted = aes.encrypt(password, hash);
      expect(encrypted.split(r'$').length, equals(2));
    });

    test('decrypts the password correctly', () {
      final encrypted = aes.encrypt(password, hash);
      final decrypted = aes.decrypt(encrypted, hash);
      expect(decrypted, equals(password));
    });
  });
}
