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

  UserEntity? get user => _user;

  Future<void> getUserFromFirestore(String userId) async {
    state = UserState.loading;
    _user = await _userFirestoreRepository.getUserFromFirestore(userId);
    state = _user != null ? UserState.succes : UserState.error;
  }

  Future<void> saveUserToFirestore(UserEntity user) async {
    state = UserState.loading;
    final result = await _userFirestoreRepository.saveUserToFirestore(user);
    state = result ? UserState.succes : UserState.error;
  }
}
