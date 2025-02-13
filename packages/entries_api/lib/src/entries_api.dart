import 'dart:async';
import 'dart:isolate';

import 'package:cryptography/cryptography.dart';
import 'package:entries_api/entries_api.dart';
import 'package:meta/meta.dart';

/// {@template entries_api}
/// The interface and models for an API providing access to entries.
/// {@endtemplate}
abstract class EntriesApi {
  /// {@macro entries_api}
  const EntriesApi({
    required PasswordCryptography passwordCryptography,
  }) : _passwordCryptography = passwordCryptography;

  final PasswordCryptography _passwordCryptography;

  /// Provides a [Stream] of all entries.
  ///
  /// The [passkey] is passed to decrypt the entries.
  Stream<List<Entry>> getEntries(String passkey);

  /// Saves the [entry].
  ///
  /// If an [entry] already exists with the same id, it will be replaced.
  /// This means, if there's no item that has same `id` as this [entry], an
  /// insert operation will be performed, and if same `id` is found, an update
  /// operation will be performed.
  FutureOr<void> saveEntry(Entry entry, String passkey);

  /// Deletes the `entry` with the given id.
  ///
  /// If no `enrty` is found with the given id, an [EntryNotFoundException]
  /// error is thrown.
  FutureOr<void> deleteEntry(String id);

  /// Closes the client and frees up any resources.
  FutureOr<void> close();

  /// Applies encryption on the [entry] with the [passkey], and runs
  /// the [operation] with the encrypted entry.
  FutureOr<void> applyEncryption({
    required Entry entry,
    required String passkey,
    required void Function(Entry encryptedEntry) operation,
  }) async {
    final encryptedPassword = _passwordCryptography.encrypt(
      entry.password,
      passkey,
    );
    final encryptedEntry = entry.copyWith(password: encryptedPassword);
    operation.call(encryptedEntry);
  }

  /// Runs the [operation], and applies decryption on the entry with [passkey].
  /// Returns the decrypted entry.
  FutureOr<Entry> applyDecryption({
    required String passkey,
    required Entry Function() operation,
  }) async {
    final encryptedEntry = operation.call();
    final password = _passwordCryptography.decrypt(
      encryptedEntry.password,
      passkey,
    );
    return encryptedEntry.copyWith(password: password);
  }

  /// Common method to run an isolate with complex computation.
  ///
  /// This is only exposed for testing and shouldn't be used by consumers.
  @visibleForTesting
  FutureOr<T> runInBackground<T>(FutureOr<T> Function() computation) {
    return Isolate.run(computation);
  }
}

/// Error thrown when an [Entry] with the id doesn't exist in the database.
class EntryNotFoundException implements Exception {}
