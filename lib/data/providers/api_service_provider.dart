import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qms_mobile/data/services/api_service.dart';

final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService();
});
