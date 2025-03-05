import 'package:flutter_test/flutter_test.dart';
import 'package:passworthy/env/env.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PassworthyEnv', () {
    test('implements PassworthyEnvFields', () {
      expect(PassworthyEnv(), isA<PassworthyEnvFields>());
    });

    group('returns an instance of', () {
      test('DevelopmentEnv when appFlavor is development', () {
        PassworthyEnv.passworthyAppFlavor = 'development';
        expect(PassworthyEnv(), isA<DevelopmentEnv>());
      });

      test('StagingEnv when appFlavor is staging', () {
        PassworthyEnv.passworthyAppFlavor = 'staging';
        expect(PassworthyEnv(), isA<StagingEnv>());
      });

      test('ProductionEnv when appFlavor is production', () {
        PassworthyEnv.passworthyAppFlavor = 'production';
        expect(PassworthyEnv(), isA<ProductionEnv>());
      });
    });
  });
}
