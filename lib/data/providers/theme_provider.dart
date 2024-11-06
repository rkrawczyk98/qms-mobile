import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qms_mobile/data/services/user_module/preferences_service.dart';

final themeModeProvider =
    StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  return ThemeModeNotifier();
});

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(ThemeMode.system) {
    _initializeThemeMode();
  }

  Future<void> _initializeThemeMode() async {
    final savedTheme = await preferencesService.getThemeMode();
    if (savedTheme != null) {
      state =
          ThemeMode.values.firstWhere((mode) => mode.toString() == savedTheme);
    }
  }

  void setThemeMode(ThemeMode newMode) {
    state = newMode;
    preferencesService.saveThemeMode(newMode.toString());
  }
}
