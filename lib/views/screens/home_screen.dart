import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qms_mobile/data/providers/user_module/user_provider.dart';
import 'package:qms_mobile/routes/app_routes.dart';
import 'package:qms_mobile/routes/navigation_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qms_mobile/views/widgets/custom_app_bar.dart';
import 'package:qms_mobile/views/widgets/side_panel.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: CustomAppBar(
        title: localizations.homeTitle,
        showLanguageSwitcher: true,
      ),
      drawer: const SidePanelWidget(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (user != null) ...[
              Text(
                '${localizations.welcome}, ${user.username}!',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const Divider()
            ],
            Expanded(
              child: ListView(
                children: [
                  _buildSectionTitle(context, localizations.lists),
                  _buildGridSection(context, [
                    _buildNavigationCard(
                      context,
                      icon: Icons.local_shipping,
                      title: localizations.deliveryList,
                      onTap: () =>
                          navigationService.navigateTo(AppRoutes.deliveryList),
                    ),
                    _buildNavigationCard(context,
                        icon: Icons.list_alt,
                        title: localizations.componentList,
                        onTap: () =>
                            navigationService.navigateTo(AppRoutes.componentScreen),
                        ),
                  ]),
                  const SizedBox(height: 20),
                  if (user?.permissions.contains('MASTER_PERMISSION') ?? false)
                    _buildSectionTitle(context, localizations.administration),
                  if (user?.permissions.contains('MASTER_PERMISSION') ?? false)
                    _buildGridSection(context, [
                      _buildNavigationCard(
                        context,
                        icon: Icons.people,
                        title: localizations.userManagement,
                        onTap: () => navigationService
                            .navigateTo(AppRoutes.userManagement),
                      ),
                      _buildNavigationCard(
                        context,
                        icon: Icons.local_shipping,
                        title: localizations.deliveryManagement,
                        onTap: () => navigationService
                            .navigateTo(AppRoutes.deliveryManagement),
                      ),
                      _buildNavigationCard(
                        context,
                        icon: Icons.business,
                        title: localizations.customerManagement,
                        onTap: () => navigationService
                            .navigateTo(AppRoutes.customerManagement),
                      ),
                      _buildNavigationCard(
                        context,
                        icon: Icons.build,
                        title: localizations.componentManagement,
                        onTap: () => navigationService
                            .navigateTo(AppRoutes.componentManagement),
                      ),
                      _buildNavigationCard(
                        context,
                        icon: Icons.warehouse,
                        title: localizations.warehouseManagement,
                        onTap: () => navigationService
                            .navigateTo(AppRoutes.warehouseManagement),
                      ),
                    ]),
                  const SizedBox(height: 20),
                  _buildSectionTitle(context, localizations.other),
                  _buildGridSection(context, [
                    _buildNavigationCard(
                      context,
                      icon: Icons.settings,
                      title: localizations.settings,
                      onTap: () =>
                          navigationService.navigateTo(AppRoutes.settings),
                    ),
                    _buildNavigationCard(
                      context,
                      icon: Icons.info_outline,
                      title: localizations.aboutApp,
                      onTap: () =>
                          navigationService.navigateTo(AppRoutes.about),
                    ),
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 40,
              ),
              const SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.headlineSmall,
      ),
    );
  }

  Widget _buildGridSection(BuildContext context, List<Widget> cards) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: cards,
    );
  }
}
