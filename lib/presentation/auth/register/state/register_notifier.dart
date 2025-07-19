import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_test/data/auth/model/user_model.dart';
import 'package:riverpod_test/data/auth/remote/auth_remote.dart';

class RegisterNotifier extends StateNotifier<AsyncValue<void>> {
  RegisterNotifier() : super(AsyncValue.data(null));

  Future<void> register(RegisterModel user) async {
    state = AsyncValue.loading();
    try {
      await AuthRemote().register(user);
      state = AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}
