// For testing environment
// ignore_for_file: avoid_redundant_argument_values

import 'package:flutter_test/flutter_test.dart';
import 'package:passworthy/banner/banner.dart';

void main() {
  group('BannerState', () {
    BannerState createSubject({
      bool? showBanner,
    }) {
      return BannerState(
        showBanner: showBanner ?? false,
      );
    }

    test('constructor works correctly', () {
      expect(createSubject, returnsNormally);
    });

    test('props are correct', () {
      expect(createSubject().props, [false]);
    });

    group('copyWith', () {
      test('returns same object when no arguments are passed', () {
        expect(createSubject().copyWith(), equals(createSubject()));
      });

      test('returns object with same value when passed arguments are null', () {
        expect(
          createSubject().copyWith(showBanner: null),
          equals(createSubject()),
        );
      });

      test('returns new object with updated value', () {
        expect(
          createSubject().copyWith(showBanner: true),
          equals(createSubject(showBanner: true)),
        );
      });
    });
  });
}
