abstract class ILocalStorageService {
  Future<void> setLoggedIn(bool value);
  Future<bool> isLoggedIn();
}
