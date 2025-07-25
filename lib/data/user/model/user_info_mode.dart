class UserInfoMode {
  final String name;
  final String email;
  final List<String> role;
  final List<String> permissions;

  UserInfoMode(
      {required this.name,
      required this.email,
      required this.role,
      required this.permissions});

  factory UserInfoMode.fromJson(Map<String, dynamic> json) {
    return UserInfoMode(
        name: json['name'],
        email: json['email'],
        role: List<String>.from(json['role'] as List<dynamic>),
        permissions: List<String>.from(json['permissions'] as List<dynamic>));
  }
}
