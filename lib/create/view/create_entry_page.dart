import 'package:entries_api/entries_api.dart';
import 'package:entries_repository/entries_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:passkey_repository/passkey_repository.dart';
import 'package:passworthy/colors/colors.dart';
import 'package:passworthy/create/create.dart';
import 'package:passworthy/decorators/decorators.dart';
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
    final size = MediaQuery.of(context).size;
    return BlocListener<CreateBloc, CreateState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == CreateEntryStatus.success) {
          Navigator.pop(context);
        }

        if (state.status == CreateEntryStatus.failure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(
                content: Text(
                  'Something went wrong!',
                  textAlign: TextAlign.center,
                ),
              ),
            );
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16,
          children: [
            const _BuildTitle(),
            const _PlatformInputField(),
            const _IdentityInputField(),
            const _PasswordInputField(),
            if (size.height < 640) const SizedBox(height: 48),
            if (size.height >= 640) const Spacer(),
            const _EntrySubmitted(),
          ],
        ).wrapScrollableConditionally(size.height),
      ),
    );
  }
}

class _BuildTitle extends StatelessWidget {
  const _BuildTitle();

  @override
  Widget build(BuildContext context) {
    final state = context.select((CreateBloc bloc) => bloc.state);
    return Text(
      state.isNewEntry ? 'new entry' : 'update entry',
      style: PassworthyTextStyle.titleText,
    ).padding(const EdgeInsets.symmetric(horizontal: 24));
  }
}

class _PlatformInputField extends StatelessWidget {
  const _PlatformInputField();

  @override
  Widget build(BuildContext context) {
    final state = context.select((CreateBloc bloc) => bloc.state);

    return TextFormField(
      key: const Key('createEntryView_platformInput_textField'),
      initialValue: state.platform,
      onChanged: (value) => context.read<CreateBloc>().add(
            PlatformInputChanged(value),
          ),
      style: PassworthyTextStyle.inputText,
      cursorColor: PassworthyColors.inputCursor,
      decoration: const InputDecoration(
        hintText: 'which platform?',
        helperText: 'example - google account, netflix, zomato',
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: PassworthyColors.inputHintText,
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: PassworthyColors.inputHintText,
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

    return TextFormField(
      key: const Key('createEntryView_identityInput_textField'),
      initialValue: state.identity,
      onChanged: (value) => context.read<CreateBloc>().add(
            IdentityInputChanged(value),
          ),
      style: PassworthyTextStyle.inputText,
      cursorColor: PassworthyColors.inputCursor,
      decoration: const InputDecoration(
        hintText: 'account identity',
        helperText: 'could be your email, username, phone',
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: PassworthyColors.inputHintText,
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: PassworthyColors.inputHintText,
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

    return TextFormField(
      key: const Key('createEntryView_passwordInput_textField'),
      initialValue: state.password,
      onChanged: (value) => context.read<CreateBloc>().add(
            PasswordInputChanged(value),
          ),
      style: PassworthyTextStyle.inputText,
      cursorColor: PassworthyColors.inputCursor,
      decoration: const InputDecoration(
        hintText: 'your password',
        helperText: 'you know what to do',
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: PassworthyColors.inputHintText,
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: PassworthyColors.inputHintText,
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
    final status = context.select(
      (CreateBloc bloc) => bloc.state.status,
    );
    final state = context.select((CreateBloc bloc) => bloc.state);
    return ElevatedButton(
      key: const Key('createEntryView_entrySubmit_elevatedButton'),
      onPressed: () => context.read<CreateBloc>().add(const EntrySubmitted()),
      child: status.isLoadingOrSuccess
          ? const CircularProgressIndicator.adaptive()
          : Text(state.isNewEntry ? 'Add now' : 'Update it'),
    ).padding(const EdgeInsets.fromLTRB(24, 32, 24, 56));
  }
}
