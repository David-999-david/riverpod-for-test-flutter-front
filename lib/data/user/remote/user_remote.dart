import 'package:dio/dio.dart';
import 'package:riverpod_test/api_url.dart';
import 'package:riverpod_test/data/user/model/author_model.dart';
import 'package:riverpod_test/data/user/model/user_info_mode.dart';
import 'package:riverpod_test/dio_client.dart';

class UserRemote {
  final Dio _dio = DioClient.dio;

  Future<UserInfoMode> getUserInfo() async {
    try {
      final response = await _dio.get(ApiUrl.userinfo);

      final status = response.statusCode!;

      if (status >= 200 && status < 300) {
        final data = response.data['data'];
        return UserInfoMode.fromJson(data);
      } else {
        throw Exception(
            'Error => status=$status, message : ${response.data['message']}');
      }
    } on DioException catch (e) {
      throw Exception('${e.response!.data['message']}');
    }
  }

  Future<List<AuthorModel>> showAllAuthors() async {
    try {
      final response = await _dio.get(ApiUrl.getAuthors);

      final status = response.statusCode!;

      if (status >= 200 && status < 300) {
        final data = response.data['data'] as List<dynamic>;

        return data.map((a) => AuthorModel.fromJson(a)).toList();
      } else {
        throw Exception(
            'Error => status=$status, message : ${response.data['message']}');
      }
    } on DioException catch (e) {
      throw Exception('${e.response!.data['messaage']}');
    }
  }
}
