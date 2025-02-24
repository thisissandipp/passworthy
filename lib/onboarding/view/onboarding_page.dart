import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onboarding_repository/onboarding_repository.dart';
import 'package:passworthy/colors/colors.dart';
import 'package:passworthy/decorators/decorators.dart';
import 'package:passworthy/l10n/l10n.dart';
import 'package:passworthy/onboarding/onboarding.dart';
import 'package:passworthy/passkey/passkey.dart';
import 'package:passworthy/typography/typography.dart';

class OnbaordingPage extends StatelessWidget {
  const OnbaordingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OnboardingBloc>(
      create: (context) => OnboardingBloc(
        onboardingRepository: context.read<OnboardingRepository>(),
      )..add(const CheckFirstTimeUserRequested()),
      child: const OnboardingDecisionView(),
    );
  }
}

class OnboardingDecisionView extends StatelessWidget {
  const OnboardingDecisionView({super.key});

  @override
  Widget build(BuildContext context) {
    final isFirstTimeUser = context.select(
      (OnboardingBloc bloc) => bloc.state.isFirstTimeUser,
    );

    if (!isFirstTimeUser) return const ExistingPasskeyPage();
    return const OnboardingView();
  }
}

class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final l10n = context.l10n;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Passworthy',
            style: PassworthyTextStyle.titleText.copyWith(
              fontSize: 28,
            ),
          ).padding(
            const EdgeInsets.symmetric(horizontal: 24),
          ),
          if (size.height < 640) const SizedBox(height: 48),
          if (size.height >= 640) const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 32,
            children: [
              Text(
                'secure all of your\npasswords. simplify your life.',
                style: PassworthyTextStyle.titleText.copyWith(
                  fontSize: 16,
                  height: 1.84,
                ),
              ),
              ElevatedButton(
                key: const Key('onboardingView_continue_elevatedButton'),
                onPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) => const FirstTimePasskeyPage(),
                  ),
                ),
                child: Text(l10n.passkeySubmitButtonText),
              ),
            ],
          ).padding(const EdgeInsets.fromLTRB(24, 32, 24, 56)).decoratedBox(
                decoration: const BoxDecoration(
                  color: PassworthyColors.slateGrey,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                  ),
                ),
              ),
        ],
      ).wrapScrollableConditionally(size.height),
    );
  }
}
