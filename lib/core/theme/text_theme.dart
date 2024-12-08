import 'package:flutter/material.dart';

class AppTextTheme {
  static const lightTextTheme = TextTheme(
    headlineLarge: TextStyle(
        fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black),
    headlineMedium: TextStyle(
        fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black),
    bodyLarge: TextStyle(
        fontSize: 16, fontWeight: FontWeight.normal, color: Colors.black),
  );

  static const darkTextTheme = TextTheme(
    headlineLarge: TextStyle(
        fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
    headlineMedium: TextStyle(
        fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white),
    bodyLarge: TextStyle(
        fontSize: 16, fontWeight: FontWeight.normal, color: Colors.white),
  );
}
