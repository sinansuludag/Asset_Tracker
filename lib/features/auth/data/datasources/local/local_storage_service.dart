import 'package:asset_tracker/features/auth/data/datasources/local/abstract_local_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageServiceImpl implements ILocalStorageService {
  static const String _isLoggedInKey = 'isLoggedIn';

  @override
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  @override
  Future<void> setLoggedIn(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, value);
  }

  @override
  Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId') ?? '';
  }

  @override
  Future<void> setUserId(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', userId);
  }
}
