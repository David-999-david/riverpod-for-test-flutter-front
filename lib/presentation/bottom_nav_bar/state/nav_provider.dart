import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_test/presentation/bottom_nav_bar/state/nav_notifier.dart';

final navProvider =
    StateNotifierProvider<NavNotifier, int>((ref) => NavNotifier());
