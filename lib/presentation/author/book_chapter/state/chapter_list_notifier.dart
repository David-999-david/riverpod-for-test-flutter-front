import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_test/data/book/model/chapter_model.dart';
import 'package:riverpod_test/data/book/remote/book_remote.dart';

class ChapterListNotifier
    extends StateNotifier<AsyncValue<List<ReturnChapterModel>>> {
  ChapterListNotifier(this.ref, this.bookId) : super(AsyncValue.loading()) {
    getAllChapters();
  }

  final Ref ref;
  final int bookId;

  Future<void> getAllChapters() async {
    state = AsyncValue.loading();
    state = await AsyncValue.guard(() => BookRemote().getAllChapters(bookId));
  }
}
