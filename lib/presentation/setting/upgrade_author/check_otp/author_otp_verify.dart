import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pinput/pinput.dart';
import 'package:riverpod_test/main.dart';
import 'package:riverpod_test/presentation/setting/upgrade_author/check_otp/state/author_otp_provider.dart';
import 'package:riverpod_test/theme/app_text_style.dart';

class AuthorOtpVerify extends ConsumerStatefulWidget {
  const AuthorOtpVerify({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AuthorOtpVerifyState();
}

class _AuthorOtpVerifyState extends ConsumerState<AuthorOtpVerify> {
  late final TextEditingController otp;

  @override
  void initState() {
    super.initState();
    otp = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final FocusNode node = FocusNode();

    final PinTheme defaultPinTheme = PinTheme(
        width: 50,
        height: 56,
        textStyle: 15.sp(),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.black)));

    final PinTheme focusPinTheme = defaultPinTheme.copyWith(
        decoration: defaultPinTheme.decoration!
            .copyWith(border: Border.all(color: Colors.blue)));

    ref.listen(verifyAuthorOtpProvider, (prev, next) {
      next.when(
          data: (_) {
            appnavigator.pop();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Upgrade to Author success! Have fun😎')));
          },
          error: (error, _) {
            appnavigator.pop();
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(error.toString())));
          },
          loading: () {});
    });

    final verifyState = ref.watch(verifyAuthorOtpProvider);
    return ConstrainedBox(
        constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.25),
        child: Padding(
          padding: EdgeInsets.only(
            top: 20,
            right: 10,
            left: 10,
            bottom: 5,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Pinput(
                length: 6,
                focusNode: node,
                controller: otp,
                defaultPinTheme: defaultPinTheme,
                focusedPinTheme: focusPinTheme,
                onCompleted: (value) {
                  ref
                      .read(verifyAuthorOtpProvider.notifier)
                      .verifyAuthorOtp(otp.text.trim());
                },
              ),
              verifyState.isLoading
                  ? SpinKitDualRing(
                      color: Colors.yellow,
                      size: 20,
                    )
                  : SizedBox.shrink()
            ],
          ),
        ));
  }
}
