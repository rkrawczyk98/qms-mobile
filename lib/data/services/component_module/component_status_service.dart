import 'package:qms_mobile/data/models/DTOs/component_module/component_status/component_status_response_dto.dart';
import 'package:qms_mobile/data/models/DTOs/component_module/component_status/create_component_status_dto.dart';
import 'package:qms_mobile/data/models/DTOs/component_module/component_status/update_component_status_dto.dart';
import 'package:qms_mobile/data/services/api_service.dart';

class ComponentStatusService {
  final ApiService apiService;

  ComponentStatusService(this.apiService);

  Future<List<ComponentStatusResponseDto>> getAllComponentStatuses() async {
    try {
      final response = await apiService.dio.get('/component-statuses');
      return (response.data as List)
          .map((e) => ComponentStatusResponseDto.fromJson(e))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch component statuses: $e');
    }
  }

  Future<ComponentStatusResponseDto> getComponentStatusById(int id) async {
    try {
      final response = await apiService.dio.get('/component-statuses/$id');
      return ComponentStatusResponseDto.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to fetch component status: $e');
    }
  }

  Future<ComponentStatusResponseDto> createComponentStatus(CreateComponentStatusDto dto) async {
    try {
      final response = await apiService.dio.post('/component-statuses', data: dto.toJson());
      return ComponentStatusResponseDto.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to create component status: $e');
    }
  }

  Future<ComponentStatusResponseDto> updateComponentStatus(int id, UpdateComponentStatusDto dto) async {
    try {
      final response = await apiService.dio.put('/component-statuses/$id', data: dto.toJson());
      return ComponentStatusResponseDto.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to update component status: $e');
    }
  }

  Future<void> deleteComponentStatus(int id) async {
    try {
      await apiService.dio.delete('/component-statuses/$id');
    } catch (e) {
      throw Exception('Failed to delete component status: $e');
    }
  }
}
