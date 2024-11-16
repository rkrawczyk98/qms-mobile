import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qms_mobile/data/models/DTOs/component_module/subcomponent_secondary_status/subcomponent_secondary_status_response_dto.dart';
import 'package:qms_mobile/data/services/component_module/subcomponent_secondary_status_service.dart';
import 'package:qms_mobile/data/providers/api_service_provider.dart';

class SubcomponentSecondaryStatusNotifier
    extends StateNotifier<List<SubcomponentSecondaryStatusResponseDto>> {
  final SubcomponentSecondaryStatusService service;

  SubcomponentSecondaryStatusNotifier(this.service) : super([]);

  Future<void> fetchSecondaryStatuses(int subcomponentId) async {
    try {
      state = await service.getSecondaryStatuses(subcomponentId);
    } catch (e) {
      throw Exception('Failed to fetch secondary statuses: $e');
    }
  }

  void addSecondaryStatus(SubcomponentSecondaryStatusResponseDto status) {
    state = [...state, status];
  }

  void updateSecondaryStatus(int id, SubcomponentSecondaryStatusResponseDto updatedStatus) {
    state = [
      for (final status in state)
        if (status.id == id) updatedStatus else status,
    ];
  }

  void removeSecondaryStatus(int id) {
    state = state.where((status) => status.id != id).toList();
  }
}

final subcomponentSecondaryStatusProvider =
    StateNotifierProvider<SubcomponentSecondaryStatusNotifier, List<SubcomponentSecondaryStatusResponseDto>>((ref) {
  final service = ref.read(subcomponentSecondaryStatusServiceProvider);
  return SubcomponentSecondaryStatusNotifier(service);
});

final subcomponentSecondaryStatusServiceProvider = Provider<SubcomponentSecondaryStatusService>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return SubcomponentSecondaryStatusService(apiService);
});
