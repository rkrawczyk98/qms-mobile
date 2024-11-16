import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qms_mobile/data/models/DTOs/component_module/component_type/component_type_response_dto.dart';
import 'package:qms_mobile/data/services/component_module/component_type_service.dart';
import 'package:qms_mobile/data/providers/api_service_provider.dart';

class ComponentTypeNotifier
    extends StateNotifier<List<ComponentTypeResponseDto>> {
  final ComponentTypeService componentTypeService;

  ComponentTypeNotifier(this.componentTypeService) : super([]);

  Future<void> fetchComponentTypes() async {
    try {
      state = await componentTypeService.getAllComponentTypes();
    } catch (e) {
      throw Exception('Failed to fetch component types: $e');
    }
  }

  void addComponentType(ComponentTypeResponseDto componentType) {
    state = [...state, componentType];
  }

  void updateComponentType(int id, ComponentTypeResponseDto updatedType) {
    state = [
      for (final type in state)
        if (type.id == id) updatedType else type,
    ];
  }

  Future<void> deleteComponentType(int id) async {
    await componentTypeService.deleteComponentType(id);
    state = state.where((type) => type.id != id).toList();
  }
}

final componentTypeProvider = StateNotifierProvider<ComponentTypeNotifier,
    List<ComponentTypeResponseDto>>((ref) {
  final componentTypeService = ref.read(componentTypeServiceProvider);
  return ComponentTypeNotifier(componentTypeService);
});

final componentTypeServiceProvider = Provider<ComponentTypeService>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return ComponentTypeService(apiService);
});
