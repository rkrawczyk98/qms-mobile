import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qms_mobile/data/providers/api_service_provider.dart';
import 'package:qms_mobile/data/services/auth_module/auth_service.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return AuthService(apiService);
});

final isLoggedInProvider = StateProvider<bool>((ref) => false);