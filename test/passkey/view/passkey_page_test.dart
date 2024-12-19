// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:passkey_repository/passkey_repository.dart';
import 'package:passworthy/passkey/passkey.dart';

import '../../helpers/helpers.dart';

void main() {
  group('PasskeyPage', () {
    late PasskeyRepository passkeyRepository;

    setUp(() {
      passkeyRepository = MockPasskeyRepository();
      when(() => passkeyRepository.isFirstTimeUser()).thenAnswer(
        (_) async => true,
      );
    });

    testWidgets('renders [PaskeyView]', (tester) async {
      await tester.pumpApp(PasskeyPage(), passkeyRepository: passkeyRepository);
      expect(find.byType(PasskeyView), findsOneWidget);
    });

    testWidgets(
      'renders [FirstTimePasskeyView] for first time users',
      (tester) async {
        await tester.pumpApp(
          PasskeyPage(),
          passkeyRepository: passkeyRepository,
        );
        expect(find.byType(FirstTimePasskeyView), findsOneWidget);
      },
    );

    testWidgets(
      'renders [ExistingPasskeyView] for existing users',
      (tester) async {
        when(() => passkeyRepository.isFirstTimeUser()).thenAnswer(
          (_) async => Future.value(false),
        );

        await tester.pumpApp(
          PasskeyPage(),
          passkeyRepository: passkeyRepository,
        );
        await tester.pumpAndSettle();
        expect(find.byType(ExistingPasskeyView), findsOneWidget);
      },
    );
  });
}
