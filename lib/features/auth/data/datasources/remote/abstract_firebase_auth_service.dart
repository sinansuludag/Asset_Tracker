import 'package:firebase_auth/firebase_auth.dart';

abstract class IFirebaseAuthService {
  Future<User?> signIn(String email, String password);
  Future<User?> register(String email, String password, String username);
  Future<void> signOut();
  Future<void> sendPasswordResetEmail(String email);
}
