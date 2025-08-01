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

class PageWithBookList {
  final List<BookWithAuthor> books;
  final int totalCounts;
  final int totalPage;

  PageWithBookList(
      {required this.books,
      required this.totalCounts,
      required this.totalPage});

  factory PageWithBookList.fromJson(Map<String, dynamic> json) {
    final books = (json['books'] as List<dynamic>)
        .map((b) => BookWithAuthor.fromJson(b))
        .toList();
    return PageWithBookList(
        books: books,
        totalCounts: json['totalCounts'],
        totalPage: json['totalPage']);
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
  final List<ReturnSubCategory> subCategories;
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
      required this.subCategories,
      required this.categoryId,
      required this.category});

  String get formated => DateFormat('yyyy-MM-dd HH:mm').format(createdAt);

  factory BookWithAuthor.fromJson(Map<String, dynamic> json) {
    final subCategories = (json['subCategories'] as List<dynamic>)
        .map((s) => ReturnSubCategory.fromJson(s))
        .toList();
    return BookWithAuthor(
        authorId: json['authorId'] as String,
        authorName: json['authorName'] as String,
        bookId: json['bookId'] as int,
        bookName: json['bookName'] as String,
        description: json['description'] as String,
        imageUrl: json['imageUrl'] as String?,
        createdAt: DateTime.parse(json['createdAt']),
        subCategories: subCategories,
        categoryId: json['categoryId'] as int,
        category: json['category'] as String);
  }

  // Map<String, dynamic> toLocal() {
  //   return {
  //     'id': bookId,
  //     'authorId': authorId,
  //     'authorName': authorName,
  //     'bookName': bookName,
  //     'description': description,
  //     'imageUrl': imageUrl,
  //     'created_at': createdAt.millisecondsSinceEpoch
  //   };
  // }

  // factory BookWithAuthor.fromLocal(Map<String,dynamic> map){
  //   BookWithAuthor(
  //     authorId: authorId, 
  //     authorName: authorName, 
  //     bookId: bookId, 
  //     bookName: bookName, 
  //     description: description, 
  //     imageUrl: imageUrl, 
  //     createdAt: createdAt, subCategories: subCategories, categoryId: categoryId, category: category)
  // }
}

class ReturnSubCategory {
  final int subCatId;
  final String subCategory;

  ReturnSubCategory({required this.subCatId, required this.subCategory});

  factory ReturnSubCategory.fromJson(Map<String, dynamic> json) {
    return ReturnSubCategory(
        subCatId: json['subCatId'], subCategory: json['subCategory']);
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
  final int? categoryId;
  final String? category;
  final List<SubModel> subCategories;

  TargetAuthorBook(
      {required this.bookId,
      required this.bookName,
      required this.description,
      required this.imageUrl,
      required this.createdAt,
      required this.categoryId,
      required this.category,
      required this.subCategories});

  String get formated => DateFormat('yyyy-MM-dd HH:mm').format(createdAt);

  factory TargetAuthorBook.fromJson(Map<String, dynamic> json) {
    final subCategories = (json['subCategories'] as List<dynamic>)
        .map((e) => SubModel.fromJson(e))
        .toList();
    return TargetAuthorBook(
        bookId: json['bookId'],
        bookName: json['bookName'],
        description: json['description'],
        imageUrl: json['imageUrl'] as String?,
        createdAt: DateTime.parse(json['createdAt']),
        categoryId: json['categoryId'] as int?,
        category: json['category'] as String?,
        subCategories: subCategories);
  }
}

class SubModel {
  final int subCatId;
  final String subCategory;

  SubModel({required this.subCatId, required this.subCategory});

  factory SubModel.fromJson(Map<String, dynamic> json) {
    return SubModel(
        subCatId: json['subCatId'], subCategory: json['subCategory']);
  }
}
