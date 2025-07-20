import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_test/presentation/auth/forgotpassword/state/email_verified_notifier.dart';

final requestOtpProvider =
    StateNotifierProvider<EmailVerifiedNotifier, AsyncValue<String>>(
        (ref) => EmailVerifiedNotifier());
