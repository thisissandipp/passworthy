import 'package:flutter/material.dart';
import 'package:passworthy/decorators/decorators.dart';
import 'package:passworthy/l10n/l10n.dart';
import 'package:passworthy/typography/typography.dart';

class EmptyEntriesWidget extends StatelessWidget {
  const EmptyEntriesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Center(
      child: Column(
        spacing: 8,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            l10n.noEntriesTitle,
            textAlign: TextAlign.center,
            style: PassworthyTextStyle.titleText.copyWith(
              color: PassworthyTextStyle.captionText.color,
            ),
          ),
          Text(
            l10n.noEntriesCaption,
            textAlign: TextAlign.center,
            style: PassworthyTextStyle.captionText.copyWith(
              color: PassworthyTextStyle.captionText.color,
              fontSize: 12,
            ),
          ),
        ],
      ).padding(
        const EdgeInsets.only(bottom: kToolbarHeight * 2, left: 28, right: 28),
      ),
    );
  }
}
