import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  Future<ComponentResponseDto> addComponent(CreateComponentDto component) async {
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
  Future<void> updateComponent(int id, UpdateComponentDto updatedComponent) async {
    try {
      final response = await _componentService.updateComponent(id, updatedComponent);
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

final componentProvider =
    AsyncNotifierProvider<ComponentNotifier, List<ComponentResponseDto>>(() {
  return ComponentNotifier();
});

final componentServiceProvider = Provider<ComponentService>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return ComponentService(apiService);
});
