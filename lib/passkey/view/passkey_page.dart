import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:passkey_repository/passkey_repository.dart';
import 'package:passworthy/passkey/passkey.dart';

/// {@template passkey_page}
/// Sets provider for [PasskeyBloc], and renders passkey page.
/// {@endtemplate}
class PasskeyPage extends StatelessWidget {
  /// {@macro passkey_page}
  const PasskeyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PasskeyBloc>(
      create: (context) => PasskeyBloc(
        passkeyRepository: context.read<PasskeyRepository>(),
      )..add(const FirstTimeUserCheckRequested()),
      child: const PasskeyView(),
    );
  }
}

/// {@template passkey_view}
/// View that decides which subsequent view to render.
/// 
/// - For first time users, it renders [FirstTimePasskeyView].
/// - For existing users, it renders [ExistingPasskeyView].
/// {@endtemplate}
class PasskeyView extends StatelessWidget {
  /// {@macro passkey_view}
  const PasskeyView({super.key});

  @override
  Widget build(BuildContext context) {
    final firstTimeUser = context.select(
      (PasskeyBloc bloc) => bloc.state.isFirstTimeUser,
    );

    if (firstTimeUser) return const FirstTimePasskeyView();
    return const ExistingPasskeyView();
  }
}
