import '../entities/user.dart';

abstract class IAuthRepository {
  Future<User?> signIn(String email, String password);
  Future<User?> register(String email, String password, String username);
  Future<void> signOut();
  Future<bool> isLoggedIn();
  Future<void> sendPasswordResetEmail(String email);
}
