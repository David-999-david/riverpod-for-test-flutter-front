import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_test/data/auth/remote/auth_remote.dart';

class SplashNotifier extends StateNotifier<AsyncValue<void>> {
  SplashNotifier() : super(AsyncValue.loading());

  Future<void> handleStartScreen() async {
    state = AsyncValue.loading();
    try {
      await AuthRemote().handleStartScreen();
      state = AsyncValue.data(null);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }
}
