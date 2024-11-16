import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:qms_mobile/utils/interceptors/auth_interceptor.dart';
import 'package:qms_mobile/utils/interceptors/error_interceptor.dart';
import 'package:qms_mobile/utils/helpers/token_manager.dart';

class ApiService {
  final Dio _dio;
  final CookieJar _cookieJar;
  final TokenManager _tokenManager = TokenManager();

  ApiService()
      : _dio = Dio(),
        _cookieJar = CookieJar() {
    _dio.options = BaseOptions(
      baseUrl: 'http://10.0.1.31:8080',
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
      sendTimeout: const Duration(seconds: 5),
      extra: {'withCredentials': true},
    );

    _dio.interceptors.add(CookieManager(_cookieJar));

    final List<String> endpointsToSkip = [
      '/auth/login',
      '/auth/refresh',
      '/auth/logout',
    ];

    _dio.interceptors.add(AuthInterceptor(
      endpointsToSkip: endpointsToSkip,
      apiService: this,
      tokenManager: _tokenManager,
    ));
    _dio.interceptors.add(ErrorInterceptor());
  }

  Dio get dio => _dio;
}
