import 'package:entries_repository/entries_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:passkey_repository/passkey_repository.dart';
import 'package:passworthy/create/create.dart';
import 'package:passworthy/decorators/decorators.dart';
import 'package:passworthy/overview/overview.dart';
import 'package:passworthy/typography/typography.dart';

/// {@template overview_page}
/// Renders the entries list.
/// {@endtemplate}
class OverviewPage extends StatelessWidget {
  const OverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OverviewBloc>(
      create: (context) => OverviewBloc(
        entriesRepository: context.read<EntriesRepository>(),
        passkeyRepository: context.read<PasskeyRepository>(),
      )..add(const OverviewSubscriptionRequested()),
      child: const OverviewView(),
    );
  }
}

class OverviewView extends StatelessWidget {
  const OverviewView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (_) => const CreateEntryPage(),
            fullscreenDialog: true,
          ),
        ),
        child: const Icon(Icons.add),
      ),
      body: BlocBuilder<OverviewBloc, OverviewState>(
        builder: (context, state) {
          if (state.entries.isEmpty) {
            if (state.status == OverviewStatus.loading) {
              return const Center(child: CircularProgressIndicator.adaptive());
            }
            if (state.status != OverviewStatus.success) {
              return const SizedBox();
            }

            return Center(
              child: Text(
                'No Entries',
                style: PassworthyTextStyle.titleText.copyWith(
                  color: PassworthyTextStyle.captionText.color,
                ),
              ).padding(const EdgeInsets.only(bottom: kToolbarHeight * 2)),
            );
          }

          return ListView.builder(
            itemCount: state.entries.length,
            itemBuilder: (context, index) {
              final entry = state.entries[index];
              return Text(
                'Platform: ${entry.platform}, identity: ${entry.identity}, '
                'password: ${entry.password}',
                style: PassworthyTextStyle.disclaimerText,
              ).padding(const EdgeInsets.symmetric(horizontal: 24));
            },
          );
        },
      ),
    );
  }
}
