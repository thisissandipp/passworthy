// ignore_for_file: prefer_const_constructors
import 'package:cryptography/cryptography.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

const passkey = r'topS3c43t_Pa$$wo4d';
const salt = 'a5ed9dbbd35d3cbf0ed449224374e232fa5888d2828e4b3188a5801173f811c0';

class MockAlgorithm extends Mock implements Algorithm {}

void main() {
  group('Cryptography', () {
    late Algorithm algorithm;
    late PasskeyCryptography cryptography;

    setUp(() {
      algorithm = MockAlgorithm();
      cryptography = PasskeyCryptography(algorithm: algorithm);

      when(() => algorithm.hash(any())).thenReturn('okay');
      when(() => algorithm.decode(any())).thenReturn(algorithm);
    });

    test('can be instantiated', () {
      expect(PasskeyCryptography(), isNotNull);
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
}
