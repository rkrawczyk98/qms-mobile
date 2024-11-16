import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qms_mobile/data/models/DTOs/component_module/subcomponent_primary_status/subcomponent_primary_status_response_dto.dart';
import 'package:qms_mobile/data/services/component_module/subcomponent_primary_status_service.dart';
import 'package:qms_mobile/data/providers/api_service_provider.dart';

class SubcomponentPrimaryStatusNotifier
    extends StateNotifier<List<SubcomponentPrimaryStatusResponseDto>> {
  final SubcomponentPrimaryStatusService service;

  SubcomponentPrimaryStatusNotifier(this.service) : super([]);

  Future<void> fetchPrimaryStatuses(int subcomponentId) async {
    try {
      state = await service.getPrimaryStatuses(subcomponentId);
    } catch (e) {
      throw Exception('Failed to fetch primary statuses: $e');
    }
  }

  void addPrimaryStatus(SubcomponentPrimaryStatusResponseDto status) {
    state = [...state, status];
  }

  void updatePrimaryStatus(int id, SubcomponentPrimaryStatusResponseDto updatedStatus) {
    state = [
      for (final status in state)
        if (status.id == id) updatedStatus else status,
    ];
  }

  void removePrimaryStatus(int id) {
    state = state.where((status) => status.id != id).toList();
  }
}

final subcomponentPrimaryStatusProvider =
    StateNotifierProvider<SubcomponentPrimaryStatusNotifier, List<SubcomponentPrimaryStatusResponseDto>>((ref) {
  final service = ref.read(subcomponentPrimaryStatusServiceProvider);
  return SubcomponentPrimaryStatusNotifier(service);
});

final subcomponentPrimaryStatusServiceProvider = Provider<SubcomponentPrimaryStatusService>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return SubcomponentPrimaryStatusService(apiService);
});
