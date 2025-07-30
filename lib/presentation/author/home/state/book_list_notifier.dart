import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_test/data/book/model/book_model.dart';
import 'package:riverpod_test/data/book/remote/book_remote.dart';

class BookListNotifier extends StateNotifier<AsyncValue<List<ReturnBook>>> {
  final int showLimit;
  final Ref ref;
  BookListNotifier(this.ref, this.showLimit) : super(AsyncValue.loading()) {
    fetchAll();
  }

  final int _page = 1;

  int get page => _page;

  Future<void> fetchAll() async {
    state = AsyncValue.loading();
    // try {
    //   final bookList = await BookRemote().fetchAllBooksAuthor();
    //   state = AsyncValue.data(bookList);
    // } catch (e, s) {
    //   state = AsyncValue.error(e, s);
    // }
    state = await AsyncValue.guard(
        () => BookRemote().fetchAllBooksAuthor(showLimit, page));
  }
}
