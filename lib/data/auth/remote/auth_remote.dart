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
      throw Exception(
          '${e.response!.statusCode} : ${e.response!.data['message']}');
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

        appnavigator.pushReplacement(HomeScreen(), null);
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
}
