import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A custom text field widget for forms.
///
/// This widget allows you to create a text field with customizable
/// labels, hints, and an option to obscure the text (useful for passwords).
class CustomTextField extends StatelessWidget {
  /// The label text to display above the text field.
  final String label;

  /// The hint text to display inside the text field when it is empty.
  final String hint;

  /// Whether to obscure the text (useful for password fields).
  final bool isObscure;

  /// A function for validating the input text. It should return
  /// an error message if the input is invalid, or `null` if valid.
  final String? Function(String?)? validator;

  /// A callback function that is triggered every time the text changes.
  final void Function(String)? onChanged;

  final Iterable<String>? autofillHint;

  final TextInputType? keyboardType;

  final double? fontSize;

  final TextEditingController? controller;

  const CustomTextField({
    super.key,
    required this.label,
    required this.hint,
    this.isObscure =
        false, // Default value is false, meaning text is not obscured.
    this.validator, // Validator function for custom validation logic.
    this.onChanged, // onChanged function to be triggered on text change.
    this.autofillHint,
    this.keyboardType,
    this.fontSize,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextFormField(
      controller: controller,
      // Determines if the text should be obscured (e.g., for password fields).
      obscureText: isObscure,

      // Validator function called to validate the text.
      validator: validator,

      // Function that is called when the text in the field changes.
      onChanged: onChanged,

      autofillHints: autofillHint,

      keyboardType: keyboardType,

      // Decoration for the text field, including labels, hints, and borders.
      decoration: InputDecoration(
        // The label text displayed above the text field.
        labelText: label,

        // The hint text displayed inside the text field when it is empty.
        hintText: hint,

        // The style of the label text.
        labelStyle: GoogleFonts.inter(
            fontSize: fontSize ?? 14, color: theme.textTheme.bodySmall?.color),
      ),
    );
  }
}
