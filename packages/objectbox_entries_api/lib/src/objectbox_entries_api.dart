import 'dart:async';

import 'package:cache/cache.dart';
import 'package:cryptography/cryptography.dart';
import 'package:entries_api/entries_api.dart';
import 'package:flutter/foundation.dart' show visibleForTesting;
import 'package:objectbox_entries_api/objectbox_entries_api.dart';

/// {@template objectbox_entries_api}
/// An implementation of the EntriesApi that uses Objectbox persistent library.
/// {@endtemplate}
class ObjectboxEntriesApi extends EntriesApi {
  /// {@macro objectbox_entries_api}
  ObjectboxEntriesApi._create({
    required super.passwordCryptography,
    required this.store,
    required CacheClient cacheClient,
  }) : _cacheClient = cacheClient;

  /// Initializes the store for the application.
  static Future<ObjectboxEntriesApi> init({
    required String storeDirectory,
    required CacheClient cacheClient,
    PasswordCryptography? cryptography,
  }) async {
    final store = await openStore(directory: storeDirectory);
    return ObjectboxEntriesApi._create(
      passwordCryptography: cryptography ?? const PasswordCryptography(),
      store: store,
      cacheClient: cacheClient,
    );
  }

  final CacheClient _cacheClient;

  /// The store for the data.
  late final Store store;

  /// The key used for storing the count of entries locally.
  ///
  /// This is only exposed for testing and shouldn't be used by consumers.
  @visibleForTesting
  static const kEntriesCountKey = '__entries_count_key__';

  @override
  Stream<List<Entry>> getEntries(String passkey) async* {
    final queryStream = store.box<EntryDto>().query().watch(
          triggerImmediately: true,
        );

    yield* queryStream.asyncMap((query) async {
      final entryDtoList = await query.findAsync();

      // Update entries count in the cache
      _cacheClient.write<int>(
        key: kEntriesCountKey,
        value: entryDtoList.length,
      );

      final entryList = await Future.wait(
        entryDtoList.map((entryDto) async {
          final encryptedEntry = entryDto.toEntry();
          return await applyDecryption(
            passkey: passkey,
            operation: () => encryptedEntry,
          );
        }),
      );
      return entryList;
    });
  }

  @override
  Stream<List<Entry>> getEntriesWithFilter(
    String passkey,
    String searchText,
  ) async* {
    final queryStream = store
        .box<EntryDto>()
        .query(
          EntryDto_.platform
              .contains(searchText)
              .or(EntryDto_.identity.contains(searchText)),
        )
        .watch(
          triggerImmediately: true,
        );

    yield* queryStream.asyncMap((query) async {
      final entryDtoList = await query.findAsync();
      final entryList = await Future.wait(
        entryDtoList.map((entryDto) async {
          final encryptedEntry = entryDto.toEntry();
          return await applyDecryption(
            passkey: passkey,
            operation: () => encryptedEntry,
          );
        }),
      );
      return entryList;
    });
  }

  @override
  int entriesCount() {
    return _cacheClient.read<int>(key: kEntriesCountKey) ?? 0;
  }

  @override
  FutureOr<void> saveEntry(Entry entry, String passkey) async {
    return applyEncryption(
      entry: entry,
      passkey: passkey,
      operation: (encrypted) {
        final entryBox = store.box<EntryDto>();
        final query = EntryDto_.uid.equals(entry.id);
        final entryToPut = entryBox.query(query).build().findFirst();

        if (entryToPut != null) {
          // TODO(thisissandipp): Update `lastUpdatedAt` if the password has changed.
          encrypted = encrypted.copyWith(lastUpdatedAt: DateTime.now());
        }

        entryBox.putAsync(EntryDto.fromEntry(encrypted));
      },
    );
  }

  @override
  FutureOr<void> deleteEntry(String id) {
    final entryToRemove = store
        .box<EntryDto>()
        .query(EntryDto_.uid.equals(id))
        .build()
        .findFirst();

    if (entryToRemove == null) throw EntryNotFoundException();
    store.box<EntryDto>().remove(entryToRemove.id);
  }

  @override
  FutureOr<void> close() {}
}
