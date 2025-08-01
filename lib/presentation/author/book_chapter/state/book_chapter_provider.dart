import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_test/data/book/model/chapter_model.dart';
import 'package:riverpod_test/presentation/author/book_chapter/create_chapter/state/create_chapter_notifier.dart';
import 'package:riverpod_test/presentation/author/book_chapter/state/chapter_list_notifier.dart';

final createChpaterProvider = StateNotifierProvider.family<
    CreateChapterNotifier,
    AsyncValue<ReturnChapterModel?>,
    int>((ref, bookId) => CreateChapterNotifier(ref, bookId));

final getAllChapterProvider = StateNotifierProvider.family<
    ChapterListNotifier,
    AsyncValue<List<ReturnChapterModel>>,
    int>((ref, bookId) => ChapterListNotifier(ref, bookId));
