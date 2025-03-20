import 'package:asset_tracker/features/auth/domain/entities/user_entity_model.dart';

abstract class IUserFirestoreRepository {
  Future<bool> saveUserToFirestore(UserEntity user);
  Future<UserEntity?> getUserFromFirestore(String userId);
}
