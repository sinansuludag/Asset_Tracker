import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  static const _themeKey = 'app_theme_mode';

  ThemeModeNotifier() : super(ThemeMode.system) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeString = prefs.getString(_themeKey);

    if (themeString == 'dark') {
      state = ThemeMode.dark;
    } else if (themeString == 'light') {
      state = ThemeMode.light;
    } else {
      state = ThemeMode.system;
    }
  }

  Future<void> toggleTheme(bool isDarkMode) async {
    final prefs = await SharedPreferences.getInstance();
    state = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    await prefs.setString(_themeKey, isDarkMode ? 'dark' : 'light');
  }

  Future<void> setSystemMode() async {
    final prefs = await SharedPreferences.getInstance();
    state = ThemeMode.system;
    await prefs.setString(_themeKey, 'system');
  }

  Future<void> setLightMode() async {
    final prefs = await SharedPreferences.getInstance();
    state = ThemeMode.light;
    await prefs.setString(_themeKey, 'light');
  }
}
