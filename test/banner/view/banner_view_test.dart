import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:passworthy/banner/banner.dart';

import '../../helpers/helpers.dart';

void main() {
  group('BannerView', () {
    late BannerCubit bannerCubit;
    const bannerKey = Key('bannerView_bannerWidget_row');

    setUp(() {
      bannerCubit = MockBannerCubit();
      when(() => bannerCubit.state).thenReturn(
        const BannerState(),
      );
    });

    testWidgets('renders [BannerWidget]', (tester) async {
      await tester.pumpApp(const BannerView());
      expect(find.byType(BannerWidget), findsOneWidget);
    });

    testWidgets('renders the banner', (tester) async {
      await tester.pumpApp(const BannerView(), bannerCubit: bannerCubit);
      expect(find.byKey(bannerKey), findsOneWidget);
    });

    testWidgets(
      "doesn't render the banner after tapping close",
      (tester) async {
        await tester.pumpApp(const BannerView(), bannerCubit: bannerCubit);
        await tester.tap(find.byType(Icon));

        await tester.pumpAndSettle();
        expect(find.byKey(bannerKey), findsNothing);
      },
    );

    testWidgets(
      'calls the removeBanner from cubit on icon pressed',
      (tester) async {
        await tester.pumpApp(const BannerWidget(), bannerCubit: bannerCubit);
        await tester.tap(find.byType(Icon));
        verify(() => bannerCubit.removeBanner()).called(1);
      },
    );
  });
}
