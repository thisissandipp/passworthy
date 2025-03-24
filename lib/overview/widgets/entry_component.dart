import 'package:entries_api/entries_api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:passworthy/colors/colors.dart';
import 'package:passworthy/decorators/decorators.dart';
import 'package:passworthy/l10n/l10n.dart';
import 'package:passworthy/overview/overview.dart';
import 'package:passworthy/typography/typography.dart';

class EntryComponent extends StatelessWidget {
  const EntryComponent({required this.entry, super.key});
  final Entry entry;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      spacing: 16,
      children: [
        Expanded(
          child: Row(
            spacing: 16,
            children: [
              Text(
                entry.platform[0].toUpperCase(),
                style: PassworthyTextStyle.inputText.copyWith(
                  fontSize: 26,
                ),
              )
                  .padding(const EdgeInsets.symmetric(horizontal: 16))
                  .decoratedBox(
                    decoration: BoxDecoration(
                      color: PassworthyColors.darkGrey,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(
                      TextSpan(
                        text: entry.platform,
                        children: [
                          const TextSpan(text: '  '),
                          if (entry.isFavorite)
                            const WidgetSpan(
                              baseline: TextBaseline.alphabetic,
                              alignment: PlaceholderAlignment.baseline,
                              child: Icon(
                                CupertinoIcons.star_fill,
                                color: PassworthyColors.amberHighlight,
                                size: 14,
                              ),
                            ),
                        ],
                      ),
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
              ),
            ],
          ),
        ),
        CopyPasswordButton(
          onPressed: () {
            Clipboard.setData(ClipboardData(text: entry.password));
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(l10n.passwordCopiedMessage),
                ),
              );
          },
        ),
      ],
    )
        .padding(const EdgeInsets.all(16))
        .decoratedBox(
          decoration: BoxDecoration(
            color: PassworthyColors.slateGrey,
            borderRadius: BorderRadius.circular(12),
          ),
        )
        .padding(const EdgeInsets.fromLTRB(16, 8, 16, 8));
  }
}
