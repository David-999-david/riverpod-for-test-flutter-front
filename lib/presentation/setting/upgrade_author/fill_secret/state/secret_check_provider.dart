import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_test/presentation/setting/upgrade_author/fill_secret/state/secret_check_notifier.dart';

final secretProvider =
    StateNotifierProvider<SecretCheckNotifier, AsyncValue<String>>(
        (ref) => SecretCheckNotifier());
