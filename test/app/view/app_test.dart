import 'package:entries_repository/entries_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:onboarding_repository/onboarding_repository.dart';
import 'package:passkey_repository/passkey_repository.dart';
import 'package:passworthy/app/app.dart';
import 'package:passworthy/onboarding/onboarding.dart';

import '../../helpers/helpers.dart';

void main() {
  group('App', () {
    late OnboardingRepository onboardingRepository;
    late PasskeyRepository passkeyRepository;
    late EntriesRepository entriesRepository;

    setUp(() {
      onboardingRepository = MockOnboardingRepository();
      passkeyRepository = MockPasskeyRepository();
      entriesRepository = MockEntriesRepository();
      when(() => onboardingRepository.isFirstTimeUser()).thenReturn(true);
    });

    testWidgets('renders PasskeyPage', (tester) async {
      await tester.pumpApp(
        App(
          onboardingRepository: onboardingRepository,
          passkeyRepository: passkeyRepository,
          entriesRepository: entriesRepository,
        ),
      );
      expect(find.byType(OnbaordingPage), findsOneWidget);
    });
  });
}
