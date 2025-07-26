import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_test/data/user/model/author_model.dart';
import 'package:riverpod_test/presentation/user/author_detail/state/author_detail_notifier.dart';

final authDetailProvider = StateNotifierProvider.family<
    AuthorDetailNotifier,
    AsyncValue<TargetAuthor>,
    String>((ref, authorId) => AuthorDetailNotifier(ref, authorId));
