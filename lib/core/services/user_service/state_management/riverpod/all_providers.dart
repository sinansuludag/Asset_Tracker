import 'package:asset_tracker/core/services/user_service/data/data_source/impl_user_firestore_service.dart';
import 'package:asset_tracker/core/services/user_service/data/repository/impl_user_repository.dart';
import 'package:asset_tracker/core/services/user_service/domain/abstract_user_repository.dart';
import 'package:asset_tracker/core/services/user_service/state_management/riverpod/user_manager_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final commonUserProvider =
    StateNotifierProvider<UserManagerNotifier, CommonUserState>(
  (ref) {
    final userRepository = ref.watch(_userRepositoryProvider);
    return UserManagerNotifier(userRepository);
  },
);

final _userRepositoryProvider = Provider<ICommonUserRepository>((ref) {
  return ImplCommonUserRepository(ImplCommonUserFirestoreService());
});
