import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RefreshIntervalNotifier extends StateNotifier<Duration> {
  static const _key = 'refresh_interval_seconds';

  RefreshIntervalNotifier() : super(const Duration(seconds: 30)) {
    _loadFromPrefs();
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final seconds = prefs.getInt(_key) ?? 30;
    state = Duration(seconds: seconds);
  }

  Future<void> updateInterval(Duration newInterval) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_key, newInterval.inSeconds);
    state = newInterval;
  }

  Duration get currentInterval => state;
}
