// ignore_for_file: avoid_redundant_argument_values

import 'package:flutter_test/flutter_test.dart';
import 'package:passworthy/onboarding/onboarding.dart';

void main() {
  group('OnboardingState', () {
    OnboardingState createSubject({bool isFirstTimeUser = true}) {
      return OnboardingState(isFirstTimeUser: isFirstTimeUser);
    }

    test('constructor works correctly', () {
      expect(createSubject, returnsNormally);
    });

    test('supports value equality', () {
      expect(createSubject(), equals(createSubject()));
    });

    test('props are correct', () {
      expect(
        createSubject().props,
        equals(
          <Object?>[
            true, // isFirstTimeUser
          ],
        ),
      );
    });

    group('copyWith', () {
      test('returns same object if no argument is passed', () {
        expect(
          createSubject().copyWith(),
          equals(createSubject()),
        );
      });

      test('returns the old value for each parameter if null is provided', () {
        expect(
          createSubject().copyWith(
            isFirstTimeUser: null,
          ),
          equals(createSubject()),
        );
      });

      test('returns the updated copy of this for every non-null parameter', () {
        expect(
          createSubject().copyWith(
            isFirstTimeUser: false,
          ),
          equals(
            createSubject(
              isFirstTimeUser: false,
            ),
          ),
        );
      });
    });
  });
}
