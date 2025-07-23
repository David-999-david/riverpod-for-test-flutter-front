import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_test/data/auth/remote/auth_remote.dart';

class AuthorOtpNotifier extends StateNotifier<AsyncValue<void>> {
  AuthorOtpNotifier() : super(AsyncValue.data(null));

  Future<void> verifyAuthorOtp(String otp) async {
    state = AsyncValue.loading();
    // try {
    //   await AuthRemote().verifyOtpAndUpgrade(otp);
    //   state = AsyncValue.data(null);
    // } catch (e, s) {
    //   state = AsyncValue.error(e, s);
    // }
    state = await AsyncValue.guard(() => AuthRemote().verifyOtpAndUpgrade(otp));
  }
}

