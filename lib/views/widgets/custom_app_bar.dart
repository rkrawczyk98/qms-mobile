import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qms_mobile/views/widgets/language_switcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CustomAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoggedIn = true; //ref.watch(userProvider);
    final localizations = AppLocalizations.of(context)!;

    return AppBar(
      automaticallyImplyLeading: false, // Disable the back arrow
      backgroundColor:
          Theme.of(context).appBarTheme.backgroundColor ?? Colors.black,
      leading: isLoggedIn
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
      title: const Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween, // This spaces out the elements
        children: [
          const Row(
            children: [],
          ),
          LanguageSwitcher(),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
