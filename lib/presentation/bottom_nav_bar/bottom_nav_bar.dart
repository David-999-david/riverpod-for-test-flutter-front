import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_test/presentation/bottom_nav_bar/state/nav_provider.dart';
import 'package:riverpod_test/presentation/filter/filter.dart';
import 'package:riverpod_test/presentation/home/home_screen.dart';
import 'package:riverpod_test/presentation/search_screen/search.dart';
import 'package:riverpod_test/presentation/setting/setting.dart';
import 'package:riverpod_test/routes/routes.dart';

class BottomNavBar extends ConsumerWidget {
  BottomNavBar({super.key});

  final List<Widget> _screen = [HomeScreen(), Search(), Filter(), Setting()];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(navProvider);

    return Scaffold(
      body: _screen[index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (value) {
          ref.read(navProvider.notifier).setIndex(value);
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
  }
}
