import 'package:dio/dio.dart';
import 'package:qms_mobile/data/models/DTOs/delivery_module/delivery/create_delivery_dto.dart';
import 'package:qms_mobile/data/models/DTOs/delivery_module/delivery/delivery_response_dto.dart';
import 'package:qms_mobile/data/models/DTOs/delivery_module/delivery/update_delivery_dto.dart';
class DeliveryService {
  final Dio dio;

  DeliveryService(this.dio);

  Future<List<DeliveryResponseDto>> getAllDeliveries() async {
    final response = await dio.get('/deliveries');
    return (response.data as List)
        .map((json) => DeliveryResponseDto.fromJson(json))
        .toList();
  }

  Future<DeliveryResponseDto> getDeliveryById(int id) async {
    final response = await dio.get('/deliveries/$id');
    return DeliveryResponseDto.fromJson(response.data);
  }

  Future<DeliveryResponseDto> createDelivery(CreateDeliveryDto dto) async {
    final response = await dio.post('/deliveries', data: dto.toJson());
    return DeliveryResponseDto.fromJson(response.data);
  }

  Future<DeliveryResponseDto> updateDelivery(int id, UpdateDeliveryDto dto) async {
    final response = await dio.put('/deliveries/$id', data: dto.toJson());
    return DeliveryResponseDto.fromJson(response.data);
  }

  Future<void> deleteDelivery(int id) async {
    await dio.delete('/deliveries/$id');
  }

    Future<Map<String, dynamic>> advancedFind({
    int page = 1,
    int limit = 10,
    String? sort,
    String order = 'ASC',
    String? filter,
  }) async {
    try {
      final response = await dio.get(
        '/deliveries/with-filtration-and-pagination',
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
      final deliveries = (responseData['data'] as List)
          .map((json) => DeliveryResponseDto.fromJson(json))
          .toList();

      // We return the data as a map to maintain access to metadata
      return {
        'data': deliveries,
        'page': responseData['page'],
        'totalPages': responseData['totalPages'],
        'hasNextPage': responseData['hasNextPage'],
        'hasPreviousPage': responseData['hasPreviousPage'],
      };
    } catch (e) {
      throw Exception('Failed to fetch deliveries with filtration: $e');
    }
  }
}
