import 'package:asset_tracker/features/auth/data/datasources/remote/abstract_user_firestore_service.dart';
import 'package:asset_tracker/features/auth/domain/entities/user_entity_model.dart';
import 'package:asset_tracker/features/auth/domain/repositories/user_firestore_repository.dart';

class UserFirestoreRepository implements IUserFirestoreRepository {
  final IUserFirestoreService _userFirestoreService;

  UserFirestoreRepository({required IUserFirestoreService userFirestoreService})
      : _userFirestoreService = userFirestoreService;

  @override
  Future<UserEntity?> getUserFromFirestore() async {
    final user = await _userFirestoreService.getUserFromFirestore();
    return user;
  }

  @override
  Future<bool> saveUserToFirestore(UserEntity user) async {
    try {
      await _userFirestoreService.saveUserToFirestore(user);
      return true;
    } catch (e) {
      return false;
    }
  }
}
