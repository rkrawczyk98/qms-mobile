import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qms_mobile/data/services/customer_module/customer_service.dart';
import 'package:qms_mobile/data/providers/api_service_provider.dart';
import 'package:qms_mobile/data/models/DTOs/customer_module/customer_response_dto.dart';

class CustomerNotifier extends StateNotifier<List<CustomerResponseDto>> {
  final CustomerService _customerService;

  CustomerNotifier(this._customerService) : super([]);

  Future<void> fetchCustomers() async {
    try {
      state = await _customerService.getAllCustomers();
    } catch (e) {
      throw Exception('Failed to fetch customers: $e');
    }
  }

  void addCustomer(CustomerResponseDto customer) {
    state = [...state, customer];
  }

  Future<void> deleteCustomer(int id) async {
    await _customerService.deleteCustomer(id);
    await fetchCustomers(); // Refresh list after deletion
  }

  Future<void> updateCustomer(
      int id, CustomerResponseDto updatedCustomer) async {
    state = [
      for (final customer in state)
        if (customer.id == id) updatedCustomer else customer,
    ];
  }
}

final customerProvider =
    StateNotifierProvider<CustomerNotifier, List<CustomerResponseDto>>((ref) {
  final customerService = ref.read(customerServiceProvider);
  return CustomerNotifier(customerService);
});

final customerServiceProvider = Provider<CustomerService>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return CustomerService(apiService);
});
