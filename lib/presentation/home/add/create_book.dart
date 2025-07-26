import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_test/data/book/model/book_model.dart';
import 'package:riverpod_test/main.dart';
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
    bookName = TextEditingController();
    bookDesc = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<BookModel?>>(bookCreateProvider, (prev, next) {
      next.when(
          data: (book) {
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
                              child: _textformfield(subCategory, 'Sub-category',
                                  1, 'Sub-category')),
                        ],
                      ),
                      SizedBox(
                        height: 20,
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
                          : ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 3),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                  side: BorderSide(color: Colors.blue)),
                              onPressed: () {
                                if (!key.currentState!.validate()) return;
                                ref
                                    .read(bookCreateProvider.notifier)
                                    .createBook(InsertBook(
                                        category: category.text.trim(),
                                        subCategory: subCategory.text.trim(),
                                        bookName: bookName.text.trim(),
                                        bookDesc: bookDesc.text.trim()));
                              },
                              child: Text(
                                'Confirm',
                                style: 12.sp(),
                              ))
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
    },
  );
}
