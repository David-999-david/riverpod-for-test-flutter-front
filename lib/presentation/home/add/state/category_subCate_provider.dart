import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_test/data/book/model/category_sub_category.dart';
import 'package:riverpod_test/presentation/home/add/state/category_subCate_notifier.dart';

final cateSubCateProvider = StateNotifierProvider<CategorySubcateNotifier,
    AsyncValue<CategorySubCategory>>((ref) => CategorySubcateNotifier());
