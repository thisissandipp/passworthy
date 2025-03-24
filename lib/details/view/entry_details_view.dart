import 'package:entries_api/entries_api.dart';
import 'package:entries_repository/entries_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:passkey_repository/passkey_repository.dart';
import 'package:passworthy/colors/colors.dart';
import 'package:passworthy/create/create.dart';
import 'package:passworthy/decorators/decorators.dart';
import 'package:passworthy/details/details.dart';
import 'package:passworthy/l10n/l10n.dart';
import 'package:passworthy/typography/typography.dart';

class EntryDetailsView extends StatelessWidget {
  const EntryDetailsView({required this.entry, super.key});
  final Entry entry;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DetailsBloc>(
      create: (context) => DetailsBloc(
        entry: entry,
        entriesRepository: context.read<EntriesRepository>(),
        passkeyRepository: context.read<PasskeyRepository>(),
      ),
      child: const EntryDetailsSetup(),
    );
  }
}

class EntryDetailsSetup extends StatelessWidget {
  const EntryDetailsSetup({super.key});

  @override
  Widget build(BuildContext context) {
    final entry = context.select((DetailsBloc bloc) => bloc.state.entry);
    final l10n = context.l10n;
    return Column(
      spacing: 8,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          spacing: 16,
          children: [
            Text(
              entry.platform[0].toUpperCase(),
              style: PassworthyTextStyle.inputText.copyWith(
                fontSize: 26,
              ),
            )
                .padding(
                  const EdgeInsets.symmetric(horizontal: 16),
                )
                .decoratedBox(
                  decoration: BoxDecoration(
                    color: PassworthyColors.darkGrey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 1.25,
              children: [
                Text(
                  entry.platform,
                  overflow: TextOverflow.ellipsis,
                  style: PassworthyTextStyle.titleText.copyWith(
                    fontSize: 14,
                  ),
                ),
                Text(
                  entry.identity,
                  overflow: TextOverflow.ellipsis,
                  style: PassworthyTextStyle.disclaimerText.copyWith(
                    color: PassworthyColors.lightGrey,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 2),
        const PasswordToggle(),
        Column(
          spacing: 8,
          mainAxisSize: MainAxisSize.min,
          children: [
            const FavoriteStatusView(),
            const Divider(color: PassworthyColors.mediumGrey),
            GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (context) => CreateEntryPage(initialEntry: entry),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.updateButtonText,
                    style: PassworthyTextStyle.captionText.copyWith(
                      color: PassworthyColors.lightGrey,
                    ),
                  ),
                  const Icon(
                    CupertinoIcons.chevron_forward,
                    size: 18,
                    color: PassworthyColors.lightGrey,
                  ),
                ],
              ),
            ),
            const Divider(color: PassworthyColors.mediumGrey),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
                context.read<DetailsBloc>().add(const EntryDeletionRequested());
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.deleteEntryButtonText,
                    style: PassworthyTextStyle.captionText.copyWith(
                      color: PassworthyColors.redError,
                    ),
                  ),
                  const Icon(
                    CupertinoIcons.delete,
                    size: 18,
                    color: PassworthyColors.redError,
                  ),
                ],
              ),
            ),
          ],
        ).padding(const EdgeInsets.all(16)).decoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: PassworthyColors.darkGrey,
              ),
            ),
        // Delete the entry
        const SizedBox(height: 12),
      ],
    ).padding(const EdgeInsets.all(16));
  }
}

class PasswordToggle extends StatelessWidget {
  const PasswordToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<DetailsBloc, DetailsState>(
      buildWhen: (previous, current) =>
          previous.showPassword != current.showPassword,
      builder: (context, state) {
        return GestureDetector(
          onTap: () => context
              .read<DetailsBloc>()
              .add(const PasswordVisibilityToggled()),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (state.showPassword)
                SelectableText(
                  state.entry.password,
                  style: PassworthyTextStyle.captionText.copyWith(
                    color: PassworthyColors.greenSuccess,
                  ),
                )
              else
                Text(
                  l10n.showPasswordButtonText,
                  overflow: TextOverflow.ellipsis,
                  style: PassworthyTextStyle.captionText.copyWith(
                    color: PassworthyColors.lightGrey,
                  ),
                ),
              Icon(
                state.showPassword ? Icons.visibility_off : Icons.visibility,
                size: 18,
                color: PassworthyColors.lightGrey,
              ),
            ],
          ).padding(const EdgeInsets.all(16)).decoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: PassworthyColors.darkGrey,
                ),
              ),
        );
      },
    );
  }
}

class FavoriteStatusView extends StatelessWidget {
  const FavoriteStatusView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isFavorite = context.select(
      (DetailsBloc bloc) => bloc.state.entry.isFavorite,
    );
    return GestureDetector(
      onTap: () => context.read<DetailsBloc>().add(
            const EntryFavoriteStatusChanged(),
          ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            isFavorite
                ? l10n.removeFromFavoriteButtonText
                : l10n.addToFavoriteButtonText,
            style: PassworthyTextStyle.captionText.copyWith(
              color: PassworthyColors.lightGrey,
            ),
          ),
          Icon(
            isFavorite ? Icons.star : Icons.star_border,
            size: 18,
            color: isFavorite
                ? PassworthyColors.amberHighlight
                : PassworthyColors.lightGrey,
          ),
        ],
      ),
    );
  }
}

class DeleteConfirmationDialog extends StatelessWidget {
  const DeleteConfirmationDialog({
    required this.entryDetails,
    required this.onDeleteCanceled,
    required this.onDeleteConfirmed,
    super.key,
  });

  final String entryDetails;
  final VoidCallback onDeleteCanceled;
  final VoidCallback onDeleteConfirmed;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 12,
      children: [
        Text(
          l10n.deleteTitle,
          style: PassworthyTextStyle.titleText,
        ),
        Text(
          l10n.deleteCaption,
          style: PassworthyTextStyle.disclaimerText.copyWith(
            color: PassworthyColors.lightGrey,
            fontSize: 14,
          ),
        ),
        Text(
          entryDetails,
          style: PassworthyTextStyle.disclaimerText.copyWith(
            color: PassworthyColors.mediumGrey,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          spacing: 16,
          children: [
            Expanded(
              child: SizedBox(
                height: 45,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: PassworthyColors.mediumGrey),
                    foregroundColor: PassworthyColors.lightGrey,
                  ),
                  onPressed: onDeleteCanceled,
                  child: Text(l10n.deleteCancelButtonText),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: SizedBox(
                height: 45,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: PassworthyColors.redError,
                  ),
                  onPressed: onDeleteConfirmed,
                  child: Text(l10n.deleteConfirmButtonText),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
      ],
    ).padding(
      const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
    );
  }
}
