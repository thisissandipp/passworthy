import 'package:flutter/material.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:passworthy/colors/colors.dart';
import 'package:passworthy/decorators/decorators.dart';
import 'package:passworthy/l10n/l10n.dart';
import 'package:passworthy/passkey/passkey.dart';
import 'package:passworthy/typography/typography.dart';

class PasskeyCriteriaInfo extends StatelessWidget {
  const PasskeyCriteriaInfo({required this.passkeyErrors, super.key});
  final List<PasskeyValidationError>? passkeyErrors;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Align(
      alignment: Alignment.centerLeft,
      child: TextButton(
        onPressed: () {
          showModalBottomSheet<void>(
            context: context,
            backgroundColor: PassworthyColors.slateGrey,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            builder: (_) => PasskeyCriteriaModalBuilder(
              m12Characters: passkeyErrors.missing12Characters,
              mUppercaseLetter: passkeyErrors.missingUppercaseLetter,
              mLowercaseLetter: passkeyErrors.missingLowercaseLetter,
              mNumber: passkeyErrors.missingNumber,
              mSpecialCharacter: passkeyErrors.missingSpecialCharacter,
            ),
          );
        },
        style: TextButton.styleFrom(
          backgroundColor: PassworthyColors.darkIndigo.withAlpha(37),
          foregroundColor: PassworthyColors.mediumIndigo,
          textStyle: PassworthyTextStyle.disclaimerText,
        ),
        child: Text(l10n.passkeyCriteriaButtonText),
      ),
    ).padding(const EdgeInsets.symmetric(horizontal: 24));
  }
}

class PasskeyCriteriaModalBuilder extends StatelessWidget {
  const PasskeyCriteriaModalBuilder({
    required this.m12Characters,
    required this.mUppercaseLetter,
    required this.mLowercaseLetter,
    required this.mNumber,
    required this.mSpecialCharacter,
    super.key,
  });

  final bool m12Characters;
  final bool mUppercaseLetter;
  final bool mLowercaseLetter;
  final bool mNumber;
  final bool mSpecialCharacter;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: 8,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.passkeyCriteriaModalTitle,
          style: PassworthyTextStyle.titleText,
        ),
        const SizedBox(height: 4),
        Text(
          l10n.passkeyCharactersLengthRule,
          style: PassworthyTextStyle.disclaimerText.copyWith(
            color: m12Characters ? null : PassworthyColors.greenSuccess,
          ),
        ),
        Text(
          l10n.passkeyUppercaseRule,
          style: PassworthyTextStyle.disclaimerText.copyWith(
            color: mUppercaseLetter ? null : PassworthyColors.greenSuccess,
          ),
        ),
        Text(
          l10n.passkeyLowercaseRule,
          style: PassworthyTextStyle.disclaimerText.copyWith(
            color: mLowercaseLetter ? null : PassworthyColors.greenSuccess,
          ),
        ),
        Text(
          l10n.passkeyNumberRule,
          style: PassworthyTextStyle.disclaimerText.copyWith(
            color: mNumber ? null : PassworthyColors.greenSuccess,
          ),
        ),
        Text(
          l10n.passkeySpecialCharacterRule,
          style: PassworthyTextStyle.disclaimerText.copyWith(
            color: mSpecialCharacter ? null : PassworthyColors.greenSuccess,
          ),
        ),
        const SizedBox(height: 8),
      ],
    ).padding(
      const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
    );
  }
}
