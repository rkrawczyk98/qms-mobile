import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qms_mobile/data/providers/user_module/user_provider.dart';
import 'package:qms_mobile/routes/navigation_service.dart';
import 'package:qms_mobile/routes/app_routes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UserProfileScreen extends ConsumerWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.userProfile),
      ),
      body: user == null
          ? Center(child: Text(localizations.noUserLoggedIn))
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    localizations.userProfileTitle,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 16),
                  _buildProfileInfoTile(
                    context,
                    icon: Icons.person,
                    title: localizations.username,
                    value: user.username,
                  ),
                  // _buildProfileInfoTile(
                  //   context,
                  //   icon: Icons.email,
                  //   title: localizations.email,
                  //   value: user.email ?? localizations.noEmail,
                  // ),
                  _buildProfileInfoTile(
                    context,
                    icon: Icons.account_circle,
                    title: localizations.roles,
                    value: user.roles.isEmpty
                        ? localizations.noRoles
                        : user.roles.join(', '),
                  ),
                  _buildProfileInfoTile( //Not sure about that
                    context,
                    icon: Icons.security,
                    title: localizations.permissions,
                    value: user.permissions.isEmpty
                        ? localizations.noPermissions
                        : user.permissions.join(', '),
                  ),
                  const Spacer(),
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        navigationService.navigateTo(AppRoutes.changePassword);
                      },
                      icon: const Icon(Icons.edit),
                      label: Text(localizations.changePassword),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildProfileInfoTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title, style: Theme.of(context).textTheme.bodyLarge),
      subtitle: Text(
        value,
        style: Theme.of(context).textTheme.bodyMedium,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
