import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_test/data/auth/remote/auth_remote.dart';

class OtpVerifyNotifier extends StateNotifier<AsyncValue<void>> {
  OtpVerifyNotifier() : super(AsyncValue.data(null));

  Future<void> otpVerify(String email, String otp) async {
    state = AsyncValue.loading();
    // try {
    //   await AuthRemote().verifyOtp(email, otp);
    //   state = AsyncValue.data(null);
    // } catch (e, s) {
    //   state = AsyncValue.error(e, s);
    // }
    state = await AsyncValue.guard(() => AuthRemote().verifyOtp(email, otp));
  }
}
