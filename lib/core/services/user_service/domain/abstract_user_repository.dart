import 'package:asset_tracker/features/auth/data/models/user_model.dart';
import 'package:asset_tracker/features/auth/domain/entities/user_entity_model.dart';

abstract class ICommonUserRepository {
  Future<UserModel?> getCurrentUserProfileRepository();
  Future<bool> updateUserProfileRepository(UserEntity user);
  Future<bool> updateUserPasswordRepository(String newPassword);
  Future<bool> verifyCurrentPassword(String currentPassword);
}
