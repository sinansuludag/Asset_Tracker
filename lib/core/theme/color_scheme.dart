import 'package:flutter/material.dart';

class AppColorScheme {
  static const lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF6200EE),
    onPrimary: Color(0xFFFFFFFF),
    secondary: Color(0xFF03DAC6),
    onSecondary: Color(0xFF000000),
    background: Color(0xFFF6F6F6),
    onBackground: Color(0xFF000000),
    surface: Color(0xFFFFFFFF),
    onSurface: Color(0xFF000000),
    error: Color(0xFFB00020),
    onError: Color(0xFFFFFFFF),
  );

  static const darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFFBB86FC),
    onPrimary: Color(0xFF000000),
    secondary: Color(0xFF03DAC6),
    onSecondary: Color(0xFF000000),
    background: Color(0xFF121212),
    onBackground: Color(0xFFFFFFFF),
    surface: Color(0xFF121212),
    onSurface: Color(0xFFFFFFFF),
    error: Color(0xFFCF6679),
    onError: Color(0xFF000000),
  );
}
