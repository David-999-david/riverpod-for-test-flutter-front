import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:riverpod_test/main.dart';
import 'package:riverpod_test/presentation/auth/forgotpassword/reset_password/state/reset_password_provider.dart';
import 'package:riverpod_test/presentation/auth/login/login_screen.dart';
import 'package:riverpod_test/theme/app_text_style.dart';

class ResetPassword extends ConsumerStatefulWidget {
  const ResetPassword({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends ConsumerState<ResetPassword> {
  final GlobalKey<FormState> key = GlobalKey<FormState>();
  late final TextEditingController _newPsw;
  late final TextEditingController _confirmPsw;

  @override
  void initState() {
    _newPsw = TextEditingController();
    _confirmPsw = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(changePswProvider, (prev, next) {
      next.when(
          data: (msg) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(msg.toString())));
            appnavigator.pushAndRemoveUntil(LoginScreen(), (_) => false);
          },
          error: (error, _) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(error.toString())));
          },
          loading: () {});
    });

    final changePswState = ref.watch(changePswProvider);

    return Scaffold(
      body: Container(
        color: Color(0xff322E3E),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              expandedHeight: 300,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      'assets/images/psw.png',
                      fit: BoxFit.cover,
                    ),
                    DecoratedBox(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [
                          Color(0xff614385).withOpacity(0.2),
                          Color(0xff516395).withOpacity(0.3)
                        ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter)))
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Form(
                key: key,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Text(
                          'Change you password here',
                          style: 18.sp(color: Colors.white),
                        ),
                        SizedBox(
                          height: 35,
                        ),
                        newPswTextField(
                            _newPsw, 'New Password', newPswProvider),
                        confirmPswTextField(_confirmPsw, 'Confirm passowrd',
                            confirmPswProvider, _newPsw),
                        SizedBox(
                          height: 20,
                        ),
                        !changePswState.isLoading
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
                                      .read(changePswProvider.notifier)
                                      .changePsw(_confirmPsw.text.trim());
                                },
                                child: Text(
                                  'Confirm',
                                  style: 13.sp(),
                                ))
                            : SpinKitDualRing(
                                color: Colors.yellow,
                                size: 20,
                              )
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

Widget newPswTextField(
    TextEditingController controller, String hint, StateProvider pswState) {
  final focusNode = FocusNode();
  return Consumer(
    builder: (context, ref, child) {
      final isObscured = ref.watch(pswState);
      return Padding(
        padding: const EdgeInsets.only(bottom: 15),
        child: TextFormField(
          controller: controller,
          focusNode: focusNode,
          style: 15.sp(),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          obscureText: isObscured,
          decoration: InputDecoration(
              hintText: hint,
              hintStyle: 15.sp(),
              filled: true,
              suffixIcon: IconButton(
                  onPressed: () {
                    ref.read(pswState.notifier).state = !isObscured;
                  },
                  icon: Icon(
                      isObscured ? Icons.visibility_off : Icons.visibility)),
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
            if (value == null || value.isEmpty) return 'New Password required';
            if (value.length < 8) return 'New password must be at lease 8';
            return null;
          },
        ),
      );
    },
  );
}

Widget confirmPswTextField(TextEditingController controller, String hint,
    StateProvider pswState, TextEditingController newPsw) {
  final focusNode = FocusNode();
  return Consumer(
    builder: (context, ref, child) {
      final isObscured = ref.watch(pswState);
      return TextFormField(
        controller: controller,
        focusNode: focusNode,
        obscureText: isObscured,
        style: 15.sp(),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
            hintText: hint,
            hintStyle: 15.sp(),
            filled: true,
            suffixIcon: IconButton(
                onPressed: () {
                  ref.read(pswState.notifier).state = !isObscured;
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
          if (value == null || value.isEmpty) return 'New Password required';
          if (value.length < 8) return 'Confirm password must be at lease 8';
          if (value != newPsw.text) return 'Confirm password is worng';
          return null;
        },
      );
    },
  );
}
