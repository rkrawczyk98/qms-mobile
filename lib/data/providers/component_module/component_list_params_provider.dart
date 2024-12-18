import 'package:flutter_riverpod/flutter_riverpod.dart';

class ComponentListParams {
  final Map<String, List<Map<String, dynamic>>> filters;
  final String? sortColumn;
  final String sortOrder;

  ComponentListParams({
    this.filters = const {},
    this.sortColumn = 'component.insideNumber',
    this.sortOrder = 'ASC',
  });

  ComponentListParams copyWith({
    Map<String, List<Map<String, dynamic>>>? filters,
    String? sortColumn,
    String? sortOrder,
  }) {
    return ComponentListParams(
      filters: filters ?? this.filters,
      sortColumn: sortColumn ?? this.sortColumn,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }
}

class ComponentListParamsNotifier extends StateNotifier<ComponentListParams> {
  ComponentListParamsNotifier() : super(ComponentListParams());

  void setFilters(Map<String, List<Map<String, dynamic>>> filters) {
    state = state.copyWith(filters: filters);
  }

  void setSort(String? column, String order) {
    state = state.copyWith(sortColumn: column, sortOrder: order);
  }
}

final componentListParamsProvider =
    StateNotifierProvider<ComponentListParamsNotifier, ComponentListParams>(
        (ref) => ComponentListParamsNotifier());
