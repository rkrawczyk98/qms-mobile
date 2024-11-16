import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qms_mobile/data/services/warehouse_module/warehouse_service.dart';
import 'package:qms_mobile/data/providers/api_service_provider.dart';
import 'package:qms_mobile/data/models/DTOs/warehouse_module/warehouse_response_dto.dart';

class WarehouseNotifier extends StateNotifier<List<WarehouseResponseDto>> {
  final WarehouseService warehouseService;

  WarehouseNotifier(this.warehouseService) : super([]) {
    fetchWarehouses();
  }

  Future<void> fetchWarehouses() async {
    try {
      state = await warehouseService.getAllWarehouses();
    } catch (e) {
      throw Exception('Failed to fetch warehouses: $e');
    }
  }

  void addWarehouse(WarehouseResponseDto warehouse) {
    state = [...state, warehouse];
  }

  void updateWarehouse(int id, WarehouseResponseDto updatedWarehouse) {
    state = [
      for (final warehouse in state)
        if (warehouse.id == id) updatedWarehouse else warehouse,
    ];
  }

  Future<void> deleteWarehouse(int id) async {
    await warehouseService.deleteWarehouse(id);
    state = state.where((warehouse) => warehouse.id != id).toList();
  }
}

final warehouseProvider =
    StateNotifierProvider<WarehouseNotifier, List<WarehouseResponseDto>>((ref) {
  final warehouseService = ref.read(warehouseServiceProvider);
  return WarehouseNotifier(warehouseService);
});

final warehouseServiceProvider = Provider<WarehouseService>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return WarehouseService(apiService);
});
