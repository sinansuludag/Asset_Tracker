import 'package:asset_tracker/core/services/user_service/data/data_source/abstract_user_service.dart';
import 'package:asset_tracker/features/auth/data/models/user_model.dart';
import 'package:asset_tracker/features/auth/domain/entities/user_entity_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class ImplCommonUserFirestoreService implements ICommonUserService {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  @override
  Future<UserModel?> getCurrentUserProfileService() async {
    final user = _auth.currentUser;
    if (user == null) return Future.value(null);

    final doc = await _firestore.collection('users').doc(user.uid).get();
    if (doc.exists) {
      final data = doc.data() as Map<String, dynamic>;
      return UserModel.fromJson(data);
    } else {
      return Future.value(null);
    }
  }

  @override
  Future<bool> updateUserPasswordService(String newPassword) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return false;

      await user.updatePassword(newPassword);

      // Firestore'da şifreyi ayrı tutuyorsan güncelle (opsiyonel)
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({'password': newPassword});

      return true;
    } on FirebaseAuthException catch (e) {
      debugPrint("Şifre güncelleme hatası: ${e.code}");
      return false;
    } catch (e) {
      debugPrint("Bilinmeyen şifre hatası: $e");
      return false;
    }
  }

  @override
  Future<bool> updateUserProfileService(UserEntity userEntity) {
    final user = _auth.currentUser;
    if (user == null) return Future.value(false);

    return _firestore
        .collection('users')
        .doc(user.uid)
        .update({'username': userEntity.username, 'email': userEntity.email})
        .then((_) => true)
        .catchError((_) => false);
  }

  @override
  Future<bool> verifyCurrentPassword(String currentPassword) async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      final credential = EmailAuthProvider.credential(
        email: user!.email!,
        password: currentPassword,
      );

      await user.reauthenticateWithCredential(credential);
      return true;
    } catch (e) {
      debugPrint("Şifre doğrulama hatası: $e");
      return false;
    }
  }
}
