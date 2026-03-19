import 'package:dio/dio.dart';
import '../storage/secure_storage.dart';

class ApiClient {
  static const _baseUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: 'https://api.alochi.uz',
  );
  late final Dio _dio;

  ApiClient() {
    _dio = Dio(BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {'Content-Type': 'application/json'},
    ));

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await SecureStorage.getAccessToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (error, handler) async {
        if (error.response?.statusCode == 401) {
          final refreshed = await _tryRefresh();
          if (refreshed) {
            final token = await SecureStorage.getAccessToken();
            error.requestOptions.headers['Authorization'] = 'Bearer $token';
            try {
              final response = await _dio.fetch(error.requestOptions);
              return handler.resolve(response);
            } catch (e) {
              return handler.next(error);
            }
          } else {
            await SecureStorage.clear();
          }
        }
        return handler.next(error);
      },
    ));
  }

  Future<bool> _tryRefresh() async {
    try {
      final refresh = await SecureStorage.getRefreshToken();
      if (refresh == null) return false;
      final res = await Dio().post('$_baseUrl/auth/refresh', data: {'refresh': refresh});
      await SecureStorage.saveTokens(
        access: res.data['access'],
        refresh: refresh,
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<Response> get(String path, {Map<String, dynamic>? params}) =>
      _dio.get(path, queryParameters: params);

  Future<Response> post(String path, {dynamic data}) => _dio.post(path, data: data);

  Future<Response> patch(String path, {dynamic data}) => _dio.patch(path, data: data);

  Future<Response> delete(String path) => _dio.delete(path);
}

final apiClient = ApiClient();
