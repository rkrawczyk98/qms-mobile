import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const String _themeModeKey = 'themeMode';
  static const String _languageCodeKey = 'languageCode';
  static const String _notificationsEnabledKey = 'notificationsEnabled';

  // Save selected theme
  Future<void> saveThemeMode(String themeMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeModeKey, themeMode);
  }

  // Get saved theme
  Future<String?> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_themeModeKey);
  }

  // Save selected language
  Future<void> saveLanguageCode(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageCodeKey, languageCode);
  }

  // Get saved language
  Future<String?> getLanguageCode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_languageCodeKey);
  }

  // Save notification setting
  Future<void> saveNotificationsEnabled(bool isEnabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notificationsEnabledKey, isEnabled);
  }

  // Get notification setting
  Future<bool> getNotificationsEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_notificationsEnabledKey) ?? true; // Default to true
  }
}

final preferencesService = PreferencesService();
