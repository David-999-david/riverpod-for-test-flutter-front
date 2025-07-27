import 'package:intl/intl.dart';

class AuthorModel {
  final String id;
  final String name;

  AuthorModel({required this.id, required this.name});

  factory AuthorModel.fromJson(Map<String, dynamic> json) {
    return AuthorModel(
        id: json['authorId'] as String, name: json['authorName'] as String);
  }
}

class BookWithAuthor {
  final String authorId;
  final String authorName;
  final int bookId;
  final String bookName;
  final String description;
  final String? imageUrl;
  final DateTime createdAt;
  final int subCatId;
  final String subCategory;
  final int categoryId;
  final String category;

  BookWithAuthor(
      {required this.authorId,
      required this.authorName,
      required this.bookId,
      required this.bookName,
      required this.description,
      required this.imageUrl,
      required this.createdAt,
      required this.subCatId,
      required this.subCategory,
      required this.categoryId,
      required this.category});

  String get formated => DateFormat('yyyy-MM-dd HH:mm').format(createdAt);

  factory BookWithAuthor.fromJson(Map<String, dynamic> json) {
    return BookWithAuthor(
        authorId: json['authorId'] as String,
        authorName: json['authorName'] as String,
        bookId: json['bookId'] as int,
        bookName: json['bookName'] as String,
        description: json['description'] as String,
        imageUrl: json['imageUrl'] as String?,
        createdAt: DateTime.parse(json['createdAt']),
        subCatId: json['subCatId'] as int,
        subCategory: json['subCategory'] as String,
        categoryId: json['categoryId'] as int,
        category: json['category'] as String);
  }
}

class TargetAuthor {
  final String authorId;
  final String authorName;
  final List<TargetAuthorBook> books;

  TargetAuthor(
      {required this.authorId, required this.authorName, required this.books});

  factory TargetAuthor.fromJson(Map<String, dynamic> json) {
    final books = (json['books'] as List<dynamic>)
        .map((b) => TargetAuthorBook.fromJson(b))
        .toList();

    return TargetAuthor(
        authorId: json['authorId'],
        authorName: json['authorName'],
        books: books);
  }
}

class TargetAuthorBook {
  final int bookId;
  final String bookName;
  final String description;
  final String? imageUrl;
  final DateTime createdAt;
  final int subCatId;
  final String subCategory;
  final int categoryId;
  final String category;

  TargetAuthorBook(
      {required this.bookId,
      required this.bookName,
      required this.description,
      required this.imageUrl,
      required this.createdAt,
      required this.subCatId,
      required this.subCategory,
      required this.categoryId,
      required this.category});

  String get formated => DateFormat('yyyy-MM-dd HH:mm').format(createdAt);

  factory TargetAuthorBook.fromJson(Map<String, dynamic> json) {
    return TargetAuthorBook(
        bookId: json['bookId'],
        bookName: json['bookName'],
        description: json['description'],
        imageUrl: json['imageUrl'] as String?,
        createdAt: DateTime.parse(json['createdAt']),
        subCatId: json['subCatId'],
        subCategory: json['subCategory'],
        categoryId: json['categoryId'],
        category: json['category']);
  }
}
