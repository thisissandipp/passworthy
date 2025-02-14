import 'dart:async';

import 'package:cryptography/cryptography.dart';
import 'package:entries_api/entries_api.dart';
import 'package:objectbox_entries_api/objectbox_entries_api.dart';

/// {@template objectbox_entries_api}
/// An implementation of the EntriesApi that uses Objectbox persistent library.
/// {@endtemplate}
class ObjectboxEntriesApi extends EntriesApi {
  /// {@macro objectbox_entries_api}
  ObjectboxEntriesApi._create({
    required super.passwordCryptography,
    required this.store,
  });

  /// Initializes the store for the application.
  static Future<ObjectboxEntriesApi> init({
    required String storeDirectory,
    PasswordCryptography? cryptography,
  }) async {
    final store = await openStore(directory: storeDirectory);
    return ObjectboxEntriesApi._create(
      passwordCryptography: cryptography ?? const PasswordCryptography(),
      store: store,
    );
  }

  /// The store for the data.
  late final Store store;

  @override
  Stream<List<Entry>> getEntries(String passkey) async* {
    final queryStream = store.box<EntryDto>().query().watch(
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
  FutureOr<void> saveEntry(Entry entry, String passkey) async {
    return applyEncryption(
      entry: entry,
      passkey: passkey,
      operation: (encrypted) {
        store.box<EntryDto>().putAsync(EntryDto.fromEntry(encrypted));
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
