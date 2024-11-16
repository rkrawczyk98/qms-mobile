import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qms_mobile/data/models/DTOs/component_module/component_prefix/component_prefix_response_dto.dart';
import 'package:qms_mobile/data/services/component_module/component_prefix_service.dart';
import 'package:qms_mobile/data/providers/api_service_provider.dart';

class ComponentPrefixNotifier extends StateNotifier<List<ComponentPrefixResponseDto>> {
  final ComponentPrefixService componentPrefixService;

  ComponentPrefixNotifier(this.componentPrefixService) : super([]);

  Future<void> fetchComponentPrefixes() async {
    try {
      state = await componentPrefixService.getAllComponentPrefixes();
    } catch (e) {
      throw Exception('Failed to fetch component prefixes: $e');
    }
  }

  void addComponentPrefix(ComponentPrefixResponseDto prefix) {
    state = [...state, prefix];
  }

  void updateComponentPrefix(int id, ComponentPrefixResponseDto updatedPrefix) {
    state = [
      for (final prefix in state)
        if (prefix.id == id) updatedPrefix else prefix,
    ];
  }

  Future<void> deleteComponentPrefix(int id) async {
    await componentPrefixService.deleteComponentPrefix(id);
    state = state.where((prefix) => prefix.id != id).toList();
  }
}

final componentPrefixProvider = StateNotifierProvider<ComponentPrefixNotifier, List<ComponentPrefixResponseDto>>((ref) {
  final componentPrefixService = ref.read(componentPrefixServiceProvider);
  return ComponentPrefixNotifier(componentPrefixService);
});

final componentPrefixServiceProvider = Provider<ComponentPrefixService>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return ComponentPrefixService(apiService);
});
