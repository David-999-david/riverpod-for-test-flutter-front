import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_test/data/auth/remote/auth_remote.dart';

class SecretCheckNotifier extends StateNotifier<AsyncValue<String>> {
  SecretCheckNotifier() : super(AsyncValue.data(''));

  Future<void> checkSecret(String secret) async {
    state = AsyncValue.loading();
    state = await AsyncValue.guard(() => AuthRemote().checkSecreKey(secret));
  }
}
