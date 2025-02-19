import 'package:asset_tracker/features/auth/domain/entities/user_entity_model.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.id,
    required super.email,
    required super.password,
    super.username,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      password: json['password'],
      username: json['username'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'password': password,
      'username': username ?? '',
    };
  }

  UserModel copyWith({String? id, String? email, String? username}) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      password: '',
    );
  }
}
