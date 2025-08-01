import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_test/data/user/model/user_info_mode.dart';
import 'package:riverpod_test/data/user/remote/user_remote.dart';
import 'package:riverpod_test/database/database_helper.dart';
import 'package:riverpod_test/local.dart';
import 'package:sqflite/sqflite.dart';

class UserinfoNotifier extends StateNotifier<AsyncValue<UserInfoMode>> {
  UserinfoNotifier() : super(AsyncValue.loading()) {
    getInfo();
  }

  final FlutterSecureStorage storage = FlutterSecureStorage();

  Future<void> getInfo() async {
    state = AsyncValue.loading();

    final db = await DatabaseHelper.instance.db;

    try {
      final local = await readDataBaseUser(db);

      state = AsyncValue.data(local);
    } catch (_) {}

    try {
      final user = await UserRemote().getUserInfo();

      await updateDatabaseUser(db, user);

      final refresh = await readDataBaseUser(db);

      state = AsyncValue.data(refresh);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }

  Future<UserInfoMode> readDataBaseUser(Database db) async {
    final UserInfoMode user;

    final userMaps = (await db.query('user'));

    if (userMaps.isEmpty) {
      throw StateError('No cached user');
    }

    final userMap = userMaps.first;

    final userLocal = UserLocal.fromMap(userMap);

    final roleMap = await db.query('role');

    final List<String> roles = [];
    for (var r in roleMap) {
      final roleLocal = Role.fromMap(r);

      roles.add(roleLocal.name);
    }

    final permMap = await db.query('permissions');

    final List<String> perms = [];

    for (var p in permMap) {
      final permLocal = Permission.fromMap(p);

      perms.add(permLocal.name);
    }

    user = UserInfoMode(
        name: userLocal.name,
        email: userLocal.email,
        role: roles,
        permissions: perms);

    if (user != null) {
      await storage.write(key: Local.testsqflite, value: 'true');
      print(
          'User of info like role and permission is saved to local sqflite table for each and can read them');
    }

    return user;
  }

  Future<void> updateDatabaseUser(Database db, UserInfoMode user) async {
    final batch = await db.batch();

    final userLocal = UserLocal(name: user.name, email: user.email);

    await db.insert('user', userLocal.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);

    final userFromLocal =
        (await db.query('user', where: 'name=?', whereArgs: [userLocal.name]))
            .first;

    final userIdLocal = UserLocal.fromMap(userFromLocal).id;

    batch.delete('role', where: 'user_id=?', whereArgs: [userIdLocal]);

    batch.delete('permissions', where: 'user_id=?', whereArgs: [userIdLocal]);

    for (var r in user.role) {
      final roleLocal = Role(userId: userIdLocal!, name: r);

      batch.insert('role', roleLocal.toMap());
    }

    for (var p in user.permissions) {
      final permLocal = Permission(userId: userIdLocal!, name: p);

      batch.insert('permissions', permLocal.toMap());
    }

    await batch.commit(noResult: true);
  }
}
