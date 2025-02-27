import 'package:entries_repository/entries_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:passworthy/colors/colors.dart';
import 'package:passworthy/decorators/decorators.dart';
import 'package:passworthy/l10n/l10n.dart';
import 'package:passworthy/settings/settings.dart';
import 'package:passworthy/typography/typography.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SettingsCubit>(
      create: (context) => SettingsCubit(
        entriesRepository: context.read<EntriesRepository>(),
      )..getEntriesCount(),
      child: const SettingsView(),
    );
  }
}

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final entriesCount = context.select(
      (SettingsCubit cubit) => cubit.state.entriesCount,
    );
    final l10n = context.l10n;

    return BlocListener<SettingsCubit, SettingsState>(
      listenWhen: (previous, current) =>
          previous.errorMessage != current.errorMessage,
      listener: (context, state) {
        if (state.errorMessage.isNotEmpty) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(l10n.urlLaunchErrorMessage),
              ),
            );
        }
      },
      child: Scaffold(
        appBar: AppBar(),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 24,
          children: [
            Text(
              l10n.settingsPageTitle,
              style: PassworthyTextStyle.titleText,
            ).padding(const EdgeInsets.symmetric(horizontal: 24)),
            StaggeredGrid.count(
              crossAxisCount: 4,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: [
                StaggeredGridTile.count(
                  crossAxisCellCount: 2,
                  mainAxisCellCount: 2,
                  child: SettingsTile(
                    label: l10n.supportCardLabel,
                    icon: Icons.headset_mic_rounded,
                    onPressed: () =>
                        context.read<SettingsCubit>().launchSupport(),
                  ),
                ),
                StaggeredGridTile.count(
                  crossAxisCellCount: 2,
                  mainAxisCellCount: 1,
                  child: SettingsTile(
                    metric: entriesCount.toString(),
                    label: l10n.totalEntriesCardLabel,
                  ),
                ),
                StaggeredGridTile.count(
                  crossAxisCellCount: 2,
                  mainAxisCellCount: 1,
                  child: SettingsTile(
                    label: l10n.licensesCardLabel,
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (context) => const PassworthyLicensePage(),
                      ),
                    ),
                  ),
                ),
              ],
            ).padding(const EdgeInsets.symmetric(horizontal: 24)),
          ],
        ).wrapScrollableConditionally(size.height),
      ),
    );
  }
}

class SettingsTile extends StatelessWidget {
  const SettingsTile({
    required this.label,
    this.icon,
    this.metric,
    this.onPressed,
    super.key,
  });

  final IconData? icon;
  final String? metric;
  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (icon != null)
            Icon(
              icon,
              size: 32,
              color: PassworthyColors.lightGrey,
            ).padding(const EdgeInsets.all(8)).decoratedBox(
                  decoration: BoxDecoration(
                    color: PassworthyColors.darkGrey,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (metric != null)
                Text(
                  '$metric',
                  style: PassworthyTextStyle.captionText.copyWith(
                    color: PassworthyColors.lightGrey,
                  ),
                ),
              Text(
                label,
                style: PassworthyTextStyle.disclaimerText.copyWith(
                  color: PassworthyColors.lightGrey,
                ),
              ),
            ],
          ),
        ],
      ).padding(const EdgeInsets.all(16)).decoratedBox(
            decoration: BoxDecoration(
              color: PassworthyColors.slateGrey,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
    );
  }
}

class PassworthyLicensePage extends StatelessWidget {
  const PassworthyLicensePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    final headlineSmall = textTheme.headlineSmall;
    final bodySmall = textTheme.bodySmall;
    final bodyMedium = textTheme.bodyMedium;
    final titleMedium = textTheme.titleMedium;
    return Theme(
      data: Theme.of(context).copyWith(
        cardColor: PassworthyColors.darkGrey,
        textTheme: Theme.of(context).textTheme.copyWith(
              headlineSmall: headlineSmall?.copyWith(
                color: PassworthyColors.lightGrey,
              ),
              bodySmall: bodySmall?.copyWith(
                color: PassworthyColors.mediumGrey,
              ),
              bodyMedium: bodyMedium?.copyWith(
                color: PassworthyColors.lightGrey,
              ),
              titleMedium: titleMedium?.copyWith(
                color: PassworthyColors.lightGrey,
              ),
            ),
      ),
      child: LicensePage(applicationName: l10n.appName),
    );
  }
}
