import 'package:asset_tracker/features/auth/data/datasources/remote/abstract_auth_service.dart';
import 'package:asset_tracker/features/auth/data/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthServiceImpl implements IAuthService<UserModel> {
  final FirebaseAuth _firebaseAuth;

  FirebaseAuthServiceImpl(this._firebaseAuth);

  @override
  Future<UserModel?> register(
      String email, String password, String username) async {
    UserCredential result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    Map<String, dynamic> json = {
      'id': result.user?.uid ?? '',
      'email': result.user?.email ?? '',
      'password': password,
      'username': username,
    };
    return UserModel.fromJson(json);
  }

  @override
  Future<UserModel?> signIn(String email, String password) async {
    UserCredential result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    Map<String, dynamic> json = {
      'id': result.user?.uid ?? '',
      'email': result.user?.email ?? '',
      'password': password,
    };
    return UserModel.fromJson(json);
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }
}
