import 'package:qms_mobile/data/models/DTOs/component_module/component_subcomponent/component_subcomponent_response_dto.dart';
import 'package:qms_mobile/data/models/DTOs/component_module/component_subcomponent/create_component_subcomponent_dto.dart';
import 'package:qms_mobile/data/models/DTOs/component_module/component_subcomponent/update_component_subcomponent_dto.dart';
import 'package:qms_mobile/data/services/api_service.dart';

class ComponentSubcomponentService {
  final ApiService apiService;

  ComponentSubcomponentService(this.apiService);

  Future<List<ComponentSubcomponentResponseDto>> getAllComponentSubcomponents() async {
    try {
      final response = await apiService.dio.get('/component-subcomponents');
      return (response.data as List)
          .map((e) => ComponentSubcomponentResponseDto.fromJson(e))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch component-subcomponent relationships: $e');
    }
  }

  Future<ComponentSubcomponentResponseDto> getComponentSubcomponentById(int id) async {
    try {
      final response = await apiService.dio.get('/component-subcomponents/$id');
      return ComponentSubcomponentResponseDto.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to fetch component-subcomponent relationship: $e');
    }
  }

  Future<ComponentSubcomponentResponseDto> createComponentSubcomponent(
      CreateComponentSubcomponentDto dto) async {
    try {
      final response = await apiService.dio.post(
        '/component-subcomponents',
        data: dto.toJson(),
      );
      return ComponentSubcomponentResponseDto.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to create component-subcomponent relationship: $e');
    }
  }

  Future<ComponentSubcomponentResponseDto> updateComponentSubcomponent(
      int id, UpdateComponentSubcomponentDto dto) async {
    try {
      final response = await apiService.dio.put(
        '/component-subcomponents/$id',
        data: dto.toJson(),
      );
      return ComponentSubcomponentResponseDto.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to update component-subcomponent relationship: $e');
    }
  }

  Future<void> deleteComponentSubcomponent(int id) async {
    try {
      await apiService.dio.delete('/component-subcomponents/$id');
    } catch (e) {
      throw Exception('Failed to delete component-subcomponent relationship: $e');
    }
  }
}
