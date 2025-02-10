import 'package:asset_tracker/features/auth/domain/entities/user_entity_model.dart';

class MockUserModel extends UserEntity {
  MockUserModel({
    required super.id,
    required super.email,
    required super.password,
    super.username,
  });

  factory MockUserModel.fromJson(Map<String, dynamic> json) {
    return MockUserModel(
      id: json['id'],
      email: json['email'],
      password: json['password'],
      username: json['username'] ?? '',
    );
  }
}
