abstract class ILocalStorageService {
  Future<void> setLoggedIn(bool value);
  Future<bool> isLoggedIn();
  Future<void> setUserId(String userId);
  Future<String?> getUserId();
}
