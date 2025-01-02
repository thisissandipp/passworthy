import 'dart:math';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:pointycastle/export.dart' hide Algorithm;

/// {@template pbkdf2}
/// PBKDF2 algorithm (Password-Based Key Derivation Function 2).
/// {@endtemplate}
class PBKDF2 extends Algorithm {
  /// {@macro pbkdf2}
  PBKDF2({String? salt, int? iteration}) {
    final list = List<int>.generate(32, (_) => Random().nextInt(256));
    final rnd = FortunaRandom()..seed(KeyParameter(Uint8List.fromList(list)));
    _salt = salt == null ? rnd.nextBytes(32) : salt.toUint8List;

    _iteration = iteration ?? 9000 + Random().nextInt(1000);

    final mac = HMac(SHA512Digest(), 64);
    final pbkdf2Params = Pbkdf2Parameters(_salt, _iteration, 32);
    _derivator = PBKDF2KeyDerivator(mac)..init(pbkdf2Params);
  }

  /// The unique identifier for the algorithm.
  ///
  /// Used to determine the type of the [Algorithm] during decoding a hash.
  static const id = 'pbkdf2';

  late final int _iteration;
  late final Uint8List _salt;
  late final PBKDF2KeyDerivator _derivator;

  @override
  String hash(String password) {
    final encoded = Uint8List.fromList(password.codeUnits);
    final encryptedKey = _derivator.process(Uint8List.fromList(encoded));
    return encode(
      id,
      _salt.toHexString,
      _iteration,
      encryptedKey.toHexString,
    );
  }

  @override
  List<Object?> get props => [_salt, _iteration];
}
