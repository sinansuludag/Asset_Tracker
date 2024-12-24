import 'package:asset_tracker/features/auth/data/datasources/local/abstract_local_storage.dart';
import 'package:asset_tracker/features/auth/data/datasources/local/local_storage_service.dart';
import 'package:asset_tracker/features/auth/data/datasources/remote/abstract_firebase_auth_service.dart';
import 'package:asset_tracker/features/auth/data/datasources/remote/firebase_auth_service.dart';
import 'package:asset_tracker/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:asset_tracker/features/auth/presentation/state_management/auth_state_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authService =
      ref.watch(firebaseAuthServiceProvider); // Firebase servisleri
  final localStorageService =
      ref.watch(localStorageServiceProvider); // Local servis
  final authRepository =
      AuthRepositoryImpl(authService, localStorageService); // Repository

  // Repository doğrudan AuthNotifier'a enjekte edildi
  return AuthNotifier(authRepository);
});

final firebaseAuthServiceProvider = Provider<IFirebaseAuthService>((ref) {
  return FirebaseAuthServiceImpl(
      FirebaseAuth.instance); // FirebaseAuth örneği burada sağlanır
});

final localStorageServiceProvider = Provider<ILocalStorageService>((ref) {
  return LocalStorageServiceImpl(); // LocalStorageService örneği burada sağlanır
});

final isLoadingProvider = StateProvider<bool>((ref) => false);
