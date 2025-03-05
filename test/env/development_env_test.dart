import 'package:flutter_test/flutter_test.dart';
import 'package:passworthy/env/env.dart';

void main() {
  group('DevelopmentEnv', () {
    test('implements PassworthyEnv and PassworthyEnvFields', () {
      expect(DevelopmentEnv(), isA<PassworthyEnv>());
      expect(DevelopmentEnv(), isA<PassworthyEnvFields>());
    });

    test('has kObjectBoxStoreDirectoryPath defined', () {
      final env = DevelopmentEnv();
      expect(env.kObjectBoxStoreDirectoryPath, isA<String>());
    });

    test('has kPasskeyStorageKey defined', () {
      final env = DevelopmentEnv();
      expect(env.kPasskeyStorageKey, isA<String>());
    });
  });
}
