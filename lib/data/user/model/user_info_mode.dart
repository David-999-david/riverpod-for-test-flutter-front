class UserInfoMode {
  final String name;
  final String email;

  UserInfoMode({required this.name, required this.email});

  factory UserInfoMode.fromJson(Map<String, dynamic> json) {
    return UserInfoMode(name: json['name'], email: json['email']);
  }
}
