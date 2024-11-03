import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qms_mobile/data/providers/theme_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ThemeToggleButton extends ConsumerWidget {
  final bool useIcons;

  const ThemeToggleButton({super.key, this.useIcons = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final localizations = AppLocalizations.of(context)!;

    return ToggleButtons(
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
        Tooltip(
          message:
              localizations.themeLight,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: useIcons
                ? const Icon(Icons.light_mode)
                : Text(localizations.themeLight),
          ),
        ),
        Tooltip(
          message: localizations
              .themeSystem,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: useIcons
                ? const Icon(Icons.brightness_auto)
                : Text(localizations.themeSystem),
          ),
        ),
        Tooltip(
          message:
              localizations.themeDark,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: useIcons
                ? const Icon(Icons.dark_mode)
                : Text(localizations.themeDark),
          ),
        ),
      ],
    );
  }
}
