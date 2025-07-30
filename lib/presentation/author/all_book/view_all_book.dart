import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:riverpod_test/main.dart';
import 'package:riverpod_test/presentation/author/book_chapter/book_chapter.dart';
import 'package:riverpod_test/presentation/author/home/home_screen.dart';
import 'package:riverpod_test/presentation/author/home/state/book_provider.dart';
import 'package:riverpod_test/theme/app_text_style.dart';

class ViewAllBook extends ConsumerStatefulWidget {
  const ViewAllBook({super.key});

  @override
  ConsumerState<ViewAllBook> createState() => _ViewAllBookState();
}

class _ViewAllBookState extends ConsumerState<ViewAllBook> {
  @override
  Widget build(BuildContext context) {
    final fetchState = ref.watch(bookfetchProvider(100));

    final books = fetchState.value;

    return Scaffold(
      body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: fetchState.isLoading
              ? Center(
                  child: SpinKitDualRing(
                    color: Colors.yellow,
                    size: 25,
                  ),
                )
              : books != null && books.isNotEmpty
                  ? GridView.builder(
                      itemCount: books.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 20,
                          mainAxisExtent: 240),
                      itemBuilder: (context, index) {
                        final book = books[index];
                        return bookItemAuthor(book, () {
                          appnavigator.push(BookChapter(
                            book: books[index],
                          ));
                        });
                      },
                    )
                  : Center(
                      child: Text(
                        'Nothing for show',
                        style: 16.sp(),
                      ),
                    )),
    );
  }
}
