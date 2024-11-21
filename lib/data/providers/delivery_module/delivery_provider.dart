import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qms_mobile/data/models/DTOs/delivery_module/delivery/create_delivery_dto.dart';
import 'package:qms_mobile/data/models/DTOs/delivery_module/delivery/delivery_response_dto.dart';
import 'package:qms_mobile/data/providers/api_service_provider.dart';
import 'package:qms_mobile/data/services/delivery_module/delivery_service.dart';

class DeliveryNotifier extends StateNotifier<AsyncValue<List<DeliveryResponseDto>>> {
  final DeliveryService deliveryService;

  DeliveryNotifier(this.deliveryService) : super(const AsyncValue.loading());

  Future<void> fetchDeliveries() async {
    try {
      final deliveries = await deliveryService.getAllDeliveries();
      state = AsyncValue.data(deliveries);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<int> addDelivery(CreateDeliveryDto deliveryDto) async {
    try {
      final newDelivery = await deliveryService.createDelivery(deliveryDto);
      state = state.whenData((deliveries) => [...deliveries, newDelivery]);
      return newDelivery.id;
    } catch (e) {
      throw Exception('Failed to create delivery: $e');
    }
  }

  Future<DeliveryResponseDto?> getDeliveryById(int id) async {
    try {
      final delivery = await deliveryService.getDeliveryById(id);
      state = state.whenData((deliveries) {
        final updatedList = [
          for (final d in deliveries)
            if (d.id == id) delivery else d,
        ];
        if (!updatedList.any((d) => d.id == id)) {
          updatedList.add(delivery);
        }
        return updatedList;
      });
      return delivery;
    } catch (e) {
      throw Exception('Failed to fetch delivery with id $id: $e');
    }
  }

  void updateDelivery(int id, DeliveryResponseDto updatedDelivery) {
    state = state.whenData((deliveries) {
      return [
        for (final delivery in deliveries)
          if (delivery.id == id) updatedDelivery else delivery,
      ];
    });
  }

  Future<void> deleteDelivery(int id) async {
    try {
      await deliveryService.deleteDelivery(id);
      state = state.whenData((deliveries) =>
          deliveries.where((delivery) => delivery.id != id).toList());
    } catch (e) {
      throw Exception('Failed to delete delivery: $e');
    }
  }
}

final deliveryServiceProvider = Provider<DeliveryService>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return DeliveryService(apiService.dio);
});

final deliveryProvider = StateNotifierProvider<DeliveryNotifier, AsyncValue<List<DeliveryResponseDto>>>((ref) {
  final deliveryService = ref.read(deliveryServiceProvider);
  return DeliveryNotifier(deliveryService);
});
