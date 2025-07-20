import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:riverpod_test/data/auth/model/user_model.dart';
import 'package:riverpod_test/main.dart' show appnavigator;
import 'package:riverpod_test/presentation/auth/login/login_screen.dart';
import 'package:riverpod_test/presentation/auth/register/state/register_provider.dart';
import 'package:riverpod_test/presentation/home/home_screen.dart';
import 'package:riverpod_test/theme/app_text_style.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final GlobalKey<FormState> key = GlobalKey<FormState>();

  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<void>>(registerProvider, (pref, next) {
      next.when(
          data: (_) {
            appnavigator.pushReplacement(HomeScreen(), null);
          },
          error: (error, _) {
            final message =
                error is Exception ? error.toString() : 'Unknown Error';
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(message)));
          },
          loading: () {});
    });
    final registerState = ref.watch(registerProvider);
    return Scaffold(
      body: Container(
        color: Color(0xff322E3E),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 250,
              pinned: true,
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
            registerState.isLoading
                ? SliverFillRemaining(
                    child: LoadingAnimationWidget.inkDrop(
                        color: Colors.yellow, size: 25),
                  )
                : SliverToBoxAdapter(
                    child: Center(
                      child: Form(
                        key: key,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 70),
                          child: Column(
                            children: [
                              textfield(_name, 'Name', 'User-name'),
                              textfieldEmail(_email, 'Email', 'Email'),
                              textfieldPh(
                                  _phone, 'Phone number', 'Phone number'),
                              textfieldPsw(_password, 'Password', 'Password'),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 3),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      side: BorderSide(color: Colors.blue)),
                                  onPressed: () {
                                    if (!key.currentState!.validate()) return;
                                    ref
                                        .read(registerProvider.notifier)
                                        .register(RegisterModel(
                                            name: _name.text.trim(),
                                            email: _email.text.trim(),
                                            phone: _phone.text.trim(),
                                            password: _password.text.trim()));
                                  },
                                  child: Text(
                                    'Sign up',
                                    style: 13.sp(),
                                  )),
                              SizedBox(
                                height: 20,
                              ),
                              GestureDetector(
                                onTap: () {
                                  appnavigator.push(LoginScreen());
                                },
                                child: RichText(
                                    text: TextSpan(children: [
                                  TextSpan(
                                      text: 'Already have an account?  ',
                                      style: 12.sp(color: Colors.grey)),
                                  TextSpan(
                                      text: 'Log-in',
                                      style: 14
                                          .sp(color: Colors.white)
                                          .copyWith(
                                              decoration:
                                                  TextDecoration.underline))
                                ])),
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

Widget textfield(TextEditingController ctr, String hint, String text) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 15),
    child: TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: ctr,
      decoration: InputDecoration(
          hintText: hint,
          hintStyle: 16.sp(),
          filled: true,
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
        if (value == null || value.isEmpty) return '$text must not be empty';
        return null;
      },
    ),
  );
}

Widget textfieldPh(TextEditingController ctr, String hint, String text) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 15),
    child: TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: ctr,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          hintText: hint,
          hintStyle: 16.sp(),
          filled: true,
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.black)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.greenAccent)),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.greenAccent))),
      // validator: (value) {
      //   if (value == null || value.isEmpty) return '$text must not be empty';
      //   return null;
      // },
    ),
  );
}

Widget textfieldEmail(TextEditingController ctr, String hint, String text) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 15),
    child: TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: ctr,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
          hintText: hint,
          hintStyle: 16.sp(),
          filled: true,
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
        if (value == null || value.isEmpty) return '$text must not be empty';
        if (!EmailValidator.validate(value)) return 'Invalid email';
        return null;
      },
    ),
  );
}

Widget textfieldPsw(TextEditingController ctr, String hint, String text) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 15),
    child: TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: ctr,
      decoration: InputDecoration(
          hintText: hint,
          hintStyle: 16.sp(),
          filled: true,
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
        if (value == null || value.isEmpty) return '$text must not be empty';
        if (value.length < 8) return '$text must be greater than 8';
        return null;
      },
    ),
  );
}
