import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:riverpod_test/api_url.dart';
import 'package:riverpod_test/app_navigator.dart';
import 'package:riverpod_test/local.dart';
import 'package:riverpod_test/presentation/auth/login/login_screen.dart';

class AuthInterceptor extends Interceptor {
  final FlutterSecureStorage _storage;
  final Dio _refreshDio;
  final Dio _dio;

  AuthInterceptor._(this._storage, this._refreshDio, this._dio);

  static Future<AuthInterceptor> create(Dio dio) async {
    final storage = FlutterSecureStorage();
    final refreshDio = Dio(BaseOptions(
        baseUrl: ApiUrl.baseUrl,
        headers: {'Content-Type': 'application/json'}));
    return AuthInterceptor._(storage, refreshDio, dio);
  }

  final publicPath = ['/auth/register', '/auth/refresh', '/auth/login'];

  bool isJwtExpired(String? token) {
    return token == null || JwtDecoder.isExpired(token);
  }

  Future<bool> refresh() async {
    String? refreshTk = await _storage.read(key: Local.refreshToken);
    if (isJwtExpired(refreshTk)) return false;

    final response =
        await _refreshDio.post(ApiUrl.refresh, data: {'refreshTok': refreshTk});

    final statusCode = response.statusCode!;

    if (statusCode >= 200 && statusCode < 300) {
      final data = response.data['data'] as Map<String, dynamic>;

      final newAccess = data['newAccess'];
      final newRefresh = data['newRefresh'];

      if (newAccess == null || newRefresh == null) return false;

      await _storage.write(key: Local.accessToken, value: newAccess);
      await _storage.write(key: Local.refreshToken, value: newRefresh);
      return true;
    } else {
      throw Exception(
          'Failed to generate new access and refresh for refresh call');
    }
  }

  Future<void> _handleExpiredSession(RequestOptions options,
      {RequestInterceptorHandler? reqHandler,
      ErrorInterceptorHandler? errHandler}) async {
    await _storage.delete(key: Local.accessToken);
    await _storage.delete(key: Local.refreshToken);
    AppNavigator().pushAndRemoveUntil(LoginScreen(), (_) => false);
    final DioException exception = DioException(
        requestOptions: options,
        response: Response(requestOptions: options, statusCode: 401),
        error: 'SESSION EXPIRED',
        type: DioExceptionType.cancel);

    if (reqHandler != null) {
      reqHandler.reject(exception);
    }
    if (errHandler != null) {
      errHandler.reject(exception);
    }
  }

  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    if (publicPath.contains(options.path)) {
      return handler.next(options);
    }

    String? access = await _storage.read(key: Local.accessToken);

    if (isJwtExpired(access)) {
      final didRefresh = await refresh();

      if (!didRefresh) {
        return _handleExpiredSession(options, reqHandler: handler);
      } else {
        access = await _storage.read(key: Local.accessToken);
      }
    }

    if (access != null && !isJwtExpired(access)) {
      options.headers['Authorization'] = 'Bearer $access';
      return handler.next(options);
    } else {
      return _handleExpiredSession(options);
    }
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    return handler.next(response);
  }

  @override
  Future<void> onError(
      DioException err, ErrorInterceptorHandler handler) async {
    final errPath = err.requestOptions.path;
    final response = err.response;

    if (response == null) {
      return handler.next(err);
    }

    final status = response.statusCode ?? 0;

    if (publicPath.contains(errPath)) {
      return handler.next(err);
    }

    if ((status == 401 || status == 403) && err.error != 'SESSION EXPIRED') {
      bool didRefresh = false;
      try {
        didRefresh = await refresh();
      } catch (e) {
        didRefresh = false;
      }

      if (didRefresh) {
        String? access = await _storage.read(key: Local.accessToken);

        final errOpts = err.requestOptions
          ..copyWith(headers: {
            ...err.requestOptions.headers,
            'Authorization': 'Bearer $access'
          });

        try {
          final retry = await _dio.fetch(errOpts);
          return handler.resolve(retry);
        } catch (e) {
          handler.next(e as DioException);
        }
      } else {
        return _handleExpiredSession(err.requestOptions, errHandler: handler);
      }
    } else {
      handler.next(err);
    }
  }
}
