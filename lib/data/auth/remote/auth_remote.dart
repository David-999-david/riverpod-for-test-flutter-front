import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_test/api_url.dart';
import 'package:riverpod_test/data/auth/model/user_model.dart';
import 'package:riverpod_test/dio_client.dart';
import 'package:riverpod_test/local.dart';

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
}
