import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:riverpod_test/data/user/model/author_model.dart';
import 'package:riverpod_test/presentation/user/author_detail/state/author_detail_provider.dart';
import 'package:riverpod_test/theme/app_text_style.dart';

class AuthorDetail extends ConsumerWidget {
  const AuthorDetail({super.key, required this.authorId});

  final String authorId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fetchState = ref.watch(authDetailProvider(authorId));

    final author = fetchState.value;

    return Scaffold(
        backgroundColor: Color.fromARGB(255, 209, 209, 211),
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              automaticallyImplyLeading: false,
              expandedHeight: 300,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: EdgeInsets.only(bottom: 10, left: 10),
                title: fetchState.when(data: (data) {
                  return Text(
                    data.authorName,
                    style: 20.sp(color: Colors.white),
                  );
                }, error: (error, _) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(error.toString())));
                }, loading: () {
                  return SpinKitDualRing(
                    color: Colors.yellow,
                    size: 20,
                  );
                }),
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      'assets/images/c6.png',
                      fit: BoxFit.cover,
                    ),
                    DecoratedBox(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [
                          Color(0xffC9D6FF).withOpacity(0.1),
                          Color(0xffE2E2E2).withOpacity(0.2)
                        ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter)))
                  ],
                ),
              ),
            ),
            fetchState.isLoading
                ? SliverFillRemaining(
                    child: SpinKitDualRing(
                      color: Colors.yellow,
                      size: 25,
                    ),
                  )
                : author != null && author.books.isNotEmpty
                    ? SliverPadding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                        sliver: SliverGrid(
                            delegate: SliverChildBuilderDelegate(
                              childCount: author.books.length,
                              (context, index) {
                                final book = author.books[index];
                                return bookItem(book);
                              },
                            ),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 7,
                                    mainAxisSpacing: 10,
                                    mainAxisExtent: 270)),
                      )
                    : SliverFillRemaining(
                        child: Center(
                          child: Text(
                              'There is no books from ${author!.authorName}'),
                        ),
                      )
          ],
        ));
  }
}

Widget bookItem(TargetAuthorBook book) {
  return Container(
    decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black)),
    child: Column(
      children: [
        Image(
          image: AssetImage('assets/images/c5.png'),
          fit: BoxFit.cover,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                book.bookName,
                style: 16.sp(),
              ),
              Text(
                book.description,
                style: 13.sp(),
                overflow: TextOverflow.ellipsis,
                softWrap: true,
              ),
              Text(
                book.formated,
                style: 13.sp(color: Colors.grey),
              ),
              Row(
                children: [
                  Text(
                    book.category,
                    style: 13.sp(),
                  ),
                  Text(
                    ' / ',
                    style: 12.sp(color: Colors.grey),
                  ),
                  Text(
                    book.subCategory,
                    style: 13.sp(),
                  )
                ],
              )
            ],
          ),
        )
      ],
    ),
  );
}
