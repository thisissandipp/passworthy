import 'package:entries_api/entries_api.dart';
import 'package:entries_repository/entries_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:passkey_repository/passkey_repository.dart';
import 'package:passworthy/colors/colors.dart';
import 'package:passworthy/create/create.dart';
import 'package:passworthy/decorators/decorators.dart';
import 'package:passworthy/l10n/l10n.dart';
import 'package:passworthy/typography/typography.dart';

class CreateEntryPage extends StatelessWidget {
  const CreateEntryPage({required this.initialEntry, super.key});
  final Entry? initialEntry;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CreateBloc>(
      create: (context) => CreateBloc(
        entriesRepository: context.read<EntriesRepository>(),
        passkeyRepository: context.read<PasskeyRepository>(),
        initialEntry: initialEntry,
      ),
      child: const CreateEntryView(),
    );
  }
}

class CreateEntryView extends StatelessWidget {
  const CreateEntryView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final initialEntry = context.select(
      (CreateBloc bloc) => bloc.state.initialEntry,
    );
    final dateFormat = DateFormat.yMMMMd('en_US').add_jm();

    return BlocListener<CreateBloc, CreateState>(
      listenWhen: (previous, current) =>
          previous.createStatus != current.createStatus,
      listener: (context, state) {
        if (state.createStatus == CreateEntryStatus.success) {
          Navigator.pop(context);
        }

        if (state.createStatus == CreateEntryStatus.failure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(
                  l10n.unknownErrorMessage,
                  textAlign: TextAlign.center,
                ),
              ),
            );
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 16,
            children: [
              const _BuildTitle(),
              const _PlatformInputField(),
              const _IdentityInputField(),
              const _PasswordInputField(),
              const AdditionalNotesInputField(),
              if (initialEntry != null) ...[
                const SizedBox(height: 8),
                Row(
                  spacing: 8,
                  children: [
                    const Icon(
                      CupertinoIcons.info,
                      size: 18,
                      color: PassworthyColors.lightGrey,
                    ),
                    Text(
                      l10n.createdOn(dateFormat.format(initialEntry.createdAt)),
                      style: PassworthyTextStyle.disclaimerText.copyWith(
                        color: PassworthyColors.lightGrey,
                      ),
                    ),
                  ],
                ).padding(const EdgeInsets.symmetric(horizontal: 24)),
              ],
              const _EntrySubmitted(),
            ],
          ),
        ),
      ),
    );
  }
}

class _BuildTitle extends StatelessWidget {
  const _BuildTitle();

  @override
  Widget build(BuildContext context) {
    final state = context.select((CreateBloc bloc) => bloc.state);
    final l10n = context.l10n;

    return Text(
      state.isNewEntry ? l10n.newEntryPageTitle : l10n.updateEntryPageTitle,
      style: PassworthyTextStyle.titleText,
    ).padding(const EdgeInsets.symmetric(horizontal: 24));
  }
}

class _PlatformInputField extends StatelessWidget {
  const _PlatformInputField();

  @override
  Widget build(BuildContext context) {
    final state = context.select((CreateBloc bloc) => bloc.state);
    final l10n = context.l10n;

    return TextFormField(
      key: const Key('createEntryView_platformInput_textField'),
      initialValue: state.platform.value,
      onChanged: (value) => context.read<CreateBloc>().add(
            PlatformInputChanged(value),
          ),
      style: PassworthyTextStyle.inputText,
      cursorColor: PassworthyColors.mediumIndigo,
      decoration: InputDecoration(
        hintText: l10n.platformInputHintText,
        helperText: l10n.platformInputHelperText,
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: PassworthyColors.lightGrey,
          ),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: PassworthyColors.lightGrey,
          ),
        ),
      ),
    ).padding(const EdgeInsets.symmetric(horizontal: 24));
  }
}

class _IdentityInputField extends StatelessWidget {
  const _IdentityInputField();

  @override
  Widget build(BuildContext context) {
    final state = context.select((CreateBloc bloc) => bloc.state);
    final l10n = context.l10n;

    return TextFormField(
      key: const Key('createEntryView_identityInput_textField'),
      initialValue: state.identity.value,
      onChanged: (value) => context.read<CreateBloc>().add(
            IdentityInputChanged(value),
          ),
      style: PassworthyTextStyle.inputText,
      cursorColor: PassworthyColors.mediumIndigo,
      decoration: InputDecoration(
        hintText: l10n.identityInputHintText,
        helperText: l10n.identityInputHelperText,
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: PassworthyColors.lightGrey,
          ),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: PassworthyColors.lightGrey,
          ),
        ),
      ),
    ).padding(const EdgeInsets.symmetric(horizontal: 24));
  }
}

class _PasswordInputField extends StatelessWidget {
  const _PasswordInputField();

  @override
  Widget build(BuildContext context) {
    final state = context.select((CreateBloc bloc) => bloc.state);
    final l10n = context.l10n;

    return TextFormField(
      key: const Key('createEntryView_passwordInput_textField'),
      initialValue: state.password.value,
      onChanged: (value) => context.read<CreateBloc>().add(
            PasswordInputChanged(value),
          ),
      style: PassworthyTextStyle.inputText,
      cursorColor: PassworthyColors.mediumIndigo,
      decoration: InputDecoration(
        hintText: l10n.passwordInputHintText,
        helperText: l10n.passwordInputHelperText,
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: PassworthyColors.lightGrey,
          ),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: PassworthyColors.lightGrey,
          ),
        ),
      ),
    ).padding(const EdgeInsets.symmetric(horizontal: 24));
  }
}

class AdditionalNotesInputField extends StatelessWidget {
  const AdditionalNotesInputField({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.select((CreateBloc bloc) => bloc.state);
    final l10n = context.l10n;
    return TextFormField(
      key: const Key('createEntryView_additionalNotes_textField'),
      initialValue: state.additionalNotes,
      onChanged: (value) => context.read<CreateBloc>().add(
            AdditionalNotesChanged(value),
          ),
      style: PassworthyTextStyle.inputText,
      cursorColor: PassworthyColors.mediumIndigo,
      keyboardType: TextInputType.multiline,
      maxLines: 3,
      decoration: InputDecoration(
        hintText: l10n.additionalNotesHintText,
        helperText: l10n.additionaNotesHelperText,
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: PassworthyColors.lightGrey,
          ),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: PassworthyColors.lightGrey,
          ),
        ),
      ),
    ).padding(const EdgeInsets.symmetric(horizontal: 24));
  }
}

class _EntrySubmitted extends StatelessWidget {
  const _EntrySubmitted();

  @override
  Widget build(BuildContext context) {
    final state = context.select((CreateBloc bloc) => bloc.state);
    final l10n = context.l10n;

    return ElevatedButton(
      key: const Key('createEntryView_entrySubmit_elevatedButton'),
      onPressed: state.isFormValid
          ? () => context.read<CreateBloc>().add(const EntrySubmitted())
          : null,
      child: state.createStatus.isLoadingOrSuccess
          ? const CircularProgressIndicator.adaptive()
          : Text(
              state.isNewEntry
                  ? l10n.addEntryButtonText
                  : l10n.updateEntryButtonText,
            ),
    ).padding(const EdgeInsets.fromLTRB(24, 32, 24, 56));
  }
}
