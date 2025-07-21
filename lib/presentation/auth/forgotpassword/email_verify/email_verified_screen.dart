import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:riverpod_test/main.dart';
import 'package:riverpod_test/presentation/auth/forgotpassword/email_verify/state/email_verified_provider.dart';
import 'package:riverpod_test/presentation/auth/forgotpassword/otp_verify/otp_verify.dart';
import 'package:riverpod_test/presentation/auth/register/register_screen.dart';
import 'package:riverpod_test/theme/app_text_style.dart';

class EmailVerifiedScreen extends ConsumerStatefulWidget {
  const EmailVerifiedScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EmailVerifiedScreenState();
}

class _EmailVerifiedScreenState extends ConsumerState<EmailVerifiedScreen> {
  final GlobalKey<FormState> key = GlobalKey<FormState>();
  late final TextEditingController email;

  @override
  void initState() {
    email = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<String>>(requestOtpProvider, (prev, next) {
      next.when(
          data: (msg) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(msg.toString())));

            // appnavigator.push(OtpVerify());
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return AlertDialog(
                  backgroundColor: Color(0xff322E3E),
                  title: Align(
                    alignment: Alignment.topRight,
                    child: InkWell(
                      onTap: () {
                        appnavigator.pop();
                      },
                      child: Icon(
                        Icons.cancel,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  content: OtpVerify(
                    email: email.text.trim(),
                  ),
                );
              },
            );
          },
          error: (error, _) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(error.toString())));
          },
          loading: () {});
    });

    final verifyState = ref.watch(requestOtpProvider);

    final loading = verifyState.isLoading;

    return Scaffold(
      body: Container(
          color: Color(0xff322E3E),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Form(
              key: key,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Please enter your email',
                    style: 17.sp(color: Colors.white),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  textfieldEmail(email, 'Email', 'Email'),
                  SizedBox(
                    height: 10,
                  ),
                  !loading
                      ? ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              side: BorderSide(color: Colors.blue)),
                          onPressed: () {
                            if (!key.currentState!.validate()) return;

                            ref
                                .read(requestOtpProvider.notifier)
                                .requestOtp(email.text.trim());
                          },
                          child: Text(
                            'Verify',
                            style: 12.sp(),
                          ))
                      : SpinKitDualRing(
                          color: Colors.yellow,
                          size: 20,
                          duration: Duration(seconds: 5),
                        )
                ],
              ),
            ),
          )),
    );
  }
}
