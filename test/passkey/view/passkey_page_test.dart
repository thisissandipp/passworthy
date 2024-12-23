// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:onboarding_repository/onboarding_repository.dart';
import 'package:passworthy/passkey/passkey.dart';

import '../../helpers/helpers.dart';

void main() {
  group('PasskeyPage', () {
    late OnboardingRepository onboardingRepository;

    setUp(() {
      onboardingRepository = MockOnboardingRepository();
      when(() => onboardingRepository.isFirstTimeUser()).thenReturn(true);
    });

    testWidgets('renders [PaskeyView]', (tester) async {
      await tester.pumpApp(
        PasskeyPage(),
        onboardingRepository: onboardingRepository,
      );
      expect(find.byType(PasskeyView), findsOneWidget);
    });

    testWidgets(
      'renders [FirstTimePasskeyView] for first time users',
      (tester) async {
        await tester.pumpApp(
          PasskeyPage(),
          onboardingRepository: onboardingRepository,
        );
        expect(find.byType(FirstTimePasskeyView), findsOneWidget);
      },
    );

    testWidgets(
      'renders [ExistingPasskeyView] for existing users',
      (tester) async {
        when(() => onboardingRepository.isFirstTimeUser()).thenReturn(false);

        await tester.pumpApp(
          PasskeyPage(),
          onboardingRepository: onboardingRepository,
        );
        await tester.pumpAndSettle();
        expect(find.byType(ExistingPasskeyView), findsOneWidget);
      },
    );
  });
}
