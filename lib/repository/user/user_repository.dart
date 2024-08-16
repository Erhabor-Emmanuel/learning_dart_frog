class User{
  const User({
    required this.id,
    required this.name,
    required this.username,
    required this.password,
  });

  /// User's id
  final String id;

  /// User's name
  final String name;

  /// User's username
  final String username;

  /// User's password
  final String password;
}