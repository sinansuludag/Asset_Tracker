import 'package:asset_tracker/features/auth/data/datasources/local/local_storage_service.dart';
import 'package:asset_tracker/features/auth/data/datasources/remote/auth_service.dart';
import 'package:asset_tracker/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:asset_tracker/features/auth/presentation/state_management/auth_state_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authService = FirebaseAuthService(); // Firebase servisleri
  final localStorageService = LocalStorageService(); // Local servis
  final authRepository =
      AuthRepositoryImpl(authService, localStorageService); // Repository

  // Use-case yerine repository doğrudan AuthNotifier'a enjekte edildi
  return AuthNotifier(authRepository);
});
