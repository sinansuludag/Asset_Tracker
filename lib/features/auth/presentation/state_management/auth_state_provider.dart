import 'package:asset_tracker/features/auth/data/datasources/local/local_storage_service.dart';
import 'package:asset_tracker/features/auth/data/datasources/remote/abstract_firebase_auth_service.dart';
import 'package:asset_tracker/features/auth/data/datasources/remote/firebase_auth_service.dart';
import 'package:asset_tracker/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:asset_tracker/features/auth/presentation/state_management/auth_state_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authService =
      FirebaseAuthServiceImpl(FirebaseAuth.instance); // Firebase servisleri
  final localStorageService = LocalStorageServiceImpl(); // Local servis
  final authRepository =
      AuthRepositoryImpl(authService, localStorageService); // Repository

  // Use-case yerine repository doğrudan AuthNotifier'a enjekte edildi
  return AuthNotifier(authRepository);
});

final firebaseAuthServiceProvider = Provider<IFirebaseAuthService>((ref) {
  return FirebaseAuthServiceImpl(
      FirebaseAuth.instance); // FirebaseAuth örneği burada sağlanır
});
