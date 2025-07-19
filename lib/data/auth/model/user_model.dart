class RegisterModel {
  final String name;
  final String email;
  final String? phone;
  final String password;

  RegisterModel(
      {required this.name,
      required this.email,
      this.phone,
      required this.password});

  Map<String, dynamic> toJson() {
    return {'name': name, 'email': email, 'phone': phone, 'password': password};
  }
}
