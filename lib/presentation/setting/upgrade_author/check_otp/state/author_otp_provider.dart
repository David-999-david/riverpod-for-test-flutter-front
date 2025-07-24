import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_test/presentation/setting/upgrade_author/check_otp/state/author_otp_notifier.dart';

final verifyAuthorOtpProvider =
    StateNotifierProvider<AuthorOtpNotifier, AsyncValue<void>>(
        (ref) => AuthorOtpNotifier());

