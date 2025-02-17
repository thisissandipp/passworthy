// Ignore below specifics for testing environment.
// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:onboarding_repository/onboarding_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  group('OnboardingRepository', () {
    late SharedPreferences plugin;
    late OnboardingRepository onboardingRepository;

    setUp(() {
      plugin = MockSharedPreferences();
      onboardingRepository = OnboardingRepository(plugin: plugin);
    });

    group('isFirstTimeUser', () {
      test('returns true when the user is new', () async {
        final result = onboardingRepository.isFirstTimeUser();
        expect(result, isTrue);

        verify(
          () => plugin.getBool(OnboardingRepository.kFirstTimeUserKey),
        ).called(1);
      });

      test('returns false when the user is existing user', () async {
        when(() => plugin.getBool(any())).thenReturn(false);
        final result = onboardingRepository.isFirstTimeUser();
        expect(result, isFalse);

        verify(
          () => plugin.getBool(OnboardingRepository.kFirstTimeUserKey),
        ).called(1);
      });
    });

    group('setOnboarded', () {
      test('sets the bool value correctly', () async {
        when(() => plugin.setBool(any(), any())).thenAnswer((_) async => true);

        final onboarded = await onboardingRepository.setOnboarded();
        expect(onboarded, isTrue);

        verify(
          () => plugin.setBool(OnboardingRepository.kFirstTimeUserKey, false),
        ).called(1);
      });
    });
  });
}
