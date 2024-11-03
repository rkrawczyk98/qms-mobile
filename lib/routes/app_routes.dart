import 'package:flutter/material.dart';
import 'package:qms_mobile/views/screens/admin_panel/admin_panel.dart';
import 'package:qms_mobile/views/screens/admin_panel/client_management_screen.dart';
import 'package:qms_mobile/views/screens/admin_panel/component_management_screen.dart';
import 'package:qms_mobile/views/screens/admin_panel/delivery_management_screen.dart';
import 'package:qms_mobile/views/screens/admin_panel/inventory_management_screen.dart';
import 'package:qms_mobile/views/screens/admin_panel/user_management_screen.dart';
import 'package:qms_mobile/views/screens/home_screen.dart';
import 'package:qms_mobile/views/screens/settings/about_app_screen.dart';
import 'package:qms_mobile/views/screens/settings/change_password_screen.dart';
import 'package:qms_mobile/views/screens/settings/settings_screen.dart';
import 'package:qms_mobile/views/screens/login_screen.dart';
import 'package:qms_mobile/views/screens/settings/user_profile_screen.dart';
import 'package:qms_mobile/views/widgets/log_viewer.dart';

class AppRoutes {
  static const String login = '/login';
  static const String home = '/home';
  static const String about = '/about';
  static const String settings = '/settings';
  static const String logs = '/logs';
  static const String changePassword = '/change-password';
  static const String profile = '/profile';
  static const String adminPanel = '/admin-panel';
  static const String userManagement = '/admin-panel/user-management';
  static const String deliveryManagement = '/admin-panel/delivery-management';
  static const String clientManagement = '/admin-panel/client-management';
  static const String componentManagement = '/admin-panel/component-management';
  static const String inventoryManagement = '/admin-panel/inventory-management';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      login: (context) => const LoginScreen(),
      home: (context) => const HomeScreen(),
      about: (context) => const AboutAppScreen(),
      settings: (context) => const SettingsScreen(),
      logs: (context) => const LogViewer(),
      changePassword: (context) => const ChangePasswordScreen(),
      profile: (context) => const UserProfileScreen(),
      adminPanel: (context) => const AdminPanelScreen(),
      userManagement: (context) => const UserManagementScreen(),
      deliveryManagement: (context) => const DeliveryManagementScreen(),
      clientManagement: (context) => const ClientManagementScreen(),
      componentManagement: (context) => const ComponentManagementScreen(),
      inventoryManagement: (context) => const InventoryManagementScreen(),
    };
  }
}
