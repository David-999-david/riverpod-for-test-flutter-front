import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:riverpod_test/data/book/model/book_model.dart';
import 'package:riverpod_test/main.dart';
import 'package:riverpod_test/presentation/home/add/create_book.dart';
import 'package:riverpod_test/presentation/home/state/book_form_notifier.dart';
import 'package:riverpod_test/presentation/home/state/book_provider.dart';
import 'package:riverpod_test/presentation/setting/state/user_provider.dart';
import 'package:riverpod_test/theme/app_text_style.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState {
  // @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     ref.read(boolfetchProvider.notifier).fetchAll();
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final fetchState = ref.watch(bookfetchProvider);
    final book = fetchState.value;

    final userState = ref.watch(userProvider);
    final user = userState.value;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 209, 209, 211),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.black,
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: EdgeInsets.only(left: 15, bottom: 10),
              title: userState.isLoading
                  ? SpinKitDualRing(
                      color: Colors.white,
                      size: 20,
                    )
                  : Text(
                      user!.name,
                      style: 20.sp(color: Colors.white),
                    ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    'assets/images/author.png',
                    fit: BoxFit.cover,
                  ),
                  DecoratedBox(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                    Color(0xff3C3B3F).withOpacity(0.2),
                    Color(0xff605C3C).withOpacity(0.1)
                  ], begin: Alignment.topCenter, end: Alignment.bottomCenter))),
                  userState.isLoading
                      ? Positioned(
                          bottom: 15,
                          left: 20,
                          child: SpinKitDualRing(
                            color: Colors.yellow,
                            size: 20,
                          ))
                      : Positioned(
                          top: 70,
                          left: 20,
                          child: Text(
                            'Welcome ${user!.role.first.toUpperCase()}',
                            style: 15.sp(color: Colors.white),
                          ))
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            sliver: SliverToBoxAdapter(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        fixedSize: Size(50, 40),
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(color: Colors.blue))),
                    onPressed: () {
                      appnavigator.push(CreateBook());
                    },
                    child: Text('ADD')),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        fixedSize: Size(50, 40),
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(color: Colors.blue))),
                    onPressed: () {
                      appnavigator.push(CreateBook());
                    },
                    child: Text('EDIT')),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        fixedSize: Size(50, 40),
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(color: Colors.blue))),
                    onPressed: () {
                      appnavigator.push(CreateBook());
                    },
                    child: Text('Do')),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        fixedSize: Size(50, 40),
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(color: Colors.blue))),
                    onPressed: () {
                      appnavigator.push(CreateBook());
                    },
                    child: Text('add')),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        fixedSize: Size(50, 40),
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(color: Colors.blue))),
                    onPressed: () {
                      appnavigator.push(CreateBook());
                    },
                    child: Text('add')),
              ],
            )),
          ),
          fetchState.isLoading
              ? SliverFillRemaining(
                  child: Center(
                    child: SpinKitDualRing(
                      color: Colors.yellow,
                      size: 28,
                    ),
                  ),
                )
              : book != null && book.isNotEmpty
                  ? SliverPadding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      sliver: SliverGrid(
                          delegate: SliverChildBuilderDelegate(
                              childCount: book.length, (context, index) {
                            return bookItem(book[index]);
                          }),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 8,
                                  crossAxisSpacing: 7,
                                  mainAxisExtent: 245)),
                    )
                  : SliverToBoxAdapter(
                      child: Center(
                          child: Padding(
                        padding: const EdgeInsets.only(top: 130),
                        child: Text(
                          'There is no book',
                          style: 17.sp(),
                        ),
                      )),
                    ),
        ],
      ),
    );
  }
}

Widget bookItem(ReturnBook book) {
  final bookImageUrl = book.imageUrl;

  final hasImageUrl = bookImageUrl != null && bookImageUrl.isNotEmpty;

  dynamic bg = hasImageUrl
      ? Image.network(
          bookImageUrl,
          fit: BoxFit.cover,
        )
      : Image.asset(
          'assets/images/cool4.png',
          fit: BoxFit.cover,
        );
  return Container(
    decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black)),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          height: 170,
          width: double.infinity,
          child: Stack(
            fit: StackFit.expand,
            children: [
              bg,
              DecoratedBox(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                Color(0xffBABABD).withOpacity(0.2),
                Color(0xffC39CA4).withOpacity(0.1)
              ], begin: Alignment.topCenter, end: Alignment.bottomCenter)))
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: 8,
            bottom: 10,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                book.bookName,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                style: 15.sp(),
              ),
              SizedBox(
                height: 4,
              ),
              Text(
                book.bookDesc,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                style: 13.sp(),
              ),
              SizedBox(
                height: 2,
              ),
              Text(
                book.formatedDate,
                style: 13.sp(color: Colors.grey),
              )
            ],
          ),
        )
      ],
    ),
  );
}
