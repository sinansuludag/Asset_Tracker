import 'package:asset_tracker/features/auth/data/datasources/remote/abstract_user_firestore_service.dart';
import 'package:asset_tracker/features/auth/data/models/user_model.dart';
import 'package:asset_tracker/features/auth/domain/entities/user_entity_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserFirestoreServiceImpl implements IUserFirestoreService {
  final FirebaseFirestore _firestore;

  UserFirestoreServiceImpl(this._firestore);

  @override
  Future<UserEntity?> getUserFromFirestore(String userId) async {
    final userDoc = await _firestore.collection('users').doc(userId).get();
    if (userDoc.exists) {
      final data = userDoc.data();
      return UserModel(
        id: userId,
        email: data?['email'] ?? '',
        password: '', // Şifre burada saklanmaz, güvenlik için
        username: data?['username'],
      );
    } else {
      return null;
    }
  }

  @override
  Future<bool> saveUserToFirestore(UserEntity user) async {
    try {
      await _firestore.collection('users').doc(user.id).set({
        'id': user.id,
        'email': user.email,
        'username': user.username,
        'password': user.password,
        'createdAt': FieldValue.serverTimestamp(),
      });
      return true;
    } catch (e) {
      return false;
    }
  }
}
