import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qms_mobile/data/models/DTOs/component_module/subcomponent_status/subcomponent_status_response_dto.dart';
import 'package:qms_mobile/data/services/component_module/subcomponent_status_service.dart';
import 'package:qms_mobile/data/providers/api_service_provider.dart';

class SubcomponentStatusNotifier extends StateNotifier<List<SubcomponentStatusResponseDto>> {
  final SubcomponentStatusService service;

  SubcomponentStatusNotifier(this.service) : super([]);

  Future<void> fetchAllStatuses() async {
    try {
      state = await service.getAllStatuses();
    } catch (e) {
      throw Exception('Failed to fetch subcomponent statuses: $e');
    }
  }

  void addStatus(SubcomponentStatusResponseDto status) {
    state = [...state, status];
  }

  void updateStatus(SubcomponentStatusResponseDto updatedStatus) {
    state = [
      for (final status in state)
        if (status.id == updatedStatus.id) updatedStatus else status,
    ];
  }

  void removeStatus(int id) {
    state = state.where((status) => status.id != id).toList();
  }
}

final subcomponentStatusProvider =
    StateNotifierProvider<SubcomponentStatusNotifier, List<SubcomponentStatusResponseDto>>((ref) {
  final service = ref.read(subcomponentStatusServiceProvider);
  return SubcomponentStatusNotifier(service);
});

final subcomponentStatusServiceProvider = Provider<SubcomponentStatusService>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return SubcomponentStatusService(apiService);
});
