import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qms_mobile/data/models/DTOs/warehouse_module/warehouse_position_response_dto.dart';
import 'package:qms_mobile/data/providers/api_service_provider.dart';
import 'package:qms_mobile/data/services/warehouse_module/warehouse_position_service.dart';

class WarehousePositionNotifier
    extends StateNotifier<List<WarehousePositionResponseDto>> {
  final WarehousePositionService warehousePositionService;

  WarehousePositionNotifier(this.warehousePositionService) : super([]) {
    fetchWarehousePositions();
  }

  Future<void> fetchWarehousePositions() async {
    try {
      state = await warehousePositionService.getAllWarehousePositions();
    } catch (e) {
      throw Exception('Failed to fetch warehouse positions: $e');
    }
  }

  void addWarehousePosition(WarehousePositionResponseDto position) {
    state = [...state, position];
  }

  void updateWarehousePosition(
      int id, WarehousePositionResponseDto updatedPosition) {
    state = [
      for (final position in state)
        if (position.id == id) updatedPosition else position,
    ];
  }

  Future<void> deleteWarehousePosition(int id) async {
    await warehousePositionService.deleteWarehousePosition(id);
    state = state.where((position) => position.id != id).toList();
  }
}

final warehousePositionProvider = StateNotifierProvider<
    WarehousePositionNotifier, List<WarehousePositionResponseDto>>((ref) {
  final warehousePositionService = ref.read(warehousePositionServiceProvider);
  return WarehousePositionNotifier(warehousePositionService);
});

final warehousePositionServiceProvider =
    Provider<WarehousePositionService>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return WarehousePositionService(apiService);
});
