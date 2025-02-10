abstract class IAuthRepository<T> {
  Future<T?> signIn(String email, String password);
  Future<T?> register(String email, String password, String username);
  Future<void> signOut();
  Future<bool> isLoggedIn();
  Future<void> sendPasswordResetEmail(String email);
}
