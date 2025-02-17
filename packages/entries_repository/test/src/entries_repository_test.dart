// Ignore below specifics for testing environment.
// ignore_for_file: prefer_const_constructors
import 'package:entries_api/entries_api.dart';
import 'package:entries_repository/entries_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockEntriesApi extends Mock implements EntriesApi {}

class MockEntry extends Mock implements Entry {}

void main() {
  group('EntriesRepository', () {
    late Entry entry;
    late EntriesApi entriesApi;
    late EntriesRepository entriesRepository;

    setUp(() {
      entry = MockEntry();
      entriesApi = MockEntriesApi();
      entriesRepository = EntriesRepository(entriesApi: entriesApi);

      when(() => entry.id).thenReturn('id');

      when(() => entriesApi.getEntries(any())).thenAnswer(
        (_) => Stream.value([entry]),
      );
      when(() => entriesApi.getEntriesWithFilter(any(), any())).thenAnswer(
        (_) => Stream.value([entry]),
      );
    });

    test('can be instantiated', () {
      expect(EntriesRepository(entriesApi: entriesApi), isNotNull);
    });

    test('getEntries makes correct api call', () {
      entriesRepository.getEntries(passkey: 'passkey');
      verify(() => entriesApi.getEntries('passkey')).called(1);
    });

    test('getEntriesWithFilter makes correct api call', () {
      entriesRepository.getEntriesWithFilter(
        passkey: 'passkey',
        searchText: 'search',
      );
      verify(
        () => entriesApi.getEntriesWithFilter('passkey', 'search'),
      ).called(1);
    });

    test('saveEntry makes correct api call', () {
      entriesRepository.saveEntry(entry: entry, passkey: 'passkey');
      verify(() => entriesApi.saveEntry(entry, 'passkey')).called(1);
    });

    test('deleteEntry makes correct api call', () {
      entriesRepository.deleteEntry(entry: entry);
      verify(() => entriesApi.deleteEntry('id')).called(1);
    });
  });
}
