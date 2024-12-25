// ignore_for_file: prefer_const_constructors

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:onboarding_repository/onboarding_repository.dart';
import 'package:passworthy/onboarding/onboarding.dart';
import 'package:passworthy/passkey/passkey.dart';

import '../../helpers/helpers.dart';

void main() {
  group('OnboardingPage', () {
    late OnboardingRepository onboardingRepository;

    setUp(() {
      onboardingRepository = MockOnboardingRepository();
      when(() => onboardingRepository.isFirstTimeUser()).thenReturn(true);
    });

    testWidgets('renders correctly', (tester) async {
      await tester.pumpApp(
        OnbaordingPage(),
        onboardingRepository: onboardingRepository,
      );
      expect(find.byType(OnboardingDecisionView), findsOneWidget);
    });
  });

  group('OnboardingDecisionView', () {
    late OnboardingBloc onboardingBloc;

    setUp(() {
      onboardingBloc = MockOnboardingBloc();
      when(() => onboardingBloc.state).thenReturn(OnboardingState());
    });

    testWidgets('renders [OnboardingView] for new users', (tester) async {
      await tester.pumpApp(
        OnboardingDecisionView(),
        onboardingBloc: onboardingBloc,
      );
      expect(find.byType(OnboardingView), findsOneWidget);
    });

    testWidgets('renders [ExistingPasskeyView] for old users', (tester) async {
      when(() => onboardingBloc.state).thenReturn(
        OnboardingState(isFirstTimeUser: false),
      );
      await tester.pumpApp(
        OnboardingDecisionView(),
        onboardingBloc: onboardingBloc,
      );
      expect(find.byType(ExistingPasskeyPage), findsOneWidget);
    });
  });

  group('OnboardingView', () {
    testWidgets('navigates to [FirstTimePasskeyPage]', (tester) async {
      await tester.pumpApp(OnboardingView());
      const buttonKey = Key('onboardingView_continue_elevatedButton');

      await tester.tap(find.byKey(buttonKey));
      await tester.pumpAndSettle();

      expect(find.byType(FirstTimePasskeyPage), findsOneWidget);
    });
  });
}
