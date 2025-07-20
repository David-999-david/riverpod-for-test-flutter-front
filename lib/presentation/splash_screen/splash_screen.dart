import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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
                  ? SpinKitDualRing(
                      color: Colors.yellow,
                      size: 25,
                      duration: Duration(seconds: 5),
                    )
                  : SizedBox.shrink())
        ],
      ),
    ));
  }
}
