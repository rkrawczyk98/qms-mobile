import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qms_mobile/data/services/customer_module/customer_service.dart';
import 'package:qms_mobile/data/providers/api_service_provider.dart';
import 'package:qms_mobile/data/models/DTOs/customer_module/customer_response_dto.dart';
import 'package:qms_mobile/data/models/DTOs/customer_module/create_customer_dto.dart';
import 'package:qms_mobile/data/models/DTOs/customer_module/update_customer_dto.dart';

class CustomerNotifier extends StateNotifier<AsyncValue<List<CustomerResponseDto>>> {
  final CustomerService _customerService;

  CustomerNotifier(this._customerService) : super(const AsyncValue.loading()) {
    fetchCustomers();
  }

  /// Downloads all clients
  Future<void> fetchCustomers() async {
    try {
      final customers = await _customerService.getAllCustomers();
      state = AsyncValue.data(customers);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  /// Adds a new client
  Future<void> addCustomer(CreateCustomerDto dto) async {
    try {
      final newCustomer = await _customerService.createCustomer(dto);
      state = state.whenData((customers) => [...customers, newCustomer]);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  /// Deletes a client
  Future<void> deleteCustomer(int id) async {
    try {
      await _customerService.deleteCustomer(id);
      state = state.whenData(
        (customers) => customers.where((customer) => customer.id != id).toList(),
      );
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  /// Updates customer data
  Future<void> updateCustomer(int id, UpdateCustomerDto dto) async {
    try {
      final updatedCustomer = await _customerService.updateCustomer(id, dto);
      state = state.whenData((customers) {
        return [
          for (final customer in customers)
            if (customer.id == id) updatedCustomer else customer,
        ];
      });
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  /// Collects data from one customer
  Future<CustomerResponseDto?> getCustomerById(int id) async {
    try {
      final customer = await _customerService.getCustomerById(id);
      state = state.whenData((customers) {
        final updatedCustomers = [
          for (final c in customers)
            if (c.id == id) customer else c,
        ];
        if (!updatedCustomers.any((c) => c.id == id)) {
          updatedCustomers.add(customer);
        }
        return updatedCustomers;
      });
      return customer;
    } catch (e) {
      throw Exception('Failed to fetch customer with id $id: $e');
    }
  }
}

final customerProvider =
    StateNotifierProvider<CustomerNotifier, AsyncValue<List<CustomerResponseDto>>>((ref) {
  final customerService = ref.read(customerServiceProvider);
  return CustomerNotifier(customerService);
});

final customerServiceProvider = Provider<CustomerService>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return CustomerService(apiService);
});
