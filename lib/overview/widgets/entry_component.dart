import 'package:entries_api/entries_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:passworthy/colors/colors.dart';
import 'package:passworthy/decorators/decorators.dart';
import 'package:passworthy/typography/typography.dart';

class EntryComponent extends StatelessWidget {
  const EntryComponent({required this.entry, super.key});
  final Entry entry;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          spacing: 24,
          children: [
            Text(
              entry.platform[0].toUpperCase(),
              style: PassworthyTextStyle.inputText.copyWith(
                fontSize: 26,
              ),
            ).padding(const EdgeInsets.symmetric(horizontal: 16)).decoratedBox(
                  decoration: BoxDecoration(
                    color: PassworthyColors.backgroundDefault,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                  style: PassworthyTextStyle.disclaimerText,
                ),
              ],
            ),
          ],
        ),
        IconButton(
          onPressed: () {
            Clipboard.setData(ClipboardData(text: entry.password));
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(
                  content: Text('password has been copied to clipboard'),
                ),
              );
          },
          icon: const Icon(Icons.copy_sharp),
          color: PassworthyColors.buttonText,
          iconSize: 18,
        ),
      ],
    )
        .padding(const EdgeInsets.all(16))
        .decoratedBox(
          decoration: BoxDecoration(
            color: PassworthyColors.backgroundLight,
            borderRadius: BorderRadius.circular(12),
          ),
        )
        .padding(const EdgeInsets.fromLTRB(16, 8, 16, 8));
  }
}
