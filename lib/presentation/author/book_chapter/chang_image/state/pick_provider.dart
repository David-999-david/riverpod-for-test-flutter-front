import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_test/presentation/author/book_chapter/chang_image/state/change_book_image_notifier.dart';
import 'package:riverpod_test/presentation/author/book_chapter/chang_image/state/pick_notifier.dart';

final pickProvider =
    StateNotifierProvider<PickNotifier, XFile?>((ref) => PickNotifier());

final changeProvider = StateNotifierProvider.family<
    ChangeBookImageNotifier,
    AsyncValue<String?>,
    int>((ref, bookId) => ChangeBookImageNotifier(ref, bookId));
