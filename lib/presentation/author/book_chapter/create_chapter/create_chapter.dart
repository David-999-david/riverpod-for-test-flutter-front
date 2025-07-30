import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:riverpod_test/data/book/model/chapter_model.dart';
import 'package:riverpod_test/main.dart';
import 'package:riverpod_test/presentation/author/book_chapter/state/book_chapter_provider.dart';
import 'package:riverpod_test/theme/app_text_style.dart';

class CreateChapter extends ConsumerStatefulWidget {
  const CreateChapter({super.key, required this.bookId});

  final int bookId;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CreateChapterState();
}

class _CreateChapterState extends ConsumerState<CreateChapter> {
  final GlobalKey<FormState> key = GlobalKey<FormState>();

  late final TextEditingController chapterctl;
  late final TextEditingController title;
  late final TextEditingController content;

  @override
  void initState() {
    super.initState();
    chapterctl = TextEditingController();
    title = TextEditingController();
    content = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(createChpaterProvider(widget.bookId), (prev, next) {
      next.when(
          data: (chapter) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Create Chapter success!')));

            appnavigator.pop();
          },
          error: (error, _) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(error.toString())));
          },
          loading: () {});
    });

    final createState = ref.watch(createChpaterProvider(widget.bookId));

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
        child: Form(
            key: key,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                chapterField(chapterctl, 'Chapter'),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Text(
                    'Title',
                    style: 14.sp(),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                textField(title, 'Title', 'Title', 250, false),
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Text(
                    'Story',
                    style: 14.sp(),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Expanded(
                  child: textField(content, 'Write your story here ....',
                      'Content', 350, true),
                ),
                SizedBox(
                  height: 20,
                ),
                Center(
                    child: !createState.isLoading
                        ? ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                side: BorderSide(color: Colors.blue)),
                            onPressed: () {
                              if (!key.currentState!.validate()) return;
                              final InsertChapterModel chapter =
                                  InsertChapterModel(
                                      chapter: double.parse(chapterctl.text),
                                      title: title.text.trim().toUpperCase(),
                                      content: content.text.trim());
                              ref
                                  .read(createChpaterProvider(widget.bookId)
                                      .notifier)
                                  .createChapter(widget.bookId, chapter);
                            },
                            child: Text(
                              'Save',
                              style: 15.sp(),
                            ))
                        : Center(
                            child: SpinKitDualRing(
                              color: Colors.yellow,
                              size: 20,
                            ),
                          ))
              ],
            )),
      ),
    );
  }
}

Widget chapterField(TextEditingController ctrl, String hint) {
  return SizedBox(
      width: 150,
      child: TextFormField(
        controller: ctrl,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
            hintText: hint,
            hintStyle: 14.sp(),
            contentPadding: EdgeInsets.symmetric(horizontal: 5),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.blue))),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Chapter Number is require';
          }
          return null;
        },
      ));
}

Widget textField(TextEditingController ctrl, String hint, String label,
    double width, bool expand) {
  return SizedBox(
    width: width,
    child: TextFormField(
      maxLines: null,
      controller: ctrl,
      expands: expand,
      decoration: InputDecoration(
          filled: true,
          hintText: hint,
          hintStyle: 14.sp(),
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
        if (value == null || value.isEmpty) {
          return '$label is require';
        }
        return null;
      },
    ),
  );
}
