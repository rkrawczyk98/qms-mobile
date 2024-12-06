import 'package:flutter/material.dart';
import 'package:qms_mobile/views/screens/component/add_component_screen.dart';
import 'package:qms_mobile/views/screens/component/component_manage_screen.dart';
import 'package:qms_mobile/views/screens/component/component_edit_screen.dart';
import 'package:qms_mobile/views/screens/component/component_screen.dart';
import 'package:qms_mobile/views/screens/admin_panel/component_managment/component_type/create_component_type_screen.dart';
import 'package:qms_mobile/views/screens/admin_panel/customer_managment/create_customer_screen.dart';
import 'package:qms_mobile/views/screens/admin_panel/customer_managment/manage_customer_screen.dart';
import 'package:qms_mobile/views/screens/admin_panel/delivery_managment/create_delivery_status_screen.dart';
import 'package:qms_mobile/views/screens/admin_panel/delivery_managment/manage_delivery_status_screen.dart';
import 'package:qms_mobile/views/screens/admin_panel/navigation/customer_management_screen.dart';
import 'package:qms_mobile/views/screens/admin_panel/user_managment/create_user_screen.dart';
import 'package:qms_mobile/views/screens/admin_panel/user_managment/role_permission_managment_screen.dart';
import 'package:qms_mobile/views/screens/admin_panel/user_managment/user_managment_screen.dart';
import 'package:qms_mobile/views/screens/admin_panel/navigation/admin_panel.dart';
import 'package:qms_mobile/views/screens/admin_panel/navigation/component_management_screen.dart';
import 'package:qms_mobile/views/screens/admin_panel/navigation/delivery_management_screen.dart';
import 'package:qms_mobile/views/screens/admin_panel/navigation/warehouse_management_screen.dart';
import 'package:qms_mobile/views/screens/admin_panel/navigation/user_management_screen.dart';
import 'package:qms_mobile/views/screens/admin_panel/warehouse_managment/create_warehouse_position_screen.dart';
import 'package:qms_mobile/views/screens/admin_panel/warehouse_managment/create_warehouse_screen.dart';
import 'package:qms_mobile/views/screens/admin_panel/warehouse_managment/manage_warehouse_positions_screen.dart';
import 'package:qms_mobile/views/screens/admin_panel/warehouse_managment/manage_warehouses_screen.dart';
import 'package:qms_mobile/views/screens/delivery/delivery_contents_screen.dart';
import 'package:qms_mobile/views/screens/delivery/delivery_details_screen.dart';
import 'package:qms_mobile/views/screens/delivery/delivery_screen.dart';
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
  static const String customerManagement = '/admin-panel/customer-management';
  static const String componentManagement = '/admin-panel/component-management';
  static const String warehouseManagement = '/admin-panel/warehouse-management';
  static const String createUser = '/admin-panel/create-user';
  static const String manageUser = '/admin-panel/manage-user';
  static const String rolePermissionManagment =
      '/admin-panel/role-permission-managment';
  static const String deleteCustomer = '/admin-panel/delete-customer';
  static const String createCustomer = '/admin-panel/create-customer';
  static const String manageCustomer = '/admin-panel/manage-customer';
  static const String createWarehouse = '/admin-panel/create-warehouse';
  static const String manageWarehouse = '/admin-panel/manage-warehouse';
  static const String createWarehousePosition =
      '/admin-panel/create-warehouse-position';
  static const String manageWarehousePosition =
      '/admin-panel/manage-warehouse-position';
  static const String createComponentType =
      '/admin-panel/create-component-type';
  static const String deliveryList = '/delivery-list';
  static const String deliveryDetails = '/delivery-details';
  static const String createDeliveryStatus =
      '/admin-panel/create-delivery-status';
  static const String manageDeliveryStatuses =
      '/admin-panel/manage-delivery-statuses';
  static const String componentList = '/component-list';
  static const String componentManage = '/component-manage';
  static const String componentEdit = '/component-edit';
  static const String addComponent = '/add-component';
  static const String deliveryContents = '/delivery-contents';

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
      customerManagement: (context) => const CustomerManagementScreen(),
      componentManagement: (context) => const ComponentManagementScreen(),
      warehouseManagement: (context) => const WarehouseManagementScreen(),
      createUser: (context) => const CreateUserScreen(),
      manageUser: (context) => const ManageUserScreen(),
      rolePermissionManagment: (context) =>
          const RolePermissionManagementScreen(),
      createCustomer: (context) => const CreateCustomerScreen(),
      manageCustomer: (context) => const ManageCustomersScreen(),
      createWarehouse: (context) => const CreateWarehouseScreen(),
      manageWarehouse: (context) => const ManageWarehousesScreen(),
      createWarehousePosition: (context) =>
          const CreateWarehousePositionScreen(),
      manageWarehousePosition: (context) =>
          const ManageWarehousePositionsScreen(),
      createComponentType: (context) => const CreateComponentTypeScreen(),
      deliveryList: (context) => const DeliveryScreen(),
      deliveryDetails: (context) {
        final deliveryId = ModalRoute.of(context)!.settings.arguments as int;
        return DeliveryDetailsScreen(deliveryId: deliveryId);
      },
      createDeliveryStatus: (context) => const CreateDeliveryStatusScreen(),
      manageDeliveryStatuses: (context) => const ManageDeliveryStatusesScreen(),
      componentList: (context) => const ComponentScreen(),
      componentManage: (context) {
        final componentId = ModalRoute.of(context)!.settings.arguments as int;
        return ComponentManageScreen(componentId: componentId);
      },
      componentEdit: (context) {
        final componentId = ModalRoute.of(context)!.settings.arguments as int;
        return ComponentEditScreen(componentId: componentId);
      },
      deliveryContents: (context) {
        final deliveryId = ModalRoute.of(context)!.settings.arguments as int;
        return DeliveryContentsScreen(deliveryId: deliveryId);
      },
      addComponent: (context) {
        final args =
            ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
        final showAppBar = args?['showAppBar'] ?? false;
        final deliveryId = args?['deliveryId'];
        return AddComponentScreen(
          showAppBar: showAppBar,
          deliveryId: deliveryId,
        );
      },
    };
  }
}
