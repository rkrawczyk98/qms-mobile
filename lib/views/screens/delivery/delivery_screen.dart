import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qms_mobile/data/providers/delivery_module/delivery_provider.dart';
import 'package:qms_mobile/views/dialogs/custom_snackbar.dart';
import 'package:qms_mobile/views/screens/delivery/add_delivery_screen.dart';
import 'package:qms_mobile/views/screens/delivery/delivery_list_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DeliveryScreen extends ConsumerStatefulWidget {
  const DeliveryScreen({super.key});

  @override
  ConsumerState<DeliveryScreen> createState() => _DeliveryScreenState();
}

class _DeliveryScreenState extends ConsumerState<DeliveryScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);

    // Collection of deliveries during initialization
    final deliveryNotifier = ref.read(deliveryProvider.notifier);
    deliveryNotifier.fetchDeliveries();

    // Tab change support
    tabController.addListener(() {
      if (tabController.index == 0) {
        deliveryNotifier.fetchDeliveries();
      }
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deliveriesAsync = ref.watch(deliveryProvider);
    final localizations = AppLocalizations.of(context)!;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(localizations.manageDeliveries),
          bottom: TabBar(
            controller: tabController,
            tabs: [
              Tab(text: localizations.browse),
              Tab(text: localizations.create),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () async {
                try {
                  await ref.read(deliveryProvider.notifier).fetchDeliveries();
                  if (!mounted) return;
                  CustomSnackbar.showSuccessSnackbar(
                    context,
                    localizations.refreshSuccess,
                  );
                } catch (e) {
                  CustomSnackbar.showErrorSnackbar(
                    context,
                    localizations.refreshError,
                  );
                }
              },
            ),
          ],
        ),
        body: TabBarView(
          controller: tabController,
          children: [
            deliveriesAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Text('${localizations.refreshError}: $error'),
              ),
              data: (deliveries) {
                if (deliveries.isEmpty) {
                  return Center(
                    child: Text(localizations.noDeliveriesFound),
                  );
                }
                return DeliveryList(deliveries: deliveries);
              },
            ),
            const AddDeliveryScreen(),
          ],
        ),
      ),
    );
  }
}


