import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:riverpod_test/main.dart';
import 'package:riverpod_test/presentation/auth/login/state/login_provider.dart';
import 'package:riverpod_test/presentation/auth/register/register_screen.dart';
import 'package:riverpod_test/presentation/setting/upgrade_author/check_otp/author_otp_verify.dart';
import 'package:riverpod_test/presentation/setting/upgrade_author/fill_secret/state/secret_check_provider.dart';
import 'package:riverpod_test/theme/app_text_style.dart';

class FillSecret extends ConsumerStatefulWidget {
  const FillSecret({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FillSecretState();
}

class _FillSecretState extends ConsumerState<FillSecret> {
  final GlobalKey<FormState> key = GlobalKey<FormState>();

  final TextEditingController secret = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ref.listen(secretProvider, (prev, next) {
      next.when(
          data: (msg) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(msg.toString())));
            appnavigator.pop();
            showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) {
                return AlertDialog(
                  backgroundColor: Color(0xff3f2b96),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 40),
                        child: Text(
                          'Check your mail for otp, \nVerify Otp here',
                          textAlign: TextAlign.center,
                          style: 17.sp(color: Colors.white),
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            appnavigator.pop();
                          },
                          icon: Icon(
                            Icons.cancel,
                            color: Colors.white,
                          ))
                    ],
                  ),
                  content: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            gradient: LinearGradient(
                                colors: [Color(0xffa8c0ff), Color(0xff3f2b96)],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter)),
                        child: AuthorOtpVerify()),
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

    final secretState = ref.watch(secretProvider);

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.2,
      ),
      child: Form(
          key: key,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    top: 25, left: 10, right: 10, bottom: 5),
                child: textfieldSecret(
                    secret, "Please Enter Secret-key", 'Secret-key'),
              ),
              secretState.isLoading
                  ? SpinKitDualRing(
                      color: Colors.yellow,
                      size: 20,
                    )
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          side: BorderSide(color: Colors.blue)),
                      onPressed: () {
                        if (!key.currentState!.validate()) return;
                        ref
                            .read(secretProvider.notifier)
                            .checkSecret(secret.text.trim());
                      },
                      child: Text(
                        'Confirm',
                        style: 12.sp(),
                      ))
            ],
          )),
    );
  }
}

Widget textfieldSecret(TextEditingController ctr, String hint, String text) {
  final paswFocus = FocusNode();
  return Consumer(
    builder: (context, ref, child) {
      final isObscured = ref.watch(passwrodProvider);
      return Padding(
        padding: const EdgeInsets.only(bottom: 15),
        child: TextFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          controller: ctr,
          focusNode: paswFocus,
          obscureText: isObscured,
          decoration: InputDecoration(
              hintText: hint,
              hintStyle: 16.sp(),
              filled: true,
              suffixIcon: IconButton(
                  onPressed: () {
                    ref.read(passwrodProvider.notifier).state = !isObscured;
                  },
                  icon: isObscured
                      ? Icon(Icons.visibility_off)
                      : Icon(Icons.visibility)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.black)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.greenAccent)),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.greenAccent))),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '$text must not be empty';
            }
            // if (value.length < 8) return '$text must be greater than 8';

            return null;
          },
        ),
      );
    },
  );
}
