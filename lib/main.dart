import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_test/app_navigator.dart';
import 'package:riverpod_test/dio_client.dart';
import 'package:riverpod_test/presentation/user/user_home/user_home.dart';
import 'package:riverpod_test/presentation/auth/forgotpassword/email_verify/email_verified_screen.dart';
import 'package:riverpod_test/presentation/auth/forgotpassword/otp_verify/otp_verify.dart';
import 'package:riverpod_test/presentation/auth/forgotpassword/reset_password/reset_password.dart';
import 'package:riverpod_test/presentation/auth/login/login_screen.dart';
import 'package:riverpod_test/presentation/auth/register/register_screen.dart';
import 'package:riverpod_test/presentation/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:riverpod_test/presentation/filter/filter.dart';
import 'package:riverpod_test/presentation/author/home/home_screen.dart';
import 'package:riverpod_test/presentation/search_screen/search.dart';
import 'package:riverpod_test/presentation/setting/setting.dart';
import 'package:riverpod_test/presentation/splash_screen/splash_screen.dart';
import 'package:riverpod_test/routes/routes.dart';
import 'package:riverpod_test/theme/app_theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final appnavigator = AppNavigator();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
 
  await DioClient.init();

  await dotenv.load(fileName: ".env");

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANNON_KEY']!
  );
  runApp(
      //   ProviderScope(
      //   overrides: [
      //     navProvider.overrideWith((ref) {
      //       final notfier = NavNotifier();
      //       notfier.setIndex(2);
      //       return notfier;
      //     })
      //   ],
      //   child: Myapp(),
      // ));
      ProviderScope(child: Myapp()));
}

class Myapp extends StatelessWidget {
  const Myapp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: appnavigator.navigatorKey,
      theme: AppTheme().appTheme,
      initialRoute: Routes.splash,
      routes: {
        Routes.splash: (_) => SplashScreen(),
        Routes.login: (_) => LoginScreen(),
        Routes.register: (_) => RegisterScreen(),
        Routes.verifyemail: (_) => EmailVerifiedScreen(),
        Routes.verifyOtp: (_) => OtpVerify(),
        Routes.resetPsw: (_) => ResetPassword(),
        Routes.nav: (_) => BottomNavBar(),
        Routes.home: (_) => HomeScreen(),
        Routes.address: (_) => UserHome(),
        Routes.filter: (_) => Filter(),
        Routes.search: (_) => Search(),
        Routes.setting: (_) => Setting()
      },
    );
  }
}
