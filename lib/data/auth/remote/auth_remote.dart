import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:riverpod_test/api_url.dart';
import 'package:riverpod_test/data/auth/model/user_model.dart';
import 'package:riverpod_test/dio_client.dart';
import 'package:riverpod_test/local.dart';
import 'package:riverpod_test/main.dart';
import 'package:riverpod_test/presentation/auth/login/login_screen.dart';
import 'package:riverpod_test/presentation/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:riverpod_test/presentation/home/home_screen.dart';

class AuthRemote {
  final Dio _dio = DioClient.dio;

  final FlutterSecureStorage storage = FlutterSecureStorage();

  Future<void> register(RegisterModel user) async {
    try {
      final response = await _dio.post(ApiUrl.register, data: user.toJson());

      final status = response.statusCode!;
      if (status >= 200 && status < 300) {
        final data = response.data['data'] as Map<String, dynamic>;

        final access = data['access'] as String?;

        final refresh = data['refresh'] as String?;

        if (access == null || refresh == null) {
          throw Exception('Access or Refresh Token is missing');
        }

        await storage.write(key: Local.accessToken, value: access);

        await storage.write(key: Local.refreshToken, value: refresh);
      } else {
        throw Exception(
            'Error => status:$status , message:${response.data['message']}');
      }
    } on DioException catch (e) {
      throw Exception(
          '${e.response!.statusCode} : ${e.response!.data['message']}');
    }
  }

  Future<void> login(LoginModel user) async {
    try {
      final response = await _dio.post(ApiUrl.login, data: user.toJson());

      final status = response.statusCode!;

      if (status >= 200 && status < 300) {
        final data = response.data['data'] as Map<String, dynamic>;

        final access = data['access'];
        final refresh = data['refresh'];

        if (access == null || refresh == null) {
          throw Exception('Access or refresh token is missing');
        }

        await storage.write(key: Local.accessToken, value: access);

        await storage.write(key: Local.refreshToken, value: refresh);
      } else {
        throw Exception(
            'Error => status=$status , message : ${response.data['message']}');
      }
    } on DioException catch (e) {
      throw Exception(' ${e.response!.data['message']}');
    }
  }

  bool isJwtExpired(String? token) {
    return token == null || JwtDecoder.isExpired(token);
  }

  Future<void> handleStartScreen() async {
    String? refresh = await storage.read(key: Local.refreshToken);

    if (isJwtExpired(refresh)) {
      debugPrint('Refresh Token is Expired');
      await storage.delete(key: Local.accessToken);
      await storage.delete(key: Local.refreshToken);
      appnavigator.pushAndRemoveUntil(LoginScreen(), (_) => false);
      return;
    }

    try {
      final response =
          await _dio.post(ApiUrl.refresh, data: {'refreshTok': refresh});

      final status = response.statusCode!;

      if (status >= 200 && status < 300) {
        final data = response.data['data'] as Map<String, dynamic>;

        final newAccess = data['newAccess'] as String?;

        final newRefresh = data['newRefresh'] as String?;

        if (newAccess == null || newRefresh == null) {
          appnavigator.pushAndRemoveUntil(LoginScreen(), (_) => false);
          return;
        }

        await storage.write(key: Local.accessToken, value: newAccess);

        await storage.write(key: Local.refreshToken, value: newRefresh);

        appnavigator.pushReplacement(BottomNavBar(), null);
      } else {
        await storage.delete(key: Local.accessToken);
        await storage.delete(key: Local.refreshToken);
        appnavigator.pushAndRemoveUntil(LoginScreen(), (_) => false);
        return;
      }
    } on DioException catch (e) {
      await storage.delete(key: Local.accessToken);
      await storage.delete(key: Local.refreshToken);
      appnavigator.pushAndRemoveUntil(LoginScreen(), (_) => false);
      throw Exception(
          '${e.response!.statusCode} : ${e.response!.data['message']}');
    }
  }

  // bool isJwtExpired(String token) {
  //   return JwtDecoder.isExpired(token);
  // }

  // Future<void> handleStartScreen() async {
  //   String? access = await storage.read(key: Local.accessToken);

  //   final refresh = await storage.read(key: Local.refreshToken);

  //   if (access == null && refresh == null) {
  //     appnavigator.pushReplacement(
  //         BottomNavBar(
  //           0,
  //         ),
  //         (_) => false);
  //     return;
  //   }

  //   if (refresh != null && isJwtExpired(refresh)) {
  //     debugPrint('Refresh Token is Expired');
  //     await storage.delete(key: Local.accessToken);
  //     await storage.delete(key: Local.refreshToken);
  //     appnavigator.pushAndRemoveUntil(LoginScreen(), (_) => false);
  //     return;
  //   }

  //   try {
  //     final response =
  //         await _dio.post(ApiUrl.refresh, data: {'refreshTok': refresh});

  //     final status = response.statusCode!;

  //     if (status >= 200 && status < 300) {
  //       final data = response.data['data'] as Map<String, dynamic>;

  //       final newAccess = data['newAccess'] as String?;

  //       final newRefresh = data['newRefresh'] as String?;

  //       if (newAccess == null || newRefresh == null) {
  //         appnavigator.pushAndRemoveUntil(LoginScreen(), (_) => false);
  //         return;
  //       }

  //       await storage.write(key: Local.accessToken, value: newAccess);

  //       await storage.write(key: Local.refreshToken, value: newRefresh);

  //       appnavigator.pushReplacement(
  //           BottomNavBar(
  //             0,
  //           ),
  //           null);
  //     } else {
  //       await storage.delete(key: Local.accessToken);
  //       await storage.delete(key: Local.refreshToken);
  //       appnavigator.pushAndRemoveUntil(LoginScreen(), (_) => false);
  //       return;
  //     }
  //   } on DioException catch (e) {
  //     await storage.delete(key: Local.accessToken);
  //     await storage.delete(key: Local.refreshToken);
  //     appnavigator.pushAndRemoveUntil(LoginScreen(), (_) => false);
  //     throw Exception(
  //         '${e.response!.statusCode} : ${e.response!.data['message']}');
  //   }
  // }

  Future<String> requestOtp(String email) async {
    try {
      final response =
          await _dio.post(ApiUrl.requestOtp, data: {'email': email});

      final status = response.statusCode!;

      if (status >= 200 && status < 300) {
        final message = response.data['message'];
        return message;
      } else {
        throw Exception(
            'Error => status=$status, message : ${response.data['message']}');
      }
    } on DioException catch (e) {
      throw Exception('${e.response!.data['message']} ');
    }
  }

  Future<void> verifyOtp(String email, String otp) async {
    try {
      final response =
          await _dio.post(ApiUrl.verifyOtp, data: {'email': email, 'otp': otp});

      final status = response.statusCode!;

      if (status >= 200 && status < 300) {
        final resetTk = response.data['resetToken'];

        if (resetTk != null) {
          await storage.write(key: Local.resetToken, value: resetTk);
        } else {
          throw Exception('RESET Token is missing');
        }
      } else {
        throw Exception(
            'Error => status=$status, message : ${response.data['message']}');
      }
    } on DioException catch (e) {
      throw Exception('${e.response!.data['message']}');
    }
  }

  Future<String> changePsw(String newPsw) async {
    try {
      String? resetToken = await storage.read(key: Local.resetToken);

      if (resetToken == null) {
        throw Exception('Reset Token is missing');
      }

      final response = await _dio.post(ApiUrl.changePsw,
          data: {'resetToken': resetToken, 'newPsw': newPsw});

      final status = response.statusCode!;

      if (status >= 200 && status < 300) {
        final message = response.data['data'] as String;
        return message;
      } else {
        throw Exception(
            'Error => status=$status, message : ${response.data['message']}');
      }
    } on DioException catch (e) {
      throw Exception('${e.response!.data['message']}');
    }
  }

  Future<String> checkSecreKey(String secretKey) async {
    try {
      final response =
          await _dio.post(ApiUrl.checkSecret, data: {'secret_key': secretKey});

      final status = response.statusCode!;

      if (status >= 200 && status < 300) {
        final data = response.data['data'] as String;
        return data;
      } else {
        throw Exception(
            'Error => status==$status, message : ${response.data['message']}');
      }
    } on DioException catch (e) {
      throw Exception('${e.response!.data['message']}');
    }
  }

  Future<void> verifyOtpAndUpgrade(String otp) async {
    try {
      final response = await _dio.post(ApiUrl.authorOtp, data: {'otp': otp});

      final status = response.statusCode!;

      if (status >= 200 && status < 300) {
        final data = response.data['data'] as Map<String, dynamic>;

        final access = data['access'];

        final refresh = data['refresh'];

        if (access == null) {
          throw Exception('Access token is missing');
        }

        if (refresh == null) {
          throw Exception('refresh token is missing');
        }

        await storage.delete(key: Local.accessToken);
        await storage.delete(key: Local.refreshToken);

        try {
          await storage.write(key: Local.accessToken, value: access);
          await storage.write(key: Local.refreshToken, value: refresh);
        } catch (e) {
          throw Exception('Access or refresh failed to store in local storage');
        }
      } else {
        throw Exception(
            'Error => status=$status, message : ${response.data['message']}');
      }
    } on DioException catch (e) {
      throw Exception('${e.response!.data['message']}');
    }
  }

  Future<void> signOut() async {
    try {
      String? refresh = await storage.read(key: Local.refreshToken);

      if (refresh == null) {
        appnavigator.pushAndRemoveUntil(LoginScreen(), (_) => false);
      }

      final response =
          await _dio.post(ApiUrl.logOut, data: {'refreshToken': refresh});

      final status = response.statusCode!;

      if (status >= 200 && status < 300) {
        await Future.wait([
          storage.delete(key: Local.accessToken),
          storage.delete(key: Local.refreshToken)
        ]);

        appnavigator.pushAndRemoveUntil(LoginScreen(), (_) => false);
      } else {}
    } on DioException catch (e) {
      throw Exception('Error =>${e.response!.data['message']}');
    }
  }
}
