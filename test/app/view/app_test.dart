import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:passkey_repository/passkey_repository.dart';
import 'package:passworthy/app/app.dart';
import 'package:passworthy/passkey/passkey.dart';

import '../../helpers/helpers.dart';

void main() {
  group('App', () {
    late PasskeyRepository passkeyRepository;

    setUp(() {
      passkeyRepository = MockPasskeyRepository();
      when(() => passkeyRepository.isFirstTimeUser()).thenAnswer(
        (_) async => true,
      );
    });

    testWidgets('renders CounterPage', (tester) async {
      await tester.pumpApp(App(passkeyRepository: passkeyRepository));
      expect(find.byType(PasskeyPage), findsOneWidget);
    });
  });
}
