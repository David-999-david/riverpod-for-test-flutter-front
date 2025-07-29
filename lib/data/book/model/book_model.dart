import 'package:intl/intl.dart';

class InsertBook {
  final String category;
  final List<String> subCategory;
  final String bookName;
  final String bookDesc;

  InsertBook(
      {required this.category,
      required this.subCategory,
      required this.bookName,
      required this.bookDesc});

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'subCategories': subCategory,
      'name': bookName,
      'description': bookDesc
    };
  }
}

class BookModel {
  final String authorName;
  final String category;
  final List<String> subCategory;
  final Book book;

  BookModel(
      {required this.authorName,
      required this.category,
      required this.subCategory,
      required this.book});

  factory BookModel.fromJson(Map<String, dynamic> json) {
    final book = json['book'] as Map<String, dynamic>;
    return BookModel(
        authorName: json['authorName'] as String,
        category: json['categoryName'] as String,
        subCategory: (json['subCateNames'] as List<dynamic>)
            .map((s) => s as String)
            .toList(),
        book: Book.fromJson(book));
  }
}

class Book {
  final int bookId;
  final String bookName;
  final String bookDesc;
  final String? imageUrl;

  Book(
      {required this.bookId,
      required this.bookName,
      required this.bookDesc,
      required this.imageUrl});

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
        bookId: json['id'] as int,
        bookName: json['name'] as String,
        bookDesc: json['description'] as String,
        imageUrl: json['image_url'] as String?);
  }
}

class ReturnBook {
  final int bookId;
  final String authorName;
  final String category;
  final List<String> subCategories;
  final String bookName;
  final String bookDesc;
  final String? imageUrl;
  final DateTime created;

  ReturnBook(
      {required this.bookId,
      required this.authorName,
      required this.category,
      required this.subCategories,
      required this.bookName,
      required this.bookDesc,
      required this.imageUrl,
      required this.created});

  String get formatedDate => DateFormat('yyyy-MM-dd HH:mm').format(created);

  factory ReturnBook.fromJson(Map<String, dynamic> json) {
    return ReturnBook(
        bookId: json['bookId'] as int,
        authorName: json['authorName'] as String,
        category: json['category'] as String,
        subCategories:
            List<String>.from(json['subCategories'] as List<dynamic>),
        bookName: json['bookName'] as String,
        bookDesc: json['bookDesc'] as String,
        imageUrl: json['imageUrl'] as String?,
        created: DateTime.parse(json['createdTime'] as String));
  }
}

