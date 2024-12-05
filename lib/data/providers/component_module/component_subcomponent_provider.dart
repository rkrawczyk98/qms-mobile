import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qms_mobile/data/models/DTOs/component_module/component_subcomponent/component_subcomponent_response_dto.dart';
import 'package:qms_mobile/data/models/DTOs/component_module/component_subcomponent/update_component_subcomponent_dto.dart';
import 'package:qms_mobile/data/services/component_module/component_subcomponent_service.dart';
import 'package:qms_mobile/data/providers/api_service_provider.dart';

class ComponentSubcomponentNotifier
    extends AsyncNotifier<List<ComponentSubcomponentResponseDto>> {
  late final ComponentSubcomponentService _componentSubcomponentService;

  @override
  Future<List<ComponentSubcomponentResponseDto>> build() async {
    _componentSubcomponentService = ref.read(componentSubcomponentServiceProvider);
    return await fetchComponentSubcomponents();
  }

  /// Fetch all component-subcomponent relationships
  Future<List<ComponentSubcomponentResponseDto>> fetchComponentSubcomponents() async {
    try {
      final data = await _componentSubcomponentService.getAllComponentSubcomponents();
      state = AsyncValue.data(data);
      return data;
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      rethrow;
    }
  }

  /// Add a new component-subcomponent relationship
  Future<void> addComponentSubcomponent(ComponentSubcomponentResponseDto subcomponent) async {
    state = AsyncValue.data([
      ...state.value ?? [],
      subcomponent,
    ]);
  }

  /// Update a component-subcomponent relationship
  Future<void> updateComponentSubcomponent(
      int id, UpdateComponentSubcomponentDto dto) async {
    try {
      // Update in the backend
      final updatedSubcomponent =
          await _componentSubcomponentService.updateComponentSubcomponent(id, dto);

      // Update local state
      state = AsyncValue.data([
        for (final subcomponent in state.value ?? [])
          if (subcomponent.id == id) updatedSubcomponent else subcomponent,
      ]);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      rethrow;
    }
  }

  /// Delete a component-subcomponent relationship
  Future<void> deleteComponentSubcomponent(int id) async {
    try {
      await _componentSubcomponentService.deleteComponentSubcomponent(id);

      // Remove from local state
      state = AsyncValue.data(
        (state.value ?? []).where((subcomponent) => subcomponent.id != id).toList(),
      );
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      rethrow;
    }
  }
}

final componentSubcomponentProvider = AsyncNotifierProvider<ComponentSubcomponentNotifier,
    List<ComponentSubcomponentResponseDto>>(() {
  return ComponentSubcomponentNotifier();
});

final componentSubcomponentServiceProvider =
    Provider<ComponentSubcomponentService>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return ComponentSubcomponentService(apiService);
});
