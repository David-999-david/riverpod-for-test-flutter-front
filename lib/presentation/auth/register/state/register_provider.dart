import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_test/presentation/auth/register/state/register_notifier.dart';

final registerProvider =
    StateNotifierProvider<RegisterNotifier, AsyncValue<void>>(
        (ref) => RegisterNotifier());
