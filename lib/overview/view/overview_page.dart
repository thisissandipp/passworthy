import 'package:entries_api/entries_api.dart';
import 'package:entries_repository/entries_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:passkey_repository/passkey_repository.dart';
import 'package:passworthy/banner/banner.dart';
import 'package:passworthy/colors/colors.dart';
import 'package:passworthy/create/create.dart';
import 'package:passworthy/decorators/decorators.dart';
import 'package:passworthy/details/details.dart';
import 'package:passworthy/l10n/l10n.dart';
import 'package:passworthy/overview/overview.dart';
import 'package:passworthy/settings/view/settings_page.dart';
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
        actions: [
          GestureDetector(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const SettingsPage()),
            ),
            child: const Icon(Icons.settings)
                .padding(const EdgeInsets.symmetric(horizontal: 8))
                .decoratedBox(
                  decoration: const BoxDecoration(
                    color: PassworthyColors.slateGrey,
                    shape: BoxShape.circle,
                  ),
                ),
          ).padding(const EdgeInsets.only(right: 16)),
        ],
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
          SearchEntryInput(),
          BannerView(),
          Expanded(
            child: EntriesListViewBuilder(),
          ),
        ],
      ),
    );
  }
}

class SearchEntryInput extends StatelessWidget {
  const SearchEntryInput({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return TextFormField(
      style: PassworthyTextStyle.inputText.copyWith(
        fontSize: 14,
      ),
      cursorColor: PassworthyColors.mediumIndigo,
      onChanged: (value) => context.read<OverviewBloc>().add(
            OverviewSearchInputChanged(value),
          ),
      decoration: InputDecoration(
        hintText: l10n.searchEntryHintText,
        icon: const Icon(
          Icons.search,
          color: PassworthyColors.lightGrey,
        ).padding(
          const EdgeInsets.only(left: 16),
        ),
      ),
    )
        .decoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: PassworthyColors.slateGrey,
          ),
        )
        .padding(const EdgeInsets.symmetric(horizontal: 16, vertical: 4));
  }
}

class EntriesListViewBuilder extends StatelessWidget {
  const EntriesListViewBuilder({super.key});

  @override
  Widget build(BuildContext context) {
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

          return const EmptyEntriesWidget();
        }

        return ListView.builder(
          itemCount: state.entries.length,
          itemBuilder: (context, index) {
            final entry = state.entries[index];
            return GestureDetector(
              onTap: () => showModalBottomSheet<void>(
                context: context,
                backgroundColor: PassworthyColors.slateGrey,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                builder: (_) => EntryDetailsView(entry: entry),
              ),
              child: EntryComponent(entry: entry),
            );
          },
        );
      },
    );
  }
}

class BuildEntryDetails extends StatelessWidget {
  const BuildEntryDetails({
    required this.entry,
    required this.onUpdatePressed,
    required this.onDeletePressed,
    super.key,
  });

  final Entry entry;
  final VoidCallback onUpdatePressed;
  final VoidCallback onDeletePressed;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      spacing: 12,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                l10n.entryDetailsTitle,
                style: PassworthyTextStyle.titleText,
              ),
            ),
            IconButton(
              key: const Key('buildEntryDetails_delete_iconButton'),
              onPressed: onDeletePressed,
              constraints: const BoxConstraints(maxHeight: 24, minWidth: 24),
              splashRadius: 24,
              color: PassworthyColors.redError,
              padding: EdgeInsets.zero,
              icon: const Icon(CupertinoIcons.delete_solid),
            ),
          ],
        ).padding(const EdgeInsets.symmetric(horizontal: 4, vertical: 4)),
        Column(
          spacing: 2,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.platformLabel,
              style: PassworthyTextStyle.disclaimerText,
            ),
            SelectableText(
              entry.platform,
              style: PassworthyTextStyle.captionText.copyWith(
                color: PassworthyColors.lightGrey,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.identityLabel,
              style: PassworthyTextStyle.disclaimerText,
            ),
            SelectableText(
              entry.identity,
              style: PassworthyTextStyle.captionText.copyWith(
                color: PassworthyColors.lightGrey,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.passwordLabel,
              style: PassworthyTextStyle.disclaimerText,
            ),
            SelectableText(
              entry.password,
              style: PassworthyTextStyle.captionText.copyWith(
                color: PassworthyColors.lightGrey,
              ),
            ),
          ],
        )
            .padding(
              const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            )
            .decoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: PassworthyColors.darkGrey,
              ),
            ),
        SizedBox(
          height: 45,
          child: ElevatedButton(
            onPressed: onUpdatePressed,
            child: Text(l10n.updateButtonText),
          ),
        ),
        const SizedBox(height: 4),
      ],
    ).wrapScrollableConditionally(size.height);
  }
}
