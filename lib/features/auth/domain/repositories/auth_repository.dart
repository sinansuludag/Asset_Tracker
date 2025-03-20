import 'package:asset_tracker/features/auth/domain/entities/user_entity_model.dart';

abstract class IAuthRepository {
  Future<UserEntity?> signIn(String email, String password);
  Future<UserEntity?> register(String email, String password, String username);
  Future<void> signOut();
  Future<bool> isLoggedIn();
  Future<void> sendPasswordResetEmail(String email);
}
