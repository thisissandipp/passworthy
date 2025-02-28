import 'package:entries_repository/entries_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:onboarding_repository/onboarding_repository.dart';
import 'package:passkey_repository/passkey_repository.dart';
import 'package:passworthy/banner/banner.dart';
import 'package:passworthy/l10n/l10n.dart';
import 'package:passworthy/onboarding/onboarding.dart';
import 'package:passworthy/passkey/passkey.dart';

import 'helpers.dart';

extension PumpApp on WidgetTester {
  Future<void> pumpApp(
    Widget widget, {
    OnboardingRepository? onboardingRepository,
    PasskeyRepository? passkeyRepository,
    EntriesRepository? entriesRepository,
    OnboardingBloc? onboardingBloc,
    PasskeyBloc? passkeyBloc,
    BannerCubit? bannerCubit,
  }) {
    return pumpWidget(
      MultiRepositoryProvider(
        providers: [
          RepositoryProvider<OnboardingRepository>.value(
            value: onboardingRepository ?? MockOnboardingRepository(),
          ),
          RepositoryProvider<PasskeyRepository>.value(
            value: passkeyRepository ?? MockPasskeyRepository(),
          ),
          RepositoryProvider<EntriesRepository>.value(
            value: entriesRepository ?? MockEntriesRepository(),
          ),
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider<OnboardingBloc>.value(
              value: onboardingBloc ?? MockOnboardingBloc(),
            ),
            BlocProvider<PasskeyBloc>.value(
              value: passkeyBloc ?? MockPasskeyBloc(),
            ),
            BlocProvider<BannerCubit>.value(
              value: bannerCubit ?? MockBannerCubit(),
            ),
          ],
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: widget,
          ),
        ),
      ),
    );
  }
}
