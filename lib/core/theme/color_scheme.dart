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
    primary: AppColors.mainButtonBackground, // Ana buton arka planı
    onPrimary: AppColors.mainButtonTextColor, // Ana buton metin rengi
    secondary: AppColors.secondaryButtonBackground, // İkinci buton arka planı
    onSecondary: AppColors.secondaryButtonTextColor, // İkinci buton metin rengi
    surface: Color(0xFF121212), // Karanlık zemin rengi
    onSurface: AppColors.mainTextColor, // Karanlık zeminde ana metin rengi
    error: AppColors.error, // Hata rengi
    onError: AppColors.mainTextColor, // Hata mesajlarında metin rengi
  );
}
