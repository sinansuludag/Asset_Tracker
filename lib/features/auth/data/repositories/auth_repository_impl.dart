import 'package:asset_tracker/features/auth/data/datasources/local/abstract_local_storage.dart';
import 'package:asset_tracker/features/auth/data/datasources/remote/abstract_firebase_auth_service.dart';
import 'package:asset_tracker/features/auth/domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements IAuthRepository {
  final IFirebaseAuthService _firebaseAuthService;
  final ILocalStorageService _localStorageService;

  AuthRepositoryImpl(this._firebaseAuthService, this._localStorageService);

  @override
  Future<User?> signIn(String email, String password) async {
    final user = await _firebaseAuthService.signIn(email, password);
    if (user != null) {
      await _localStorageService.setLoggedIn(true);
      return UserModel(id: user.uid, email: user.email!, password: password);
    }
    return null;
  }

  @override
  Future<User?> register(String email, String password, String username) async {
    final user = await _firebaseAuthService.register(email, password, username);
    if (user != null) {
      await _localStorageService.setLoggedIn(true);
      return UserModel(
          id: user.uid,
          email: user.email!,
          password: password,
          username: username);
    }
    return null;
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuthService.signOut();
    await _localStorageService.setLoggedIn(false);
  }

  @override
  Future<bool> isLoggedIn() async {
    return await _localStorageService.isLoggedIn();
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    await _firebaseAuthService.sendPasswordResetEmail(email);
  }
}
