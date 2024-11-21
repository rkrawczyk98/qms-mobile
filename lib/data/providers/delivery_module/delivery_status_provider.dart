import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qms_mobile/data/models/DTOs/delivery_module/delivery_status/delivery_status_response_dto.dart';
import 'package:qms_mobile/data/models/DTOs/delivery_module/delivery_status/create_delivery_status_dto.dart';
import 'package:qms_mobile/data/models/DTOs/delivery_module/delivery_status/update_delivery_status_dto.dart';
import 'package:qms_mobile/data/providers/api_service_provider.dart';
import 'package:qms_mobile/data/services/delivery_module/delivery_status_service.dart';

class DeliveryStatusNotifier
    extends StateNotifier<AsyncValue<List<DeliveryStatusResponseDto>>> {
  final DeliveryStatusService deliveryStatusService;

  DeliveryStatusNotifier(this.deliveryStatusService)
      : super(const AsyncValue.loading()) {
    fetchDeliveryStatuses();
  }

  /// Downloading all delivery statuses
  Future<void> fetchDeliveryStatuses() async {
    try {
      final statuses = await deliveryStatusService.getAllDeliveryStatuses();
      state = AsyncValue.data(statuses);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  /// Adding new status
  Future<void> addDeliveryStatus(CreateDeliveryStatusDto dto) async {
    try {
      final newStatus = await deliveryStatusService.createDeliveryStatus(dto);
      state = state.whenData((statuses) => [...statuses, newStatus]);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  /// Delivery Status Update
  Future<void> updateDeliveryStatus(
      int id, UpdateDeliveryStatusDto updatedDto) async {
    try {
      final updatedStatus =
          await deliveryStatusService.updateDeliveryStatus(id, updatedDto);
      state = state.whenData((statuses) {
        return [
          for (final status in statuses)
            if (status.id == id) updatedStatus else status,
        ];
      });
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  /// Deleting a delivery status
  Future<void> deleteDeliveryStatus(int id) async {
    try {
      await deliveryStatusService.deleteDeliveryStatus(id);
      state = state.whenData(
          (statuses) => statuses.where((status) => status.id != id).toList());
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

final deliveryStatusServiceProvider = Provider<DeliveryStatusService>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return DeliveryStatusService(apiService.dio);
});

final deliveryStatusProvider = StateNotifierProvider<DeliveryStatusNotifier,
    AsyncValue<List<DeliveryStatusResponseDto>>>((ref) {
  final deliveryStatusService = ref.read(deliveryStatusServiceProvider);
  return DeliveryStatusNotifier(deliveryStatusService);
});
