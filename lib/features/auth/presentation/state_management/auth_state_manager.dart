import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';

enum AuthState {
  initial,
  authenticated,
  unauthenticated,
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repository;
  User? _user;

  AuthNotifier(this._repository) : super(AuthState.initial) {
    checkLoginStatus(); // Başlangıçta login durumunu kontrol et
  }

  User? get user => _user;

  // Giriş yapma
  Future<void> signIn(String email, String password) async {
    try {
      _user = await _repository.signIn(email, password);
      state =
          _user != null ? AuthState.authenticated : AuthState.unauthenticated;
    } catch (e) {
      state = AuthState.unauthenticated;
      print('Sign-in error: $e');
    }
  }

  // Kayıt olma
  Future<void> register(String email, String password, String username) async {
    try {
      _user = await _repository.register(email, password, username);
      state =
          _user != null ? AuthState.authenticated : AuthState.unauthenticated;
    } catch (e) {
      state = AuthState.unauthenticated;
      print('Registration error: $e');
    }
  }

  // Çıkış yapma
  Future<void> signOut() async {
    try {
      await _repository.signOut();
      _user = null;
      state = AuthState.unauthenticated;
    } catch (e) {
      print('Sign-out error: $e');
    }
  }

  // Giriş durumunu kontrol etme
  Future<void> checkLoginStatus() async {
    try {
      bool isLoggedIn = await _repository.isLoggedIn();
      if (isLoggedIn) {
        _user = User(
            id: 'dummy_id',
            email: 'dummy_email',
            password: 'dummy_email',
            username: 'dummy_username');
        state = AuthState.authenticated;
      } else {
        state = AuthState.unauthenticated;
      }
    } catch (e) {
      state = AuthState.unauthenticated;
      print('Check login status error: $e');
    }
  }
}
