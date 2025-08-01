import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  Database? _database;

  DatabaseHelper._init();
  static get instance => DatabaseHelper._init();

  Future<Database> get db async {
    if (_database != null) return _database!;
    final database = await _OpenDatabase();
    return database;
  }

  Future<Database> _OpenDatabase() async {
    final dbPath = join(await getDatabasesPath(), 'my_db.db');

    final database = openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) {
        _CreateDatabase(db, version);
      },
    );
    return database;
  }

  _CreateDatabase(Database db, int version) async {
    await db.execute('''
    create table sub_category(
    subCatId  integer not null,
    subCategory text not null
    )
''');

await db.execute('''
    create table book(
    id integer not null,
    authorId text not null,
    authorName text not null,
    bookName text not null,
    description text not null,
    imageUrl text not null,
    created_at integer not null,
    
    )
''');
  }
}
