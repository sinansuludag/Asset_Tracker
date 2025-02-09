import 'package:firebase_auth/firebase_auth.dart';

abstract class IFirebaseAuthService<T> {
  Future<T?> signIn(String email, String password);
  Future<T?> register(String email, String password, String username);
  Future<void> signOut();
  Future<void> sendPasswordResetEmail(String email);
}
