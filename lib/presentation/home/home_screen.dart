import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:riverpod_test/main.dart';
import 'package:riverpod_test/presentation/home/add/create_book.dart';
import 'package:riverpod_test/presentation/home/state/book_form_notifier.dart';
import 'package:riverpod_test/presentation/home/state/book_provider.dart';
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
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
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
                  fetchState.isLoading
                      ? SpinKitDualRing(
                          color: Colors.white,
                          size: 22,
                        )
                      : book != null && book.isNotEmpty
                          ? Positioned(
                              left: 20,
                              bottom: 10,
                              child: Text(
                                book.first.authorName,
                                style: 17.sp(color: Colors.white),
                              ))
                          : Positioned(
                              left: 20,
                              bottom: 10,
                              child: Text(
                                'No Book is here',
                                style: 17.sp(color: Colors.white),
                              ))
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: ElevatedButton(
                onPressed: () {
                  appnavigator.push(CreateBook());
                },
                child: Text('add')),
          )
        ],
      ),
    );
  }
}
