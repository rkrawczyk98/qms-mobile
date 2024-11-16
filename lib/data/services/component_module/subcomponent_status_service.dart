import 'package:qms_mobile/data/models/DTOs/component_module/subcomponent_status/create_subcomponent_status_dto.dart';
import 'package:qms_mobile/data/models/DTOs/component_module/subcomponent_status/subcomponent_status_response_dto.dart';
import 'package:qms_mobile/data/models/DTOs/component_module/subcomponent_status/update_subcomponent_status_dto.dart';
import 'package:qms_mobile/data/services/api_service.dart';

class SubcomponentStatusService {
  final ApiService apiService;

  SubcomponentStatusService(this.apiService);

  Future<List<SubcomponentStatusResponseDto>> getAllStatuses() async {
    try {
      final response = await apiService.dio.get('/subcomponent-statuses');
      return (response.data as List)
          .map((e) => SubcomponentStatusResponseDto.fromJson(e))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch subcomponent statuses: $e');
    }
  }

  Future<SubcomponentStatusResponseDto> getStatusById(int id) async {
    try {
      final response = await apiService.dio.get('/subcomponent-statuses/$id');
      return SubcomponentStatusResponseDto.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to fetch subcomponent status: $e');
    }
  }

  Future<SubcomponentStatusResponseDto> createStatus(CreateSubcomponentStatusDto dto) async {
    try {
      final response = await apiService.dio.post(
        '/subcomponent-statuses',
        data: dto.toJson(),
      );
      return SubcomponentStatusResponseDto.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to create subcomponent status: $e');
    }
  }

  Future<SubcomponentStatusResponseDto> updateStatus(int id, UpdateSubcomponentStatusDto dto) async {
    try {
      final response = await apiService.dio.put(
        '/subcomponent-statuses/$id',
        data: dto.toJson(),
      );
      return SubcomponentStatusResponseDto.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to update subcomponent status: $e');
    }
  }

  Future<void> deleteStatus(int id) async {
    try {
      await apiService.dio.delete('/subcomponent-statuses/$id');
    } catch (e) {
      throw Exception('Failed to delete subcomponent status: $e');
    }
  }
}
