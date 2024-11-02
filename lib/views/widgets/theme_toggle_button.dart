import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qms_mobile/data/providers/theme_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ThemeToggleButton extends ConsumerWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final localizations = AppLocalizations.of(context)!;

    return Column(
      children: [
        Text(localizations.theme),
        ToggleButtons(
          isSelected: [
            themeMode == ThemeMode.light,
            themeMode == ThemeMode.system,
            themeMode == ThemeMode.dark,
          ],
          onPressed: (int index) {
            ThemeMode selectedMode;
            if (index == 0) {
              selectedMode = ThemeMode.light;
            } else if (index == 1) {
              selectedMode = ThemeMode.system;
            } else {
              selectedMode = ThemeMode.dark;
            }
            ref.read(themeModeProvider.notifier).state = selectedMode;
          },
          borderRadius: BorderRadius.circular(15),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(localizations.themeLight),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(localizations.themeSystem),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(localizations.themeDark),
            ),
          ],
        ),
      ],
    );
  }
}
