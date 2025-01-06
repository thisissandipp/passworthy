import 'dart:async';

import 'package:entries_api/entries_api.dart';

/// {@template entries_repository}
/// A repository that handles entry related requests.
/// {@endtemplate}
class EntriesRepository {
  /// {@macro entries_repository}
  const EntriesRepository({
    required EntriesApi entriesApi,
  }) : _entriesApi = entriesApi;

  final EntriesApi _entriesApi;

  /// Provides a [Stream] of all the entries.
  Stream<List<Entry>> getEntries({required String passkey}) {
    return _entriesApi.getEntries(passkey);
  }

  /// Saves an [entry].
  ///
  /// If there's already an entry with the same id, it will be replaced.
  FutureOr<void> saveEntry({required Entry entry, required String passkey}) {
    return _entriesApi.saveEntry(entry, passkey);
  }

  /// Deletes the entry.
  ///
  /// If no entry found with the provided entry's id, an
  /// [EntryNotFoundException] is thrown.
  FutureOr<void> deleteEntry({required Entry entry}) {
    return _entriesApi.deleteEntry(entry.id);
  }
}
