import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A custom checkbox widget with a label.
///
/// This widget allows you to create a checkbox with an associated text label.
/// The text label will automatically resize to fit within the available space,
/// using the AutoSizeText package to ensure it fits within the provided constraints.
class CustomCheckbox extends StatelessWidget {
  /// The text label to display next to the checkbox.
  final String text;

  /// The current state of the checkbox (checked or unchecked).
  final bool isChecked;

  /// A callback that is triggered when the checkbox state changes.
  final ValueChanged<bool?> onChanged;

  /// The maximum number of lines for the text label.
  /// If not provided, it defaults to 1 line.
  final int? maxLines;

  /// The color of the text label.
  /// If not provided, it defaults to black.
  final Color? textColor;

  /// The font size of the text label.
  /// If not provided, it defaults to 14.
  final double? fontSize;

  const CustomCheckbox({
    super.key,
    required this.isChecked,
    required this.onChanged,
    required this.text,
    this.maxLines,
    this.textColor,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      // Ensures the Row only takes up as much space as it needs.
      // mainAxisSize: MainAxisSize.min,
      
      children: [
        // A fixed-size Checkbox widget.
        SizedBox(
          height: 30,
          width: 30,
          child: Checkbox(
            value: isChecked, // Indicates whether the checkbox is checked.
            onChanged: onChanged, // Callback function to handle state changes.
          ),
        ),

        // A small gap between the checkbox and the text label.
        const SizedBox(width: 8),

        // Flexible text label that resizes to fit the available space.
        // The text will automatically shrink to fit within its constraints.
        Flexible(
          child: AutoSizeText(
            text, // The text label to display next to the checkbox.
            style: GoogleFonts.inter(
              fontSize: fontSize ?? 18, // Default font size is 14 if not provided.
              color: textColor ?? Colors.black, // Default text color is black if not provided.
            ),
            maxLines: maxLines ?? 1, // Limits the number of lines to the provided value or defaults to 1.
            wrapWords: false, // Prevents word wrapping to keep text on one line if possible.
          ),
        ),
      ],
    );
  }
}
