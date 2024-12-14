import 'package:cryptography/cryptography.dart';
import 'package:test/test.dart';

class TestAlgorithm extends Algorithm {
  @override
  dynamic noSuchMethod(Invocation invocation) {
    return super.noSuchMethod(invocation);
  }
}

const salt = 'a5ed9dbbd35d3cbf0ed449224374e232fa5888d2828e4b3188a5801173f811c0';

void main() {
  group('Algorithm', () {
    test('can be instantiated', () {
      expect(TestAlgorithm.new, returnsNormally);
    });

    test('encode returns the encoded string', () {
      final algo = TestAlgorithm();
      expect(
        algo.encode('id', 'salt', 12, 'hash'),
        equals(r'$id$salt$c$hash'),
      );
    });

    group('decode', () {
      test('returns pbkdf2 with salt and iteration when the id matches', () {
        const hash = '\$${PBKDF2.id}\$$salt\$c\$hash';
        final algo = TestAlgorithm();

        final decodedAlgo = algo.decode(hash);
        expect(decodedAlgo, isA<PBKDF2>());

        expect(
          decodedAlgo,
          equals(PBKDF2(salt: salt, iteration: 12)),
        );
      });

      test('throws unimplemented error when the id do not match', () {
        const hash = r'$something$salt$c$hash';
        final algo = TestAlgorithm();

        expect(
          () => algo.decode(hash),
          throwsA(isA<UnimplementedError>()),
        );
      });
    });
  });
}
