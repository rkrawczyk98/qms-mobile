import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qms_mobile/data/providers/auth_module/auth_provider.dart';
import 'package:qms_mobile/data/providers/user_module/user_provider.dart';
import 'package:qms_mobile/routes/app_routes.dart';
import 'package:qms_mobile/routes/navigation_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qms_mobile/views/widgets/custom_logo.dart';

class SidePanelWidget extends ConsumerWidget {
  const SidePanelWidget({super.key});

  Future<void> _handleLogout(BuildContext context, WidgetRef ref) async {
    final authService = ref.read(authServiceProvider);
    await authService.logout();
    
    await ref.read(userProvider.notifier).logOut();
    navigationService.navigateAndClearStack(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final localizations = AppLocalizations.of(context);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          if (user != null) ...[
            const DrawerHeader(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: CustomLogoWidget(
                      logoPath: 'images/logo.svg',
                      width: 80,
                      height: 100,
                    ),
                  )
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: Text(localizations!.home),
              onTap: () {
                navigationService.navigateTo('/home');
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: Text(localizations.profile),
              onTap: () {
                navigationService.navigateTo('/profile');
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: Text(localizations.settings),
              onTap: () {
                navigationService.navigateTo(AppRoutes.settings);
              },
            ),
            if (user.permissions
                .contains('MASTER_PERMISSION')) // Check for permission
              ListTile(
                leading: const Icon(Icons.admin_panel_settings),
                title: Text(localizations.adminPanel),
                onTap: () {
                  navigationService
                      .navigateTo(AppRoutes.adminPanel); // Route to log viewer
                },
              ),
            if (user.permissions
                .contains('MASTER_PERMISSION')) // Check for permission
              ListTile(
                leading: const Icon(Icons.bug_report),
                title: Text(localizations.logs),
                onTap: () {
                  navigationService
                      .navigateTo(AppRoutes.logs); // Route to log viewer
                },
              ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: Text(localizations.logout),
              onTap: () => _handleLogout(context, ref),
            ),
          ]
        ],
      ),
    );
  }
}
