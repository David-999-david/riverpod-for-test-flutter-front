import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:riverpod_test/data/user/model/author_model.dart';
import 'package:riverpod_test/main.dart';
import 'package:riverpod_test/presentation/user/author_detail/author_detail.dart';
import 'package:riverpod_test/presentation/user/user_home/state/author_book_provider.dart';
import 'package:riverpod_test/theme/app_text_style.dart';

class UserHome extends ConsumerWidget {
  const UserHome({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final fetchAuthorState = ref.watch(authorListProvider);
    // final authorList = fetchAuthorState.value;

    // final bookAuthorState = ref.watch(bookAuthorListProvier);
    // final bookAuthorList = bookAuthorState.value;

    return Scaffold(
        backgroundColor: Color.fromARGB(255, 209, 209, 211),
        body: SafeArea(
          child: Column(
            children: [
              Container(
                  color: Colors.white,
                  width: double.infinity,
                  height: 80,
                  child: ref.watch(authorListProvider).when(data: (authors) {
                    if (authors.isNotEmpty) {
                      return ListView.separated(
                        separatorBuilder: (context, index) {
                          return SizedBox(
                            width: 10,
                          );
                        },
                        scrollDirection: Axis.horizontal,
                        itemCount: authors.length,
                        itemBuilder: (context, index) {
                          final author = authors[index];
                          return authorCircle(author);
                        },
                      );
                    }
                    return Text('No author at current');
                  }, error: (error, _) {
                    return Center(
                      child: Text(error.toString()),
                    );
                  }, loading: () {
                    return Center(
                      child: SpinKitDualRing(
                        color: Colors.yellow,
                        size: 20,
                      ),
                    );
                  })),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: ref.watch(bookAuthorListProvier).when(data: (books) {
                      if (books.isNotEmpty) {
                        return GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 7,
                                  mainAxisSpacing: 10,
                                  mainAxisExtent: 280),
                          itemCount: books.length,
                          itemBuilder: (context, index) {
                            final book = books[index];
                            return bookItem(book);
                          },
                        );
                      }
                      return Center(
                        child: Text(
                          'Nothing for show....',
                          style: 14.sp(),
                        ),
                      );
                    }, error: (error, _) {
                      return Center(
                        child: Text(error.toString()),
                      );
                    }, loading: () {
                      return Center(
                        child: SpinKitDualRing(
                          color: Colors.yellow,
                          size: 25,
                        ),
                      );
                    })),
              )
            ],
          ),
        ));
  }
}

Widget authorCircle(AuthorModel author) {
  return Padding(
    padding: const EdgeInsets.only(top: 5, left: 10),
    child: InkWell(
      onTap: () {
        appnavigator.push(AuthorDetail(authorId: author.id));
      },
      child: Column(
        children: [
          Container(
            height: 50,
            width: 50,
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.pinkAccent),
                borderRadius: BorderRadius.circular(24),
                image: DecorationImage(
                    image: AssetImage('assets/images/cool4.png'),
                    fit: BoxFit.cover)),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            author.name,
            style: 12.sp(),
          )
        ],
      ),
    ),
  );
}

Widget bookItem(BookWithAuthor book) {
  final bookImage = book.imageUrl;

  final hasBookImage = bookImage != null && bookImage.isNotEmpty;

  dynamic bg = hasBookImage
      ? NetworkImage(bookImage)
      : AssetImage('assets/images/c5.png');
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: Colors.black),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 184,
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(image: bg, fit: BoxFit.cover),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                book.authorName,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                style: 15.sp(color: Colors.black),
              ),
              Text(
                book.bookName,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                style: 12.sp(),
              ),
              Text(
                book.description,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
                style: 12.sp(),
              ),
              Text(
                'Date : ${book.formated}',
                style: 12.sp(color: Colors.grey),
              ),
              SizedBox(
                height: 20,
                child: Row(
                  children: [
                    Text(
                      book.category,
                      style: 13.sp(),
                    ),
                    Text(
                      ' / ',
                      style: 12.sp(color: Colors.grey),
                    ),
                    Expanded(
                      child: SizedBox(
                        height: 20,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: book.subCategories
                                .map((s) => Padding(
                                      padding: EdgeInsets.only(right: 4),
                                      child: Text(
                                        s.subCategory,
                                        style: 12.sp(),
                                      ),
                                    ))
                                .toList(),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    ),
  );
}
