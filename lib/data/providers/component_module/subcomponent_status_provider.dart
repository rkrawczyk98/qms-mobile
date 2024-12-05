import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qms_mobile/data/models/DTOs/component_module/subcomponent_status/subcomponent_status_response_dto.dart';
import 'package:qms_mobile/data/models/DTOs/component_module/subcomponent_status/update_subcomponent_status_dto.dart';
import 'package:qms_mobile/data/services/component_module/subcomponent_status_service.dart';
import 'package:qms_mobile/data/providers/api_service_provider.dart';

class SubcomponentStatusNotifier
    extends AsyncNotifier<List<SubcomponentStatusResponseDto>> {
  late final SubcomponentStatusService _service;

  @override
  Future<List<SubcomponentStatusResponseDto>> build() async {
    _service = ref.read(subcomponentStatusServiceProvider);
    return await fetchAllStatuses();
  }

  /// Fetch all statuses
  Future<List<SubcomponentStatusResponseDto>> fetchAllStatuses() async {
    try {
      final data = await _service.getAllStatuses();
      state = AsyncValue.data(data);
      return data;
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      rethrow;
    }
  }

  /// Add a new status
  Future<void> addStatus(SubcomponentStatusResponseDto newStatus) async {
    state = AsyncValue.data([...state.value ?? [], newStatus]);
  }

  /// Update an existing status
  Future<void> updateStatus(int id, UpdateSubcomponentStatusDto dto) async {
    try {
      // Update in backend
      final updatedStatus = await _service.updateStatus(id, dto);

      // Update local state
      state = AsyncValue.data([
        for (final status in state.value ?? [])
          if (status.id == id) updatedStatus else status,
      ]);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      rethrow;
    }
  }

  /// Remove a status
  Future<void> removeStatus(int id) async {
    try {
      await _service.deleteStatus(id);

      // Update local state
      state = AsyncValue.data(
        (state.value ?? []).where((status) => status.id != id).toList(),
      );
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      rethrow;
    }
  }
}

final subcomponentStatusProvider = AsyncNotifierProvider<
    SubcomponentStatusNotifier, List<SubcomponentStatusResponseDto>>(() {
  return SubcomponentStatusNotifier();
});

final subcomponentStatusServiceProvider =
    Provider<SubcomponentStatusService>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return SubcomponentStatusService(apiService);
});
