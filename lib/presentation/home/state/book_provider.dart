import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_test/data/book/model/book_model.dart';
import 'package:riverpod_test/presentation/home/state/book_form_notifier.dart';
import 'package:riverpod_test/presentation/home/state/book_list_notifier.dart';

final bookCreateProvider =
    StateNotifierProvider<BookFormNotifier, AsyncValue<BookModel?>>(
        (ref) => BookFormNotifier());

final bookfetchProvider = StateNotifierProvider.autoDispose<BookListNotifier,
    AsyncValue<List<ReturnBook>>>((ref) => BookListNotifier());
