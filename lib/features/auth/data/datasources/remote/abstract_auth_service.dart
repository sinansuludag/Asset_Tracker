import 'package:asset_tracker/features/auth/domain/entities/user_entity_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class IAuthService<T extends UserEntity> {
  Future<T?> signIn(String email, String password);
  Future<T?> register(String email, String password, String username);
  Future<void> signOut();
  Future<void> sendPasswordResetEmail(String email);
}
