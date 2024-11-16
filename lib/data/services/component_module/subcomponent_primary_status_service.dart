import 'package:qms_mobile/data/models/DTOs/component_module/subcomponent_primary_status/add_subcomponent_primary_status_dto.dart';
import 'package:qms_mobile/data/models/DTOs/component_module/subcomponent_primary_status/subcomponent_primary_status_response_dto.dart';
import 'package:qms_mobile/data/models/DTOs/component_module/subcomponent_primary_status/update_subcomponent_primary_status_dto.dart';
import 'package:qms_mobile/data/services/api_service.dart';

class SubcomponentPrimaryStatusService {
  final ApiService apiService;

  SubcomponentPrimaryStatusService(this.apiService);

  Future<List<SubcomponentPrimaryStatusResponseDto>> getPrimaryStatuses(int subcomponentId) async {
    try {
      final response = await apiService.dio.get('/subcomponent/$subcomponentId/primary-statuses');
      return (response.data as List)
          .map((e) => SubcomponentPrimaryStatusResponseDto.fromJson(e))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch primary statuses: $e');
    }
  }

  Future<SubcomponentPrimaryStatusResponseDto> addPrimaryStatus(
      int subcomponentId, AddSubcomponentPrimaryStatusDto dto) async {
    try {
      final response = await apiService.dio.post(
        '/subcomponent/$subcomponentId/primary-statuses',
        data: dto.toJson(),
      );
      return SubcomponentPrimaryStatusResponseDto.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to add primary status: $e');
    }
  }

  Future<void> removePrimaryStatus(int primaryStatusId) async {
    try {
      await apiService.dio.delete('/subcomponent/primary-statuses/$primaryStatusId');
    } catch (e) {
      throw Exception('Failed to remove primary status: $e');
    }
  }

  Future<SubcomponentPrimaryStatusResponseDto> updatePrimaryStatusSortOrder(
      int primaryStatusId, UpdateSubcomponentPrimaryStatusDto dto) async {
    try {
      final response = await apiService.dio.patch(
        '/subcomponent/primary-statuses/$primaryStatusId/sort-order',
        data: dto.toJson(),
      );
      return SubcomponentPrimaryStatusResponseDto.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to update sort order: $e');
    }
  }
}
