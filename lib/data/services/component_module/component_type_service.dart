import 'package:qms_mobile/data/models/DTOs/component_module/component_type/component_type_response_dto.dart';
import 'package:qms_mobile/data/models/DTOs/component_module/component_type/create_component_type_dto.dart';
import 'package:qms_mobile/data/models/DTOs/component_module/component_type/create_with_details_dto.dart';
import 'package:qms_mobile/data/models/DTOs/component_module/component_type/update_component_type_dto.dart';
import 'package:qms_mobile/data/services/api_service.dart';

class ComponentTypeService {
  final ApiService apiService;

  ComponentTypeService(this.apiService);

  Future<List<ComponentTypeResponseDto>> getAllComponentTypes() async {
    try {
      final response = await apiService.dio.get('/component-types');
      return (response.data as List)
          .map((e) => ComponentTypeResponseDto.fromJson(e))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch component types: $e');
    }
  }

  Future<ComponentTypeResponseDto> getComponentTypeById(int id) async {
    try {
      final response = await apiService.dio.get('/component-types/$id');
      return ComponentTypeResponseDto.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to fetch component type: $e');
    }
  }

  Future<ComponentTypeResponseDto> createComponentType(
      CreateComponentTypeDto dto) async {
    try {
      final response =
          await apiService.dio.post('/component-types', data: dto.toJson());
      return ComponentTypeResponseDto.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to create component type: $e');
    }
  }

  Future<ComponentTypeResponseDto> updateComponentType(
      int id, UpdateComponentTypeDto dto) async {
    try {
      final response = await apiService.dio.put(
        '/component-types/$id',
        data: dto.toJson(),
      );
      return ComponentTypeResponseDto.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to update component type: $e');
    }
  }

    Future<void> createWithDetails(CreateWithDetailsDto dto) async {
    try {
      await apiService.dio.post(
        '/component-types/with-details',
        data: dto.toJson(),
      );
    } catch (e) {
      throw Exception('Failed to create component type with details: $e');
    }
  }

    Future<List<CreateWithDetailsDto>> getAllWithDetails() async {
    try {
      final response =
          await apiService.dio.get('/component-types/all-with-details');
      return (response.data as List)
          .map((e) => CreateWithDetailsDto.fromJson(e))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch all component types with details: $e');
    }
  }

  Future<CreateWithDetailsDto> getOneWithDetails(int id) async {
    try {
      final response =
          await apiService.dio.get('/component-types/with-details/$id');
      return CreateWithDetailsDto.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to fetch component type with details: $e');
    }
  }

  Future<void> deleteComponentType(int id) async {
    try {
      await apiService.dio.delete('/component-types/$id');
    } catch (e) {
      throw Exception('Failed to delete component type: $e');
    }
  }
}
