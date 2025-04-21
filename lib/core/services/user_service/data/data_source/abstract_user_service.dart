import 'package:asset_tracker/features/auth/data/models/user_model.dart';
import 'package:asset_tracker/features/auth/domain/entities/user_entity_model.dart';

abstract class ICommonUserService {
  Future<UserModel?> getCurrentUserProfileService();
  Future<bool> updateUserProfileService(UserEntity user);
  Future<bool> updateUserPasswordService(String newPassword);
  Future<bool> verifyCurrentPassword(String currentPassword);
}
