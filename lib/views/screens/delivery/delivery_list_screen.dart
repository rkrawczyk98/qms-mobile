import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qms_mobile/data/providers/delivery_module/delivery_list_params_provider.dart';
import 'package:qms_mobile/data/providers/delivery_module/delivery_provider.dart';
import 'package:qms_mobile/routes/app_routes.dart';
import 'package:qms_mobile/routes/navigation_service.dart';
import 'package:qms_mobile/views/screens/delivery/delivery_filter_screen.dart';
import 'package:qms_mobile/views/screens/delivery/delivery_sort_screen.dart';
import 'package:qms_mobile/views/widgets/info_card.dart';
import 'package:qms_mobile/utils/externsions/date_formater_extensions.dart';

class DeliveryListScreen extends ConsumerStatefulWidget {
  const DeliveryListScreen({super.key});

  @override
  _DeliveryListScreenState createState() => _DeliveryListScreenState();
}

class _DeliveryListScreenState extends ConsumerState<DeliveryListScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    // Add scroll listener for infinite scrolling
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent &&
          ref.read(advancedDeliveryProvider.notifier).hasMore()) {
        ref.read(advancedDeliveryProvider.notifier).fetchDeliveries();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  String buildFilterQuery(Map<String, List<Map<String, dynamic>>> filters) {
    final filterStrings = filters.entries.expand((entry) {
      final column = entry.key;
      return entry.value.map((filter) {
        final operation = filter['operation'];
        final value = filter['value'];
        if (operation == 'between' && value is List) {
          return '$column:$operation|${value[0]}|${value[1]}';
        }
        return '$column:$operation|$value';
      });
    }).toList();

    return filterStrings.join(';');
  }

  void _navigateToFilterScreen() async {
    final currentParams = ref.read(deliveryListParamsProvider);

    final selectedFilters = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DeliveryFilterScreen(
          initialFilters: currentParams.filters,
        ),
      ),
    );

    if (selectedFilters != null) {
      ref.read(deliveryListParamsProvider.notifier).setFilters(selectedFilters);
      ref.read(advancedDeliveryProvider.notifier).resetAndFetch(
            filter: buildFilterQuery(selectedFilters),
            sort: currentParams.sortColumn,
            order: currentParams.sortOrder,
          );
    }
  }

  void _navigateToSortScreen() async {
    final currentParams = ref.read(deliveryListParamsProvider);

    final selectedSort = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DeliverySortScreen(
          initialSortColumn: currentParams.sortColumn,
          initialSortOrder: currentParams.sortOrder,
        ),
      ),
    );

    if (selectedSort != null) {
      ref.read(deliveryListParamsProvider.notifier).setSort(
            selectedSort['column'],
            selectedSort['order'],
          );
      ref.read(advancedDeliveryProvider.notifier).resetAndFetch(
            filter: buildFilterQuery(currentParams.filters),
            sort: selectedSort['column'],
            order: selectedSort['order'],
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final deliveriesAsync = ref.watch(advancedDeliveryProvider);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              icon: const Icon(Icons.filter_list, color: Colors.white),
              label: Text(
                AppLocalizations.of(context)!.filter,
                style: const TextStyle(color: Colors.white),
              ),
              onPressed: _navigateToFilterScreen,
            ),
            TextButton.icon(
              icon: const Icon(Icons.sort, color: Colors.white),
              label: Text(
                AppLocalizations.of(context)!.sort,
                style: const TextStyle(color: Colors.white),
              ),
              onPressed: _navigateToSortScreen,
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // Reset and fetch new deliveries
          ref.read(deliveryProvider.notifier).fetchDeliveries();
          final currentParams = ref.read(deliveryListParamsProvider);
          await ref.read(advancedDeliveryProvider.notifier).resetAndFetch(
                filter: buildFilterQuery(currentParams.filters),
                sort: currentParams.sortColumn,
                order: currentParams.sortOrder,
              );
        },
        child: deliveriesAsync.when(
          data: (deliveries) {
            if (deliveries.isEmpty) {
              return Center(
                child: Text(AppLocalizations.of(context)!.noDeliveriesFound),
              );
            }

            return ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: deliveries.length + 1, // +1 for the loader
              itemBuilder: (context, index) {
                if (index == deliveries.length) {
                  return ref.read(advancedDeliveryProvider.notifier).hasMore()
                      ? const Center(child: CircularProgressIndicator())
                      : const SizedBox.shrink(); // No more data
                }

                final delivery = deliveries[index];
                final fields = {
                  AppLocalizations.of(context)!.componentType:
                      delivery.componentType?.name,
                  AppLocalizations.of(context)!.status: delivery.status?.name,
                  AppLocalizations.of(context)!.customer:
                      delivery.customer?.name,
                  AppLocalizations.of(context)!.lastModified:
                      delivery.lastModified.formatToDateTime(),
                };

                return InfoCard(
                  title: delivery.number,
                  titleLabel: AppLocalizations.of(context)!.deliveryNumber,
                  icon: const Icon(
                    Icons.local_shipping_outlined,
                    size: 35,
                    color: Colors.blue,
                  ),
                  fields: fields,
                  onRightTap: () {
                    navigationService.navigateTo(
                      AppRoutes.deliveryContents,
                      arguments: delivery.id,
                    );
                  },
                  onLeftTap: () {
                    navigationService.navigateTo(
                      AppRoutes.deliveryDetails,
                      arguments: delivery.id,
                    );
                  },
                  leadingColor: Colors.blue,
                  leftTapText: AppLocalizations.of(context)!.details,
                  rightTapText: AppLocalizations.of(context)!.contents,
                );
              },
            );
          },
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          error: (error, stackTrace) => Center(
            child: Text(AppLocalizations.of(context)!.unknownError),
          ),
        ),
      ),
    );
  }
}
