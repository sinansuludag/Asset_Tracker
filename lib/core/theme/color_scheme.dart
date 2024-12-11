import 'package:asset_tracker/core/constants/colors/app_colors.dart';
import 'package:flutter/material.dart';

class AppColorScheme {
  static const lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.primaryDark,
    onPrimary: AppColors.white,
    secondary: AppColors.yellow,
    onSecondary: AppColors.black,
    surface: AppColors.lightGrey,
    onSurface: AppColors.primaryDark,
    error: AppColors.red,
    onError: AppColors.white,
  );

  static const darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: AppColors.darkGreen,
    onPrimary: AppColors.black,
    secondary: AppColors.paleYellow,
    onSecondary: AppColors.black,
    surface: AppColors.darkGrey,
    onSurface: AppColors.lightGrey,
    error: AppColors.lightRed,
    onError: AppColors.black,
  );
}
