import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_test/data/auth/remote/auth_remote.dart';

class ResetPasswordNotifier extends StateNotifier<AsyncValue<String>> {
  ResetPasswordNotifier() : super(AsyncValue.data(''));

  Future<void> changePsw(String newPsw) async {
    state = AsyncValue.loading();
    // try {
    //   final message = await AuthRemote().changePsw(newPsw);
    //   state = AsyncValue.data(message);
    // }
    // catch (e, s){
    //   state = AsyncValue.error(e, s);
    // }
    state = await AsyncValue.guard(() => AuthRemote().changePsw(newPsw));
  }
}
