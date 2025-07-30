import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_test/data/book/model/chapter_model.dart';
import 'package:riverpod_test/data/book/remote/book_remote.dart';

class CreateChapterNotifier
    extends StateNotifier<AsyncValue<ReturnChapterModel?>> {
  CreateChapterNotifier(this.ref, this.bookId) : super(AsyncValue.data(null));

  final Ref ref;
  final int bookId;

  Future<void> createChapter(int bookId, InsertChapterModel chapter) async {
    state = AsyncValue.loading();
    state = await AsyncValue.guard(
        () => BookRemote().createChapter(bookId, chapter));
  }
}
