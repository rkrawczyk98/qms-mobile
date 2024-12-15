import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qms_mobile/data/providers/component_module/component_list_params_provider.dart';
import 'package:qms_mobile/data/providers/component_module/component_provider.dart';
import 'package:qms_mobile/routes/app_routes.dart';
import 'package:qms_mobile/routes/navigation_service.dart';
import 'package:qms_mobile/views/screens/component/component_filter_screen.dart';
import 'package:qms_mobile/views/screens/component/component_sort_screen.dart';
import 'package:qms_mobile/views/widgets/info_card.dart';
import 'package:qms_mobile/utils/externsions/date_formater_extensions.dart';

class ComponentList extends ConsumerStatefulWidget {
  const ComponentList({super.key});

  @override
  _ComponentListState createState() => _ComponentListState();
}

class _ComponentListState extends ConsumerState<ComponentList> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    // Add scroll listener
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent &&
          ref.read(advancedComponentProvider.notifier).hasMore()) {
        // Load more data
        ref.read(advancedComponentProvider.notifier).fetchComponents();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  String buildFilterQuery(Map<String, dynamic> filters) {
    final filterStrings = filters.entries.map((entry) {
      final operation = entry.value['operation'];
      final value = entry.value['value'];
      if (operation == 'between' && value is List) {
        return '${entry.key}:$operation|${value[0]}|${value[1]}';
      }
      return '${entry.key}:$operation|$value';
    });
    return filterStrings.join(';');
  }

  void _navigateToFilterScreen() async {
    final currentParams = ref.read(componentListParamsProvider);

    final selectedFilter = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ComponentFilterScreen(
          initialFilters: currentParams.filters,
        ),
      ),
    );

    if (selectedFilter != null) {
      ref.read(componentListParamsProvider.notifier).setFilters(selectedFilter);
      ref.read(advancedComponentProvider.notifier).resetAndFetch(
            filter: buildFilterQuery(selectedFilter),
            sort: currentParams.sortColumn,
            order: currentParams.sortOrder,
          );
    }
  }

  void _navigateToSortScreen() async {
    final currentParams = ref.read(componentListParamsProvider);

    final selectedSort = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ComponentSortScreen(
          initialSortColumn: currentParams.sortColumn,
          initialSortOrder: currentParams.sortOrder,
        ),
      ),
    );

    if (selectedSort != null) {
      ref.read(componentListParamsProvider.notifier).setSort(
            selectedSort['column'],
            selectedSort['order'],
          );
      ref.read(advancedComponentProvider.notifier).resetAndFetch(
            filter: buildFilterQuery(currentParams.filters),
            sort: selectedSort['column'],
            order: selectedSort['order'],
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final componentsAsync = ref.watch(advancedComponentProvider);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceEvenly, // Button arrangement
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
      body: componentsAsync.when(
        data: (components) {
          if (components.isEmpty) {
            return Center(
              child: Text(AppLocalizations.of(context)!.noComponentsFound),
            );
          }

          return ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            itemCount: components.length + 1, // +1 for loader
            itemBuilder: (context, index) {
              if (index == components.length) {
                return ref.read(advancedComponentProvider.notifier).hasMore()
                    ? const Center(child: CircularProgressIndicator())
                    : const SizedBox.shrink(); // Hide loader when no more data
              }

              final component = components[index];

              // Mapping component fields to InfoCard
              final fields = {
                AppLocalizations.of(context)!.deliveryNumber:
                    component.deliveryNumber,
                AppLocalizations.of(context)!.componentNumber:
                    component.nameOne,
                AppLocalizations.of(context)!.type: component.componentTypeName,
                AppLocalizations.of(context)!.status: component.statusName,
                AppLocalizations.of(context)!.productionDate:
                    component.productionDate?.formatToNullableDateTime() ??
                        AppLocalizations.of(context)!.notAvailable,
                AppLocalizations.of(context)!.controlDate:
                    component.controlDate?.formatToNullableDateTime() ??
                        AppLocalizations.of(context)!.notAvailable,
              };

              return InfoCard(
                title: component.nameOne,
                titleLabel: AppLocalizations.of(context)!.componentNumber,
                fields: fields,
                icon: const Icon(
                  Icons.view_in_ar,
                  color: Colors.green,
                  size: 35,
                ),
                onRightTap: () => navigationService.navigateTo(
                  AppRoutes.componentManage,
                  arguments: component.id,
                ),
                onLeftTap: () => navigationService.navigateTo(
                  AppRoutes.componentEdit,
                  arguments: component.id,
                ),
                leadingColor: Colors.green,
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
    );
  }
}
