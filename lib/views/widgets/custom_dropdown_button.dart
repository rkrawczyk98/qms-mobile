import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomDropdownButton extends StatelessWidget {
  final String text; // Text to display as a hint in the dropdown
  final String? tooltipMessage; // Optional tooltip message
  final Color? textColor; // Optional text color
  final Color? fillColor; // Optional fill color for the dropdown
  final List<DropdownMenuItem<String>>? items; // List of dropdown items
  final void Function(String?)? onChanged; // Callback when the value changes
  final BorderRadius? borderRadius; // Optional border radius for the dropdown
  final BorderSide? borderSide; // Optional border side for the dropdown

  const CustomDropdownButton({
    super.key,
    required this.text,
    this.tooltipMessage,
    this.fillColor,
    this.borderRadius,
    this.borderSide,
    this.textColor,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Tooltip(
        message: tooltipMessage,
        child: DropdownButtonFormField<String>(
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: borderRadius ??
                  BorderRadius.circular(
                      5), // Set default border radius if not provided
              borderSide: borderSide ??
                  const BorderSide(
                      color: Colors
                          .grey), // Set default border side if not provided
            ),
            filled: true, // Ensure the dropdown is filled
            fillColor: fillColor ??
                Colors
                    .white, // Apply the provided fill color or default to white
          ),
          hint: Text(
            text,
            style: GoogleFonts.inter(
                color: textColor ??
                    Colors.black), // Apply text color or default to black
          ),
          items: items,
          onChanged:
              onChanged, // Trigger the callback when the dropdown value changes
          isExpanded: true,
        ),
      ),
    );
  }
}