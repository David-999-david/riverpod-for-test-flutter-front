import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_test/data/auth/remote/auth_remote.dart';

class UserLogoutNotifier extends StateNotifier<AsyncValue<void>> {
  UserLogoutNotifier() : super(AsyncValue.data(null));

  Future<void> logOut() async {
    state = AsyncValue.loading();
    state = await AsyncValue.guard(() => AuthRemote().signOut());
  }
}
