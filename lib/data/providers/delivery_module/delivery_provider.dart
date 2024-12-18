import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qms_mobile/data/models/DTOs/delivery_module/delivery/create_delivery_dto.dart';
import 'package:qms_mobile/data/models/DTOs/delivery_module/delivery/delivery_response_dto.dart';
import 'package:qms_mobile/data/providers/api_service_provider.dart';
import 'package:qms_mobile/data/services/delivery_module/delivery_service.dart';

class DeliveryNotifier
    extends StateNotifier<AsyncValue<List<DeliveryResponseDto>>> {
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

class AdvancedDeliveryNotifier
    extends AsyncNotifier<List<DeliveryResponseDto>> {
  late final DeliveryService _deliveryService;

  // Pagination, sorting and filtering management parameters
  int _currentPage = 1;
  final int _pageSize = 10;
  String? _sortColumn;
  String _sortOrder = 'ASC';
  String? _filter;
  bool _hasMore = true;

  @override
  Future<List<DeliveryResponseDto>> build() async {
    _deliveryService = ref.read(deliveryServiceProvider);
    return fetchDeliveries(reset: true);
  }

  /// Gets deliveries from backend
  Future<List<DeliveryResponseDto>> fetchDeliveries({
    bool reset = false,
    String? sort,
    String? order,
    String? filter,
  }) async {
    try {
      if (reset) {
        _currentPage = 1;
        _sortColumn = sort;
        _sortOrder = order ?? 'ASC';
        _filter = filter;
        _hasMore = true;
        state = const AsyncValue.loading();
      }

      if (!_hasMore) {
        return state.value ?? [];
      }

      final result = await _deliveryService.advancedFind(
        page: _currentPage,
        limit: _pageSize,
        sort: _sortColumn,
        order: _sortOrder,
        filter: _filter,
      );

      final deliveries = result['data'] as List<DeliveryResponseDto>;
      _hasMore = result['hasNextPage'] as bool;

      final currentState = state.value ?? [];
      final updatedState =
          reset ? deliveries : [...currentState, ...deliveries];

      state = AsyncValue.data(updatedState);

      _currentPage++;
      return updatedState; 
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      rethrow;
    }
  }

  /// Resets the list and gets new data
  Future<void> resetAndFetch({
    String? sort,
    String? order,
    String? filter,
  }) async {
    final currentSort = _sortColumn;
    final currentOrder = _sortOrder;
    final currentFilter = _filter;

    await fetchDeliveries(
      reset: true,
      sort: sort ?? currentSort,
      order: order ?? currentOrder,
      filter: filter ?? currentFilter,
    );
  }

  /// Are there any more pages to load
  bool hasMore() {
    return _hasMore;
  }
}

final deliveryServiceProvider = Provider<DeliveryService>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return DeliveryService(apiService.dio);
});

final advancedDeliveryProvider =
    AsyncNotifierProvider<AdvancedDeliveryNotifier, List<DeliveryResponseDto>>(
        () {
  return AdvancedDeliveryNotifier();
});

final deliveryProvider = StateNotifierProvider<DeliveryNotifier,
    AsyncValue<List<DeliveryResponseDto>>>((ref) {
  final deliveryService = ref.read(deliveryServiceProvider);
  return DeliveryNotifier(deliveryService);
});
