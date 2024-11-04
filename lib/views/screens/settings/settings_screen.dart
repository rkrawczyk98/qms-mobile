import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qms_mobile/data/providers/notification_provider.dart';
import 'package:qms_mobile/routes/app_routes.dart';
import 'package:qms_mobile/routes/navigation_service.dart';
import 'package:qms_mobile/views/widgets/language_switcher.dart';
import 'package:qms_mobile/views/widgets/theme_toggle_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final notificationsEnabled = ref.watch(notificationsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.settingsTitle),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            contentPadding: const EdgeInsets.all(0),
            title: Text(localizations.theme),
            subtitle: Text(localizations.selectThemeMode),
            trailing: const ThemeToggleButton(useIcons: true),
          ),
          ListTile(
            contentPadding: const EdgeInsets.all(0),
            title: Text(localizations.language),
            subtitle: Text(localizations.selectLanguage),
            trailing: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                decoration: BoxDecoration(
                  color:
                      Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20.0),
                  border: Border.all(
                      color: Theme.of(context).colorScheme.secondary,
                      width: 2.0),
                ),
                child: const LanguageSwitcher()),
          ),
          SwitchListTile(
            contentPadding: const EdgeInsets.all(0),
            title: Text(localizations.notifications),
            subtitle: Text(localizations.manageNotifications),
            value: notificationsEnabled,
            onChanged: (bool value) {
              ref
                  .read(notificationsProvider.notifier)
                  .setNotificationsEnabled(value);
            },
          ),
          ListTile(
            contentPadding: const EdgeInsets.all(0),
            title: Text(localizations.manageAccount),
            subtitle: Text(localizations.goToAccountSettings),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              navigationService.navigateTo(AppRoutes.changePassword);
            },
          ),
          ListTile(
            contentPadding: const EdgeInsets.all(0),
            title: Text(localizations.aboutApp),
            trailing: const Icon(Icons.info_outline),
            onTap: () {
              navigationService.navigateTo(AppRoutes.about);
            },
          ),
          ListTile(
            contentPadding: const EdgeInsets.all(0),
            title: Text(localizations.logs),
            subtitle: Text(localizations.appLogs),
            trailing: const Icon(Icons.bug_report),
            onTap: () {
              navigationService.navigateTo(AppRoutes.logs);
            },
          ),
        ],
      ),
    );
  }
}
