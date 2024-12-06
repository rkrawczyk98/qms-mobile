import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qms_mobile/data/models/DTOs/component_module/component_status/component_status_response_dto.dart';
import 'package:qms_mobile/data/models/DTOs/component_module/component_status/create_component_status_dto.dart';
import 'package:qms_mobile/data/models/DTOs/component_module/component_status/update_component_status_dto.dart';
import 'package:qms_mobile/data/services/component_module/component_status_service.dart';
import 'package:qms_mobile/data/providers/api_service_provider.dart';

class ComponentStatusNotifier extends AsyncNotifier<List<ComponentStatusResponseDto>> {
  late final ComponentStatusService _componentStatusService;

  @override
  Future<List<ComponentStatusResponseDto>> build() async {
    _componentStatusService = ref.read(componentStatusServiceProvider);
    return await fetchComponentStatuses();
  }

  /// Fetch all component statuses
  Future<List<ComponentStatusResponseDto>> fetchComponentStatuses() async {
    try {
      final data = await _componentStatusService.getAllComponentStatuses();
      state = AsyncValue.data(data);
      return data;
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      rethrow;
    }
  }

  /// Add a new component status
  Future<void> addComponentStatus(CreateComponentStatusDto newStatus) async {
    try {
      final response = await _componentStatusService.createComponentStatus(newStatus);
      // Update the UI state with the new status
      state = AsyncValue.data([...state.value ?? [], response]);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      rethrow;
    }
  }

  /// Update an existing component status
  Future<void> updateComponentStatus(int id, UpdateComponentStatusDto updatedStatus) async {
    try {
      final response = await _componentStatusService.updateComponentStatus(id, updatedStatus);
      state = AsyncValue.data([
        for (final status in state.value ?? [])
          if (status.id == id) response,
      ]);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      rethrow;
    }
  }

  /// Delete a component status
  Future<void> deleteComponentStatus(int id) async {
    try {
      // Delete from backend
      await _componentStatusService.deleteComponentStatus(id);

      // Update the UI state
      state = AsyncValue.data(
        (state.value ?? []).where((status) => status.id != id).toList(),
      );
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      rethrow;
    }
  }
}

final componentStatusProvider =
    AsyncNotifierProvider<ComponentStatusNotifier, List<ComponentStatusResponseDto>>(() {
  return ComponentStatusNotifier();
});

final componentStatusServiceProvider = Provider<ComponentStatusService>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return ComponentStatusService(apiService);
});
