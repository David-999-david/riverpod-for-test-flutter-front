import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_test/data/auth/remote/auth_remote.dart';

class EmailVerifiedNotifier extends StateNotifier<AsyncValue<String>> {
  EmailVerifiedNotifier() : super(AsyncValue.data(''));

  Future<void> requestOtp(String email) async {
    state = AsyncValue.loading();
    // try {
    //   final successMesg = await AuthRemote().requestOtp(email);
    //   state = AsyncValue.data(successMesg);
    // } catch (e, s) {
    //   state = AsyncValue.error(e, s);
    // }
    state = await AsyncValue.guard(() => AuthRemote().requestOtp(email));
  }
}
