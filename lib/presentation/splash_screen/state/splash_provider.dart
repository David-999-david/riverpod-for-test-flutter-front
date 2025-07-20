import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_test/presentation/splash_screen/state/splash_notifier.dart';

final splashprovider = StateNotifierProvider<SplashNotifier, AsyncValue<void>>(
    (ref) => SplashNotifier());
