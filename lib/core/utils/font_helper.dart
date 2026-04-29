import 'package:flutter/material.dart';

class FontHelper {
  static bool isArabic(BuildContext context) {
    return Localizations.localeOf(context).languageCode == 'ar';
  }

  static bool isRtl(BuildContext context) {
    return Directionality.of(context) == TextDirection.rtl;
  }

  static TextStyle getBodyTextStyle(BuildContext context) {
    final isArabic = FontHelper.isArabic(context);
    return TextStyle(
      fontFamily: isArabic ? 'NaskhArabic' : 'Almarai',
      fontSize: 16,
      fontWeight: FontWeight.w400,
      height: 1.5,
    );
  }

  static TextStyle getHeadlineTextStyle(BuildContext context) {
    return const TextStyle(
      fontFamily: 'Tajawal',
      fontSize: 24,
      fontWeight: FontWeight.w700,
      height: 1.3,
    );
  }

  static TextStyle getLargeHeadlineTextStyle(BuildContext context) {
    return const TextStyle(
      fontFamily: 'Tajawal',
      fontSize: 32,
      fontWeight: FontWeight.w700,
      height: 1.2,
    );
  }

  static TextStyle getLabelTextStyle(BuildContext context) {
    final isArabic = FontHelper.isArabic(context);
    return TextStyle(
      fontFamily: isArabic ? 'NaskhArabic' : 'Almarai',
      fontSize: 12,
      fontWeight: FontWeight.w700,
      height: 1,
      letterSpacing: 0.05,
    );
  }

  static String? getFontFamily(BuildContext context) {
    final isArabic = FontHelper.isArabic(context);
    return isArabic ? 'NaskhArabic' : null;
  }

  static String? getEnglishFontFamily() {
    return 'Almarai';
  }

  static String? getArabicFontFamily() {
    return 'NaskhArabic';
  }
}