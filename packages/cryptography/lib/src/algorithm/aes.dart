import 'dart:math';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:pointycastle/export.dart';

// TODO(thecodexhub): Refactor it!
/// {@template aes}
/// A wrapper to the AES algorithm that encrypts and decrypts data.
/// {@endtemplate}
class AES {
  /// {@macro aes}
  const AES();

  /// Encrypts the [password], and returns the encrypted result.
  String encrypt(String password, String hash) {
    final hashes = hash.split(r'$');
    final key = hashes[hashes.length - 1].toUint8List;

    final list = List<int>.generate(32, (_) => Random().nextInt(256));
    final rnd = FortunaRandom()..seed(KeyParameter(Uint8List.fromList(list)));
    final nonce = rnd.nextBytes(32);

    final params = AEADParameters(KeyParameter(key), 128, nonce, Uint8List(0));
    final cipher = GCMBlockCipher(AESEngine())..init(true, params);

    final passwordBytes = Uint8List.fromList(password.codeUnits);
    final cipherText = cipher.process(passwordBytes);

    // nonce, cipherText
    return [nonce.toHexString, cipherText.toHexString].join(r'$');
  }

  /// Decrypts the [encrypted], and returns the original password.
  String decrypt(String encrypted, String hash) {
    final hashes = hash.split(r'$');
    final key = hashes[hashes.length - 1].toUint8List;

    final [decodedNonce, decodedCipherText] = encrypted.split(r'$');
    final nonce = decodedNonce.toUint8List;
    final cipherText = decodedCipherText.toUint8List;

    final params = AEADParameters(KeyParameter(key), 128, nonce, Uint8List(0));
    final cipher = GCMBlockCipher(AESEngine())..init(false, params);

    final passwordBytes = cipher.process(cipherText);
    final password = String.fromCharCodes(Uint8List.fromList(passwordBytes));

    return password;
  }
}
