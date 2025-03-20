import 'package:asset_tracker/features/auth/data/datasources/local/abstract_local_storage.dart';
import 'package:asset_tracker/features/auth/data/datasources/remote/abstract_auth_service.dart';
import 'package:asset_tracker/features/auth/domain/entities/user_entity_model.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements IAuthRepository {
  final IAuthService authService;
  final ILocalStorageService _localStorageService;

  AuthRepositoryImpl(this.authService, this._localStorageService);

  @override
  Future<UserEntity?> signIn(String email, String password) async {
    final user = await authService.signIn(email, password);
    if (user != null) {
      await _localStorageService.setLoggedIn(true);
      final storedUserId = await _localStorageService.getUserId();

      // Eğer kayıtlı bir userId yoksa, yeni userId'yi kaydet
      if (storedUserId == '') {
        await _localStorageService.setUserId(user.id);
      }
      return user;
    }
    return null;
  }

  @override
  Future<UserEntity?> register(
      String email, String password, String username) async {
    final user = await authService.register(email, password, username);
    if (user != null) {
      await _localStorageService.setLoggedIn(true);
      await _localStorageService.setUserId(user.id);
      return user;
    }
    return null;
  }

  @override
  Future<void> signOut() async {
    await authService.signOut();
    await _localStorageService.setLoggedIn(false);
    await _localStorageService.setUserId('');
  }

  @override
  Future<bool> isLoggedIn() async {
    return await _localStorageService.isLoggedIn();
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    await authService.sendPasswordResetEmail(email);
  }
}
