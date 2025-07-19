import 'package:dio/dio.dart';
import 'package:riverpod_test/api_url.dart';
import 'package:riverpod_test/auth_interceptor.dart';
import 'package:riverpod_test/logger_interceptor.dart';

class DioClient {
  static late final _dio;

  static Future<void> init() async {
    final Dio dio = Dio(
      BaseOptions(
          baseUrl: ApiUrl.baseUrl,
          headers: {'Content-Type': 'application/json'},
          responseType: ResponseType.json,
          connectTimeout: Duration(seconds: 60),
          receiveTimeout: Duration(seconds: 60),
          sendTimeout: Duration(seconds: 10)),
    );

    final auth = await AuthInterceptor.create(dio);
    dio.interceptors.add(auth);
    dio.interceptors.add(LoggerInterceptor());
    _dio = dio;
  }

  static Dio get dio {
    if (_dio == null) {
      throw Exception('Error in dio call');
    }
    return _dio;
  }
}
