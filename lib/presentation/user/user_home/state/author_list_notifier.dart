import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_test/data/user/model/author_model.dart';
import 'package:riverpod_test/data/user/remote/user_remote.dart';
import 'package:riverpod_test/database/database_helper.dart';
import 'package:riverpod_test/local.dart';
import 'package:sqflite/sqflite.dart';

class AuthorListNotifier extends StateNotifier<AsyncValue<List<AuthorModel>>> {
  AuthorListNotifier() : super(AsyncValue.loading()) {
    getAllAuthors();
  }

  final FlutterSecureStorage storage = FlutterSecureStorage();

  Future<void> getAllAuthors() async {
    state = AsyncValue.loading();

    final db = await DatabaseHelper.instance.db;

    final local = await readDataBaseAuthor(db);

    state = AsyncValue.data(local);

    try {
      final authorList = await UserRemote().showAllAuthors();

      await updateDataBaseAuthor(db, authorList);

      final refresh = await readDataBaseAuthor(db);

      state = AsyncValue.data(refresh);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }

  Future<List<AuthorModel>> readDataBaseAuthor(Database db) async {
    final List<AuthorModel> authorList = <AuthorModel>[];

    final authorsMap = await db.query('author');

    if (authorsMap.isEmpty) return [];

    for (var a in authorsMap) {
      final authorMap = AuthorModel.fromMap(a);

      authorList.add(authorMap);
    }

    if (authorList.isNotEmpty) {
      print(
          'AuthorList from server is successfully added to sqflite and read success');
      await storage.write(key: Local.testsqflite, value: 'true');
    }

    return authorList;
  }

  Future<void> updateDataBaseAuthor(
      Database db, List<AuthorModel> authorList) async {
    final batch = await db.batch();

    for (var a in authorList) {
      batch.insert('author', a.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit(noResult: true);
  }
}
