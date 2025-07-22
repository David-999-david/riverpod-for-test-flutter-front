import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pinput/pinput.dart';
import 'package:riverpod_test/main.dart';
import 'package:riverpod_test/presentation/auth/forgotpassword/otp_verify/state/otp_verify_provider.dart';
import 'package:riverpod_test/presentation/auth/forgotpassword/reset_password/reset_password.dart';
import 'package:riverpod_test/theme/app_text_style.dart';

class OtpVerify extends ConsumerStatefulWidget {
  const OtpVerify({super.key, this.email = ''});

  final String email;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _OtpVerifyState();
}

class _OtpVerifyState extends ConsumerState<OtpVerify> {
  final focusPinNode = FocusNode();
  final otpCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ref.listen(otpProvider, (prev, next) {
      next.when(
          data: (_) {
            appnavigator.pushReplacement(ResetPassword(), (_) => false);
          },
          error: (error, _) {},
          loading: () {});
    });

    final defaultPinThem = PinTheme(
        textStyle: 15.sp(color: Colors.white),
        height: 50,
        width: 60,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(8)));

    final focusPinTheme = defaultPinThem.copyWith(
        decoration: defaultPinThem.decoration!
            .copyWith(border: Border.all(color: Colors.blue)));

    final otpState = ref.watch(otpProvider);

    return ConstrainedBox(
      constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.25,
          maxWidth: MediaQuery.of(context).size.width * 0.9),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'Enter Verification code',
            style: 18.sp(color: Colors.white),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            'A 6-digit code was just sent to your email',
            style: 14.sp(color: Colors.white),
          ),
          SizedBox(
            height: 30,
          ),
          Pinput(
            length: 6,
            focusNode: focusPinNode,
            controller: otpCtrl,
            defaultPinTheme: defaultPinThem,
            focusedPinTheme: focusPinTheme,
            onCompleted: (value) {
              ref
                  .read(otpProvider.notifier)
                  .otpVerify(widget.email, otpCtrl.text.trim());
            },
          ),
          otpState.isLoading
              ? SpinKitDualRing(
                  color: Colors.yellow,
                  size: 20,
                  duration: Duration(seconds: 5),
                )
              : SizedBox.shrink()
        ],
      ),
    );
  }
}
