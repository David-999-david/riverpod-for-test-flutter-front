import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_test/data/book/model/book_model.dart';
import 'package:riverpod_test/data/book/remote/book_remote.dart';

class BookFormNotifier extends StateNotifier<AsyncValue<BookModel?>> {
  BookFormNotifier() : super(AsyncValue.data(null));

  Future<void> createBook(InsertBook book) async {
    state = AsyncValue.loading();
    // try {
    //   final createdBook = await BookRemote().insertBook(book);
    //   state = AsyncValue.data(createdBook);
    // } catch (e, s) {
    //   state = AsyncValue.error(e, s);
    // }
    state = await AsyncValue.guard(() => BookRemote().insertBook(book));
  }
}
