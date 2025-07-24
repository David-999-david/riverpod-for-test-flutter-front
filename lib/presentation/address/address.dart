import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_test/main.dart';
import 'package:riverpod_test/presentation/bottom_nav_bar/bottom_nav_bar.dart';

class Address extends ConsumerWidget {
  const Address({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
            onPressed: () {
              appnavigator.push(BottomNavBar(initialIndex: 2,));
            },
            child: Text('test')),
      ),
    );
  }
}
