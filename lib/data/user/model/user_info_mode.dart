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

class UserLocal {
  final int? id;
  final String name;
  final String email;

  UserLocal({this.id, required this.name, required this.email});

  factory UserLocal.fromMap(Map<String, dynamic> map) {
    return UserLocal(id: map['id'], name: map['name'], email: map['email']);
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'email': email};
  }
}

class Role {
  final int? id;
  final int userId;
  final String name;

  Role({this.id, required this.userId, required this.name});

  factory Role.fromMap(Map<String, dynamic> map) {
    return Role(id: map['id'], userId: map['user_id'], name: map['name']);
  }

  Map<String, dynamic> toMap() {
    return {'user_id': userId, 'name': name};
  }
}

class Permission {
  final int? id;
  final int userId;
  final String name;

  Permission({this.id, required this.userId, required this.name});

  factory Permission.fromMap(Map<String, dynamic> map) {
    return Permission(id: map['id'], userId: map['user_id'], name: map['name']);
  }

  Map<String, dynamic> toMap() {
    return {'user_id': userId, 'name': name};
  }
}
