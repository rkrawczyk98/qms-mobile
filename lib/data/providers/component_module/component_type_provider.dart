import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qms_mobile/data/models/DTOs/component_module/component_type/component_type_response_dto.dart';
import 'package:qms_mobile/data/models/DTOs/component_module/component_type/create_with_details_dto.dart';
import 'package:qms_mobile/data/services/component_module/component_type_service.dart';
import 'package:qms_mobile/data/providers/api_service_provider.dart';

class ComponentTypeNotifier
    extends StateNotifier<AsyncValue<List<ComponentTypeResponseDto>>> {
  final ComponentTypeService componentTypeService;

  ComponentTypeNotifier(this.componentTypeService)
      : super(const AsyncValue.loading());

  // ownloading simple component types
  Future<void> fetchComponentTypes() async {
    try {
      final data = await componentTypeService.getAllComponentTypes();
      state = AsyncValue.data(data);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  //Adding a component to the list
  void addComponentType(ComponentTypeResponseDto componentType) {
    state = state.whenData((types) => [...types, componentType]);
  }

  // Updating component in state
  void updateComponentType(int id, ComponentTypeResponseDto updatedType) {
    state = state.whenData((types) {
      return [
        for (final type in types)
          if (type.id == id) updatedType else type,
      ];
    });
  }

  // Removing a component from the list
  Future<void> deleteComponentType(int id) async {
    await componentTypeService.deleteComponentType(id);
    state = state
        .whenData((types) => types.where((type) => type.id != id).toList());
  }
}

class ComponentTypeWithDetailsNotifier
    extends StateNotifier<AsyncValue<List<CreateWithDetailsDto>>> {
  final ComponentTypeService componentTypeService;

  ComponentTypeWithDetailsNotifier(this.componentTypeService)
      : super(const AsyncValue.loading());

  // Download all components with details
  Future<void> fetchAllWithDetails() async {
    try {
      final data = await componentTypeService.getAllWithDetails();
      state = AsyncValue.data(data);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  // Pobranie pojedynczego komponentu z szczegółami
  Future<CreateWithDetailsDto> fetchOneWithDetails(int id) async {
    try {
      return await componentTypeService.getOneWithDetails(id);
    } catch (e) {
      throw Exception('Failed to fetch component type with details: $e');
    }
  }

  // Creating a new component with details
  Future<bool> createWithDetails(CreateWithDetailsDto dto) async {
    try {
      await componentTypeService.createWithDetails(dto);
      await fetchAllWithDetails();
      return true;
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      return false;
    }
  }

  Future<int> getLastSortOrder() async {
    try {
      return await componentTypeService.getLastSortOrderNumber();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      return 0;
    }
  }
}

// Provider for simple components
final componentTypeProvider = StateNotifierProvider<ComponentTypeNotifier,
    AsyncValue<List<ComponentTypeResponseDto>>>((ref) {
  final service = ref.read(componentTypeServiceProvider);
  return ComponentTypeNotifier(service);
});

// Provider for components with details
final componentTypeWithDetailsProvider = StateNotifierProvider<
    ComponentTypeWithDetailsNotifier,
    AsyncValue<List<CreateWithDetailsDto>>>((ref) {
  final service = ref.read(componentTypeServiceProvider);
  return ComponentTypeWithDetailsNotifier(service);
});

// Provider for the service
final componentTypeServiceProvider = Provider<ComponentTypeService>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return ComponentTypeService(apiService);
});
