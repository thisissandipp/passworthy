import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:onboarding_repository/onboarding_repository.dart';
import 'package:passkey_repository/passkey_repository.dart';
import 'package:passworthy/l10n/l10n.dart';
import 'package:passworthy/passkey/passkey.dart';

import 'helpers.dart';

extension PumpApp on WidgetTester {
  Future<void> pumpApp(
    Widget widget, {
    OnboardingRepository? onboardingRepository,
    PasskeyRepository? passkeyRepository,
    PasskeyBloc? passkeyBloc,
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
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider<PasskeyBloc>.value(
              value: passkeyBloc ?? MockPasskeyBloc(),
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
