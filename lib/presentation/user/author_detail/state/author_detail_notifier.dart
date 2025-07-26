import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_test/data/user/model/author_model.dart';
import 'package:riverpod_test/data/user/remote/user_remote.dart';

class AuthorDetailNotifier extends StateNotifier<AsyncValue<TargetAuthor>> {
  final Ref ref;
  final String authorId;
  AuthorDetailNotifier(this.ref, this.authorId) : super(AsyncValue.loading()) {
    getBooksByAuthor();
  }

  Future<void> getBooksByAuthor() async {
    state = AsyncValue.loading();
    // try {
    //   final data = await UserRemote().getBooksByAuthor(authorId);
    //   state = AsyncValue.data(data);
    // } catch (e, s) {
    //   state = AsyncValue.error(e, s);
    // }
    state =
        await AsyncValue.guard(() => UserRemote().getBooksByAuthor(authorId));
  }
}
