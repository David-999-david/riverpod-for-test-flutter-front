import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:riverpod_test/data/user/model/author_model.dart';
import 'package:riverpod_test/presentation/user_home/state/author_book_provider.dart';
import 'package:riverpod_test/theme/app_text_style.dart';

class UserHome extends ConsumerWidget {
  const UserHome({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fetchAuthorState = ref.watch(authorListProvider);
    final authorList = fetchAuthorState.value;

    final bookAuthorState = ref.watch(bookAuthorListProvier);
    final bookAuthorList = bookAuthorState.value;

    return Scaffold(
        backgroundColor: Color.fromARGB(255, 209, 209, 211),
        body: SafeArea(
          child: Column(
            children: [
              Container(
                color: Colors.white,
                width: double.infinity,
                height: 80,
                child: fetchAuthorState.isLoading
                    ? SpinKitDualRing(
                        color: Colors.yellow,
                        size: 20,
                      )
                    : authorList != null && authorList.isNotEmpty
                        ? ListView.separated(
                            separatorBuilder: (context, index) {
                              return SizedBox(
                                width: 10,
                              );
                            },
                            scrollDirection: Axis.horizontal,
                            itemCount: authorList.length,
                            itemBuilder: (context, index) {
                              final author = authorList[index];
                              return authorCircle(author);
                            },
                          )
                        : Text('There is no authors for show'),
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: bookAuthorState.isLoading
                      ? Center(
                          child: SpinKitDualRing(
                            color: Colors.yellow,
                            size: 25,
                          ),
                        )
                      : bookAuthorList != null && bookAuthorList.isNotEmpty
                          ? GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 7,
                                      mainAxisSpacing: 10,
                                      mainAxisExtent: 280),
                              itemCount: bookAuthorList.length,
                              itemBuilder: (context, index) {
                                final book = bookAuthorList[index];
                                return bookItem(book);
                              },
                            )
                          : Center(
                              child: Text('There is no books'),
                            ),
                ),
              )
            ],
          ),
        ));
  }
}

Widget authorCircle(AuthorModel author) {
  return Padding(
    padding: const EdgeInsets.only(top: 5, left: 10),
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
  );
}

Widget bookItem(BookWithAuthor book) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: Colors.black),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image(
          image: AssetImage('assets/images/c5.png'),
          fit: BoxFit.cover,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                book.authorName,
                style: 15.sp(color: Colors.black),
              ),
              Text(
                book.bookName,
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
                    Text(
                      book.subCategory,
                      style: 13.sp(),
                    )
                  ],
                ),
              )
            ],
          ),
        )
      ],
    ),
  );
}
