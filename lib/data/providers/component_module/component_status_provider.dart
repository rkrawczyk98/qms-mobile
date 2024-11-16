import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qms_mobile/data/models/DTOs/component_module/component_status/component_status_response_dto.dart';
import 'package:qms_mobile/data/services/component_module/component_status_service.dart';
import 'package:qms_mobile/data/providers/api_service_provider.dart';

class ComponentStatusNotifier extends StateNotifier<List<ComponentStatusResponseDto>> {
  final ComponentStatusService componentStatusService;

  ComponentStatusNotifier(this.componentStatusService) : super([]);

  Future<void> fetchComponentStatuses() async {
    try {
      state = await componentStatusService.getAllComponentStatuses();
    } catch (e) {
      throw Exception('Failed to fetch component statuses: $e');
    }
  }

  void addComponentStatus(ComponentStatusResponseDto status) {
    state = [...state, status];
  }

  void updateComponentStatus(int id, ComponentStatusResponseDto updatedStatus) {
    state = [
      for (final status in state)
        if (status.id == id) updatedStatus else status,
    ];
  }

  Future<void> deleteComponentStatus(int id) async {
    await componentStatusService.deleteComponentStatus(id);
    state = state.where((status) => status.id != id).toList();
  }
}

final componentStatusProvider = StateNotifierProvider<ComponentStatusNotifier, List<ComponentStatusResponseDto>>((ref) {
  final componentStatusService = ref.read(componentStatusServiceProvider);
  return ComponentStatusNotifier(componentStatusService);
});

final componentStatusServiceProvider = Provider<ComponentStatusService>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return ComponentStatusService(apiService);
});
