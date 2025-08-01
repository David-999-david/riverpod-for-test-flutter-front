import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  Database? _database;

  static final DatabaseHelper instance = DatabaseHelper._init();

  DatabaseHelper._init();

  Future<Database> get db async {
    if (_database != null) return _database!;
    _database = await _OpenDatabase();
    return _database!;
  }

  Future<Database> _OpenDatabase() async {
    final dbPath = join(await getDatabasesPath(), 'my_db.db');

    final database = openDatabase(
      dbPath,
      version: 3,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_key = ON');
      },
      onCreate: (db, version) async {
        await _CreateDatabase(db, version);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        await _updateDatabase(db, oldVersion, newVersion);
      },
    );
    return database;
  }

  _CreateDatabase(Database db, int version) async {
    await db.execute('''
    create table category(
    id integer primary key,
    name text not null);
''');

    await db.execute('''
    create table sub_category(
    id  integer primary key,
    name text not null
    );
''');

    await db.execute('''
    create table book(
    id integer primary key,
    authorId text not null,
    authorName text not null,
    bookName text not null,
    description text not null,
    imageUrl text,
    created_at integer not null,
    category_id integer not null,
    foreign key (category_id) references category(id)
    );
''');

    await db.execute('''
    create table book_sub_category(
    book_id integer not null,
    sub_category_id integer not null,
    primary key (book_id,sub_category_id),
    foreign key (book_id) references book(id) on delete cascade,
    foreign key (sub_category_id) references sub_category(id) on delete cascade
    );
''');

    if (version >= 2) {
      await db.execute('''
      create table user(
      id integer primary key autoincrement,
      name text not null,
      email text not null
      );
''');
      await db.execute('''
    create table role(
    id integer primary key autoincrement,
    user_id integer not null,
    name text not null,
    foreign key (user_id) references user(id) on delete cascade
    );
''');
      await db.execute('''
    create table permissions(
    id integer primary key autoincrement,
    user_id integer not null,
    name text not null,
    foreign key (user_id) references user(id) on delete cascade
    );
''');
    }
    if (version >= 3) {
      await db.execute('''
      create table author(
      id text primary key,
      name text not null
      )
''');
    }
  }

  _updateDatabase(Database db, int ov, int nv) async {
    if (ov < 2) {
      await db.execute('''
      create table user(
      id integer primary key autoincrement,
      name text not null,
      email text not null
      );
''');
      await db.execute('''
    create table role(
    id integer primary key autoincrement,
    user_id integer not null,
    name text not null,
    foreign key (user_id) references user(id) on delete cascade
    );
''');
      await db.execute('''
    create table permissions(
    id integer primary key autoincrement,
    user_id integer not null,
    name text not null,
    foreign key (user_id) references user(id) on delete cascade
    );
''');
    }
    if (ov < 3) {
      await db.execute('''
      create table author(
      id text primary key,
      name text not null
      )
''');
    }
  }
}
