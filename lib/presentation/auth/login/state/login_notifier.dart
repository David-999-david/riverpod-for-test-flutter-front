import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_test/data/auth/model/user_model.dart';
import 'package:riverpod_test/data/auth/remote/auth_remote.dart';

class LoginNotifier extends StateNotifier<AsyncValue<void>> {
  LoginNotifier() : super(AsyncValue.data(null));

  Future<void> login(LoginModel user) async {
    state = AsyncValue.loading();
    try {
      await AuthRemote().login(user);
      state = AsyncValue.data(null);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }
}
