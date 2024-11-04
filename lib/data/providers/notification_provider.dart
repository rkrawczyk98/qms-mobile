import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qms_mobile/data/services/preferences_service.dart';

final notificationsProvider =
    StateNotifierProvider<NotificationSettingsNotifier, bool>((ref) {
  return NotificationSettingsNotifier();
});

class NotificationSettingsNotifier extends StateNotifier<bool> {
  NotificationSettingsNotifier() : super(true) {
    _loadNotificationsSetting();
  }

  Future<void> _loadNotificationsSetting() async {
    final isEnabled = await preferencesService.getNotificationsEnabled();
    state = isEnabled;
  }

  void setNotificationsEnabled(bool isEnabled) {
    state = isEnabled;
    preferencesService.saveNotificationsEnabled(isEnabled);
  }
}
