import 'package:qms_mobile/data/models/DTOs/component_module/component_prefix/component_prefix_response_dto.dart';
import 'package:qms_mobile/data/models/DTOs/component_module/component_prefix/create_component_prefix_dto.dart';
import 'package:qms_mobile/data/models/DTOs/component_module/component_prefix/update_component_prefix_dto.dart';
import 'package:qms_mobile/data/services/api_service.dart';

class ComponentPrefixService {
  final ApiService apiService;

  ComponentPrefixService(this.apiService);

  Future<List<ComponentPrefixResponseDto>> getAllComponentPrefixes() async {
    try {
      final response = await apiService.dio.get('/component-prefixes');
      return (response.data as List)
          .map((e) => ComponentPrefixResponseDto.fromJson(e))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch component prefixes: $e');
    }
  }

  Future<ComponentPrefixResponseDto> getComponentPrefixByComponentId(int componentId) async {
    try {
      final response = await apiService.dio.get('/component-prefixes/$componentId');
      return ComponentPrefixResponseDto.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to fetch component prefix: $e');
    }
  }

  Future<ComponentPrefixResponseDto> createComponentPrefix(CreateComponentPrefixDto dto) async {
    try {
      final response = await apiService.dio.post('/component-prefixes', data: dto.toJson());
      return ComponentPrefixResponseDto.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to create component prefix: $e');
    }
  }

  Future<ComponentPrefixResponseDto> updateComponentPrefix(int id, UpdateComponentPrefixDto dto) async {
    try {
      final response = await apiService.dio.patch('/component-prefixes/$id', data: dto.toJson());
      return ComponentPrefixResponseDto.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to update component prefix: $e');
    }
  }

  Future<void> deleteComponentPrefix(int id) async {
    try {
      await apiService.dio.delete('/component-prefixes/$id');
    } catch (e) {
      throw Exception('Failed to delete component prefix: $e');
    }
  }
}
