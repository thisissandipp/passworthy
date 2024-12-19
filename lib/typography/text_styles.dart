import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:passworthy/colors/colors.dart';
import 'package:passworthy/typography/typography.dart';

/// Defines the text styles for the Passworthy App UI.
class PassworthyTextStyle {
  /// Title text style
  static TextStyle get titleText {
    return _baseTextStyle.copyWith(
      fontSize: 20,
      color: PassworthyColors.titleText,
      fontWeight: PassworthyFontWeight.semiBold,
    );
  }

  /// Caption text style
  static TextStyle get captionText {
    return _baseTextStyle.copyWith(
      fontSize: 14,
      color: PassworthyColors.captionText,
      fontWeight: PassworthyFontWeight.medium,
    );
  }

  /// Text style for disclaimers
  static TextStyle get disclaimerText {
    return _baseTextStyle.copyWith(
      fontSize: 12,
      color: PassworthyColors.disclaimerText,
      fontWeight: PassworthyFontWeight.medium,
    );
  }

  /// Button text style
  static TextStyle get buttonText {
    return _baseTextStyle.copyWith(
      fontSize: 15,
      color: PassworthyColors.buttonText,
      fontWeight: PassworthyFontWeight.bold,
    );
  }

  /// Text style for hints inside text fields
  static TextStyle get inputHintText {
    return _baseTextStyle.copyWith(
      color: PassworthyColors.inputHintText,
      fontWeight: FontWeight.w600,
    );
  }

  /// Text field input text style
  static TextStyle get inputText {
    return _baseTextStyle.copyWith(
      fontSize: 22,
      color: PassworthyColors.inputText,
      fontWeight: FontWeight.w600,
    );
  }

  static final _baseTextStyle = GoogleFonts.poppins(
    fontWeight: PassworthyFontWeight.regular,
    letterSpacing: 0.72,
    height: 1.6,
  );
}
