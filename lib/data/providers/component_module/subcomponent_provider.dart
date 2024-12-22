import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qms_mobile/data/models/DTOs/component_module/subcomponent/subcomponent_response_dto.dart';
import 'package:qms_mobile/data/models/DTOs/component_module/subcomponent/update_subcomponent_dto.dart';
import 'package:qms_mobile/data/services/component_module/subcomponent_service.dart';
import 'package:qms_mobile/data/providers/api_service_provider.dart';

class SubcomponentNotifier extends AsyncNotifier<List<SubcomponentResponseDto>> {
  late final SubcomponentService _service;

  @override
  Future<List<SubcomponentResponseDto>> build() async {
    _service = ref.read(subcomponentServiceProvider);
    return await fetchAllSubcomponents();
  }

  /// Fetch all subcomponents
  Future<List<SubcomponentResponseDto>> fetchAllSubcomponents() async {
    try {
      final data = await _service.getAllSubcomponents();
      data.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
      state = AsyncValue.data(data);
      return data;
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      rethrow;
    }
  }

  /// Add a new subcomponent
  Future<void> addSubcomponent(SubcomponentResponseDto subcomponent) async {
    state = AsyncValue.data([
      ...state.value ?? [],
      subcomponent,
    ]);
  }

  /// Update an existing subcomponent
  Future<void> updateSubcomponent(int id, UpdateSubcomponentDto dto) async {
    try {
      // Update in backend
      final updatedSubcomponent = await _service.updateSubcomponent(id, dto);

      // Update local state
      state = AsyncValue.data([
        for (final subcomponent in state.value ?? [])
          if (subcomponent.id == id) updatedSubcomponent else subcomponent,
      ]);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      rethrow;
    }
  }

  /// Delete a subcomponent
  Future<void> removeSubcomponent(int id) async {
    try {
      await _service.deleteSubcomponent(id);

      // Update local state
      state = AsyncValue.data(
        (state.value ?? []).where((subcomponent) => subcomponent.id != id).toList(),
      );
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      rethrow;
    }
  }
}

final subcomponentProvider =
    AsyncNotifierProvider<SubcomponentNotifier, List<SubcomponentResponseDto>>(() {
  return SubcomponentNotifier();
});

final subcomponentServiceProvider = Provider<SubcomponentService>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return SubcomponentService(apiService);
});
