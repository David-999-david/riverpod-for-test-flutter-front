import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_test/data/book/model/book_model.dart';
import 'package:riverpod_test/data/book/remote/book_remote.dart';

class BookListNotifier extends StateNotifier<AsyncValue<List<ReturnBook>>> {
  BookListNotifier() : super(AsyncValue.loading()) {
    fetchAll();
  }

  Future<void> fetchAll() async {
    state = AsyncValue.loading();
    // try {
    //   final bookList = await BookRemote().fetchAllBooksAuthor();
    //   state = AsyncValue.data(bookList);
    // } catch (e, s) {
    //   state = AsyncValue.error(e, s);
    // }
    state = await AsyncValue.guard(() => BookRemote().fetchAllBooksAuthor());
  }
}
