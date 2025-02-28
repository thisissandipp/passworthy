import 'package:flutter/material.dart';
import 'package:passworthy/colors/colors.dart';
import 'package:passworthy/decorators/decorators.dart';
import 'package:passworthy/l10n/l10n.dart';
import 'package:passworthy/typography/typography.dart';

class CopyPasswordButton extends StatefulWidget {
  const CopyPasswordButton({required this.onPressed, super.key});
  final VoidCallback onPressed;

  @override
  State<CopyPasswordButton> createState() => _CopyPasswordButtonState();
}

class _CopyPasswordButtonState extends State<CopyPasswordButton> {
  bool _inCopiedMode = false;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return GestureDetector(
      onTap: () async {
        setState(() => _inCopiedMode = true);
        widget.onPressed();
        await Future<void>.delayed(const Duration(seconds: 3));
        setState(() => _inCopiedMode = false);
      },
      child: SizedBox(
        width: 84,
        height: 32,
        child: Center(
          child: Text.rich(
            TextSpan(
              children: [
                if (_inCopiedMode) ...[
                  WidgetSpan(
                    child: const Icon(
                      Icons.check,
                      size: 12,
                      color: PassworthyColors.greenSuccess,
                    ).padding(
                      const EdgeInsets.only(bottom: 2.6),
                    ),
                  ),
                  const WidgetSpan(child: SizedBox(width: 4)),
                ],
                TextSpan(
                  text: _inCopiedMode
                      ? l10n.copiedButtonText
                      : l10n.copyButtonText,
                  style: PassworthyTextStyle.disclaimerText.copyWith(
                    color: _inCopiedMode
                        ? PassworthyColors.greenSuccess
                        : PassworthyColors.white,
                    fontWeight: PassworthyFontWeight.semiBold,
                    letterSpacing: -0.13,
                  ),
                ),
              ],
            ),
          ),
        ).decoratedBox(
          decoration: BoxDecoration(
            color: PassworthyColors.darkGrey.withBlue(23),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
