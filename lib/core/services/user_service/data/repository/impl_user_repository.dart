import 'package:asset_tracker/core/services/user_service/data/data_source/abstract_user_service.dart';
import 'package:asset_tracker/core/services/user_service/domain/abstract_user_repository.dart';
import 'package:asset_tracker/features/auth/data/models/user_model.dart';
import 'package:asset_tracker/features/auth/domain/entities/user_entity_model.dart';

class ImplCommonUserRepository implements ICommonUserRepository {
  final ICommonUserService _userService;

  ImplCommonUserRepository(this._userService);

  @override
  Future<UserModel?> getCurrentUserProfileRepository() async {
    return await _userService.getCurrentUserProfileService();
  }

  @override
  Future<bool> updateUserPasswordRepository(String newPassword) async {
    return await _userService.updateUserPasswordService(newPassword);
  }

  @override
  Future<bool> updateUserProfileRepository(UserEntity user) async {
    return await _userService.updateUserProfileService(user);
  }

  @override
  Future<bool> verifyCurrentPassword(String currentPassword) {
    return _userService.verifyCurrentPassword(currentPassword);
  }
}
