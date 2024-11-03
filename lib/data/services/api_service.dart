import 'package:dio/dio.dart';
import 'package:qms_mobile/utils/interceptors/auth_interceptor.dart';
import 'package:qms_mobile/utils/interceptors/error_interceptor.dart';

class ApiService {
  final Dio _dio;

  ApiService() : _dio = Dio() {
    _dio.options = BaseOptions(
      baseUrl: 'http://192.168.56.1:8080',
      headers: {
        'Content-Type':
            'application/json; charset=UTF-8',
      },
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
      sendTimeout: const Duration(seconds: 5)
    );

    // List of endpoints that should skip adding the Authorization header
    final List<String> endpointsToSkip = [
      '/auth/login',
      '/auth/refresh',
      '/auth/logout',
    ];

    _dio.interceptors.add(ErrorInterceptor());
    _dio.interceptors.add(AuthInterceptor(endpointsToSkip: endpointsToSkip));
  }

  Dio get dio => _dio;
}
