// Ignore below specifics for testing environment.
// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:passworthy/onboarding/onboarding.dart';

void main() {
  group('OnboardingEvent', () {
    group('CheckFirstTimeUserRequested', () {
      test('supports value equality', () {
        expect(
          CheckFirstTimeUserRequested(),
          equals(CheckFirstTimeUserRequested()),
        );
      });

      test('props are correct', () {
        expect(
          CheckFirstTimeUserRequested().props,
          equals(<Object>[]),
        );
      });
    });
  });
}
