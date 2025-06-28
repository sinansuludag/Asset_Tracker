import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color appBackground = Color(0xFFE6F9F5); //(arka plan için)
  static const Color mainButtonBackground =
      Color(0xFF00c5a1); // Ana buton arka plan rengi
  static const Color mainButtonTextColor =
      Color(0xFFFFFFFF); // Ana buton metin rengi
  static const Color mainTextColor = Color(0xFF4c4637); // Ana metin rengi
  static const Color secondaryTextColor = Color(0xFFb2ab99); // 2.metin rengi
  static const Color secondaryButtonBackground =
      Color(0xFFc4fcf0); // 2. buton arka plan rengi
  static const Color secondaryButtonTextColor =
      Color(0xFF000000); // 2. buton metin rengi
  static const Color error = Color(0xFFff0000); // Hata rengi
  static const Color success = Color(0xFF00ff00); // Başarılı işlem rengi
  static const Color black = Color(0xFF000000); // Siyah renk

  static const Color primaryGreen = Color(0xFF1DD1A1);
  static const Color primaryBlue = Color(0xFF26D0CE);
  static const Color surfaceWhite = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF2C3E50);
  static const Color textSecondary = Color(0xFF7F8C8D);
  static const Color textLight = Color(0xFF95A5A6);
  static const Color overlayColor = Color(0x1A000000);
// Mevcut renklerinize ekleyin
  static const Color backgroundLight = Color(0xFFF8FFFE);
  static const Color cardBackground = Color(0xFFFFFFFF);

  // Gradient definitions
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryGreen, primaryBlue],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFFFFFF), Color(0xFFF8FFFE)],
  );
}
