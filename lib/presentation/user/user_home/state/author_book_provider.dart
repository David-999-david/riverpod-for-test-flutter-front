import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_test/data/user/model/author_model.dart';
import 'package:riverpod_test/presentation/user/user_home/state/author_list_notifier.dart';
import 'package:riverpod_test/presentation/user/user_home/state/book_author_list_notifier.dart';

final authorListProvider =
    StateNotifierProvider<AuthorListNotifier, AsyncValue<List<AuthorModel>>>(
        (ref) => AuthorListNotifier());

final bookAuthorListProvier = StateNotifierProvider<BookAuthorListNotifier,
    AsyncValue<List<BookWithAuthor>>>((ref) => BookAuthorListNotifier());
