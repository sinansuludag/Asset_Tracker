import 'package:asset_tracker/features/auth/data/models/user_model.dart';
import 'package:asset_tracker/features/auth/domain/entities/user_entity_model.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repositories/auth_repository.dart';

enum AuthState {
  initial,
  authenticated,
  unauthenticated,
}

class AuthNotifier extends StateNotifier<AuthState> {
  final IAuthRepository _repository;
  UserEntity? _user;

  AuthNotifier(this._repository) : super(AuthState.initial) {
    checkLoginStatus(); // Başlangıçta login durumunu kontrol et
  }

  UserEntity? get user => _user;

  // Giriş yapma
  Future<void> signIn(String email, String password) async {
    try {
      _user = await _repository.signIn(email, password);
      state =
          _user != null ? AuthState.authenticated : AuthState.unauthenticated;
    } on FirebaseAuthException catch (e) {
      state = AuthState.unauthenticated;
      rethrow; // FirebaseAuthException'ı dışarıya ilet
    } catch (e) {
      state = AuthState.unauthenticated;
      rethrow; // Diğer tüm hataları ilet
    }
  }

  // Kayıt olma
  Future<void> register(String email, String password, String username) async {
    try {
      _user = await _repository.register(email, password, username);
      state =
          _user != null ? AuthState.authenticated : AuthState.unauthenticated;
    } on FirebaseAuthException catch (e) {
      state = AuthState.unauthenticated;
      rethrow; // FirebaseAuthException'ı dışarıya ilet
    } catch (e) {
      state = AuthState.unauthenticated;
      rethrow; // Diğer tüm hataları ilet
    }
  }

  // Çıkış yapma
  Future<void> signOut() async {
    try {
      await _repository.signOut();
      _user = null;
      state = AuthState.unauthenticated;
    } on FirebaseAuthException catch (e) {
      rethrow; // FirebaseAuthException'ı dışarıya ilet
    } catch (e) {
      rethrow; // Diğer tüm hataları ilet
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _repository.sendPasswordResetEmail(email);
    } on FirebaseAuthException catch (e) {
      rethrow; // FirebaseAuthException'ı dışarıya ilet
    } catch (e) {
      rethrow; // Diğer tüm hataları ilet
    }
  }

  // Giriş durumunu kontrol etme
  Future<void> checkLoginStatus() async {
    try {
      bool isLoggedIn = await _repository.isLoggedIn();
      if (isLoggedIn) {
        _user = UserModel(
            id: 'dummy_id',
            email: 'dummy_email',
            password: 'dummy_email',
            username: 'dummy_username');
        state = AuthState.authenticated;
      } else {
        state = AuthState.unauthenticated;
      }
    } on FirebaseAuthException catch (e) {
      state = AuthState.unauthenticated;
      rethrow; // FirebaseAuthException'ı dışarıya ilet
    } catch (e) {
      state = AuthState.unauthenticated;
      rethrow; // Diğer tüm hataları ilet
    }
  }
}
