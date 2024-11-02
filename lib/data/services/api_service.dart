import 'package:dio/dio.dart';
import 'package:qms_mobile/utils/interceptors/error_interceptor.dart';

class ApiService {
  final Dio _dio;

  ApiService()
      : _dio = Dio() {
    _dio.options.baseUrl = 'http://localhost:8080';
    _dio.interceptors.add(ErrorInterceptor());
  }

  Dio get dio => _dio;
}
