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
      bool isFavorite = false,
    }) {
      return EntryDto(
        id: id,
        uid: uid,
        platform: platform,
        identity: identity,
        password: password,
        createdAt: createdAt ?? DateTime.now(),
        isFavorite: isFavorite,
      );
    }

    test('constructor works correctly', () {
      expect(createSubject, returnsNormally);
    });

    test('converts to Entry correctly', () {
      expect(
        createSubject(
          createdAt: DateTime(2025),
        ).toEntry(),
        Entry(
          id: 'abcd',
          platform: 'platform',
          identity: 'identity',
          password: 'password',
          createdAt: DateTime(2025),
          isFavorite: false,
        ),
      );
    });

    test('fromEntry factory works correctly', () {
      expect(
        EntryDto.fromEntry(
          Entry(
            id: 'abcd',
            platform: 'platform',
            identity: 'identity',
            password: 'password',
            createdAt: DateTime(2025),
            isFavorite: false,
          ),
        ),
        isA<EntryDto>(),
      );
    });
  });
}
