import 'package:cryptography/cryptography.dart';
import 'package:equatable/equatable.dart';

/// Base class for the algorithm.
abstract class Algorithm extends Equatable {
  /// Encodes the algorithm [id], used [salt], number of [iteration], and
  /// the resultant [hash].
  String encode(String id, String salt, int iteration, String hash) {
    return ['', id, salt, iteration.toRadixString(16), hash].join(r'$');
  }

  /// Hashes the given plain-text [password].
  String hash(String password);

  /// Decodes the [hash], uses the encoded parameters to decide the algorithm.
  Algorithm decode(String hash) {
    final parts = hash.split(r'$');
    final algorithm = parts[1];

    switch (algorithm) {
      case PBKDF2.id:
        final extractedSalt = parts[2];
        final extractedIteration = int.parse(parts[3], radix: 16);
        return PBKDF2(salt: extractedSalt, iteration: extractedIteration);
      default:
        throw UnimplementedError();
    }
  }
}
