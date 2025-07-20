import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_test/presentation/auth/login/state/login_notifier.dart';

final loginprovider = StateNotifierProvider<LoginNotifier, AsyncValue<void>>(
    (ref) => LoginNotifier());
