import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qms_mobile/data/models/DTOs/component_module/component/component_response_dto.dart';
import 'package:qms_mobile/data/providers/component_module/component_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qms_mobile/routes/app_routes.dart';
import 'package:qms_mobile/routes/navigation_service.dart';
import 'package:qms_mobile/views/screens/component/add_component_screen.dart';

class ComponentScreen extends ConsumerStatefulWidget {
  const ComponentScreen({super.key});

  @override
  ConsumerState<ComponentScreen> createState() => _ComponentScreenState();
}

class _ComponentScreenState extends ConsumerState<ComponentScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(componentProvider.notifier).fetchComponents();
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(localization!.manageComponents),
          bottom: TabBar(
            tabs: [
              Tab(text: localization.browse),
              Tab(text: localization.create),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            ComponentList(),
            AddComponentScreen(),
          ],
        ),
      ),
    );
  }
}

class ComponentList extends ConsumerWidget {
  const ComponentList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final componentsAsync = ref.watch(componentProvider);

    return componentsAsync.when(
      data: (components) {
        if (components.isEmpty) {
          return Center(
            child: Text(AppLocalizations.of(context)!.noComponentsFound),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: components.length,
          itemBuilder: (context, index) {
            final component = components[index];
            return ComponentItem(
              component: component,
              onDetailsTap: () => Navigator.pushNamed(
                context,
                '/component-details',
                arguments: component.id,
              ),
              onManageTap: () => Navigator.pushNamed(
                context,
                '/component-manage',
                arguments: component.id,
              ),
            );
          },
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, stackTrace) => Center(
        child: Text(AppLocalizations.of(context)!.unknownError),
      ),
    );
  }
}

class ComponentItem extends StatelessWidget {
  final ComponentResponseDto component;
  final VoidCallback onDetailsTap;
  final VoidCallback onManageTap;

  const ComponentItem({
    super.key,
    required this.component,
    required this.onDetailsTap,
    required this.onManageTap,
  });

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRow(localization!.deliveryNumber, component.delivery.number,
                context),
            const Divider(),
            _buildRow(localization.componentNumber, component.nameOne, context),
            const SizedBox(height: 8),
            _buildRow(localization.type, component.componentType.name, context),
            _buildRow(localization.status, component.status.name, context),
            const SizedBox(height: 8),
            _buildRow(
                localization.productionDate,
                component.productionDate != null
                    ? component.productionDate.toString()
                    : localization.notAvailable,
                context),
            _buildRow(
                localization.controlDate,
                component.controlDate?.toString() ?? localization.notAvailable,
                context),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: onManageTap,
                  child: Text(localization.manage),
                ),
                TextButton(
                  onPressed: onDetailsTap,
                  child: Text(localization.details),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, String? value, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Text(
          value ?? AppLocalizations.of(context)!.notAvailable,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}
