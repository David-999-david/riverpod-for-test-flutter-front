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
    super.initState();
    Future.microtask(() {
      ref.read(splashprovider.notifier).handleStartScreen();
      // ref.read(userProvider.notifier).getInfo();
    });
  }

  @override
  Widget build(BuildContext context) {
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
