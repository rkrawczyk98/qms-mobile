import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qms_mobile/data/models/DTOs/component_module/subcomponent/subcomponent_response_dto.dart';
import 'package:qms_mobile/data/services/component_module/subcomponent_service.dart';
import 'package:qms_mobile/data/providers/api_service_provider.dart';

class SubcomponentNotifier extends StateNotifier<List<SubcomponentResponseDto>> {
  final SubcomponentService service;

  SubcomponentNotifier(this.service) : super([]);

  Future<void> fetchAllSubcomponents() async {
    try {
      state = await service.getAllSubcomponents();
    } catch (e) {
      throw Exception('Failed to fetch subcomponents: $e');
    }
  }

  void addSubcomponent(SubcomponentResponseDto subcomponent) {
    state = [...state, subcomponent];
  }

  void updateSubcomponent(SubcomponentResponseDto updatedSubcomponent) {
    state = [
      for (final subcomponent in state)
        if (subcomponent.id == updatedSubcomponent.id) updatedSubcomponent else subcomponent,
    ];
  }

  void removeSubcomponent(int id) {
    state = state.where((subcomponent) => subcomponent.id != id).toList();
  }
}

final subcomponentProvider =
    StateNotifierProvider<SubcomponentNotifier, List<SubcomponentResponseDto>>((ref) {
  final service = ref.read(subcomponentServiceProvider);
  return SubcomponentNotifier(service);
});

final subcomponentServiceProvider = Provider<SubcomponentService>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return SubcomponentService(apiService);
});
