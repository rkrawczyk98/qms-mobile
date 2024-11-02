import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthInterceptor extends Interceptor {
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  final List<String> endpointsToSkip;

  AuthInterceptor({required this.endpointsToSkip});

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    //Check if the endpoint is on the list of those that should skip adding the header
    if (!endpointsToSkip.any((endpoint) => options.path.contains(endpoint))) {
      // Get token
      final accessToken = await secureStorage.read(key: 'access_token');
      if (accessToken != null) {
        options.headers['Authorization'] = 'Bearer $accessToken';
      }
    }
    return super.onRequest(options, handler);
  }
}
