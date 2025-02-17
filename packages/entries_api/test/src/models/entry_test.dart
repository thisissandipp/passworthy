// Ignore below specifics for testing environment.
// ignore_for_file: avoid_redundant_argument_values
import 'package:entries_api/entries_api.dart';
import 'package:test/test.dart';
import 'package:uuid/uuid.dart';

void main() {
  group('Entry', () {
    const defaultId = '32b2ea3c-275b-4cde-876d-ecb3ef947920';
    final defaultCreatedAt = DateTime.parse('2012-02-27T14+00:00');

    Entry createSubject({
      String? id = defaultId,
      String platform = 'Amazon',
      String identity = 'test@test.com',
      String password = 'test',
      DateTime? createdAt,
      bool isFavorite = false,
    }) {
      return Entry(
        id: id,
        platform: platform,
        identity: identity,
        password: password,
        createdAt: createdAt ?? defaultCreatedAt,
        isFavorite: isFavorite,
      );
    }

    group('constructor', () {
      test('works correctly', () {
        expect(createSubject, returnsNormally);
      });

      test('throws AssertionError when id is empty', () {
        expect(
          () => createSubject(id: ''),
          throwsA(isA<AssertionError>()),
        );
      });

      test('sets an id (UUID) if not provided', () {
        final entry = createSubject(id: null);
        expect(entry.id, isNotEmpty);
        expect(Uuid.isValidUUID(fromString: entry.id), isTrue);
      });
    });

    test('supports value equality', () {
      expect(
        createSubject(),
        equals(createSubject()),
      );
    });

    test('props are correct', () {
      expect(
        createSubject().props,
        equals([
          defaultId, // id
          'Amazon', // platform
          'test@test.com', // identifier
          'test', // password
          defaultCreatedAt, // createdAt
          false, // isFavorite
        ]),
      );
    });

    group('copyWith', () {
      test('returns the same object if no arguments are provided', () {
        expect(
          createSubject().copyWith(),
          equals(createSubject()),
        );
      });

      test('returns old value for each parameter if null is provided', () {
        expect(
          createSubject().copyWith(
            id: null,
            platform: null,
            identity: null,
            password: null,
            createdAt: null,
            isFavorite: null,
          ),
          equals(createSubject()),
        );
      });

      test('replaces every non-null parameter', () {
        const newId = '543f5820-fa5e-4a59-9572-776d3404d156';
        final newCreatedAt = DateTime.parse('2024-05-12T07+00:00');

        expect(
          createSubject().copyWith(
            id: newId,
            platform: 'Google account',
            identity: 'test@gmail.com',
            password: 'testgmail',
            createdAt: newCreatedAt,
            isFavorite: true,
          ),
          equals(
            createSubject(
              id: newId,
              platform: 'Google account',
              identity: 'test@gmail.com',
              password: 'testgmail',
              createdAt: newCreatedAt,
              isFavorite: true,
            ),
          ),
        );
      });
    });
  });
}
