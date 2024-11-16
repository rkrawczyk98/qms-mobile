import 'package:qms_mobile/data/models/DTOs/warehouse_module/create_warehouse_position_dto.dart';
import 'package:qms_mobile/data/models/DTOs/warehouse_module/update_warehouse_position_dto.dart';
import 'package:qms_mobile/data/models/DTOs/warehouse_module/warehouse_position_response_dto.dart';
import 'package:qms_mobile/data/services/api_service.dart';

class WarehousePositionService {
  final ApiService apiService;

  WarehousePositionService(this.apiService);

  Future<List<WarehousePositionResponseDto>> getAllWarehousePositions() async {
    try {
      final response = await apiService.dio.get('/warehouse-positions');
      return (response.data as List)
          .map((e) => WarehousePositionResponseDto.fromJson(e))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<WarehousePositionResponseDto> getWarehousePositionById(int id) async {
    try {
      final response = await apiService.dio.get('/warehouse-positions/$id');
      return WarehousePositionResponseDto.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<WarehousePositionResponseDto> createWarehousePosition(
      CreateWarehousePositionDto dto) async {
    try {
      final response =
          await apiService.dio.post('/warehouse-positions', data: dto.toJson());
      return WarehousePositionResponseDto.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<WarehousePositionResponseDto> updateWarehousePosition(
      int id, UpdateWarehousePositionDto dto) async {
    try {
      final response = await apiService.dio.put(
        '/warehouse-positions/$id',
        data: dto.toJson(),
      );
      return WarehousePositionResponseDto.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteWarehousePosition(int id) async {
    try {
      await apiService.dio.delete('/warehouse-positions/$id');
    } catch (e) {
      rethrow;
    }
  }
}
