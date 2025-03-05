import 'package:flutter_test/flutter_test.dart';
import 'package:passworthy/env/env.dart';

class TestEnv implements PassworthyEnvFields {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  group('PassworthyEnvFields', () {
    test('can be constructed', () {
      expect(TestEnv.new, returnsNormally);
    });
  });
}
