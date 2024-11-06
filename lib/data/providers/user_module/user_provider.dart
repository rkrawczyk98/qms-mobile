import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qms_mobile/data/models/DTOs/auth_module/user_info.dart';
import 'package:qms_mobile/data/providers/api_service_provider.dart';
import 'package:qms_mobile/data/services/user_module/user_service.dart';
import 'package:qms_mobile/utils/helpers/auth_storage.dart';

class UserNotifier extends StateNotifier<UserInfo?> {
  UserNotifier() : super(null);

  Future<void> logOut() async {
    // Clearing login data from memory
    await AuthStorage.deleteLoginData();
    // Set state to `null` to clear user information
    state = null;
  }

  void setUser(UserInfo user) {
    state = user;
  }

  bool get isLoggedIn => state != null;
}

final userProvider = StateNotifierProvider<UserNotifier, UserInfo?>((ref) {
  return UserNotifier();
});


final userServiceProvider = Provider<UserService>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return UserService(apiService);
});