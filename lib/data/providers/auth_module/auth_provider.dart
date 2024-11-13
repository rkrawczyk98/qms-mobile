import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qms_mobile/data/providers/api_service_provider.dart';
import 'package:qms_mobile/data/services/auth_module/auth_service.dart';
import 'package:qms_mobile/utils/helpers/token_manager.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  final apiService = ref.read(apiServiceProvider);
  final tokenManager = TokenManager();
  return AuthService(apiService, tokenManager);
});

final isLoggedInProvider = StateProvider<bool>((ref) => false);
