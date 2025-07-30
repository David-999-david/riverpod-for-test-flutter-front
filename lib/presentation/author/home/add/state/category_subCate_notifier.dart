import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_test/data/book/model/category_sub_category.dart';
import 'package:riverpod_test/data/book/remote/book_remote.dart';

class CategorySubcateNotifier
    extends StateNotifier<AsyncValue<CategorySubCategory>> {
  CategorySubcateNotifier() : super(AsyncValue.loading()) {
    fetchAllCateSubCate();
  }

  Future<void> fetchAllCateSubCate() async {
    state = AsyncValue.loading();
    try {
      final cateSubCate = await BookRemote().getAllCateSubCate();
      state = AsyncValue.data(cateSubCate);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }
}
