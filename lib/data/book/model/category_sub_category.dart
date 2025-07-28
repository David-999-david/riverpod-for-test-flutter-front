class CategoryModel {
  final int id;
  final String name;

  CategoryModel({required this.id, required this.name});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(id: json['categoryId'], name: json['category']);
  }
}

class SubCategoryModel {
  final int id;
  final int cateId;
  final String name;

  SubCategoryModel(
      {required this.id, required this.cateId, required this.name});

  factory SubCategoryModel.fromJson(Map<String, dynamic> json) {
    return SubCategoryModel(
        id: json['subCateId'], cateId: json['catId'], name: json['subCate']);
  }
}

class CategorySubCategory {
  final List<CategoryModel> categories;
  final List<SubCategoryModel> subCategories;

  CategorySubCategory({required this.categories, required this.subCategories});

  factory CategorySubCategory.fromJson(Map<String, dynamic> json) {
    final categories = (json['categories'] as List<dynamic>)
        .map((c) => CategoryModel.fromJson(c))
        .toList();

    final subCategories = (json['subcategories'] as List<dynamic>)
        .map((s) => SubCategoryModel.fromJson(s))
        .toList();

    return CategorySubCategory(
        categories: categories, subCategories: subCategories);
  }
}
