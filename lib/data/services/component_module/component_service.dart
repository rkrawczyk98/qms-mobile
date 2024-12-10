import 'package:qms_mobile/data/models/DTOs/component_module/component/advenced_find_component_response_dto.dart';
import 'package:qms_mobile/data/models/DTOs/component_module/component/component_response_dto.dart';
import 'package:qms_mobile/data/models/DTOs/component_module/component/create_component_dto.dart';
import 'package:qms_mobile/data/models/DTOs/component_module/component/update_component_dto.dart';
import 'package:qms_mobile/data/services/api_service.dart';

class ComponentService {
  final ApiService apiService;

  ComponentService(this.apiService);

  Future<List<ComponentResponseDto>> getAllComponents() async {
    try {
      final response = await apiService.dio.get('/components');
      return (response.data as List)
          .map((e) => ComponentResponseDto.fromJson(e))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch components: $e');
    }
  }

  Future<ComponentResponseDto> createComponent(CreateComponentDto dto) async {
    try {
      final response =
          await apiService.dio.post('/components', data: dto.toJson());
      return ComponentResponseDto.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to create component: $e');
    }
  }

  Future<ComponentResponseDto> updateComponent(
      int id, UpdateComponentDto dto) async {
    try {
      final response =
          await apiService.dio.put('/components/$id', data: dto.toJson());
      return ComponentResponseDto.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to update component: $e');
    }
  }

  Future<void> deleteComponent(int id) async {
    try {
      await apiService.dio.delete('/components/$id');
    } catch (e) {
      throw Exception('Failed to delete component: $e');
    }
  }

  Future<ComponentResponseDto> getComponentById(int id) async {
    try {
      final response = await apiService.dio.get('/components/$id');
      return ComponentResponseDto.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to fetch component: $e');
    }
  }

  Future<Map<String, dynamic>> advancedFind({
    int page = 1,
    int limit = 10,
    String? sort,
    String order = 'ASC',
    String? filter,
  }) async {
    try {
      final response = await apiService.dio.get(
        '/components/with-filtration-and-pagination',
        queryParameters: {
          'page': page,
          'limit': limit,
          if (sort != null) 'sort': sort,
          'order': order,
          if (filter != null) 'filter': filter,
        },
      );

      // Read data
      final responseData = response.data as Map<String, dynamic>;

      // Verify that the response contains all the required fields
      if (!responseData.containsKey('data') ||
          !responseData.containsKey('page') ||
          !responseData.containsKey('totalPages') ||
          !responseData.containsKey('hasNextPage') ||
          !responseData.containsKey('hasPreviousPage')) {
        throw Exception('Unexpected response format from backend.');
      }

      // Data Mapping to DTO
      final components = (responseData['data'] as List)
          .map((json) => AdvencedFindComponentResponseDto.fromJson(json))
          .toList();

      // We return the data as a map to maintain access to metadata
      return {
        'data': components,
        'page': responseData['page'],
        'totalPages': responseData['totalPages'],
        'hasNextPage': responseData['hasNextPage'],
        'hasPreviousPage': responseData['hasPreviousPage'],
      };
    } catch (e) {
      throw Exception('Failed to fetch components with filtration: $e');
    }
  }
}
