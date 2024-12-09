import 'package:flutter/material.dart';

class AppColorScheme {
  static const lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF212121),
    onPrimary: Color(0xFFFFFFFF),
    secondary: Color(0xFFFFC107),
    onSecondary: Color(0xFF000000),
    surface: Color(0xFFF5F5F5),
    onSurface: Color(0xFF212121),
    error: Color(0xFFD32F2F),
    onError: Color(0xFFFFFFFF),
  );

  static const darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFF81C784),
    onPrimary: Color(0xFF000000),
    secondary: Color(0xFFFFE082),
    onSecondary: Color(0xFF000000),
    surface: Color(0xFF424242),
    onSurface: Color(0xFFF5F5F5),
    error: Color(0xFFE57373),
    onError: Color(0xFF000000),
  );
}
