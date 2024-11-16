import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qms_mobile/data/models/DTOs/component_module/component/component_response_dto.dart';
import 'package:qms_mobile/data/services/component_module/component_service.dart';
import 'package:qms_mobile/data/providers/api_service_provider.dart';

class ComponentNotifier extends StateNotifier<List<ComponentResponseDto>> {
  final ComponentService componentService;

  ComponentNotifier(this.componentService) : super([]);

  Future<void> fetchComponents() async {
    try {
      state = await componentService.getAllComponents();
    } catch (e) {
      throw Exception('Failed to fetch components: $e');
    }
  }

  void addComponent(ComponentResponseDto component) {
    state = [...state, component];
  }

  void updateComponent(int id, ComponentResponseDto updatedComponent) {
    state = [
      for (final component in state)
        if (component.id == id) updatedComponent else component,
    ];
  }

  Future<void> deleteComponent(int id) async {
    await componentService.deleteComponent(id);
    state = state.where((component) => component.id != id).toList();
  }
}

final componentProvider = StateNotifierProvider<ComponentNotifier, List<ComponentResponseDto>>((ref) {
  final componentService = ref.read(componentServiceProvider);
  return ComponentNotifier(componentService);
});

final componentServiceProvider = Provider<ComponentService>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return ComponentService(apiService);
});
