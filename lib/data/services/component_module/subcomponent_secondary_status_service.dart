import 'package:qms_mobile/data/models/DTOs/component_module/subcomponent_secondary_status/add_subcomponent_secondary_status_dto.dart';
import 'package:qms_mobile/data/models/DTOs/component_module/subcomponent_secondary_status/subcomponent_secondary_status_response_dto.dart';
import 'package:qms_mobile/data/models/DTOs/component_module/subcomponent_secondary_status/update_subcomponent_secondary_status_dto.dart';
import 'package:qms_mobile/data/services/api_service.dart';

class SubcomponentSecondaryStatusService {
  final ApiService apiService;

  SubcomponentSecondaryStatusService(this.apiService);

  Future<List<SubcomponentSecondaryStatusResponseDto>> getSecondaryStatuses(int subcomponentId) async {
    try {
      final response = await apiService.dio.get('/subcomponent/$subcomponentId/secondary-statuses');
      return (response.data as List)
          .map((e) => SubcomponentSecondaryStatusResponseDto.fromJson(e))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch secondary statuses: $e');
    }
  }

  Future<SubcomponentSecondaryStatusResponseDto> addSecondaryStatus(
      int subcomponentId, AddSubcomponentSecondaryStatusDto dto) async {
    try {
      final response = await apiService.dio.post(
        '/subcomponent/$subcomponentId/secondary-statuses',
        data: dto.toJson(),
      );
      return SubcomponentSecondaryStatusResponseDto.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to add secondary status: $e');
    }
  }

  Future<void> removeSecondaryStatus(int secondaryStatusId) async {
    try {
      await apiService.dio.delete('/subcomponent/secondary-statuses/$secondaryStatusId');
    } catch (e) {
      throw Exception('Failed to remove secondary status: $e');
    }
  }

  Future<SubcomponentSecondaryStatusResponseDto> updateSecondaryStatusSortOrder(
      int secondaryStatusId, UpdateSubcomponentSecondaryStatusDto dto) async {
    try {
      final response = await apiService.dio.patch(
        '/subcomponent/secondary-statuses/$secondaryStatusId/sort-order',
        data: dto.toJson(),
      );
      return SubcomponentSecondaryStatusResponseDto.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to update sort order: $e');
    }
  }
}
