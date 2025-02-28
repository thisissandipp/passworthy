import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:passworthy/banner/banner.dart';

void main() {
  group('BannerCubit', () {
    blocTest<BannerCubit, BannerState>(
      'emits false when removeBanner is called',
      build: BannerCubit.new,
      act: (bloc) => bloc.removeBanner(),
      expect: () => <BannerState>[
        const BannerState(showBanner: false),
      ],
    );
  });
}
