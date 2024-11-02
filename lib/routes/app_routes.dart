import 'package:flutter/material.dart';
import 'package:qms_mobile/views/screens/about_app_screen.dart';
import 'package:qms_mobile/views/screens/settings_screen.dart';
import 'package:qms_mobile/views/screens/login_screen.dart';
import 'package:qms_mobile/views/widgets/log_viewer.dart';

class AppRoutes {
  static const String login = '/login';
  static const String home = '/home';
  static const String about = '/about';
  static const String settings = '/settings';
  static const String logs = '/logs';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      login: (context) => const LoginScreen(),
      home: (context) => const SettingsScreen(),
      about: (context) => const AboutAppScreen(),
      settings: (context) => const SettingsScreen(),
      logs: (context) => const LogViewer(),
    };
  }
}
