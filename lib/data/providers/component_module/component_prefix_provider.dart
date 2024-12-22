import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qms_mobile/data/models/DTOs/component_module/component_prefix/component_prefix_response_dto.dart';
import 'package:qms_mobile/data/models/DTOs/component_module/component_prefix/update_component_prefix_dto.dart';
import 'package:qms_mobile/data/services/component_module/component_prefix_service.dart';
import 'package:qms_mobile/data/providers/api_service_provider.dart';

class ComponentPrefixNotifier
    extends AsyncNotifier<List<ComponentPrefixResponseDto>> {
  late final ComponentPrefixService componentPrefixService;

  @override
  Future<List<ComponentPrefixResponseDto>> build() async {
    componentPrefixService = ref.read(componentPrefixServiceProvider);
    return await fetchComponentPrefixes();
  }

  /// Download prefix list
  Future<List<ComponentPrefixResponseDto>> fetchComponentPrefixes() async {
    try {
      final prefixes = await componentPrefixService.getAllComponentPrefixes();
      state = AsyncValue.data(prefixes);
      return prefixes;
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      rethrow;
    }
  }

  /// Add new prefix
  Future<void> addComponentPrefix(ComponentPrefixResponseDto prefix) async {
    state = state.whenData((prefixes) => [...prefixes, prefix]);
  }

  /// Update existing prefix in state and database
  Future<void> updateComponentPrefix(
      int id, ComponentPrefixResponseDto updatedPrefix) async {
    try {
      // Update in database
      final updatedPrefixFromDb =
          await componentPrefixService.updateComponentPrefix(
        id,
        UpdateComponentPrefixDto(
            prefix: updatedPrefix.prefix, componentTypeId: id),
      );

      // Update in state
      state = state.whenData((prefixes) {
        return prefixes.map((prefix) {
          return prefix.id == id ? updatedPrefixFromDb : prefix;
        }).toList();
      });
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      rethrow;
    }
  }

  ///Remove prefix
  Future<void> deleteComponentPrefix(int id) async {
    try {
      await componentPrefixService.deleteComponentPrefix(id);
      state = state.whenData(
          (prefixes) => prefixes.where((prefix) => prefix.id != id).toList());
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      rethrow;
    }
  }
}

final componentPrefixProvider = AsyncNotifierProvider<ComponentPrefixNotifier,
    List<ComponentPrefixResponseDto>>(() {
  return ComponentPrefixNotifier();
});

final componentPrefixServiceProvider = Provider<ComponentPrefixService>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return ComponentPrefixService(apiService);
});
