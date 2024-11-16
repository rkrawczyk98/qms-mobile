import 'package:qms_mobile/data/models/DTOs/component_module/subcomponent/create_subcomponent_dto.dart';
import 'package:qms_mobile/data/models/DTOs/component_module/subcomponent/subcomponent_config_response_dto.dart';
import 'package:qms_mobile/data/models/DTOs/component_module/subcomponent/subcomponent_response_dto.dart';
import 'package:qms_mobile/data/models/DTOs/component_module/subcomponent/update_subcomponent_dto.dart';
import 'package:qms_mobile/data/services/api_service.dart';

class SubcomponentService {
  final ApiService apiService;

  SubcomponentService(this.apiService);

  Future<List<SubcomponentResponseDto>> getAllSubcomponents() async {
    try {
      final response = await apiService.dio.get('/subcomponents');
      return (response.data as List)
          .map((e) => SubcomponentResponseDto.fromJson(e))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch subcomponents: $e');
    }
  }

  Future<SubcomponentResponseDto> getSubcomponentById(int id) async {
    try {
      final response = await apiService.dio.get('/subcomponents/$id');
      return SubcomponentResponseDto.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to fetch subcomponent: $e');
    }
  }

  Future<List<SubcomponentResponseDto>> getSubcomponentsByComponentType(
      int componentTypeId) async {
    try {
      final response = await apiService.dio
          .get('/subcomponents/$componentTypeId');
      return (response.data as List)
          .map((e) => SubcomponentResponseDto.fromJson(e))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch subcomponents by component type: $e');
    }
  }

  Future<List<SubcomponentConfigResponseDto>> getConfigsByComponentType(
      int componentTypeId) async {
    try {
      final response = await apiService.dio
          .get('/subcomponents/config-by-component-type/$componentTypeId');
      return (response.data as List)
          .map((e) => SubcomponentConfigResponseDto.fromJson(e))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch subcomponent configs: $e');
    }
  }

  Future<SubcomponentResponseDto> createSubcomponent(
      CreateSubcomponentDto dto) async {
    try {
      final response = await apiService.dio.post(
        '/subcomponents',
        data: dto.toJson(),
      );
      return SubcomponentResponseDto.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to create subcomponent: $e');
    }
  }

  Future<SubcomponentResponseDto> updateSubcomponent(
      int id, UpdateSubcomponentDto dto) async {
    try {
      final response = await apiService.dio.put(
        '/subcomponents/$id',
        data: dto.toJson(),
      );
      return SubcomponentResponseDto.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to update subcomponent: $e');
    }
  }

  Future<void> deleteSubcomponent(int id) async {
    try {
      await apiService.dio.delete('/subcomponents/$id');
    } catch (e) {
      throw Exception('Failed to delete subcomponent: $e');
    }
  }
}
