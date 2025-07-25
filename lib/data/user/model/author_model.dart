class AuthorModel {
  final String id;
  final String name;

  AuthorModel({required this.id, required this.name});

  factory AuthorModel.fromJson(Map<String, dynamic> json) {
    return AuthorModel(
        id: json['authorId'] as String, name: json['authorName'] as String);
  }
}
