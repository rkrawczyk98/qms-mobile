import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// A widget that displays an SVG logo with specified width and height.
class CustomLogoWidget extends StatelessWidget {
  // The file path to the SVG logo
  final String logoPath;
  
  // The desired width of the logo
  final double width;
  
  // The desired height of the logo
  final double height;

  const CustomLogoWidget({
    super.key,
    required this.logoPath,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      logoPath, // Loads and displays the SVG file from the provided path
      width: width, // Sets the width of the logo
      height: height, // Sets the height of the logo
    );
  }
}
