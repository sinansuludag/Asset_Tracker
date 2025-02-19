abstract class UserEntity {
  final String id;
  final String email;
  final String password;
  final String? username;

  const UserEntity({
    required this.id,
    required this.email,
    required this.password,
    this.username,
  });
}
