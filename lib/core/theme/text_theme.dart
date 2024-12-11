import 'package:asset_tracker/core/constants/sizes/font_sizes.dart';
import 'package:flutter/material.dart';

class AppTextTheme {
  static const lightTextTheme = TextTheme(
    headlineLarge: TextStyle(
        fontSize: FontSizes.headlineLargeFontSize,
        fontWeight: FontWeight.bold,
        color: Colors.black),
    headlineMedium: TextStyle(
        fontSize: FontSizes.headlinemediumFontSize,
        fontWeight: FontWeight.w600,
        color: Colors.black),
    headlineSmall: TextStyle(
        fontSize: FontSizes.headlineSmallFontSize,
        fontWeight: FontWeight.w500,
        color: Colors.black),
    bodyLarge: TextStyle(
        fontSize: FontSizes.bodyLargeFontSize,
        fontWeight: FontWeight.normal,
        color: Colors.black),
    bodyMedium: TextStyle(
        fontSize: FontSizes.bodyMediumFontSize,
        fontWeight: FontWeight.normal,
        color: Colors.black),
    bodySmall: TextStyle(
        fontSize: FontSizes.bodySmallFontSize,
        fontWeight: FontWeight.normal,
        color: Colors.black),
  );

  static const darkTextTheme = TextTheme(
    headlineLarge: TextStyle(
        fontSize: FontSizes.headlineLargeFontSize,
        fontWeight: FontWeight.bold,
        color: Colors.white),
    headlineMedium: TextStyle(
        fontSize: FontSizes.headlinemediumFontSize,
        fontWeight: FontWeight.w600,
        color: Colors.white),
    headlineSmall: TextStyle(
        fontSize: FontSizes.headlineSmallFontSize,
        fontWeight: FontWeight.w500,
        color: Colors.white),
    bodyLarge: TextStyle(
        fontSize: FontSizes.bodyLargeFontSize,
        fontWeight: FontWeight.normal,
        color: Colors.white),
    bodyMedium: TextStyle(
        fontSize: FontSizes.bodyMediumFontSize,
        fontWeight: FontWeight.normal,
        color: Colors.white),
    bodySmall: TextStyle(
        fontSize: FontSizes.bodySmallFontSize,
        fontWeight: FontWeight.normal,
        color: Colors.white),
  );
}
