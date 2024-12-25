import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';
import 'package:onboarding_repository/onboarding_repository.dart';
import 'package:passkey_repository/passkey_repository.dart';
import 'package:passworthy/colors/colors.dart';
import 'package:passworthy/decorators/decorators.dart';
import 'package:passworthy/home/home.dart';
import 'package:passworthy/l10n/l10n.dart';
import 'package:passworthy/passkey/passkey.dart';
import 'package:passworthy/typography/typography.dart';

class FirstTimePasskeyPage extends StatelessWidget {
  const FirstTimePasskeyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PasskeyBloc>(
      create: (context) => PasskeyBloc(
        onboardingRepository: context.read<OnboardingRepository>(),
        passkeyRepository: context.read<PasskeyRepository>(),
      ),
      child: const FirstTimePasskeyView(),
    );
  }
}

/// {@template first_time_passkey_view}
/// Renders the passkey view for the first time users.
/// {@endtemplate}
class FirstTimePasskeyView extends StatelessWidget {
  /// {@macro first_time_passkey_view}
  const FirstTimePasskeyView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return BlocListener<PasskeyBloc, PasskeyState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status.isSuccess) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute<void>(builder: (_) => const HomePage()),
          );
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(),
        body: Column(
          spacing: 16,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _BuildTitleAndCaption(),
            const _PasskeyInputField(),
            const _ConfirmPasskeyInputField(),
            if (size.height < 640) const SizedBox(height: 48),
            if (size.height >= 640) const Spacer(),
            const _PasskeySubmitButton(),
          ],
        ).wrapScrollableConditionally(size.height),
      ),
    );
  }
}

class _BuildTitleAndCaption extends StatelessWidget {
  const _BuildTitleAndCaption();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        Text(
          l10n.firstTimePasskeyTitle,
          style: PassworthyTextStyle.titleText,
        ),
        Text(
          l10n.firstTimePasskeyCaption,
          style: PassworthyTextStyle.captionText,
        ),
      ],
    ).padding(const EdgeInsets.symmetric(horizontal: 24));
  }
}

class _PasskeyInputField extends StatelessWidget {
  const _PasskeyInputField();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final errors = context.select(
      (PasskeyBloc bloc) => bloc.state.passkey.displayError,
    );

    return TextField(
      key: const Key('firstPasskeyView_passkeyInput_textField'),
      obscureText: true,
      onChanged: (value) => context.read<PasskeyBloc>().add(
            PasskeyInputChanged(value),
          ),
      style: PassworthyTextStyle.inputText,
      autofocus: true,
      cursorColor: PassworthyColors.inputCursor,
      decoration: InputDecoration(
        hintText: l10n.passkeyTextFieldHint,
        errorMaxLines: 2,
        errorText: errors == null
            ? null
            : switch (errors.prioritized) {
                PasskeyValidationError.characterLength =>
                  l10n.passkeyCharactersLengthError,
                PasskeyValidationError.missingUppercaseLetter =>
                  l10n.passkeyUppercaseMissingError,
                PasskeyValidationError.missingLowercaseLetter =>
                  l10n.passkeyLowercaseMissingError,
                PasskeyValidationError.missingNumber =>
                  l10n.passkeyNumberMissingError,
                PasskeyValidationError.missingSpecialCharacter =>
                  l10n.passkeySpecialCharacterMissingError('{', '}'),
                _ => l10n.passkeyInvalidError,
              },
      ),
    ).padding(const EdgeInsets.symmetric(horizontal: 24));
  }
}

class _ConfirmPasskeyInputField extends StatelessWidget {
  const _ConfirmPasskeyInputField();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final errors = context.select(
      (PasskeyBloc bloc) => bloc.state.confirmPasskey.displayError,
    );

    return TextField(
      key: const Key('firstPasskeyView_confirmPasskeyInput_textField'),
      onChanged: (value) => context.read<PasskeyBloc>().add(
            ConfirmPasskeyInputChanged(value),
          ),
      style: PassworthyTextStyle.inputText,
      cursorColor: PassworthyColors.inputCursor,
      decoration: InputDecoration(
        hintText: l10n.confirmPasskeyTextFieldHint,
        errorText: errors == null ? null : l10n.confirmPasskeyDoNotMatchError,
      ),
    ).padding(const EdgeInsets.symmetric(horizontal: 24));
  }
}

class _PasskeySubmitButton extends StatelessWidget {
  const _PasskeySubmitButton();

  @override
  Widget build(BuildContext context) {
    final valid = context.select(
      (PasskeyBloc bloc) => bloc.state.isValid,
    );
    final status = context.select(
      (PasskeyBloc bloc) => bloc.state.status,
    );
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 32,
      children: [
        Text.rich(
          TextSpan(
            style: PassworthyTextStyle.disclaimerText,
            text: l10n.appDisclaimerText,
            children: [
              TextSpan(
                text: l10n.appDisclaimerHighlightedText,
                style: PassworthyTextStyle.disclaimerText.copyWith(
                  color: PassworthyColors.disclaimerHighlightText,
                ),
              ),
            ],
          ),
        ),
        ElevatedButton(
          key: const Key('firstPasskeyView_passkeySubmit_elevatedButton'),
          onPressed: valid
              ? () => context.read<PasskeyBloc>().add(
                    const PasskeyInputSubmitted(),
                  )
              : null,
          child: status.isInProgress
              ? const CircularProgressIndicator.adaptive()
              : Text(l10n.passkeySubmitButtonText),
        ),
      ],
    ).padding(const EdgeInsets.fromLTRB(24, 32, 24, 56)).decoratedBox(
          decoration: const BoxDecoration(
            color: PassworthyColors.backgroundLight,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(32),
            ),
          ),
        );
  }
}
