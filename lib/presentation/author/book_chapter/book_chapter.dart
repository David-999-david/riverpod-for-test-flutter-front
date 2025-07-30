import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_test/data/book/model/book_model.dart';
import 'package:riverpod_test/main.dart';
import 'package:riverpod_test/presentation/author/book_chapter/create_chapter/create_chapter.dart';
import 'package:riverpod_test/theme/app_text_style.dart';

class BookChapter extends ConsumerStatefulWidget {
  const BookChapter({super.key, required this.book});
  final ReturnBook book;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BookChapterState();
}

class _BookChapterState extends ConsumerState<BookChapter> {
  @override
  Widget build(BuildContext context) {
    final book = widget.book;

    bool hasImage = book.imageUrl != null && book.imageUrl!.isNotEmpty;

    dynamic bg = hasImage
        ? Image.network(
            book.imageUrl!,
            fit: BoxFit.cover,
          )
        : Image.asset(
            'assets/images/c5.png',
            fit: BoxFit.cover,
          );

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            expandedHeight: 260,
            pinned: true,
            backgroundColor: Colors.black,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                        backgroundColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        side: BorderSide(color: Colors.black)),
                    onPressed: () {},
                    child: Text(
                      'Change Image',
                      style: 14.sp(color: Colors.white),
                    )),
              )
            ],
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: EdgeInsets.only(left: 15, bottom: 10),
              title: Text(
                book.bookName,
                style: 14.sp(color: Colors.white),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  bg,
                  DecoratedBox(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [Color(0xff), Color(0xff)],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter)))
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InputChip(
                    onPressed: () {},
                    backgroundColor: Colors.blue,
                    labelStyle: 14.sp(color: Colors.white),
                    label: Text(
                      book.category,
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(book.subCategories.length, (idx) {
                        final subCat = book.subCategories[idx];
                        return Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: InputChip(
                              onPressed: () {},
                              backgroundColor: Colors.grey,
                              labelStyle: 14.sp(color: Colors.white),
                              label: Text(
                                subCat.name,
                              )),
                        );
                      }),
                    ),
                  ),
                  Align(
                      alignment: Alignment.bottomRight,
                      child: TextButton.icon(
                          onPressed: () {
                            appnavigator
                                .push(CreateChapter(bookId: book.bookId));
                          },
                          icon: Icon(
                            Icons.add_box_outlined,
                            color: Colors.black,
                          ),
                          label: Text(
                            'Add new Chapter',
                            style: 13.sp(),
                          )))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
