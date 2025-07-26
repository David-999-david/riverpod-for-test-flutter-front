import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_test/data/user/model/author_model.dart';
import 'package:riverpod_test/data/user/remote/user_remote.dart';

class BookAuthorListNotifier
    extends StateNotifier<AsyncValue<List<BookWithAuthor>>> {
  BookAuthorListNotifier() : super(AsyncValue.loading()) {
    getAllAuthorsBooks();
  }

  Future<void> getAllAuthorsBooks() async {
    state = AsyncValue.loading();
    // try {
    //   final list = await UserRemote().getAllAuthorsBooks();
    //   state = AsyncValue.data(list);
    // }
    // catch (e,s){
    //   state = AsyncValue.error(e, s);
    // }
    state = await AsyncValue.guard(() => UserRemote().getAllAuthorsBooks());
  }
}
