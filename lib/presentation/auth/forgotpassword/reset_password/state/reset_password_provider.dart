import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_test/presentation/auth/forgotpassword/reset_password/state/reset_password_notifier.dart';

final changePswProvider =
    StateNotifierProvider<ResetPasswordNotifier, AsyncValue<String>>(
        (ref) => ResetPasswordNotifier());

final newPswProvider = StateProvider<bool>((ref) => true);

final confirmPswProvider = StateProvider<bool>((ref) => true);
