import 'package:flutter/material.dart';

class CustomSwitchListTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final EdgeInsets? contentPadding;

  const CustomSwitchListTile({
    super.key,
    required this.title,
    this.subtitle,
    required this.value,
    required this.onChanged,
    this.contentPadding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SwitchListTile(
      contentPadding: contentPadding ?? const EdgeInsets.all(0),
      title: Text(
        title,
        style: theme.textTheme.bodyLarge,
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: theme.textTheme.bodySmall,
            )
          : null,
      value: value,
      onChanged: onChanged,
      trackOutlineColor: WidgetStateProperty.resolveWith((states) {
        return theme.brightness == Brightness.light
            ? theme.colorScheme.secondary
            : theme.colorScheme.onSecondary;
      }),
      thumbColor: WidgetStateProperty.resolveWith((states) {
        return theme.brightness == Brightness.light
            ? theme.colorScheme.onPrimary
            : theme.colorScheme.onPrimary;
      }),
    );
  }
}
