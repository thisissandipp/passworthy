import 'package:cryptography/cryptography.dart';

/// {@template passkey_cryptography}
/// Hashes and verifies the passkey (master password). Uses
/// the PBKDF2 algorithm for hashing.
/// {@endtemplate}
class PasskeyCryptography {
  /// {@macro passkey_cryptography}
  PasskeyCryptography({
    Algorithm? algorithm,
  }) : _algorithm = algorithm ?? PBKDF2();

  final Algorithm _algorithm;

  /// Hashes the plain text [passkey] and returns the hash.
  String hash(String passkey) => _algorithm.hash(passkey);

  /// Verifies whether the [passkey] matches the encoded [hash].
  bool verify(String passkey, String hash) {
    final algorithm = _algorithm.decode(hash);
    return algorithm.hash(passkey) == hash;
  }
}
