import 'dart:async';
import 'dart:isolate';

import 'package:cryptography/cryptography.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// {@template passkey_failure}
/// A base failure for the passkey failures.
/// {@endtemplate}
abstract class PasskeyFailure with EquatableMixin implements Exception {
  /// {@macro passkey_failure}
  const PasskeyFailure();

  @override
  List<Object?> get props => [];
}

/// {@template wrong_passkey_failure}
/// Thrown when provided old passkey is wrong for passkey update operation.
/// {@endtemplate}
class WrongOldPasskeyFailure extends PasskeyFailure {
  /// {@macro wrong_passkey_failure}
  const WrongOldPasskeyFailure();
}

/// {@template passkey_repository}
/// A repository that manages passkey or master password.
/// {@endtemplate}
class PasskeyRepository {
  /// {@macro passkey_repository}
  PasskeyRepository({
    PasskeyCryptography? passkeyCryptography,
    FlutterSecureStorage? secureStorage,
  })  : _passkeyCryptography = passkeyCryptography ?? PasskeyCryptography(),
        _secureStorage = secureStorage ?? const FlutterSecureStorage();

  final PasskeyCryptography _passkeyCryptography;
  final FlutterSecureStorage _secureStorage;

  // TODO(thecodexhub): find a way to get the value from environment variable.
  /// The key used for storing the passkey locally.
  ///
  /// This is only exposed for testing and shouldn't be used by consumers.
  @visibleForTesting
  static const kPasskeyStorageKey = '__passkey_storage_key__';

  /// Saves the [passkey] in the secure storage.
  Future<void> savePasskey(String passkey) async {
    final encrypted = await runInBackground<String>(
      () => _passkeyCryptography.hash(passkey),
    );
    await _secureStorage.write(key: kPasskeyStorageKey, value: encrypted);
  }

  // TODO(thecodexhub): This is not an ideal way, find a better solution.
  /// Returns true if the user is first time user. This method searches
  /// for saved keypass, if not found, the user is first time user.
  Future<bool> isFirstTimeUser() async {
    final encrypted = await _secureStorage.read(key: kPasskeyStorageKey);
    return encrypted == null;
  }

  /// Verifies the provided [input] with the locally stored passkey.
  ///
  /// Defaults to `false` if encrypted passkey is not found
  /// in the local storage.
  Future<bool> verifyPasskey(String input) async {
    final encrypted = await _secureStorage.read(key: kPasskeyStorageKey);
    if (encrypted == null) return false;

    final result = await runInBackground<bool>(
      () => _passkeyCryptography.verify(input, encrypted),
    );
    return result;
  }

  /// Updates the [oldPasskey], and stores the [newPasskey].
  Future<void> updatePasskey(String oldPasskey, String newPasskey) async {
    // verify the old passkey first
    final verifyOldPasskey = await verifyPasskey(oldPasskey);
    if (verifyOldPasskey == false) {
      throw const WrongOldPasskeyFailure();
    }

    // hash the new passkey
    final newEncrypted = await runInBackground<String>(
      () => _passkeyCryptography.hash(newPasskey),
    );
    // save the encrypted new passkey in the storage
    await _secureStorage.write(key: kPasskeyStorageKey, value: newEncrypted);
  }

  /// Common method to run an isolate with complex computation.
  ///
  /// This is only exposed for testing and shouldn't be used by consumers.
  @visibleForTesting
  FutureOr<T> runInBackground<T>(FutureOr<T> Function() computation) {
    return Isolate.run(computation);
  }
}
