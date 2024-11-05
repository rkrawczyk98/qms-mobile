import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A custom checkbox widget with a label.
/// The text label automatically resizes to fit within the available space,
/// using the AutoSizeText package to ensure it fits within the provided constraints.
class CustomCheckbox extends StatelessWidget {
  /// The text label to display next to the checkbox.
  final String text;

  /// The current state of the checkbox (checked or unchecked).
  final bool isChecked;

  /// A callback that is triggered when the checkbox state changes.
  final ValueChanged<bool?> onChanged;

  /// The maximum number of lines for the text label.
  final int? maxLines;

  /// The font size of the text label.
  final double? fontSize;

  const CustomCheckbox({
    super.key,
    required this.isChecked,
    required this.onChanged,
    required this.text,
    this.maxLines,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        SizedBox(
          height: 30,
          width: 30,
          child: Checkbox(
            value: isChecked,
            onChanged: onChanged,
            activeColor: colorScheme.primary,
            checkColor: colorScheme.onPrimary,
          ),
        ),

        const SizedBox(width: 8),

        Flexible(
          child: AutoSizeText(
            text,
            style: GoogleFonts.inter(
              fontSize: fontSize ?? 18,
              color: theme.textTheme.bodyLarge?.color,
            ),
            maxLines: maxLines ?? 1,
            wrapWords: false,
          ),
        ),
      ],
    );
  }
}
