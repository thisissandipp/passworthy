import 'dart:async';
import 'dart:isolate';

import 'package:cache/cache.dart';
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
    required CacheClient cacheClient,
    required String passkeyStorageKey,
    PasskeyCryptography? passkeyCryptography,
    FlutterSecureStorage? secureStorage,
  })  : _cacheClient = cacheClient,
        _passkeyStorageKey = passkeyStorageKey,
        _passkeyCryptography = passkeyCryptography ?? PasskeyCryptography(),
        _secureStorage = secureStorage ?? const FlutterSecureStorage();

  final PasskeyCryptography _passkeyCryptography;
  final FlutterSecureStorage _secureStorage;
  final CacheClient _cacheClient;
  final String _passkeyStorageKey;

  /// The key used for storing the passkey in memory/cache.
  ///
  /// This is only exposed for testing and shouldn't be used by consumers.
  @visibleForTesting
  static const kPasskeyCacheKey = '__passkey_cache_key__';

  /// Saves the [passkey] in the secure storage.
  Future<void> savePasskey(String passkey) async {
    final encrypted = await runInBackground<String>(
      () => _passkeyCryptography.hash(passkey),
    );

    // Cache the encrypted passkey, so that it can be used to encrypt
    // entry passwords.
    _cacheClient.write<String>(key: kPasskeyCacheKey, value: encrypted);

    // Securely store the user's passkey locally.
    await _secureStorage.write(key: _passkeyStorageKey, value: encrypted);
  }

  /// Retrieves cached passkey from the point when users verified their
  /// passkey to enter the app.
  ///
  /// Returns null if the cache is empty.
  String? cachedPasskey() {
    return _cacheClient.read<String>(key: kPasskeyCacheKey);
  }

  /// Verifies the provided [input] with the locally stored passkey.
  ///
  /// Defaults to `false` if encrypted passkey is not found
  /// in the local storage.
  Future<bool> verifyPasskey(String input) async {
    final encrypted = await _secureStorage.read(key: _passkeyStorageKey);
    if (encrypted == null) return false;

    final result = await runInBackground<bool>(
      () => _passkeyCryptography.verify(input, encrypted),
    );

    // If the passkey is correct, cache it.
    // This passkey will be used to encrypt and decrypt entry passwords.
    if (result) {
      _cacheClient.write<String>(key: kPasskeyCacheKey, value: encrypted);
    }

    return result;
  }

  /// Updates the [oldPasskey], and stores the [newPasskey].
  ///
  /// Make sure to prompt user to the passkey enter zone, otherwise
  /// the new passwords won't be encrypted correctly.
  ///
  /// Old passwords also need to encrypted again!
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
    await _secureStorage.write(key: _passkeyStorageKey, value: newEncrypted);
  }

  /// Common method to run an isolate with complex computation.
  ///
  /// This is only exposed for testing and shouldn't be used by consumers.
  @visibleForTesting
  FutureOr<T> runInBackground<T>(FutureOr<T> Function() computation) {
    return Isolate.run(computation);
  }
}
