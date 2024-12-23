import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:onboarding_repository/onboarding_repository.dart';
import 'package:passkey_repository/passkey_repository.dart';
import 'package:passworthy/app/app.dart';
import 'package:passworthy/passkey/passkey.dart';

import '../../helpers/helpers.dart';

void main() {
  group('App', () {
    late OnboardingRepository onboardingRepository;
    late PasskeyRepository passkeyRepository;

    setUp(() {
      onboardingRepository = MockOnboardingRepository();
      passkeyRepository = MockPasskeyRepository();
      when(() => onboardingRepository.isFirstTimeUser()).thenReturn(true);
    });

    testWidgets('renders PasskeyPage', (tester) async {
      await tester.pumpApp(
        App(
          onboardingRepository: onboardingRepository,
          passkeyRepository: passkeyRepository,
        ),
      );
      expect(find.byType(PasskeyPage), findsOneWidget);
    });
  });
}
