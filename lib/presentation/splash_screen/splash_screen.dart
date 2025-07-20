import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:riverpod_test/main.dart';
import 'package:riverpod_test/presentation/auth/login/login_screen.dart';
import 'package:riverpod_test/presentation/home/home_screen.dart';
import 'package:riverpod_test/presentation/splash_screen/state/splash_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    Future.microtask(() {
      ref.read(splashprovider.notifier).handleStartScreen();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // ref.listen<AsyncValue<void>>(splashprovider, (prev, next) {
    //   next.when(
    //       data: (_) {
    //         appnavigator.pushReplacement(HomeScreen(), null);
    //       },
    //       error: (error, _) {
    //         appnavigator.pushAndRemoveUntil(LoginScreen(), (_) => false);
    //       },
    //       loading: () {});
    // });

    final splashState = ref.watch(splashprovider);
    return Scaffold(
        body: Center(
          child: Stack(
                children: [
          Image.asset(
            'assets/images/cool2.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          DecoratedBox(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Colors.blueGrey, Colors.green],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter))),
          Positioned(
              bottom: 140,
              left: 180,
              child: splashState.isLoading
                  ? LoadingAnimationWidget.inkDrop(
                      color: Colors.yellow,
                      size: 30,
                    )
                  : SizedBox.shrink())
                ],
              ),
        ));
  }
}
