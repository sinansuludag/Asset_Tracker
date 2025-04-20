// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:asset_tracker/features/auth/domain/entities/user_entity_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:asset_tracker/features/auth/domain/repositories/user_firestore_repository.dart';

enum UserState { loading, succes, error }

class UserFirestoreNotifier extends StateNotifier<UserState> {
  final IUserFirestoreRepository _userFirestoreRepository;
  UserFirestoreNotifier(this._userFirestoreRepository)
      : super(UserState.loading);

  UserEntity? _user;

  Future<String> getUserFromFirestore() async {
    state = UserState.loading;
    _user = await _userFirestoreRepository.getUserFromFirestore();
    state = _user != null ? UserState.succes : UserState.error;
    return _user?.id ?? '';
  }

  Future<void> saveUserToFirestore(UserEntity user) async {
    state = UserState.loading;
    final result = await _userFirestoreRepository.saveUserToFirestore(user);
    state = result ? UserState.succes : UserState.error;
  }
}
