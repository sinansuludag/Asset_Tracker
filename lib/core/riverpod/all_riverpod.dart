import 'package:asset_tracker/core/riverpod/refresf_frequency_manager/refresh_frequency_notifier.dart';
import 'package:asset_tracker/core/riverpod/theme_manager/theme_mode_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Theme manager
final themeModeProvider =
    StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  return ThemeModeNotifier();
});

// Refresh interval provider
final refreshIntervalProvider =
    StateNotifierProvider<RefreshIntervalNotifier, Duration>(
  (ref) {
    return RefreshIntervalNotifier();
  },
);
