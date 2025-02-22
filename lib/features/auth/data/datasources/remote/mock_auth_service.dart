import 'package:asset_tracker/features/auth/data/datasources/remote/abstract_auth_service.dart';
import 'package:asset_tracker/features/auth/data/models/mock_user_model.dart';

class MockAuthServiceImpl implements IAuthService {
  @override
  Future<MockUserModel?> register(
      String email, String password, String username) async {
    await Future.delayed(const Duration(seconds: 2));
    return MockUserModel(
      id: '3',
      email: email,
      password: password,
      username: username,
    );
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    await Future.delayed(const Duration(seconds: 2));
  }

  @override
  Future<MockUserModel?> signIn(String email, String password) async {
    try {
      await Future.delayed(const Duration(seconds: 2));

      Map<String, dynamic>? user = _mockUsers.firstWhere(
        (element) =>
            element['email'] == email && element['password'] == password,
        orElse: () => <String, dynamic>{},
      );

      if (user.isEmpty) {
        return null;
      }

      return MockUserModel.fromJson(user);
    } catch (e) {
      print("signIn hatası: $e");
      return throw Exception("Bir hata oluştu");
    }
  }

  final List<Map<String, dynamic>> _mockUsers = [
    {
      'id': '1',
      'name': 'test1',
      'password': '123456',
      'email': 'test1@gmail.com',
    },
    {
      'id': '2',
      'name': 'test2',
      'password': '123456',
      'email': 'test2@gmail.com',
    }
  ];

  @override
  Future<void> signOut() async {
    await Future.delayed(const Duration(seconds: 2));
  }
}
