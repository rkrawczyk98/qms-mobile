import 'package:flutter/material.dart';
import 'package:qms_mobile/views/screens/core-app/settings_screen.dart';
import 'package:qms_mobile/views/screens/login/login_screen.dart';

class AppRoutes {
  static const String login = '/login';
  static const String home = '/home';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      login: (context) => const LoginPage(),
      home: (context) => const SettingsScreen(),
    };
  }
}
