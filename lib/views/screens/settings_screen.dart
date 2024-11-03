import 'package:flutter/material.dart';
import 'package:qms_mobile/routes/navigation_service.dart';
import 'package:qms_mobile/views/widgets/custom_app_bar.dart';
import 'package:qms_mobile/views/widgets/side_panel.dart';
import 'package:qms_mobile/views/widgets/theme_toggle_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: CustomAppBar(
        title: localizations.settingsTitle,
      ),
      drawer: const SidePanelWidget(),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            contentPadding: const EdgeInsets.all(0),
            title: Text(localizations.theme),
            subtitle: Text(localizations.selectThemeMode),
            trailing: const ThemeToggleButton(useIcons: true),
          ),
          SwitchListTile(
            contentPadding: const EdgeInsets.all(0),
            title: Text(localizations.notifications),
            subtitle: Text(localizations.manageNotifications),
            value: _notificationsEnabled,
            onChanged: (bool value) {
              setState(() {
                _notificationsEnabled = value;
              });
            },
          ),
          ListTile(
            contentPadding: const EdgeInsets.all(0),
            title: Text(localizations.manageAccount),
            subtitle: Text(localizations.goToAccountSettings),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {},
          ),
          ListTile(
            contentPadding: const EdgeInsets.all(0),
            title: Text(localizations.aboutApp),
            trailing: const Icon(Icons.info_outline),
            onTap: () {
              navigationService.navigateTo('/about');
            },
          ),
        ],
      ),
    );
  }
}
