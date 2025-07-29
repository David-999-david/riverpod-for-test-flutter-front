import 'dart:io';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_test/data/book/model/book_model.dart';
import 'package:riverpod_test/data/book/model/category_sub_category.dart';
import 'package:riverpod_test/main.dart';
import 'package:riverpod_test/presentation/home/add/state/category_subCate_provider.dart';
import 'package:riverpod_test/presentation/home/add/state/pick_image_provider.dart';
import 'package:riverpod_test/presentation/home/state/book_provider.dart';
import 'package:riverpod_test/theme/app_text_style.dart';

class CreateBook extends ConsumerStatefulWidget {
  const CreateBook({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CreateBookState();
}

class _CreateBookState extends ConsumerState<CreateBook> {
  final GlobalKey<FormState> key = GlobalKey<FormState>();

  final FocusNode node = FocusNode();

  late final TextEditingController category;
  late final TextEditingController subCategory;
  late final TextEditingController bookName;
  late final TextEditingController bookDesc;

  @override
  void initState() {
    super.initState();
    category = TextEditingController();
    subCategory = TextEditingController();
    subCategory.addListener(() {
      setState(() {});
    });
    bookName = TextEditingController();
    bookDesc = TextEditingController();
  }

  CategoryModel? selectedCategory;

  SubCategoryModel? selectedSub;

  List<String> confirmSubList = [];

  void getSubCate(String sub) {
    confirmSubList.add(sub);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<BookModel?>>(bookCreateProvider, (prev, next) {
      next.when(
          data: (book) {
            ref.read(pickimageProvider.notifier).clear();
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text('A new book created')));

            ref.read(bookfetchProvider.notifier).fetchAll();

            appnavigator.pop();
          },
          error: (error, _) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(error.toString())));
          },
          loading: () {});
    });

    final createState = ref.watch(bookCreateProvider);

    final pickImageState = ref.watch(pickimageProvider);
    final pickImage = pickImageState;

    bool hasPickImage = pickImage != null;

    // final catSubCatState = ref.watch(cateSubCateProvider);

    // if (catSubCatState.isLoading) {
    //   return Center(
    //     child: SpinKitDualRing(
    //       color: Colors.yellow,
    //       size: 15,
    //     ),
    //   );
    // }

    // final catSubCat = catSubCatState.value!;

    // final List<CategoryModel> categoryList = catSubCat.categories;

    // final List<SubCategoryModel> subCategoryList = catSubCat.subCategories;

    // final filterSub = (selectedCategory == null)
    //     ? subCategoryList
    //     : subCategoryList
    //         .where((s) => s.cateId == selectedCategory!.id)
    //         .toList();

    dynamic bg = hasPickImage
        ? FileImage(
            File(pickImage.path),
          )
        : AssetImage('assets/images/c5.png');

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          Color(0xff093028).withOpacity(0.6),
          Color(0xff237A57).withOpacity(0.8)
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: Center(
          child: Form(
              key: key,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                height: 240,
                                width: 190,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    image: DecorationImage(
                                        image: bg, fit: BoxFit.cover))),
                            SizedBox(
                              width: 20,
                            ),
                            Column(
                              children: [
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        fixedSize: Size(110, 30),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 3),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8))),
                                    onPressed: () {
                                      ref
                                          .read(pickimageProvider.notifier)
                                          .onPickImage(ImageSource.gallery);
                                    },
                                    child: Text(
                                      'From Gallery',
                                      style: 14.sp(),
                                    )),
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        fixedSize: Size(110, 30),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 3),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8))),
                                    onPressed: () {
                                      ref
                                          .read(pickimageProvider.notifier)
                                          .onPickImage(ImageSource.camera);
                                    },
                                    child: Text(
                                      'Camera',
                                      style: 14.sp(),
                                    ))
                              ],
                            )
                          ]),
                      SizedBox(
                        height: 20,
                      ),
                      // catSubCatState.isLoading
                      //     ? SpinKitDualRing(
                      //         color: Colors.yellow,
                      //         size: 10,
                      //       )
                      //     : Row(
                      //         mainAxisSize: MainAxisSize.min,
                      //         children: [
                      //           Expanded(
                      //               child: categoryDropdownSearch(
                      //                   categoryList,
                      //                   selectedCategory,
                      //                   (c) => setState(() {
                      //                         selectedCategory = c;
                      //                         category.text = selectedCategory!
                      //                             .name
                      //                             .toUpperCase();
                      //                         selectedSub = null;
                      //                       }))),
                      //           SizedBox(
                      //             width: 10,
                      //           ),
                      //           Expanded(
                      //               child: subCategoryDropDownSearch(
                      //                   filterSub,
                      //                   selectedSub,
                      //                   (s) => setState(() {
                      //                         selectedSub = s;
                      //                         subCategory.text = selectedSub!
                      //                             .name
                      //                             .toUpperCase();
                      //                       })))
                      //         ],
                      //       ),
                      // SizedBox(
                      //   height: 10,
                      // ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              child: _textformfield(
                                  category, 'Category', 1, 'Category')),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                              child: _subCatTextformfield(
                                  subCategory,
                                  'Sub-category',
                                  1,
                                  'Sub-category',
                                  getSubCate,
                                  confirmSubList)),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      confirmSubList.isNotEmpty
                          ? Wrap(
                              alignment: WrapAlignment.start,
                              spacing: 5,
                              runSpacing: 5,
                              children: confirmSubList.map((s) {
                                return InputChip(
                                  onDeleted: () {
                                    confirmSubList.remove(s);
                                    setState(() {});
                                  },
                                  label: Text(
                                    s,
                                  ),
                                  labelStyle: 14.sp(color: Colors.black),
                                  side: BorderSide(color: Colors.black),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                );
                              }).toList(),
                            )
                          : Center(
                              child: Text(
                                'Please confirm your add sub-categories in Sub-Category Text Field',
                                style: 12.sp(color: Colors.white),
                              ),
                            ),
                      SizedBox(
                        height: 10,
                      ),
                      _textformfield(bookName, 'Book-name', 2, 'Book-name'),
                      SizedBox(
                        height: 10,
                      ),
                      _textformfield(
                          bookDesc, 'Book-description', 4, 'Book-description'),
                      SizedBox(
                        height: 20,
                      ),
                      createState.isLoading
                          ? SpinKitDualRing(
                              color: Colors.yellow,
                              size: 20,
                            )
                          : Center(
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 3),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      side: BorderSide(color: Colors.blue)),
                                  onPressed: () async {
                                    if (!key.currentState!.validate()) return;

                                    final InsertBook insertBook = InsertBook(
                                        category:
                                            category.text.trim().toUpperCase(),
                                        subCategory: confirmSubList,
                                        bookName: bookName.text.trim(),
                                        bookDesc: bookDesc.text.trim());

                                    ref
                                        .read(bookCreateProvider.notifier)
                                        .createBook(insertBook, pickImage);
                                  },
                                  child: Text(
                                    'Confirm',
                                    style: 12.sp(),
                                  )),
                            )
                    ],
                  ),
                ),
              )),
        ),
      ),
    );
  }
}

Widget _textformfield(
    TextEditingController ctrl, String hint, int maxLine, String label) {
  return TextFormField(
    controller: ctrl,
    maxLines: maxLine,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    style: 15.sp(),
    decoration: InputDecoration(
        hintText: hint,
        hintStyle: 15.sp(),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.black)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.blue)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.black))),
    validator: (value) {
      if (value == null || value.isEmpty) return '$label must not be empty';
      return null;
    },
  );
}

Widget _subCatTextformfield(
    TextEditingController ctrl,
    String hint,
    int maxLine,
    String label,
    ValueChanged<String> onChanged,
    List<String> confirmSubList) {
  return TextFormField(
    controller: ctrl,
    maxLines: maxLine,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    style: 15.sp(),
    decoration: InputDecoration(
        hintText: hint,
        hintStyle: 15.sp(),
        filled: true,
        fillColor: Colors.white,
        suffixIcon: ctrl.text.isNotEmpty
            ? IconButton(
                onPressed: () {
                  onChanged(ctrl.text.toUpperCase());
                  ctrl.clear();
                },
                icon: Icon(Icons.arrow_right))
            : null,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.black)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.blue)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.black))),
    validator: (value) {
      if (confirmSubList.isEmpty) return 'Make a tap on icon for confirm';
      return null;
    },
  );
}

Widget categoryDropdownSearch(List<CategoryModel> categories,
    CategoryModel? selected, ValueChanged<CategoryModel?> onChanged) {
  return DropdownSearch<CategoryModel>(
    items: (String filter, _) {
      if (filter.isEmpty) return categories;
      return categories
          .where((c) => c.name.toLowerCase().contains(filter.toLowerCase()))
          .toList();
    },
    dropdownBuilder: (context, selectedItem) {
      if (selectedItem == null) return SizedBox.shrink();
      return Text(
        selectedItem.name.toUpperCase(),
        style: 14.sp(),
      );
    },
    selectedItem: selected,
    onChanged: onChanged,
    decoratorProps: DropDownDecoratorProps(
        decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: 'Tap to select Category',
            hintStyle: 14.sp(),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8))),
    popupProps: PopupProps.menu(
      showSearchBox: true,
      searchFieldProps: TextFieldProps(
          decoration: InputDecoration(
              hintText: 'Search categories...',
              hintStyle: 14.sp(),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.blue)),
              contentPadding: EdgeInsets.all(8))),
      itemBuilder: (context, item, isDisabled, isSelected) {
        return ListTile(
          selected: isSelected,
          title: Text(
            item.name.toUpperCase(),
            style: 14.sp(),
          ),
        );
      },
      emptyBuilder: (context, _) {
        return Center(
          child: Text('No categories found'),
        );
      },
      loadingBuilder: (context, _) {
        return Center(
          child: SpinKitDualRing(
            color: Colors.yellow,
            size: 10,
          ),
        );
      },
    ),
    itemAsString: (item) {
      return item.name;
    },
    compareFn: (item1, item2) => item1.id == item2.id,
  );
}

Widget subCategoryDropDownSearch(List<SubCategoryModel> subCategories,
    SubCategoryModel? selected, ValueChanged<SubCategoryModel?> onChanged) {
  return DropdownSearch<SubCategoryModel>(
    items: (String filter, _) {
      if (filter.isEmpty) return subCategories;
      return subCategories
          .where((s) => s.name.toLowerCase().contains(filter.toLowerCase()))
          .toList();
    },
    dropdownBuilder: (context, selectedItem) {
      if (selectedItem == null) return SizedBox.shrink();
      return Text(
        selectedItem.name.toUpperCase(),
        style: 14.sp(),
      );
    },
    selectedItem: selected,
    onChanged: onChanged,
    decoratorProps: DropDownDecoratorProps(
      decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: 'Select a Sub-category',
          hintStyle: 14.sp(),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
    ),
    popupProps: PopupProps.menu(
      showSearchBox: true,
      searchFieldProps: TextFieldProps(
          decoration: InputDecoration(
              hintText: 'Search Sub-category...',
              hintStyle: 14.sp(),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.blue)))),
      itemBuilder: (context, item, isDisabled, isSelected) {
        return ListTile(
          selected: isSelected,
          title: Text(
            item.name.toUpperCase(),
            style: 14.sp(),
          ),
        );
      },
      emptyBuilder: (context, searchEntry) {
        return Center(
          child: Text('No Sub-Category found'),
        );
      },
      loadingBuilder: (context, searchEntry) {
        return Center(
          child: SpinKitDualRing(
            color: Colors.yellow,
            size: 15,
          ),
        );
      },
    ),
    itemAsString: (item) => item.name,
    compareFn: (item1, item2) => item1.id == item2.id,
  );
}
