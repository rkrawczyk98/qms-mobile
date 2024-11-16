import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qms_mobile/data/models/DTOs/component_module/component_subcomponent/component_subcomponent_response_dto.dart';
import 'package:qms_mobile/data/services/component_module/component_subcomponent_service.dart';
import 'package:qms_mobile/data/providers/api_service_provider.dart';

class ComponentSubcomponentNotifier
    extends StateNotifier<List<ComponentSubcomponentResponseDto>> {
  final ComponentSubcomponentService componentSubcomponentService;

  ComponentSubcomponentNotifier(this.componentSubcomponentService) : super([]);

  Future<void> fetchComponentSubcomponents() async {
    try {
      state = await componentSubcomponentService.getAllComponentSubcomponents();
    } catch (e) {
      throw Exception('Failed to fetch component-subcomponent relationships: $e');
    }
  }

  void addComponentSubcomponent(ComponentSubcomponentResponseDto subcomponent) {
    state = [...state, subcomponent];
  }

  void updateComponentSubcomponent(
      int id, ComponentSubcomponentResponseDto updatedSubcomponent) {
    state = [
      for (final subcomponent in state)
        if (subcomponent.id == id) updatedSubcomponent else subcomponent,
    ];
  }

  Future<void> deleteComponentSubcomponent(int id) async {
    await componentSubcomponentService.deleteComponentSubcomponent(id);
    state = state.where((subcomponent) => subcomponent.id != id).toList();
  }
}

final componentSubcomponentProvider = StateNotifierProvider<
    ComponentSubcomponentNotifier, List<ComponentSubcomponentResponseDto>>((ref) {
  final componentSubcomponentService =
      ref.read(componentSubcomponentServiceProvider);
  return ComponentSubcomponentNotifier(componentSubcomponentService);
});

final componentSubcomponentServiceProvider =
    Provider<ComponentSubcomponentService>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return ComponentSubcomponentService(apiService);
});
