import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onboarding_repository/onboarding_repository.dart';
import 'package:passkey_repository/passkey_repository.dart';
import 'package:passworthy/colors/colors.dart';
import 'package:passworthy/l10n/l10n.dart';
import 'package:passworthy/onboarding/onboarding.dart';
import 'package:passworthy/typography/typography.dart';

class App extends StatelessWidget {
  const App({
    required OnboardingRepository onboardingRepository,
    required PasskeyRepository passkeyRepository,
    super.key,
  })  : _onboardingRepository = onboardingRepository,
        _passkeyRepository = passkeyRepository;

  final OnboardingRepository _onboardingRepository;
  final PasskeyRepository _passkeyRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<OnboardingRepository>.value(
          value: _onboardingRepository,
        ),
        RepositoryProvider<PasskeyRepository>.value(
          value: _passkeyRepository,
        ),
      ],
      child: const AppView(),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final appBarTheme = Theme.of(context).appBarTheme;
    final inputDecorationTheme = Theme.of(context).inputDecorationTheme;
    final snackBarTheme = Theme.of(context).snackBarTheme;

    return MaterialApp(
      theme: ThemeData.dark(useMaterial3: false).copyWith(
        scaffoldBackgroundColor: PassworthyColors.backgroundDefault,
        appBarTheme: appBarTheme.copyWith(
          elevation: 0,
          color: PassworthyColors.appBarDefault,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: PassworthyColors.elevatedButtonBackground,
            minimumSize: const Size.fromHeight(56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            textStyle: PassworthyTextStyle.buttonText,
            disabledBackgroundColor:
                PassworthyColors.elevatedButtonBackground.withAlpha(96),
          ),
        ),
        inputDecorationTheme: inputDecorationTheme.copyWith(
          hintStyle: PassworthyTextStyle.inputHintText,
          border: InputBorder.none,
        ),
        snackBarTheme: snackBarTheme.copyWith(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(32),
            ),
          ),
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          backgroundColor: PassworthyColors.backgroundLight,
          contentTextStyle: PassworthyTextStyle.disclaimerText.copyWith(
            color: PassworthyColors.disclaimerHighlightText,
          ),
        ),
        textTheme: GoogleFonts.poppinsTextTheme(textTheme),
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const OnbaordingPage(),
    );
  }
}
