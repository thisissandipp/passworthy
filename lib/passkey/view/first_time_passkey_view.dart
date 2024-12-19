import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:passworthy/colors/colors.dart';
import 'package:passworthy/decorators/decorators.dart';
import 'package:passworthy/home/home.dart';
import 'package:passworthy/l10n/l10n.dart';
import 'package:passworthy/passkey/passkey.dart';
import 'package:passworthy/typography/typography.dart';

/// {@template first_time_passkey_view}
/// Renders the passkey view for the first time users.
/// {@endtemplate}
class FirstTimePasskeyView extends StatelessWidget {
  /// {@macro first_time_passkey_view}
  const FirstTimePasskeyView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<PasskeyBloc, PasskeyState>(
      listenWhen: (prev, curr) => prev.isVerified != curr.isVerified,
      listener: (context, state) {
        if (state.isVerified) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute<void>(builder: (_) => const HomePage()),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(),
        body: const Column(
          spacing: 16,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _BuildTitleAndCaption(),
            _PasskeyInputField(),
            _ConfirmPasskeyInputField(),
            Spacer(),
            _PasskeySubmitButton(),
          ],
        ),
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
      ),
    ).padding(const EdgeInsets.symmetric(horizontal: 24));
  }
}

class _ConfirmPasskeyInputField extends StatelessWidget {
  const _ConfirmPasskeyInputField();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return TextField(
      key: const Key('firstPasskeyView_confirmPasskeyInput_textField'),
      onChanged: (value) => context.read<PasskeyBloc>().add(
            ConfirmPasskeyInputChanged(value),
          ),
      style: PassworthyTextStyle.inputText,
      cursorColor: PassworthyColors.inputCursor,
      decoration: InputDecoration(
        hintText: l10n.confirmPasskeyTextFieldHint,
      ),
    ).padding(const EdgeInsets.symmetric(horizontal: 24));
  }
}

class _PasskeySubmitButton extends StatelessWidget {
  const _PasskeySubmitButton();

  @override
  Widget build(BuildContext context) {
    final valid = context.select(
      (PasskeyBloc bloc) => bloc.state.errorMessage.isEmpty,
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
          onPressed: () => valid
              ? context.read<PasskeyBloc>().add(const PasskeyInputSubmitted())
              : null,
          child: Text(l10n.passkeySubmitButtonText),
        ),
      ],
    )
        .decoratedBox(
          decoration: const BoxDecoration(
            color: PassworthyColors.backgroundLight,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(32),
            ),
          ),
        )
        .padding(const EdgeInsets.fromLTRB(24, 32, 24, 56));
  }
}
