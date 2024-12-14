import 'package:cryptography/cryptography.dart';
import 'package:test/test.dart';

const password = r'topS3c43t_Pa$$wo4d';
const salt = 'a5ed9dbbd35d3cbf0ed449224374e232fa5888d2828e4b3188a5801173f811c0';

void main() {
  group('PBKDF2', () {
    late PBKDF2 pbkdf2;
    late String hash;

    setUp(() {
      pbkdf2 = PBKDF2();
      hash = pbkdf2.hash(password);
    });

    test('constructor works perfectly', () {
      expect(PBKDF2.new, returnsNormally);
      expect(
        () => PBKDF2(salt: salt, iteration: 12),
        returnsNormally,
      );
    });

    test('process returns encoded hash', () {
      final encoded = pbkdf2.hash(password);
      expect(encoded, equals(hash));
    });
  });
}
