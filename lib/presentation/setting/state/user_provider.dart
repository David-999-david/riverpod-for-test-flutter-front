import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_test/data/user/model/user_info_mode.dart';
import 'package:riverpod_test/presentation/setting/state/userInfo_notifier.dart';
import 'package:riverpod_test/presentation/setting/state/user_logout_notifier.dart';

final userProvider =
    StateNotifierProvider<UserinfoNotifier, AsyncValue<UserInfoMode>>(
        (ref) => UserinfoNotifier());

final logoutProvider =
    StateNotifierProvider<UserLogoutNotifier, AsyncValue<void>>(
        (ref) => UserLogoutNotifier());
