import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:riverpod_test/presentation/user/user_home/user_home.dart';
import 'package:riverpod_test/presentation/bottom_nav_bar/state/nav_provider.dart';
import 'package:riverpod_test/presentation/filter/filter.dart';
import 'package:riverpod_test/presentation/author/home/home_screen.dart';
import 'package:riverpod_test/presentation/author/home/state/book_provider.dart';
import 'package:riverpod_test/presentation/search_screen/search.dart';
import 'package:riverpod_test/presentation/setting/setting.dart';
import 'package:riverpod_test/presentation/setting/state/user_provider.dart';

class BottomNavBar extends ConsumerStatefulWidget {
  const BottomNavBar({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends ConsumerState<BottomNavBar> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => ref.read(navProvider.notifier).setIndex(widget.initialIndex));
  }

  @override
  Widget build(BuildContext context) {
    final index = ref.watch(navProvider);

    final userState = ref.watch(userProvider);

    return userState.when(data: (user) {
      final firstTab =
          user.role.first.toLowerCase() == 'author' ? HomeScreen() : UserHome();

      final List<Widget> screen = [firstTab, Search(), Filter(), Setting()];

      return Scaffold(
        body: IndexedStack(
          index: index,
          children: screen,
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: index,
          onDestinationSelected: (value) {
            ref.read(navProvider.notifier).setIndex(value);
            if (value == 0 && user.role.first.toLowerCase() == 'author') {
              if (user.role.first.toLowerCase() == 'author') {
                ref.read(bookfetchProvider(6).notifier).fetchAll();
              }
            }
          },
          destinations: [
            NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
            NavigationDestination(icon: Icon(Icons.search), label: 'Search'),
            NavigationDestination(
                icon: Icon(Icons.fiber_smart_record_outlined), label: 'Filter'),
            NavigationDestination(icon: Icon(Icons.settings), label: 'Setting'),
          ],
        ),
      );
    }, error: (error, _) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error.toString())));
      });
      return Scaffold(
        body: Center(
          child: Text(error.toString()),
        ),
      );
    }, loading: () {
      return Scaffold(
        body: Center(
          child: Card(
            color: Colors.transparent,
            child: SpinKitDualRing(
              color: Colors.yellow,
              size: 30,
            ),
          ),
        ),
      );
    });
  }
}
