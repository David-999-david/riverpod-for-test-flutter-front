import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:riverpod_test/data/book/model/book_model.dart';
import 'package:riverpod_test/data/book/model/chapter_model.dart';
import 'package:riverpod_test/main.dart';
import 'package:riverpod_test/presentation/author/book_chapter/chang_image/change_image_dialog.dart';
import 'package:riverpod_test/presentation/author/book_chapter/create_chapter/create_chapter.dart';
import 'package:riverpod_test/presentation/author/book_chapter/state/book_chapter_provider.dart';
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

    final fetchState = ref.watch(getAllChapterProvider(widget.book.bookId));

    final chapters = fetchState.value;

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
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        side: BorderSide(color: Colors.black)),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return Dialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            child: ChangeImageDialog(
                              bookId: widget.book.bookId,
                              imageUrl: book.imageUrl,
                            ),
                          );
                        },
                      );
                    },
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
          ),
          SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              sliver: fetchState.isLoading
                  ? SliverFillRemaining(
                      child: Center(
                        child: SpinKitDualRing(
                          color: Colors.yellow,
                          size: 25,
                        ),
                      ),
                    )
                  : chapters != null && chapters.isNotEmpty
                      ? SliverList.separated(
                          itemCount: chapters.length,
                          separatorBuilder: (context, index) {
                            return SizedBox(
                              height: 12,
                            );
                          },
                          itemBuilder: (context, index) {
                            return chapter(chapters[index]);
                          },
                        )
                      : SliverFillRemaining(
                          child: Center(
                            child: Text('There is no chapter'),
                          ),
                        ))
        ],
      ),
    );
  }
}

Widget chapter(ReturnChapterModel chapter) {
  return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
          color: Colors.grey, borderRadius: BorderRadius.circular(8)),
      child: Table(
        columnWidths: {0: FlexColumnWidth(1), 1: FlexColumnWidth(3)},
        children: [
          TableRow(children: [
            Text(
              chapter.numFormat(chapter.chapterNum),
              style: 14.sp(),
            ),
            Text(
              chapter.title,
              style: 14.sp(),
            )
          ]),
          TableRow(children: [
            SizedBox.shrink(),
            Text(
              chapter.content,
              style: 14.sp(),
              softWrap: true,
              overflow: TextOverflow.ellipsis,
            )
          ])
        ],
      ));
}
