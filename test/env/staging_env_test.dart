import 'package:flutter_test/flutter_test.dart';
import 'package:passworthy/env/env.dart';

void main() {
  group('StagingEnv', () {
    test('implements PassworthyEnv and PassworthyEnvFields', () {
      expect(StagingEnv(), isA<PassworthyEnv>());
      expect(StagingEnv(), isA<PassworthyEnvFields>());
    });

    test('has kObjectBoxStoreDirectoryPath defined', () {
      final env = StagingEnv();
      expect(env.kObjectBoxStoreDirectoryPath, isA<String>());
    });

    test('has kPasskeyStorageKey defined', () {
      final env = StagingEnv();
      expect(env.kPasskeyStorageKey, isA<String>());
    });
  });
}
