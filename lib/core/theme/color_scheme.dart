import 'package:asset_tracker/core/constants/colors/app_colors.dart';
import 'package:flutter/material.dart';

class AppColorScheme {
  static const lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.mainButtonBackground,
    onPrimary: AppColors.mainButtonTextColor,
    secondary: AppColors.secondaryButtonBackground,
    onSecondary: AppColors.secondaryButtonTextColor,
    surface: AppColors.appBackground,
    onSurface: AppColors.mainTextColor,
    error: AppColors.error,
    onError: AppColors.secondaryTextColor,
  );

  static const darkColorScheme = ColorScheme(
    brightness: Brightness.dark,

    // Buton ve vurgu renkleri (senin renklerinle uyumlu)
    primary: AppColors.mainButtonTextColor, // Ana yeşil buton
    onPrimary: AppColors.mainButtonBackground,

    secondary: AppColors
        .secondaryButtonTextColor, // Vurgulu ikinci buton (uyumlu parlak yeşil ton)
    onSecondary: AppColors.secondaryButtonBackground,

    surface: Color(0xFF2C2C2E), // Kart, AppBar, bottomsheet gibi yüzeyler
    onSurface: Color(0xFFEDEDED), // Kart içi metinler

    // Hata renkleri
    error: AppColors.error,
    onError: Colors.white,
  );
}
