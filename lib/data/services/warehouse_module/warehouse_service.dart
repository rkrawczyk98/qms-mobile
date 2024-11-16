import 'package:qms_mobile/data/models/DTOs/warehouse_module/create_warehouse_dto.dart';
import 'package:qms_mobile/data/models/DTOs/warehouse_module/update_warehouse_dto.dart';
import 'package:qms_mobile/data/models/DTOs/warehouse_module/warehouse_response_dto.dart';
import 'package:qms_mobile/data/services/api_service.dart';

class WarehouseService {
  final ApiService apiService;

  WarehouseService(this.apiService);

  Future<List<WarehouseResponseDto>> getAllWarehouses() async {
    try {
      final response = await apiService.dio.get('/warehouses');
      return (response.data as List)
          .map((e) => WarehouseResponseDto.fromJson(e))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<WarehouseResponseDto> getWarehouseById(int id) async {
    try {
      final response = await apiService.dio.get('/warehouses/$id');
      return WarehouseResponseDto.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<WarehouseResponseDto> createWarehouse(CreateWarehouseDto dto) async {
    try {
      final response =
          await apiService.dio.post('/warehouses', data: dto.toJson());
      return WarehouseResponseDto.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<WarehouseResponseDto> updateWarehouse(
      int id, UpdateWarehouseDto dto) async {
    try {
      final response =
          await apiService.dio.put('/warehouses/$id', data: dto.toJson());
      return WarehouseResponseDto.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteWarehouse(int id) async {
    try {
      await apiService.dio.delete('/warehouses/$id');
    } catch (e) {
      rethrow;
    }
  }
}
