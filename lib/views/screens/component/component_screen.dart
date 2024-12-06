import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qms_mobile/data/providers/component_module/component_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qms_mobile/views/dialogs/custom_snackbar.dart';
import 'package:qms_mobile/views/screens/component/add_component_screen.dart';
import 'package:qms_mobile/views/screens/component/component_list_screen.dart';

class ComponentScreen extends ConsumerStatefulWidget {
  const ComponentScreen({super.key});

  @override
  ConsumerState<ComponentScreen> createState() => _ComponentScreenState();
}

class _ComponentScreenState extends ConsumerState<ComponentScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(componentProvider.notifier).fetchComponents();
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(localization!.manageComponents),
          bottom: TabBar(
            tabs: [
              Tab(text: localization.browse),
              Tab(text: localization.create),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () async {
                try {
                  await ref.read(componentProvider.notifier).fetchComponents();
                  if (!mounted) return;
                  CustomSnackbar.showSuccessSnackbar(
                    context,
                    localization.refreshSuccess,
                  );
                } catch (e) {
                  CustomSnackbar.showErrorSnackbar(
                    context,
                    localization.refreshError,
                  );
                }
              },
            ),
          ],
        ),
        body: const TabBarView(
          children: [
            ComponentList(),
            AddComponentScreen(),
          ],
        ),
      ),
    );
  }
}
