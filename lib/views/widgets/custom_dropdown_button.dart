import 'package:flutter/material.dart';

class CustomDropdownButton<T> extends StatelessWidget {
  final String text; // Text to display as a hint in the dropdown
  final String? tooltipMessage; // Optional tooltip message
  final List<DropdownMenuItem<T>>? items; // List of dropdown items
  final void Function(T?)? onChanged; // Callback when the value changes
  final T? initialValue; // Initial value (optional)

  const CustomDropdownButton({
    super.key,
    required this.text,
    this.tooltipMessage,
    required this.items,
    required this.onChanged,
    this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    // Get current theme
    final theme = Theme.of(context);

    final dropdown = DropdownButtonFormField<T>(
      value: initialValue,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: theme.dividerColor, // Use theme's divider color
          ),
        ),
        filled: true,
      ),
      hint: Text(
        text,
      ),
      items: items ?? [],
      onChanged: onChanged,
      isExpanded: true,
    );

    if (tooltipMessage != null) {
      return Tooltip(
        message: tooltipMessage!,
        textStyle: theme.textTheme.bodySmall?.copyWith(),
        child: dropdown,
      );
    }

    return dropdown;
  }
}
