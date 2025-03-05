import 'package:flutter_test/flutter_test.dart';
import 'package:passworthy/env/env.dart';

void main() {
  group('ProductionEnv', () {
    test('implements PassworthyEnv and PassworthyEnvFields', () {
      expect(ProductionEnv(), isA<PassworthyEnv>());
      expect(ProductionEnv(), isA<PassworthyEnvFields>());
    });

    test('has kObjectBoxStoreDirectoryPath defined', () {
      final env = ProductionEnv();
      expect(env.kObjectBoxStoreDirectoryPath, isA<String>());
    });

    test('has kPasskeyStorageKey defined', () {
      final env = ProductionEnv();
      expect(env.kPasskeyStorageKey, isA<String>());
    });
  });
}
