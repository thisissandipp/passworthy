import 'package:entries_api/entries_api.dart';
import 'package:entries_repository/entries_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:passkey_repository/passkey_repository.dart';
import 'package:passworthy/colors/colors.dart';
import 'package:passworthy/create/create.dart';
import 'package:passworthy/decorators/decorators.dart';
import 'package:passworthy/l10n/l10n.dart';
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
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.overviewPageAppBarTitle),
        centerTitle: false,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (_) => const CreateEntryPage(initialEntry: null),
            fullscreenDialog: true,
          ),
        ),
        child: const Icon(Icons.add),
      ),
      body: const Column(
        children: [
          _SearchEntryInput(),
          Expanded(
            child: _EntriesListViewBuilder(),
          ),
        ],
      ),
    );
  }
}

class _SearchEntryInput extends StatelessWidget {
  const _SearchEntryInput();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return TextFormField(
      style: PassworthyTextStyle.inputText.copyWith(
        fontSize: 14,
      ),
      cursorColor: PassworthyColors.inputCursor,
      onChanged: (value) => context.read<OverviewBloc>().add(
            OverviewSearchInputChanged(value),
          ),
      decoration: InputDecoration(
        hintText: l10n.searchEntryHintText,
        icon: const Icon(
          Icons.search,
          color: PassworthyColors.disclaimerText,
        ).padding(
          const EdgeInsets.only(left: 16),
        ),
      ),
    )
        .decoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: PassworthyColors.backgroundLight,
          ),
        )
        .padding(const EdgeInsets.symmetric(horizontal: 16, vertical: 4));
  }
}

class _EntriesListViewBuilder extends StatelessWidget {
  const _EntriesListViewBuilder();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<OverviewBloc, OverviewState>(
      buildWhen: (previous, current) => previous.entries != current.entries,
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
              l10n.noEntriesText,
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
            return GestureDetector(
              onTap: () => showModalBottomSheet<void>(
                context: context,
                backgroundColor: PassworthyColors.backgroundLight,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                builder: (_) {
                  return _BuildEntryDetails(
                    entry: entry,
                    onUpdatePressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (_) => CreateEntryPage(
                            initialEntry: entry,
                          ),
                          fullscreenDialog: true,
                        ),
                      );
                    },
                    onDeletePressed: () {
                      Navigator.pop(context);
                      context.read<OverviewBloc>().add(
                            OverviewEntryDeleted(entry),
                          );
                    },
                  ).padding(
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
                  );
                },
              ),
              child: EntryComponent(entry: entry),
            );
          },
        );
      },
    );
  }
}

class _BuildEntryDetails extends StatelessWidget {
  const _BuildEntryDetails({
    required this.entry,
    required this.onUpdatePressed,
    required this.onDeletePressed,
  });

  final Entry entry;
  final VoidCallback onUpdatePressed;
  final VoidCallback onDeletePressed;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      spacing: 12,
      children: [
        _EntryInfoBuilder(
          name: l10n.platformLabel,
          value: entry.platform,
        ),
        _EntryInfoBuilder(
          name: l10n.identityLabel,
          value: entry.identity,
        ),
        _EntryInfoBuilder(
          name: l10n.passwordLabel,
          value: entry.password,
        ),
        const SizedBox(height: 4),
        Row(
          spacing: 16,
          children: [
            Expanded(
              child: SizedBox(
                height: 45,
                child: OutlinedButton(
                  onPressed: onDeletePressed,
                  child: Text(l10n.deleteButtonText),
                ),
              ),
            ),
            Expanded(
              child: SizedBox(
                height: 45,
                child: ElevatedButton(
                  onPressed: onUpdatePressed,
                  child: Text(l10n.updateButtonText),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
      ],
    );
  }
}

class _EntryInfoBuilder extends StatelessWidget {
  const _EntryInfoBuilder({required this.name, required this.value});
  final String name;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 8,
      children: [
        Text(
          name,
          style: PassworthyTextStyle.disclaimerText.copyWith(
            color: PassworthyColors.disclaimerHighlightText,
            fontSize: 14,
          ),
        ).padding(
          const EdgeInsets.symmetric(horizontal: 12),
        ),
        SelectableText(
          value,
          style: PassworthyTextStyle.inputText.copyWith(
            fontSize: 14,
          ),
        )
            .padding(
              const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            )
            .decoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: PassworthyColors.backgroundDefault,
              ),
            ),
      ],
    );
  }
}
