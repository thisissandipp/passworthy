// ignore_for_file: prefer_const_constructors
import 'package:cache/cache.dart';
import 'package:test/test.dart';

void main() {
  group('CacheClient', () {
    test('can read and write value for a given key', () {
      final cache = CacheClient();
      const key = '__key__';
      const value = '__value__';

      expect(cache.read<String>(key: key), isNull);
      cache.write<String>(key: key, value: value);
      expect(cache.read<String>(key: key), equals(value));
    });
  });
}
