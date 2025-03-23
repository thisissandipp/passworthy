// Ignore below specifics for testing environment.
// ignore_for_file: avoid_redundant_argument_values

import 'package:entries_api/entries_api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:objectbox_entries_api/objectbox_entries_api.dart';

void main() {
  group('EntryDto', () {
    EntryDto createSubject({
      int id = 0,
      String uid = 'abcd',
      String platform = 'platform',
      String identity = 'identity',
      String password = 'password',
      DateTime? createdAt,
      DateTime? lastUpdatedAt,
      bool isFavorite = false,
      String additionalNotes = 'notes',
    }) {
      return EntryDto(
        id: id,
        uid: uid,
        platform: platform,
        identity: identity,
        password: password,
        createdAt: createdAt ?? DateTime.now(),
        lastUpdatedAt: lastUpdatedAt ?? DateTime.now(),
        isFavorite: isFavorite,
        additionalNotes: additionalNotes,
      );
    }

    test('constructor works correctly', () {
      expect(createSubject, returnsNormally);
    });

    test('converts to Entry correctly', () {
      expect(
        createSubject(
          createdAt: DateTime(2025),
          lastUpdatedAt: DateTime(2025),
        ).toEntry(),
        Entry(
          id: 'abcd',
          platform: 'platform',
          identity: 'identity',
          password: 'password',
          createdAt: DateTime(2025),
          lastUpdatedAt: DateTime(2025),
          isFavorite: false,
          additionalNotes: 'notes',
        ),
      );
    });

    test('fromEntry factory works correctly', () {
      final time = DateTime(2025);
      expect(
        EntryDto.fromEntry(
          Entry(
            id: 'abcd',
            platform: 'platform',
            identity: 'identity',
            password: 'password',
            createdAt: time,
            lastUpdatedAt: time,
            isFavorite: false,
            additionalNotes: 'notes',
          ),
        ),
        isA<EntryDto>()
            .having((e) => e.uid, 'id matches', equals('abcd'))
            .having((e) => e.platform, 'platform matches', equals('platform'))
            .having((e) => e.identity, 'identity matches', equals('identity'))
            .having((e) => e.password, 'password matches', equals('password'))
            .having((e) => e.createdAt, 'createdAt matches', equals(time))
            .having(
              (e) => e.lastUpdatedAt,
              'lastUpdatedAt matches',
              equals(time),
            )
            .having((e) => e.isFavorite, 'isFavorite matches', isFalse)
            .having(
              (e) => e.additionalNotes,
              'additionalNotes matches',
              equals('notes'),
            ),
      );
    });
  });
}
