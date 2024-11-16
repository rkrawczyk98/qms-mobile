import 'package:qms_mobile/data/models/DTOs/customer_module/create_customer_dto.dart';
import 'package:qms_mobile/data/models/DTOs/customer_module/customer_response_dto.dart';
import 'package:qms_mobile/data/models/DTOs/customer_module/update_customer_dto.dart';
import 'package:qms_mobile/data/services/api_service.dart';

class CustomerService {
  final ApiService apiService;

  CustomerService(this.apiService);

  Future<List<CustomerResponseDto>> getAllCustomers() async {
    try {
      final response = await apiService.dio.get('/customers');
      return (response.data as List)
          .map((e) => CustomerResponseDto.fromJson(e))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<CustomerResponseDto> getCustomerById(int id) async {
    try {
      final response = await apiService.dio.get('/customers/$id');
      return CustomerResponseDto.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<CustomerResponseDto> createCustomer(CreateCustomerDto dto) async {
    try {
      final response =
          await apiService.dio.post('/customers', data: dto.toJson());
      return CustomerResponseDto.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<CustomerResponseDto> updateCustomer(
      int id, UpdateCustomerDto dto) async {
    try {
      final response =
          await apiService.dio.put('/customers/$id', data: dto.toJson());
      return CustomerResponseDto.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteCustomer(int id) async {
    try {
      await apiService.dio.delete('/customers/$id');
    } catch (e) {
      rethrow;
    }
  }
}
