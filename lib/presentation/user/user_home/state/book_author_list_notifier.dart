import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_test/data/user/model/author_model.dart';
import 'package:riverpod_test/data/user/remote/user_remote.dart';

class BookAuthorListNotifier
    extends StateNotifier<AsyncValue<PageWithBookList>> {
  BookAuthorListNotifier() : super(AsyncValue.loading()) {
    getAllAuthorsBooks();
  }

  final int _page = 1;
  final int _limit = 8;
  int totalCounts = 1;

  int get page => _page;
  int get limit => _limit;

  Future<void> getAllAuthorsBooks() async {
    state = AsyncValue.loading();
    final result = await AsyncValue.guard(
        () => UserRemote().getAllAuthorsBooks(_limit, _page));
    result.whenData((list) {
      totalCounts = list.totalCounts;
    });

    state = result;
  }
}
