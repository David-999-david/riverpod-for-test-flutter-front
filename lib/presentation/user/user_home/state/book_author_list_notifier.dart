import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_test/data/user/model/author_model.dart';
import 'package:riverpod_test/data/user/remote/user_remote.dart';
import 'package:riverpod_test/database/database_helper.dart';
import 'package:riverpod_test/local.dart';
import 'package:sqflite/sqflite.dart';

class BookAuthorListNotifier
    extends StateNotifier<AsyncValue<List<BookWithAuthor>>> {
  BookAuthorListNotifier() : super(AsyncValue.loading()) {
    getAllAuthorsBooks();
  }

  final FlutterSecureStorage storage = FlutterSecureStorage();

  final int _page = 1;
  final int _limit = 8;
  int totalCounts = 1;

  int get page => _page;
  int get limit => _limit;

  Future<void> getAllAuthorsBooks() async {
    state = AsyncValue.loading();

    final db = await DatabaseHelper.instance.db;

    final local = await readDBBook(db);

    state = AsyncValue.data(local);

    try {
      final page = await UserRemote().getAllAuthorsBooks(_limit, _page);
      totalCounts = page.totalCounts;

      await updateDBBook(page, db);

      final refresh = await readDBBook(db);
      state = AsyncValue.data(refresh);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }

  Future<List<BookWithAuthor>> readDBBook(Database db) async {
    final List<BookWithAuthor> result = <BookWithAuthor>[];

    final bookrows = await db.query('book');

    for (var b in bookrows) {
      final bookLocal = BookLocal.fromLocal(b);

      final categorymap = (await db.query('category',
              where: 'id=?', whereArgs: [bookLocal.categoryId]))
          .first;

      final categoryLocal = CategoryLocal.fromMap(categorymap);

      final subIdsmap = await db.query('book_sub_category',
          where: 'book_id=?', whereArgs: [bookLocal.bookId]);

      final List<ReturnSubCategory> sub = <ReturnSubCategory>[];
      for (var sId in subIdsmap) {
        final submap = (await db.query('sub_category',
                where: 'id=?', whereArgs: [sId['sub_category_id']]))
            .first;

        final subLocal = ReturnSubCategoryLocal.fromMap(submap);

        sub.add(ReturnSubCategory(
            subCatId: subLocal.subCatId, subCategory: subLocal.subCategory));
      }

      result.add(BookWithAuthor(
          authorId: bookLocal.authorId,
          authorName: bookLocal.authorName,
          bookId: bookLocal.bookId,
          bookName: bookLocal.bookName,
          description: bookLocal.description,
          imageUrl: bookLocal.imageUrl,
          createdAt: bookLocal.createdAt,
          subCategories: sub,
          categoryId: categoryLocal.id,
          category: categoryLocal.name));
    }

    if (result.isNotEmpty) {
      await storage.write(key: Local.testsqflite, value: 'true');
      print('Sqflite reader is work normal and set testsqflite is to true');
    }

    return result;
  }

  Future<void> updateDBBook(PageWithBookList page, Database db) async {
    final books = page.books;

    final batch = db.batch();

    for (var b in books) {
      final categoryLocal = CategoryLocal(id: b.categoryId, name: b.category);

      batch.insert('category', categoryLocal.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);

      final localBook = BookLocal(
          authorId: b.authorId,
          authorName: b.authorName,
          bookId: b.bookId,
          bookName: b.bookName,
          description: b.description,
          imageUrl: b.imageUrl,
          createdAt: b.createdAt,
          categoryId: b.categoryId);

      batch.insert('book', localBook.toLocal(),
          conflictAlgorithm: ConflictAlgorithm.replace);

      for (var sc in b.subCategories) {
        batch.insert('book_sub_category',
            {'book_id': b.bookId, 'sub_category_id': sc.subCatId},
            conflictAlgorithm: ConflictAlgorithm.replace);

        final subLocal = ReturnSubCategoryLocal(
            subCatId: sc.subCatId, subCategory: sc.subCategory);

        batch.insert('sub_category', subLocal.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace);
      }
    }

    await batch.commit(noResult: true);
  }
}
