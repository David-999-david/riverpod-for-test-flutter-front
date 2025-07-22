import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_test/data/user/model/user_info_mode.dart';
import 'package:riverpod_test/data/user/remote/user_remote.dart';

class UserinfoNotifier extends StateNotifier<AsyncValue<UserInfoMode>> {
  UserinfoNotifier() : super(AsyncValue.loading());

  Future<void> getInfo() async {
    state = AsyncValue.loading();
    state = await AsyncValue.guard(() => UserRemote().getUserInfo());
  }
}
