import 'package:flutter_riverpod/flutter_riverpod.dart';

class DeliveryListParams {
  final Map<String, List<Map<String, dynamic>>> filters;
  final String? sortColumn;
  final String sortOrder;

  DeliveryListParams({
    this.filters = const {},
    this.sortColumn = 'delivery.number',
    this.sortOrder = 'ASC',
  });

  DeliveryListParams copyWith({
    Map<String, List<Map<String, dynamic>>>? filters,
    String? sortColumn,
    String? sortOrder,
  }) {
    return DeliveryListParams(
      filters: filters ?? this.filters,
      sortColumn: sortColumn ?? this.sortColumn,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }
}

class DeliveryListParamsNotifier extends StateNotifier<DeliveryListParams> {
  DeliveryListParamsNotifier() : super(DeliveryListParams());

  void setFilters(Map<String, List<Map<String, dynamic>>> filters) {
    state = state.copyWith(filters: filters);
  }

  void setSort(String? column, String order) {
    state = state.copyWith(sortColumn: column, sortOrder: order);
  }
}

final deliveryListParamsProvider =
    StateNotifierProvider<DeliveryListParamsNotifier, DeliveryListParams>(
        (ref) => DeliveryListParamsNotifier());
