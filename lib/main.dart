import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_test/app_navigator.dart';
import 'package:riverpod_test/dio_client.dart';
import 'package:riverpod_test/presentation/auth/login/login_screen.dart';
import 'package:riverpod_test/presentation/splash_screen/splash_screen.dart';
import 'package:riverpod_test/theme/app_theme.dart';

final appnavigator = AppNavigator();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await DioClient.init();
  runApp(ProviderScope(child: Myapp()));
}

class Myapp extends StatelessWidget {
  const Myapp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: appnavigator.navigatorKey,
      theme: AppTheme().appTheme,
      home: SplashScreen(),
    );
  }
}
