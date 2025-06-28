import 'package:asset_tracker/core/services/user_service/domain/abstract_user_repository.dart';
import 'package:asset_tracker/features/auth/data/models/user_model.dart';
import 'package:asset_tracker/features/auth/domain/entities/user_entity_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CommonUserState {
  final UserEntity user;
  final bool isLoading;
  final bool hasError;

  CommonUserState({
    required this.user,
    this.isLoading = false,
    this.hasError = false,
  });

  factory CommonUserState.initial() => CommonUserState(
      user: UserModel(id: '', username: '', email: '', password: ''));
}

class UserManagerNotifier extends StateNotifier<CommonUserState> {
  UserManagerNotifier(this._repository) : super(CommonUserState.initial()) {
    getUser(); // ✅ Sayfa açıldığında veri otomatik çekilir
  }
  final ICommonUserRepository _repository;

  UserEntity? _user;
  UserEntity? get user => _user;

  Future<void> getUser() async {
    state = CommonUserState(
        user: UserModel(id: '', username: '', email: '', password: ''),
        isLoading: true,
        hasError: false);
    _user = await _repository.getCurrentUserProfileRepository();
    state = _user != null
        ? CommonUserState(user: user!, isLoading: false, hasError: false)
        : CommonUserState(
            user: UserModel(id: '', username: '', email: '', password: ''),
            isLoading: false,
            hasError: true);
  }

  Future<void> updateUserProfile(UserEntity user) async {
    state = CommonUserState(
        user: UserModel(
            id: user.id,
            username: user.username,
            email: user.email,
            password: user.password),
        isLoading: true,
        hasError: false);
    bool isUpdate = await _repository.updateUserProfileRepository(user);
    state = isUpdate != true
        ? CommonUserState(
            user: UserModel(
                id: user.id,
                username: user.username,
                email: user.email,
                password: user.password),
            isLoading: false,
            hasError: true)
        : CommonUserState(
            user: UserModel(
                id: user.id,
                username: user.username,
                email: user.email,
                password: user.password),
            isLoading: false,
            hasError: false);
  }

  Future<void> updateUserPassword(String newPassword) async {
    state = CommonUserState(
        user: UserModel(id: '', username: '', email: '', password: ''),
        isLoading: true,
        hasError: false);
    bool isUpdate = await _repository.updateUserPasswordRepository(newPassword);
    state = isUpdate != true
        ? CommonUserState(
            user: UserModel(id: '', username: '', email: '', password: ''),
            isLoading: false,
            hasError: true)
        : CommonUserState(
            user: UserModel(
                id: '', username: '', email: '', password: newPassword),
            isLoading: false,
            hasError: false);
  }

  Future<bool> verifyCurrentPassword(String currentPassword) async {
    state = CommonUserState(
        user: UserModel(id: '', username: '', email: '', password: ''),
        isLoading: true,
        hasError: false);
    bool isVerified = await _repository.verifyCurrentPassword(currentPassword);
    state = isVerified != true
        ? CommonUserState(
            user: UserModel(id: '', username: '', email: '', password: ''),
            isLoading: false,
            hasError: true)
        : CommonUserState(
            user: UserModel(
                id: '', username: '', email: '', password: currentPassword),
            isLoading: false,
            hasError: false);
    return isVerified;
  }
}
