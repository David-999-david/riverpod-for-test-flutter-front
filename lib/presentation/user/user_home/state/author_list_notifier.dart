import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_test/data/user/model/author_model.dart';
import 'package:riverpod_test/data/user/remote/user_remote.dart';

class AuthorListNotifier extends StateNotifier<AsyncValue<List<AuthorModel>>> {
  AuthorListNotifier() : super(AsyncValue.loading()) {
    getAllAuthors();
  }

  Future<void> getAllAuthors() async {
    state = AsyncValue.loading();
    // try {
    //   final authorList = await UserRemote().showAllAuthors();
    //   state = AsyncValue.data(authorList);
    // } catch (e, s) {
    //   state = AsyncValue.error(e, s);
    // }
    state = await AsyncValue.guard(() => UserRemote().showAllAuthors());
  }
}
