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

/// {@template password_cryptography}
/// Encrypts and decrypts the password with the AES algorithm.
/// {@endtemplate}
class PasswordCryptography {
  /// {@macro password_cryptography}
  const PasswordCryptography({AES? aes}) : _aes = aes ?? const AES();

  final AES _aes;

  /// Encrypts the password and returns the encrypted result.
  String encrypt(String password, String hash) => _aes.encrypt(password, hash);

  /// Decrypts the [encrypted] and returns the original password.
  String decrypt(String encrypted, String hash) {
    return _aes.decrypt(encrypted, hash);
  }
}
