import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:passworthy/colors/colors.dart';
import 'package:passworthy/decorators/decorators.dart';
import 'package:passworthy/home/home.dart';
import 'package:passworthy/l10n/l10n.dart';
import 'package:passworthy/passkey/passkey.dart';
import 'package:passworthy/typography/typography.dart';

/// {@template existing_passkey_view}
/// Renders the passkey view for the existing users.
/// {@endtemplate}
class ExistingPasskeyView extends StatelessWidget {
  /// {@macro existing_passkey_view}
  const ExistingPasskeyView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<PasskeyBloc, PasskeyState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status.isSuccess) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute<void>(builder: (_) => const HomePage()),
          );
        }

        if (state.status.isFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(
                  context.l10n.wrongPasskeyError,
                  textAlign: TextAlign.center,
                ),
              ),
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
            SizedBox(height: 16),
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
          l10n.existingPasskeyTitle,
          style: PassworthyTextStyle.titleText,
        ),
        Text(
          l10n.existingPasskeyCaption,
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
      key: const Key('existingPasskeyView_passkeyInput_textField'),
      obscureText: true,
      onChanged: (value) => context.read<PasskeyBloc>()
        ..add(PasskeyInputChanged(value))
        ..add(ConfirmPasskeyInputChanged(value)),
      style: PassworthyTextStyle.inputText,
      autofocus: true,
      cursorColor: PassworthyColors.inputCursor,
      decoration: InputDecoration(
        hintText: l10n.passkeyTextFieldHint,
        errorText: errors == null ? null : l10n.existingPasskeyInputError,
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

    return ElevatedButton(
      key: const Key('existingPasskeyView_passkeySubmit_elevatedButton'),
      onPressed: valid
          ? () => context.read<PasskeyBloc>().add(const PasskeyInputSubmitted())
          : null,
      child: status.isInProgress
          ? const CircularProgressIndicator.adaptive()
          : Text(l10n.passkeySubmitButtonText),
    ).padding(const EdgeInsets.symmetric(horizontal: 24));
  }
}
