import '../entities/user.dart';

abstract class AuthRepository {
  Future<User?> signIn(String email, String password);
  Future<User?> register(String email, String password, String username);
  Future<void> signOut();
  Future<bool> isLoggedIn();
}
