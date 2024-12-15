import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qms_mobile/data/models/DTOs/component_module/component/advenced_find_component_response_dto.dart';
import 'package:qms_mobile/data/models/DTOs/component_module/component/component_response_dto.dart';
import 'package:qms_mobile/data/models/DTOs/component_module/component/create_component_dto.dart';
import 'package:qms_mobile/data/models/DTOs/component_module/component/update_component_dto.dart';
import 'package:qms_mobile/data/services/component_module/component_service.dart';
import 'package:qms_mobile/data/providers/api_service_provider.dart';

class ComponentNotifier extends AsyncNotifier<List<ComponentResponseDto>> {
  late final ComponentService _componentService;

  @override
  Future<List<ComponentResponseDto>> build() async {
    _componentService = ref.read(componentServiceProvider);
    return await fetchComponents();
  }

  /// Fetch all components
  Future<List<ComponentResponseDto>> fetchComponents() async {
    try {
      final data = await _componentService.getAllComponents();
      state = AsyncValue.data(data);
      return data;
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      rethrow;
    }
  }

  /// Add a new component
  Future<ComponentResponseDto> addComponent(
      CreateComponentDto component) async {
    try {
      final response = await _componentService.createComponent(component);
      // Update the UI state
      state = AsyncValue.data([...state.value ?? [], response]);
      return response;
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      rethrow;
    }
  }

  /// Update an existing component
  Future<void> updateComponent(
      int id, UpdateComponentDto updatedComponent) async {
    try {
      final response =
          await _componentService.updateComponent(id, updatedComponent);
      // Update the UI state
      state = AsyncValue.data([
        for (final component in state.value ?? [])
          if (component.id == id) response,
      ]);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      rethrow;
    }
  }

  /// Delete a component
  Future<void> deleteComponent(int id) async {
    try {
      // Remove from backend
      await _componentService.deleteComponent(id);

      // Update the UI state
      state = AsyncValue.data(
        (state.value ?? []).where((component) => component.id != id).toList(),
      );
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      rethrow;
    }
  }
}

class AdvancedComponentNotifier
    extends AsyncNotifier<List<AdvencedFindComponentResponseDto>> {
  late final ComponentService _componentService;

  // Pagination, sorting and filtering management parameters
  int _currentPage = 1;
  final int _pageSize = 10;
  String? _sortColumn;
  String _sortOrder = 'ASC';
  String? _filter;
  bool _hasMore = true;

  @override
  Future<List<AdvencedFindComponentResponseDto>> build() async {
    _componentService = ref.read(componentServiceProvider);
    return fetchComponents(reset: true);
  }

  /// Gets components from backend
  Future<List<AdvencedFindComponentResponseDto>> fetchComponents({
    bool reset = false,
    String? sort,
    String? order,
    String? filter,
  }) async {
    try {
      if (reset) {
        _currentPage = 1;
        _sortColumn = sort;
        _sortOrder = order ?? 'ASC';
        _filter = filter;
        _hasMore = true;
        state = const AsyncValue.loading();
      }

      if (!_hasMore) {
        return state.value ?? [];
      }

      final result = await _componentService.advancedFind(
        page: _currentPage,
        limit: _pageSize,
        sort: _sortColumn,
        order: _sortOrder,
        filter: _filter,
      );

      final components =
          result['data'] as List<AdvencedFindComponentResponseDto>;
      _hasMore = result['hasNextPage'] as bool;

      final currentState = state.value ?? [];
      final updatedState =
          reset ? components : [...currentState, ...components];

      state = AsyncValue.data(updatedState);

      _currentPage++;
      return updatedState;
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      rethrow;
    }
  }

  /// Resets the list and gets new data
  Future<void> resetAndFetch({
    String? sort,
    String? order,
    String? filter,
  }) async {
    final currentSort = _sortColumn;
    final currentOrder = _sortOrder;
    final currentFilter = _filter;

    await fetchComponents(
      reset: true,
      sort: sort ?? currentSort,
      order: order ?? currentOrder,
      filter: filter ?? currentFilter,
    );
  }

  /// Are there any more pages to load
  bool hasMore() {
    return _hasMore;
  }
}

final componentProvider =
    AsyncNotifierProvider<ComponentNotifier, List<ComponentResponseDto>>(() {
  return ComponentNotifier();
});

final advancedComponentProvider = AsyncNotifierProvider<
    AdvancedComponentNotifier, List<AdvencedFindComponentResponseDto>>(() {
  return AdvancedComponentNotifier();
});

final componentServiceProvider = Provider<ComponentService>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return ComponentService(apiService);
});
