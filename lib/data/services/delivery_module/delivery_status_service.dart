import 'package:dio/dio.dart';
import 'package:qms_mobile/data/models/DTOs/delivery_module/delivery_status/create_delivery_status_dto.dart';
import 'package:qms_mobile/data/models/DTOs/delivery_module/delivery_status/delivery_status_response_dto.dart';
import 'package:qms_mobile/data/models/DTOs/delivery_module/delivery_status/update_delivery_status_dto.dart';

class DeliveryStatusService {
  final Dio dio;

  DeliveryStatusService(this.dio);

  Future<List<DeliveryStatusResponseDto>> getAllDeliveryStatuses() async {
    final response = await dio.get('/delivery-statuses');
    if (response.statusCode == 200) {
      final List data = response.data;
      return data.map((e) => DeliveryStatusResponseDto.fromJson(e)).toList();
    }
    throw Exception('Failed to fetch delivery statuses');
  }

  Future<DeliveryStatusResponseDto> getDeliveryStatusById(int id) async {
    final response = await dio.get('/delivery-statuses/$id');
    if (response.statusCode == 200) {
      return DeliveryStatusResponseDto.fromJson(response.data);
    }
    throw Exception('Failed to fetch delivery status by ID');
  }

  Future<DeliveryStatusResponseDto> createDeliveryStatus(
      CreateDeliveryStatusDto dto) async {
    final response = await dio.post('/delivery-statuses', data: dto.toJson());
    if (response.statusCode == 201) {
      return DeliveryStatusResponseDto.fromJson(response.data);
    }
    throw Exception('Failed to create delivery status');
  }

  Future<DeliveryStatusResponseDto> updateDeliveryStatus(
      int id, UpdateDeliveryStatusDto dto) async {
    final response = await dio.put('/delivery-statuses/$id', data: dto.toJson());
    if (response.statusCode == 200) {
      return DeliveryStatusResponseDto.fromJson(response.data);
    }
    throw Exception('Failed to update delivery status');
  }

  Future<void> deleteDeliveryStatus(int id) async {
    final response = await dio.delete('/delivery-statuses/$id');
    if (response.statusCode != 204) {
      throw Exception('Failed to delete delivery status');
    }
  }
}
