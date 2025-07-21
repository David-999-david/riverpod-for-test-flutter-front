import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_test/presentation/auth/forgotpassword/otp_verify/state/otp_verify_notifier.dart';

final otpProvider = StateNotifierProvider<OtpVerifyNotifier, AsyncValue<void>>(
    (ref) => OtpVerifyNotifier());
