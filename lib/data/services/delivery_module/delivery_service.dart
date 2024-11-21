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
}
