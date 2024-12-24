class User {
  final String id;
  final String email;
  final String password;
  final String? username;

  User(
      {required this.id,
      required this.email,
      required this.password,
      this.username});
}
