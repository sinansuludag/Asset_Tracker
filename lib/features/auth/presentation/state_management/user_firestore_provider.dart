import 'package:asset_tracker/features/auth/data/datasources/remote/abstract_user_firestore_service.dart';
import 'package:asset_tracker/features/auth/data/datasources/remote/user_firestore_service.dart';
import 'package:asset_tracker/features/auth/data/repositories/user_firestore_repository.dart';
import 'package:asset_tracker/features/auth/presentation/state_management/user_firestore_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userProvider = StateNotifierProvider<UserFirestoreNotifier, UserState>(
  (ref) {
    final userService = ref.watch(_userFirestoreServiceProvider);
    final userRepository =
        UserFirestoreRepository(userFirestoreService: userService);
    return UserFirestoreNotifier(userRepository);
  },
);

final _userFirestoreServiceProvider = Provider<IUserFirestoreService>((ref) {
  return UserFirestoreServiceImpl(FirebaseFirestore.instance);
});
