import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qms_mobile/data/providers/user_module/user_provider.dart';
import 'package:qms_mobile/views/widgets/language_switcher.dart';

class CustomAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final String? title;
  final bool showLanguageSwitcher;

  const CustomAppBar({
    super.key,
    this.title,
    this.showLanguageSwitcher = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    // final localizations = AppLocalizations.of(context)!;

    return AppBar(
      // automaticallyImplyLeading: false, // Disable the back arrow
      backgroundColor:
          Theme.of(context).appBarTheme.backgroundColor ?? Colors.black,
      leading: user != null
          ? Builder(
              builder: (BuildContext context) {
                return IconButton(
                  icon: const Icon(Icons.menu), // Menu icon for the SidePanel
                  onPressed: () {
                    Scaffold.of(context)
                        .openDrawer(); // Open the SidePanel (Drawer)
                  },
                );
              },
            )
          : null, // If not logged in, hide the leading icon
      title: title != null
          ? Text(
              title ?? '',
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(color: Colors.white),
            )
          : const SizedBox.shrink(), // Empty widget when title is empty
      actions: [
        if (showLanguageSwitcher)
          const LanguageSwitcher(),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
