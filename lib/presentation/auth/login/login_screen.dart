import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:riverpod_test/data/auth/model/user_model.dart';
import 'package:riverpod_test/main.dart';
import 'package:riverpod_test/presentation/auth/forgotpassword/email_verify/email_verified_screen.dart';
import 'package:riverpod_test/presentation/auth/login/state/login_provider.dart';
import 'package:riverpod_test/presentation/auth/register/register_screen.dart';
import 'package:riverpod_test/presentation/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:riverpod_test/presentation/home/home_screen.dart';
import 'package:riverpod_test/presentation/setting/state/user_provider.dart';
import 'package:riverpod_test/theme/app_text_style.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final GlobalKey<FormState> key = GlobalKey<FormState>();

  late final TextEditingController email;
  late final TextEditingController psw;

  @override
  void initState() {
    super.initState();
    email = TextEditingController();
    psw = TextEditingController();
  }

  @override
  void dispose() {
    email.dispose();
    psw.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<void>>(loginprovider, (prev, next) {
      next.when(
          data: (_) async {
            ref.invalidate(userProvider);

            await ref.read(userProvider.notifier).getInfo();

            appnavigator.pushReplacement(BottomNavBar(), null);
          },
          error: (error, _) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(error.toString())));
          },
          loading: () => ());
    });

    final loginState = ref.watch(loginprovider);

    return Scaffold(
        body: Container(
      color: Color(0xff322E3E),
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 250,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    'assets/images/cool.png',
                    fit: BoxFit.cover,
                  ),
                  DecoratedBox(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                    Color(0xff614385).withOpacity(0.2),
                    Color(0xff516395).withOpacity(0.3)
                  ], begin: Alignment.topCenter, end: Alignment.bottomCenter)))
                ],
              ),
            ),
          ),
          loginState.isLoading
              ? SliverFillRemaining(
                  child: LoadingAnimationWidget.inkDrop(
                      color: Colors.yellow, size: 25),
                )
              : SliverToBoxAdapter(
                  child: Form(
                    key: key,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 70),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          textfieldEmail(email, 'Email', 'Email'),
                          textfieldPsw(psw, 'Password', 'Password'),
                          Align(
                            alignment: Alignment.topRight,
                            child: GestureDetector(
                              onTap: () {
                                appnavigator.push(EmailVerifiedScreen());
                              },
                              child: Text(
                                'Forgot-password',
                                style: 11.sp(color: Colors.white),
                              ),
                            ),
                          ),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 3),
                                  side: BorderSide(color: Colors.blue),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8))),
                              onPressed: () {
                                if (!key.currentState!.validate()) return;

                                ref.read(loginprovider.notifier).login(
                                    LoginModel(
                                        email: email.text.trim(),
                                        password: psw.text.trim()));
                              },
                              child: Text(
                                'Log-in',
                                style: 13.sp(),
                              )),
                          SizedBox(
                            height: 10,
                          ),
                          GestureDetector(
                            onTap: () {
                              appnavigator.push(RegisterScreen());
                            },
                            child: RichText(
                                text: TextSpan(children: [
                              TextSpan(
                                  text: 'Don\'t have and account?  ',
                                  style: 12.sp(color: Colors.grey)),
                              TextSpan(
                                  text: 'Register here!',
                                  style: 13.sp(color: Colors.white).copyWith(
                                      decoration: TextDecoration.underline))
                            ])),
                          )
                        ],
                      ),
                    ),
                  ),
                )
        ],
      ),
    ));
  }
}
