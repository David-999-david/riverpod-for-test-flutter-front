import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_test/data/user/model/author_model.dart';
import 'package:riverpod_test/presentation/user_home/state/author_list_notifier.dart';

final authorListProvider =
    StateNotifierProvider<AuthorListNotifier, AsyncValue<List<AuthorModel>>>(
        (ref) => AuthorListNotifier());
