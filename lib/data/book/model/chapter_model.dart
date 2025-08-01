import 'package:intl/intl.dart';

class InsertChapterModel {
  final double chapter;
  final String title;
  final String content;

  InsertChapterModel(
      {required this.chapter, required this.title, required this.content});

  Map<String, dynamic> toJson() {
    return {'chapter': chapter, 'title': title, 'content': content};
  }
}

class ReturnChapterModel {
  final int id;
  final String authorId;
  final int bookId;
  final double chapterNum;
  final String title;
  final String content;
  final DateTime createdAt;
  final String status;

  ReturnChapterModel(
      {required this.id,
      required this.authorId,
      required this.bookId,
      required this.chapterNum,
      required this.title,
      required this.content,
      required this.createdAt,
      required this.status});

  String numFormat(double chapterNum) =>
      NumberFormat('#.##').format(chapterNum);

  factory ReturnChapterModel.fromJson(Map<String, dynamic> json) {
    return ReturnChapterModel(
        id: json['id'],
        authorId: json['author_id'],
        bookId: json['book_id'],
        chapterNum: double.parse(json['chapter'].toString()),
        title: json['title'],
        content: json['content'],
        createdAt: DateTime.parse(json['created_at']),
        status: json['status']);
  }
}
