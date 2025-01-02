// ignore_for_file: prefer_const_constructors
import 'package:cryptography/cryptography.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

const passkey = r'topS3c43t_Pa$$wo4d';
const salt = 'a5ed9dbbd35d3cbf0ed449224374e232fa5888d2828e4b3188a5801173f811c0';

class MockAlgorithm extends Mock implements Algorithm {}

class MockAES extends Mock implements AES {}

void main() {
  group('Cryptography', () {
    group('PasskeyCryptography', () {
      late Algorithm algorithm;
      late PasskeyCryptography cryptography;

      setUp(() {
        algorithm = MockAlgorithm();
        cryptography = PasskeyCryptography(algorithm: algorithm);

        when(() => algorithm.hash(any())).thenReturn('okay');
        when(() => algorithm.decode(any())).thenReturn(algorithm);
      });

      test('can be instantiated', () {
        expect(PasskeyCryptography.new, returnsNormally);
      });

      test('hash method calls the algorithm hash method', () {
        cryptography.hash(passkey);
        verify(() => algorithm.hash(passkey)).called(1);
      });

      group('verify', () {
        test('returns true when the given hash matches the passkey', () {
          final hash = cryptography.hash(passkey);
          final result = cryptography.verify(passkey, hash);
          expect(result, isTrue);

          final passkeyCryptography = PasskeyCryptography();
          final realHash = passkeyCryptography.hash(passkey);
          expect(passkeyCryptography.verify(passkey, realHash), isTrue);
        });

        test('returns false when the given hash matches the passkey', () {
          final passkeyCryptography = PasskeyCryptography();
          final realHash = passkeyCryptography.hash(passkey);
          expect(passkeyCryptography.verify('another_pass', realHash), isFalse);
        });
      });
    });

    group('PasswordCryptography', () {
      late AES aes;
      late PasswordCryptography passwordCryptography;

      setUp(() {
        aes = MockAES();
        passwordCryptography = PasswordCryptography(aes: aes);

        when(() => aes.encrypt(any(), any())).thenReturn('expected');
        when(() => aes.decrypt(any(), any())).thenReturn('password');
      });

      test('can be instantiated', () {
        expect(PasswordCryptography.new, returnsNormally);
      });

      test('encrypt method calls aes encrypt', () {
        passwordCryptography.encrypt('password', 'hash');
        verify(() => aes.encrypt('password', 'hash')).called(1);
      });

      test('decrypt method calls aes decrypt', () {
        passwordCryptography.decrypt('encrypted', 'hash');
        verify(() => aes.decrypt('encrypted', 'hash')).called(1);
      });
    });
  });
}
